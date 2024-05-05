import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateDataScreensupplier extends StatefulWidget {
  final Map<String, dynamic> karyawan;
  UpdateDataScreensupplier({required this.karyawan});

  @override
  _UpdateDataScreenState createState() => _UpdateDataScreenState();
}

class _UpdateDataScreenState extends State
<UpdateDataScreensupplier> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _jabatanController =TextEditingController();
  final TextEditingController _nomorTeleponController = TextEditingController();
  bool _isLoading = false;
  List<dynamic> karyawan = [];


  @override
  void initState() {
    super.initState();
    fetchData(); // Ambil data yang diterima melalui widget
    final Map<String, dynamic> karyawanData = widget.karyawan;
    // Setel nilai-nilai controller teks sesuai dengan data yang diterima
    _namaController.text = karyawanData['nama'];
    _alamatController.text = karyawanData['alamat'];
    _jabatanController.text = karyawanData['jabatan'];
    _emailController.text = karyawanData['email'];
    _nomorTeleponController.text = karyawanData['nomor_telepon'];
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://tugas-besar-7e24d-default-rtdb.firebaseio.com/data_supplier.json'));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData != null && responseData is Map<String, dynamic>) {
        final List<dynamic> loadedProducts = [];
        responseData.forEach((idSupplier, karyawanData) {
          loadedProducts.add({
            'id_supplier': idSupplier,
            'nama': karyawanData['nama'],
            'alamat': karyawanData['alamat'],
            'jabatan': karyawanData['jabatan'],
            "nomor_telepon": karyawanData['nomor_telepon'],
            "email": karyawanData['email']
          });
        });
        setState(() {
          karyawan = loadedProducts;
          _isLoading = false;
        });
        print(response.body);
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }


  Future<void> _updateProduct() async {
    setState(() {
      _isLoading = true;
    });

    final karyawanId = widget.karyawan['id_supplier']; // Mengambil ID supplier yang benar

    final String baseUrl =
        'https://tugas-besar-7e24d-default-rtdb.firebaseio.com/data_supplier/$karyawanId.json';
    final url = Uri.parse(baseUrl);

    try {
      final response = await http.patch(
        url,
        body: json.encode({
          'nama': _namaController.text,
          'alamat': _alamatController.text,
          'jabatan': _jabatanController.text,
          'email': _emailController.text,
          'nomor_telepon': _nomorTeleponController.text,
        }),
      );

      if (response.statusCode == 200) {
        // Setelah berhasil memperbarui data, panggil kembali fetchData untuk memperbarui tampilan data
        await fetchData();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Data berhasil diperbarui"),
            duration: Duration(seconds: 3),
          ),
        );
        setState(() {
          Navigator.of(context).pop();
        });
      } else {
        print(response.statusCode);
        print(response.body);
        throw Exception(
            'Failed to update product: Status code ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to update product: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Data'),
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _namaController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _alamatController,
              decoration: InputDecoration(labelText: 'Alamat'),
            ),
            TextField(
              controller: _jabatanController,
              decoration: InputDecoration(labelText: 'Jabatan'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _nomorTeleponController,
              decoration:
              InputDecoration(labelText: 'Nomor Telepon'),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _updateProduct,
              child: Text('Perbarui Data'),
            ),
          ],
        ),
      ),
    );
  }
}
