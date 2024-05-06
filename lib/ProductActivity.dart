import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './HomePage.dart';
import 'package:tugas_besar/supplier/DaftarBarang.dart';
import 'package:tugas_besar/HomePage.dart';

class AddBarangForm extends StatefulWidget {
  @override
  _AddBarangFormState createState() => _AddBarangFormState();
}

class _AddBarangFormState extends State<AddBarangForm> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _merekController = TextEditingController();
  final _hargaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Barang'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(labelText: 'Nama Barang'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nama barang';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _merekController,
                decoration: InputDecoration(labelText: 'Merek Barang'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan merek barang';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _hargaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Harga Barang'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan harga barang';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _addBarang();
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addBarang() async {
    final url =
        'https://tugas-besar-7e24d-default-rtdb.firebaseio.com/barang.json';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'nama': _namaController.text,
          'merek': _merekController.text,
          'harga': int.parse(_hargaController.text),
        }),
      );

      if (response.statusCode == 200) {
        print('Data barang berhasil ditambahkan.');
        _namaController.clear();
        _merekController.clear();
        _hargaController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Barang berhasil ditambahkan'),
            duration: Duration(seconds: 2), // Atur durasi tampilan Snackbar
          ),
        );
      } else {
        print(
            'Gagal menambahkan data barang. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Terjadi kesalahan: $error');
    }
  }
}
