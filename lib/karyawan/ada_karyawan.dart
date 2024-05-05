import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TambahKaryawanScreen extends StatefulWidget {
  @override
  _TambahKaryawanScreenState createState() => _TambahKaryawanScreenState();
}

class _TambahKaryawanScreenState extends State<TambahKaryawanScreen> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _jabatanController = TextEditingController();
  final TextEditingController _nomorTeleponController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();

  bool _isLoading = false;

  Future<void> _tambahKaryawan() async {
    setState(() {
      _isLoading = true;
    });

    final Map<String, dynamic> newData = {
      'nama': _namaController.text,
      'jabatan': _jabatanController.text,
      'nomor_telepon': _nomorTeleponController.text,
      'email': _emailController.text,
      'url': _urlController.text,
    };

    final response = await http.post(
      Uri.parse('https://tugas-besar-7e24d-default-rtdb.firebaseio.com/data_karyawan.json'),
      body: json.encode(newData),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Data karyawan berhasil ditambahkan"),
          duration: Duration(seconds: 3),
        ),
      );
      ScaffoldMessenger.of(context ).showSnackBar(
      SnackBar(content: Text("Data karyawan berhasil di tambahkan"),
      duration: Duration(seconds: 3),)
      );
      Navigator.pop(context); // Kembali ke halaman sebelumnya setelah menambahkan data
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal menambahkan data karyawan"),
          duration: Duration(seconds: 3),
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Data Karyawan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _namaController,
              decoration: InputDecoration(labelText: 'Nama',icon: Icon(Icons.person)),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _jabatanController,
              decoration: InputDecoration(labelText: 'Jabatan', icon: Icon(Icons.post_add)),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nomorTeleponController,
              decoration: InputDecoration(labelText: 'Nomor Telepon',icon: Icon(Icons.confirmation_num)),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email', icon: Icon(Icons.email_outlined)),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _urlController,
              decoration: InputDecoration(labelText: 'URL (Image)', icon: Icon(Icons.network_wifi)),
            ),
            SizedBox(height: 20),
            _isLoading
                ? Center(
              child: CircularProgressIndicator(),
            )
                : ElevatedButton(
              onPressed: () {
                _tambahKaryawan();
              },
              child: Text('Tambah Data'),
            ),
          ],
        ),
      ),
    );
  }
}
