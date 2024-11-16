part of 'pages.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  String _name = 'Guest';
  int _balance = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    goUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: null,
          flexibleSpace: Center(
            child: Text(
              'BANK CELENGAN',
              style: blackTextStyle.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 0, 65, 3),
              ),
            ),
          ),
          toolbarHeight: kToolbarHeight,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
               Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (int index) {
          if (index != _selectedIndex) {
            setState(() {
              _selectedIndex = index;
            });
            switch (index) {
              case 0:
                Navigator.pushNamed(context, '/home'); 
                break;
              case 1:
                Navigator.pushNamed(context, '/transfer');
                break;
              // case 2:
              //   Navigator.pushNamed(context, '/mutasi'); 
              //   break;
              case 3:
                Navigator.pushNamed(context, '/editprofile'); 
                break;
            }
          }
        },
        items: [
          BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
          BottomNavigationBarItem( label: 'Transfer', icon: Icon(Icons.wallet_travel)),
          // BottomNavigationBarItem( label: 'Mutation',icon: Icon(Icons.swap_horiz)),
          BottomNavigationBarItem(label: 'Settings', icon: Icon(Icons.settings)),
        ],
      ),
      body: _isLoading? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: Colors.white, 
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: const Color.fromARGB(255, 0, 84, 49), 
                                  child: Text(
                                    _name.isNotEmpty ? _name[0].toUpperCase() : '?', 
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white, 
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Welcome $_name',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Your Balance: Rp $_balance',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: const Color.fromARGB(255, 0, 75, 2), 
                                  ),
                                ),
                                SizedBox(height: 16),
                                Container(
                                  height: 4,
                                  width: 40,
                                  color: const Color.fromARGB(255, 13, 75, 0), 
                                ),
                              ],
                            ),
                          ),
                        ),
                  ],
                ),
              ),
            ),
    );
  }

  void goUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = _storage.read('token');
      print(token);
      if (token == null) {
        throw Exception('Authorization token not found');
      }

      final _response = await _dio.get(
        '$_apiUrl/account/my',
        options: Options(
          headers: {'Authorization': token},
        ),
      );
      print(_response);

      if (_response.statusCode == 200) {
        Map<String, dynamic> userData = _response.data['data'];
        setState(() {
          _name = userData['name'];
          _balance = userData['balance'];
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print(e);
      Navigator.pushReplacementNamed(context, '/home');
    } 
  }
}
