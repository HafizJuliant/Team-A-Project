class Account {
  const Account({
    required this.accountId,
    required this.name,
    required this.balance,
    required this.alamat,
    required this.noTelepon,
    required this.bankId,
  });

  final int accountId;
  final String name;
  final int balance;
  final String alamat;
  final int noTelepon;
  final int bankId;

  factory Account.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return Account(
      accountId: data['account_id'],
      name: data['name'],
      balance: data['balance'],
      alamat: data['alamat'],
      noTelepon: data['no_telp'],
      bankId: data['bank_id'],
    );
  }
}
