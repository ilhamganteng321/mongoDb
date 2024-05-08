import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddSalesScreen extends StatefulWidget {
  @override
  _AddSalesScreenState createState() => _AddSalesScreenState();
}

class _AddSalesScreenState extends State<AddSalesScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }
  bool _isLoading = false;

  Future<void> _addSalesData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final String baseUrl = 'https://tugas-besar-7e24d-default-rtdb.firebaseio.com/data_penjualan.json';
      final url = Uri.parse(baseUrl);

      try {
        final response = await http.post(
          url,
          body: json.encode({
            'nama_customer': _customerNameController.text,
            'nama_produk': _productNameController.text,
            'harga': double.parse(_priceController.text),
            'qty': int.parse(_quantityController.text),
            'harga_total': double.parse(_priceController.text) * int.parse(_quantityController.text),
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Data penjualan berhasil ditambahkan"),
              backgroundColor: Colors.blue,
              showCloseIcon: true,
              animation: CurvedAnimation(parent: _controller, curve: Curves.easeOut),
            ),
          );
          Navigator.pop(context); // Kembali ke layar sebelumnya setelah menambahkan data penjualan
        } else {
          throw Exception('Failed to add sales data: Status code ${response.statusCode}');
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to add sales data: $error"),
            duration: Duration(seconds: 3),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Sales'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _customerNameController,
                decoration: InputDecoration(labelText: 'Customer Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Customer name is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _productNameController,
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Product name is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Price is required';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Enter a valid price';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Quantity is required';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Enter a valid quantity';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _addSalesData,
                child: Text('Add Sales'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
