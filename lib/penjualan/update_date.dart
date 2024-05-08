import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tugas_besar/penjualan/add_penjualan.dart';

class UpdateSalesScreen extends StatefulWidget {
  final Map<String, dynamic> salesData;

  UpdateSalesScreen({required this.salesData});

  @override
  _UpdateSalesScreenState createState() => _UpdateSalesScreenState();
}

class _UpdateSalesScreenState extends State<UpdateSalesScreen> {
  late TextEditingController _customerNameController;
  late TextEditingController _productNameController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;
  late TextEditingController _totalPriceController;

  @override
  void initState() {
    super.initState();
    _customerNameController = TextEditingController();
    _productNameController = TextEditingController();
    _priceController = TextEditingController();
    _quantityController = TextEditingController();
    _totalPriceController = TextEditingController();

    // Set initial values for text fields
    _customerNameController.text = widget.salesData['customer_name'];
    _productNameController.text = widget.salesData['product_name'];
    _priceController.text = widget.salesData['price'].toString();
    _quantityController.text = widget.salesData['quantity'].toString();
    _totalPriceController.text = widget.salesData['total_price'].toString();
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _productNameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _totalPriceController.dispose();
    super.dispose();
  }

  Future<void> _updateSalesData() async {
    final String baseUrl =
        'https://tugas-besar-7e24d-default-rtdb.firebaseio.com/data_penjualan/${widget.salesData['id']}.json';

    try {
      final response = await http.patch(
        Uri.parse(baseUrl),
        body: json.encode({
          'nama_customer': _customerNameController.text,
          'nama_produk': _productNameController.text,
          'harga': double.parse(_priceController.text),
          'qty': int.parse(_quantityController.text),
          'harga_total': double.parse(_totalPriceController.text),
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true);
        // kembali ke layar sebelumnya dengan status berhasil
      } else {
        throw Exception(
            'Failed to update sales data: Status code ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to update sales data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Sales'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _customerNameController,
              decoration: InputDecoration(labelText: 'Customer Name'),
            ),
            TextField(
              controller: _productNameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _totalPriceController,
              decoration: InputDecoration(labelText: 'Total Price'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _updateSalesData();
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
