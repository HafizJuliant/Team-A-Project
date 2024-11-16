import 'package:intl/intl.dart';

class Transaction {
  const Transaction({
    required this.transactionId,
    this.transactionCategoryId,
    required this.accountId,
    this.fromAccountId,
    this.toAccountId,
    required this.amount,
    required this.transactionDesc,
    required this.transactionDate,
    required this.fromBankId,
    required this.toBankId,
  });

  final int transactionId;
  final int? transactionCategoryId; // Nullable field
  final int accountId;
  final int? fromAccountId; // Nullable field
  final int? toAccountId; // Nullable field
  final int amount;
  final String transactionDesc;
  final DateTime transactionDate;
  final int fromBankId;
  final int toBankId;

  factory Transaction.fromJson(Map<String, dynamic> json) {
    final data = json['data']; // Assuming the JSON response has a 'data' key
    return Transaction(
      transactionId: data['transaction_id'],
      transactionCategoryId: data['transaction_category_id'],
      accountId: data['account_id'],
      fromAccountId: data['from_account_id'],
      toAccountId: data['to_account_id'],
      amount: data['amount'],
      transactionDesc: data['transaction_desc'],
      transactionDate: DateTime.parse(data['transaction_date']),
      fromBankId: data['from_bank_id'],
      toBankId: data['to_bank_id'],
    );
  }
}
