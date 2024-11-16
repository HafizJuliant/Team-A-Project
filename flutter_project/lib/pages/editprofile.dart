part of 'pages.dart';

class EditProfilePage extends StatefulWidget {
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool _isNameEditing = false;
  bool _isAlamatEditing = false;
  bool _isNoTelpEditing = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController noTelpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController = TextEditingController();

  @override
   @override
  void initState() {
    super.initState();
    _getUserProfile();  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: null,
          flexibleSpace: Center(
            child: Text(
              'Profile',
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
        actions: [
          // Change Password
          IconButton(
            icon: Icon(Icons.lock_outline),
            onPressed: _showChangePasswordModal,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(defaultMargin),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10), 
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    buildUserInfoRow('Name', nameController, _isNameEditing, () {
                      setState(() {
                        _isNameEditing = !_isNameEditing;
                      });
                    }),
                    SizedBox(height: 20.0),
                    buildUserInfoRow('Alamat', alamatController, _isAlamatEditing, () {
                      setState(() {
                        _isAlamatEditing = !_isAlamatEditing;
                      });
                    }),
                    SizedBox(height: 20.0),
                    buildUserInfoRow('No Telepon', noTelpController, _isNoTelpEditing, () {
                      setState(() {
                        _isNoTelpEditing = !_isNoTelpEditing;
                      });
                    }),
                  ],
                ),
              ),
              SizedBox(height: 30.0),

              // Save changes
              if (_isNameEditing || _isAlamatEditing || _isNoTelpEditing)
                ElevatedButton(
                  onPressed: _saveUserInfo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    'Save Changes',
                    style: whiteTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUserInfoRow(
      String label, TextEditingController controller, bool isEditing, VoidCallback toggleEdit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, 
      children: [
        Expanded(
          child: isEditing
              ? TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: label,
                    filled: true,
                    fillColor: fieldColor,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: secondaryColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )
              : Text(
                  controller.text,
                  style: blackTextStyle.copyWith(fontSize: 16),
                ),
        ),
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: toggleEdit,
          padding: EdgeInsets.zero, 
        ),
      ],
    );
  }

  void _showChangePasswordModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.all(defaultMargin),
            child: Column(
              mainAxisSize: MainAxisSize.min, 
              children: [
                Text(
                  'Change Password',
                  style: blackTextStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    filled: true,
                    fillColor: fieldColor,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: secondaryColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                TextField(
                  controller: confirmNewPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm New Password',
                    filled: true,
                    fillColor: fieldColor,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: secondaryColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _saveNewPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    'Save',
                    style: whiteTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _saveUserInfo() async {
    try {
      final token = _storage.read('token');
      if (token == null) {
        throw Exception('Authorization token not found');
      }

      final _response = await _dio.patch(
        '${_apiUrl}/account/update',
        data: {
          'name': nameController.text,
          'alamat': alamatController.text,
          'no_telp': noTelpController.text,
        },
        options: Options(
          headers: {'Authorization': token},
        ),
      );

      if (_response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Profile updated successfully',
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );

        setState(() {
          _isNameEditing = false;
          _isAlamatEditing = false;
          _isNoTelpEditing = false;
        });

        await _getUserProfile();
      }
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode} - ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to update profile. Please try again.',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

   Future<void> _saveNewPassword() async {
  }

  Future<void> _getUserProfile() async {
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
        Map<String, dynamic> data = _response.data['data'];
        setState(() {
          nameController.text = data['name'] ?? '';
          alamatController.text = data['alamat'] ?? '';
          noTelpController.text = (data['no_telp'] ?? '').toString();
        });

      }

    } catch (e) {
      print('Failed to fetch user profile: $e');
    }
  }
}
