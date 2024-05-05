import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateKaryawanScreen extends StatefulWidget {
  final Map<String, dynamic> karyawan;

  UpdateKaryawanScreen({required this.karyawan});

  @override
  _UpdateKaryawanScreenState createState() => _UpdateKaryawanScreenState();
}

class _UpdateKaryawanScreenState extends State<UpdateKaryawanScreen> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _jabatanController = TextEditingController();
  final TextEditingController _nomorTeleponController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _namaController.text = widget.karyawan['nama'];
    _jabatanController.text = widget.karyawan['jabatan'];
    _nomorTeleponController.text = widget.karyawan['nomor_telepon'];
    _emailController.text = widget.karyawan['email'];
    _urlController.text = widget.karyawan['url'];
  }

  Future<void> _updateKaryawan() async {
    setState(() {
      _isLoading = true;
    });

    final Map<String, dynamic> updatedData = {
      'nama': _namaController.text,
      'jabatan': _jabatanController.text,
      'nomor_telepon': _nomorTeleponController.text,
      'email': _emailController.text,
      'url': _urlController.text,
    };

    final response = await http.patch(
      Uri.parse('https://tugas-besar-7e24d-default-rtdb.firebaseio.com/data_karyawan/${widget.karyawan['id']}.json'),
      body: json.encode(updatedData),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Data karyawan berhasil diperbarui"),
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.pop(context); // Kembali ke halaman sebelumnya setelah data diperbarui
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal memperbarui data karyawan"),
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
        title: Text('Update Data Karyawan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _namaController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _jabatanController,
              decoration: InputDecoration(labelText: 'Jabatan'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nomorTeleponController,
              decoration: InputDecoration(labelText: 'Nomor Telepon'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _urlController,
              decoration: InputDecoration(labelText: 'URL (Image)'),
            ),
            SizedBox(height: 20),
            _isLoading
                ? Center(
              child: CircularProgressIndicator(),
            )
                : ElevatedButton(
              onPressed: () {
                _updateKaryawan();
              },
              child: Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}
