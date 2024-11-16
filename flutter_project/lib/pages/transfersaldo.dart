part of 'pages.dart';

class TransferSaldoPage extends StatefulWidget {
  @override
  State<TransferSaldoPage> createState() => _TransferSaldoPageState();
}

class _TransferSaldoPageState extends State<TransferSaldoPage> {
  final TextEditingController accountController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  bool _isAccountValid = false; 
  bool _isAmountValid = true;   
  bool _isBalanceSufficient = true;  // saldo cukup
  bool _hasCheckedAccount = false;  

  List<String> banks = [];  
  String? selectedBank;  
  double userBalance = 0;  

  @override
  void initState() {
    super.initState();
    _fetchBanks(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: null,
          flexibleSpace: Center(
            child: Text(
              'Transfer',
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // form
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                ),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedBank,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedBank = newValue!; 
                          _isAccountValid = false;  
                          _hasCheckedAccount = false; 
                        });
                      },
                      items: banks.map((String bank) {
                        return DropdownMenuItem<String>(
                          value: bank,
                          child: Text(bank),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Pilih Bank',
                        filled: true,
                        fillColor: Colors.grey[200],
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: const Color.fromARGB(255, 10, 68, 0)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    TextField(
                      controller: accountController,
                      decoration: InputDecoration(
                        labelText: 'Account Tujuan',
                        filled: true,
                        fillColor: Colors.grey[200],
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: const Color.fromARGB(255, 10, 68, 0)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),

                    // validasi
                    ElevatedButton(
                      onPressed: _checkAccount,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 10, 68, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                      ),
                      child: Text(
                        'Check Account',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 10),

                    if (_hasCheckedAccount && !_isAccountValid)
                      Text(
                        'Account tidak valid!',
                        style: TextStyle(color: Colors.red),
                      ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              SizedBox(height: 20),

              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                ),
                child: Column(
                  children: [
                    // Input jumlah
                    TextField(
                      controller: amountController,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        filled: true,
                        fillColor: Colors.grey[200],
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      enabled: _isAccountValid, 
                    ),
                    SizedBox(height: 10),

                    if (!_isAmountValid)
                      Text(
                        'Amount minimal 10,000!',
                        style: TextStyle(color: Colors.red),
                      ),
                    SizedBox(height: 10),

                    ElevatedButton(
                      onPressed: _transferSaldo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 10, 68, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                      ),
                      child: Text(
                        'Transfer',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 20),

                    if (!_isBalanceSufficient)
                      Text(
                        'Saldo tidak cukup!',
                        style: TextStyle(color: Colors.red),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

void _fetchBanks() async {
    try {
      final response = await Dio().get('$_apiUrl/bank/list');
      
      if (response.statusCode == 200) {
        final List<dynamic> bankList = response.data;

        setState(() {
          banks = bankList.map((bank) => bank['name'] as String).toList();
          selectedBank = banks.isNotEmpty ? banks[0] : null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch banks!')),
        );
      }
    } catch (e) {
      print('Error fetching banks: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching bank list!')),
      );
    }
  }
  
  void _checkAccount() async {
  }

  void _showAccountInfoDialog(String bankName, String accountNumber, String accountHolder) {

  }

  void _transferSaldo() {
  }
}
