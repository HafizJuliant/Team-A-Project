class Auth {
  const Auth({
    required this.authId,
    required this.accountId,
    required this.username,
    required this.password,
  });

  final int authId;
  final int accountId;
  final String username;
  final String password;

  factory Auth.fromJson(Map<String, dynamic> json) {
    final data = json['data']; 
    return Auth(
      authId: data['auth_id'],
      accountId: data['account_id'],
      username: data['username'],
      password: data['password'],
    );
  }

}
