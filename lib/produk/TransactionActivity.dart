import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tugas_besar/produk/AddProduk.dart';

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<dynamic> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final url =
        'https://tugas-besar-7e24d-default-rtdb.firebaseio.com/data_produk.json';

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
          isLoading = false; // Tandai bahwa data telah dimuat
        });
      } else {
        print('Failed to load products. Status code: ${response.statusCode}');
        setState(() {
          isLoading = false; // Tandai bahwa terjadi kesalahan dalam memuat data
        });
      }
    } catch (error) {
      print('An error occurred: $error');
      setState(() {
        isLoading = false; // Tandai bahwa terjadi kesalahan dalam memuat data
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newProduct = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductScreen()),
          ).then((value) {
            setState(() {
              _loadProducts();
            });
          });
          if (newProduct != null) {
            _loadProducts();
          }
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Product List'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? Center(child: Text('No products available'))
              : ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(
                      key: Key(products[index]['id']),
                      onDismissed: (direction) {
                        _deleteProduct(index);
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20.0),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      child: ListTile(
                        hoverColor: Colors.blue.withOpacity(0.3),
                        iconColor: Colors.white,
                        mouseCursor: SystemMouseCursors.click,
                        selectedColor: Colors.white,
                        onTap: () {
                          _showProductDetails(context, products[index]);
                        },
                        leading: IconButton(
                          onPressed: () {
                            _showUpdateProductScreen(context, index);
                          },
                          icon: Icon(Icons.edit, color: Colors.blue),
                        ),
                        title: Text(products[index]['nama_produk']),
                        subtitle: Text(products[index]['deskripsi']),
                        trailing: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'KONFIRMASI',
                                  ),
                                  content: Text(
                                      'Apa anda yakin ingin menghapus item ini?'),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      onPressed: () {
                                        // Do something when cancel button is pressed
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Do something when delete button is pressed
                                        Navigator.of(context).pop();
                                        // Add your delete functionality here
                                        _deleteProduct(index);
                                      },
                                      child: Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.delete, color: Colors.blue),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  void _showUpdateProductScreen(BuildContext context, int index) {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => UpdateProductScreen(
          product: products[index],
        ),
      ),
    )
        .then((_) {
      // Setelah kembali dari layar pembaruan produk, muat ulang produk
      _loadProducts();
    });
  }

  void _deleteProduct(int index) async {
    final productId = products[index]['id'];
    final url =
        'https://tugas-besar-7e24d-default-rtdb.firebaseio.com/data_produk/$productId.json';

    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        products.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Data berhasil dihapus"),
          showCloseIcon: true,
          backgroundColor: Colors.blue,
          closeIconColor: Colors.white,
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to delete product.'),
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
  }

  void _showProductDetails(BuildContext context, Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(product['nama_produk']),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Description: ${product['deskripsi']}'),
              Text('Category: ${product['kategori_produk']}'),
              Text('Code: ${product['kode_produk']}'),
              Text('Stock: ${product['stok']}'),
              Text('Price: \$${product['harga']}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class UpdateProductScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  UpdateProductScreen({required this.product});

  @override
  _UpdateProductScreenState createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _kategoriController = TextEditingController();
  final TextEditingController _kodeController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set initial values for controllers based on product data
    _namaController.text = widget.product['nama_produk'];
    _deskripsiController.text = widget.product['deskripsi'];
    _hargaController.text = widget.product['harga'];
    _kategoriController.text = widget.product['kategori_produk'];
    _kodeController.text = widget.product['kode_produk'];
    _stokController.text = widget.product['stok'];
  }

  List<dynamic> products = [];
  bool isActive = true;
  Future<void> _loadProducts() async {
    final url =
        'https://tugas-besar-7e24d-default-rtdb.firebaseio.com/data_produk.json';

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

  void _updateProduct() async {
    final productId = widget.product['id'];
    final url =
        'https://tugas-besar-7e24d-default-rtdb.firebaseio.com/data_produk/$productId.json';

    try {
      final response = await http.patch(
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
        // Jika produk berhasil diperbarui, kembali ke halaman sebelumnya
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Data berhasil diupdate"),
            showCloseIcon: true,
            backgroundColor: Colors.blue,
            closeIconColor: Colors.white,
          ),
        );

        // Memuat ulang produk setelah memperbarui produk
        _loadProducts().then((_) {
          // Perbarui variabel products di dalam widget _ProductListState
          setState(() {
            products =
                List.from(products); // Membuat salinan baru dari daftar produk
          });
        });
      } else {
        // Jika terjadi kesalahan, tampilkan pesan kesalahan
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to update product.'),
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
        title: Text('Update Product'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _namaController,
              decoration: InputDecoration(
                  labelText: 'Nama Produk', icon: Icon(Icons.add_chart)),
            ),
            TextField(
              controller: _deskripsiController,
              decoration: InputDecoration(
                  labelText: 'Deskripsi', icon: Icon(Icons.description)),
            ),
            TextField(
              controller: _hargaController,
              decoration: InputDecoration(
                  labelText: 'Harga', icon: Icon(Icons.price_change)),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _kategoriController,
              decoration: InputDecoration(
                  labelText: 'Kategori Produk',
                  icon: Icon(Icons.description_sharp)),
            ),
            TextField(
              controller: _kodeController,
              decoration: InputDecoration(
                  labelText: 'Kode Produk', icon: Icon(Icons.password)),
            ),
            TextField(
              controller: _stokController,
              decoration: InputDecoration(
                  labelText: 'Stok', icon: Icon(Icons.area_chart)),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _updateProduct,
                child: Text('Update Product'),
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
