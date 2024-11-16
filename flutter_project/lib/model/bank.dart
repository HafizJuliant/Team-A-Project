class Bank {
  const Bank({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  factory Bank.fromJson(Map<String, dynamic> json) {
    final data = json['data']; 
    return Bank(
      id: data['bank_id'],  
      name: data['name'],    
    );
  }
}
