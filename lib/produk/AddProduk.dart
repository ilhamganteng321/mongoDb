import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _kategoriController = TextEditingController();
  final TextEditingController _kodeController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();
  List<dynamic> products = [];
  bool isActive = true;

  Future<void> _loadProducts() async {
    final url = 'https://tugas-besar-7e24d-default-rtdb.firebaseio.com/data_produk.json';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final List<dynamic> loadedProducts = [];
        data.forEach((productId, productData) {
          loadedProducts.add({
            'id': productId,
            'nama_produk': productData['nama_produk'],
            'deskripsi': productData['deskripsi'],
            'harga': productData['harga'],
            'kategori_produk': productData['kategori_produk'],
            'kode_produk': productData['kode_produk'],
            'stok': productData['stok'],
          });
        });
        setState(() {
          products = loadedProducts;
          isActive = false;
        });
      } else {
        print('Failed to load products. Status code: ${response.statusCode}');
        setState(() {
          isActive = false;
        });
      }
    } catch (error) {
      print('An error occurred: $error');
      setState(() {
        isActive = false;
      });
    }
  }

  Future<void> _addProduct() async {
    final url = 'https://tugas-besar-7e24d-default-rtdb.firebaseio.com/data_produk.json';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'nama_produk': _namaController.text,
          'deskripsi': _deskripsiController.text,
          'harga': _hargaController.text,
          'kategori_produk': _kategoriController.text,
          'kode_produk': _kodeController.text,
          'stok': _stokController.text,
        }),
      );

      if (response.statusCode == 200) {
        // Jika produk berhasil ditambahkan, kembali ke halaman sebelumnya
        final newProduct = Product(
          id: json.decode(response.body)['name'],
          namaProduk: _namaController.text,
          deskripsi: _deskripsiController.text,
          harga: double.parse(_hargaController.text),
          kategoriProduk: _kategoriController.text,
          kodeProduk: _kodeController.text,
          stok: int.parse(_stokController.text),
        );
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Berhasil ditambahkan"),
            duration: Duration(seconds: 3),
          ),
        );
        _loadProducts();
        setState(() {
          products.add(newProduct);
        });
      } else {
        // Jika terjadi kesalahan, tampilkan pesan kesalahan
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to add product.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      print('An error occurred: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _namaController,
              decoration: InputDecoration(labelText: 'Nama Produk', icon: Icon(Icons.add_chart)),
            ),
            TextField(
              controller: _deskripsiController,
              decoration: InputDecoration(labelText: 'Deskripsi', icon: Icon(Icons.description)),
            ),
            TextField(
              controller: _hargaController,
              decoration: InputDecoration(labelText: 'Harga', icon: Icon(Icons.price_change)),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _kategoriController,
              decoration: InputDecoration(labelText: 'Kategori Produk',icon: Icon(Icons.description_sharp)),
            ),
            TextField(
              controller: _kodeController,
              decoration: InputDecoration(labelText: 'Kode Produk',icon: Icon(Icons.password)),
            ),
            TextField(
              controller: _stokController,
              decoration: InputDecoration(labelText: 'Stok', icon: Icon(Icons.area_chart)),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addProduct,
                child: Text('Add Product'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _hargaController.dispose();
    _kategoriController.dispose();
    _kodeController.dispose();
    _stokController.dispose();
    super.dispose();
  }
}

class Product {
  final String id;
  final String namaProduk;
  final String deskripsi;
  final double harga;
  final String kategoriProduk;
  final String kodeProduk;
  final int stok;

  Product({
    required this.id,
    required this.namaProduk,
    required this.deskripsi,
    required this.harga,
    required this.kategoriProduk,
    required this.kodeProduk,
    required this.stok,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      namaProduk: json['nama_produk'],
      deskripsi: json['deskripsi'],
      harga: json['harga'],
      kategoriProduk: json['kategori_produk'],
      kodeProduk: json['kode_produk'],
      stok: json['stok'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_produk': namaProduk,
      'deskripsi': deskripsi,
      'harga': harga,
      'kategori_produk': kategoriProduk,
      'kode_produk': kodeProduk,
      'stok': stok,
    };
  }
}