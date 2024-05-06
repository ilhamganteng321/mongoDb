import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddCustomerForm extends StatefulWidget {
  @override
  _AddCustomerFormState createState() => _AddCustomerFormState();
}

class _AddCustomerFormState extends State
{
final _formKey = GlobalKey<FormState>();
final TextEditingController _namaController = TextEditingController();
final TextEditingController _alamatController = TextEditingController();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _nomorTeleponController = TextEditingController();

Future<void> _addCustomer() async {
  final url = Uri.parse('https://tugas-besar-7e24d-default-rtdb.firebaseio.com/data_pelanggan.json');

  try {
    final response = await http.post(
      url,
      body: json.encode({
        'nama': _namaController.text,
        'alamat': _alamatController.text,
        'email': _emailController.text,
        'nomor_telepon': _nomorTeleponController.text,
        'tanggal' : DateTime.now().toString()
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Customer added successfully'),
        ),
      );
      setState(() {
        Navigator.of(context).pop();
      });
    } else {
      throw Exception('Failed to add customer');
    }
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('An error occurred: $error'),
      ),
    );
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Add Customer'),
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(labelText: 'Nama'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _alamatController,
                decoration: InputDecoration(labelText: 'Alamat'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nomorTeleponController,
                decoration: InputDecoration(labelText: 'Nomor Telepon'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addCustomer();
                  }
                },
                child: Text('Add Customer'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}