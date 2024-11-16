class TransCat {
  const TransCat({
    required this.transactionCategoryId,
    required this.name,
  });

  final int transactionCategoryId;
  final String name;

  factory TransCat.fromJson(Map<String, dynamic> json) {
    final data = json['data']; // Assuming the JSON response has a 'data' key
    return TransCat(
      transactionCategoryId: data['transaction_category_id'],
      name: data['name'],
    );
  }
}
