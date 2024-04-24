import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Product {
  int id;
  String name;
  String brand;
  int price;
  int stock;

  Product({required this.id, required this.name, required this.brand, required this.price, required this.stock});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'price': price,
      'stock': stock,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      brand: map['brand'],
      price: map['price'],
      stock: map['stock'],
    );
  }
}

class ProductDatabase {
  late Database _db;

  Future<void> initialize() async {
    String path = await getDatabasesPath();
    _db = await openDatabase(
      join(path, 'products.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE Products(
            id INTEGER PRIMARY KEY,
            name TEXT,
            brand TEXT,
            price INTEGER,
            stock INTEGER
          )
        ''');
      },
      version: 1,
    );
  }

  Future<Database> get database async {
    if (!(_db.isOpen)) await initialize(); // Periksa apakah sudah diinisialisasi sebelum mengakses
    return _db;
  }

  Future<void> insertProduct(Product product) async {
    final db = await database;
    await db.insert('Products', product.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Product>> getProducts() async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query('Products');
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  Future<void> updateProduct(Product product) async {
    final db = await database;
    await db.update(
      'Products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<void> deleteProduct(int id) async {
    final db = await database;
    await db.delete(
      'Products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
