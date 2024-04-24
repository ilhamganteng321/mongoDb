class Transaction {
  String? id; // Mengubah tipe data ID menjadi String
  String customerName;
  String itemName; // Nama barang
  String itemBrand; // Merek barang
  int itemPrice; // Harga barang

  Transaction({
    this.id,
    required this.customerName,
    required this.itemName,
    required this.itemBrand,
    required this.itemPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'itemName': itemName,
      'itemBrand': itemBrand,
      'itemPrice': itemPrice,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      customerName: map['customerName'],
      itemName: map['itemName'],
      itemBrand: map['itemBrand'],
      itemPrice: map['itemPrice'],
    );
  }
}
