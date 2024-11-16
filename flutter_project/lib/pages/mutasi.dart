part of 'pages.dart';

class MutationPage extends StatefulWidget {
  @override
  _MutationPageState createState() => _MutationPageState();
}

class _MutationPageState extends State<MutationPage> {
  List<dynamic> _transactions = [];
  bool _isLoading = false;

  DateTime _fromDate = DateTime.now().subtract(Duration(days: 30));
  DateTime _toDate = DateTime.now();

  String get _formattedFromDate => DateFormat('yyyy-MM-dd').format(_fromDate);
  String get _formattedToDate => DateFormat('yyyy-MM-dd').format(_toDate);

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  // memilih tanggal mulai
  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fromDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _fromDate) {
      setState(() {
        _fromDate = picked;
      });
    }
  }

  // memilih tanggal selesai
  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _toDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _toDate) {
      setState(() {
        _toDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: null,
          flexibleSpace: Center(
            child: Text(
              'Transaction History',
              style: blackTextStyle.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 0, 65, 3),
              ),
            ),
          ),
          toolbarHeight: kToolbarHeight,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context, 
              '/home',  
              (route) => false,  
            );
          },
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('From: ', style: TextStyle(fontSize: 16)),
                      TextButton(
                        onPressed: () => _selectFromDate(context),
                        child: Text(DateFormat('yyyy-MM-dd').format(_fromDate)),
                      ),
                      Text('To: ', style: TextStyle(fontSize: 16)),
                      TextButton(
                        onPressed: () => _selectToDate(context),
                        child: Text(DateFormat('yyyy-MM-dd').format(_toDate)),
                      ),
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: _loadTransactions, 
                      ),
                    ],
                  ),
                  // List
                  Expanded(
                    child: _transactions.isEmpty
                        ? Center(child: Text('No transactions found'))
                        : ListView.builder(
                            itemCount: _transactions.length,
                            itemBuilder: (context, index) {
                              var transaction = _transactions[index];
                              return Card(
                                elevation: 4,
                                margin: EdgeInsets.symmetric(vertical: 8),
                                color: Colors.white,
                                child: ListTile(
                                  title: Text(
                                    '${transaction['transaction_desc'] ?? 'No Description'}',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('From Account: ${transaction['from_account_id']}'),
                                      Text('To Account: ${transaction['to_account_id']}'),
                                      Text('Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(transaction['transaction_date']))}'),
                                    ],
                                  ),
                                  trailing: Text(
                                    'Amount: ${transaction['amount']}',
                                    style: TextStyle(
                                      color: const Color.fromARGB(255, 25, 63, 26),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }

  
  void _loadTransactions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _dio.get(
        '$_apiUrl/account/mutation',
        queryParameters: {
          'from_date': _formattedFromDate,
          'to_date': _formattedToDate,
        },
        options: Options(
          headers: {'Authorization': _storage.read('token')},
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          _transactions = response.data['data']; 
          _isLoading = false;
        });
      } else {
        print('Failed to load transactions: ${response.statusCode}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

}
