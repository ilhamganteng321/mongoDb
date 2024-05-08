class SalesData {
  final String id;
  final String customerName;
  final String productName;
  final int quantity;
  final double price;
  final DateTime date;

  SalesData({
    required this.id,
    required this.customerName,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.date,
  });

  factory SalesData.fromJson(Map<String, dynamic> json) {
    return SalesData(
      id: json['id'],
      customerName: json['customer_name'],
      productName: json['product_name'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_name': customerName,
      'product_name': productName,
      'quantity': quantity,
      'price': price,
      'date': date.toIso8601String(),
    };
  }
}
