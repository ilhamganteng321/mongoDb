import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class AddDataScreen extends StatefulWidget {
  @override
  _AddDataScreenState createState() => _AddDataScreenState();
}

class _AddDataScreenState extends State<AddDataScreen> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nomorTeleponController = TextEditingController();
  final TextEditingController _JabatanController = TextEditingController();

  Future<void> _addData() async {
    final Map<String, dynamic> newData = {
      'nama': _namaController.text,
      'alamat': _alamatController.text,
      'jabatan' : _JabatanController.text,
      'email': _emailController.text,
      'nomor_telepon': _nomorTeleponController.text,
    };

    final response = await http.post(
      Uri.parse('https://tugas-besar-7e24d-default-rtdb.firebaseio.com/data_supplier.json'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(newData),
    );

    if (response.statusCode == 200) {
      // Data berhasil ditambahkan
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Data berhasil di tambahkan"),
        duration: Duration(seconds: 3),)
      );
    } else {
      // Gagal menambahkan data
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to add data.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Data'),
      ),
      body:  Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _namaController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: _alamatController,
              decoration: InputDecoration(labelText: 'Alamat'),
            ),
            TextField(
              controller: _JabatanController,
              decoration: InputDecoration(labelText: 'Jabatan'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _nomorTeleponController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Nomor Telepon'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addData,
              child: Text('Tambah Data'),
            ),
          ],
        ),
      ),
    );
  }
}