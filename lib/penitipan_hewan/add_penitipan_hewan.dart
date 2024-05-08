import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/customer.dart';

class FormTambahPenitipanHewan extends StatefulWidget {
  @override
  _FormTambahPenitipanHewanState createState() =>
      _FormTambahPenitipanHewanState();
}

class _FormTambahPenitipanHewanState extends State<FormTambahPenitipanHewan> {
  List<Customer> customers = [];
  String? _selectedPelanggan;
  TextEditingController _namaHewanController = TextEditingController();
  TextEditingController _tanggalPenitipanController = TextEditingController();
  TextEditingController _tanggalPengambilanController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    _fetchCustomers();
    super.initState();
  }

  Future<void> _fetchCustomers() async {
    final String baseUrl =
        'https://tugas-besar-7e24d-default-rtdb.firebaseio.com/data_pelanggan.json';
    final url = Uri.parse(baseUrl);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic>? data = json.decode(response.body);

        if (data != null) {
          List<Customer> fetchedCustomers = [];
          data.forEach((customerId, customerData) {
            if (customerData is Map<String, dynamic>) {
              fetchedCustomers.add(Customer.fromJson({
                'id': customerId,
                ...customerData,
              }));
            }
          });

          setState(() {
            customers = fetchedCustomers;
          });
        } else {
          throw Exception('Failed to load customers: Response body is null');
        }
      } else {
        throw Exception(
            'Failed to load customers: Status code ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to load customers: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Data Penitipan Hewan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedPelanggan,
              items: customers.map((customer) {
                return DropdownMenuItem<String>(
                  value: customer.nama,
                  child: Text(customer.nama),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPelanggan = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Pelanggan',
                hintText: 'Pilih Pelanggan',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _namaHewanController,
              decoration: InputDecoration(
                labelText: 'Nama Hewan',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _selectTanggalPenitipan(context);
              },
              child: Text('Pilih Tanggal Penitipan'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _selectTanggalPengambilan(context);
              },
              child: Text('Pilih Tanggal Pengambilan'),
            ),
            SizedBox(height: 20),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    onPressed: () {
                      _tambahData();
                    },
                    child: Text('Tambah Data'),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectTanggalPenitipan(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _tanggalPenitipanController.text = picked.toString();
      });
    }
  }

  Future<void> _selectTanggalPengambilan(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _tanggalPengambilanController.text = picked.toString();
      });
    }
  }

  Future<void> _tambahData() async {
    setState(() {
      _isLoading = true;
    });

    String? selectedPelangganId;
    customers.forEach((customer) {
      if (customer.nama == _selectedPelanggan) {
        selectedPelangganId = customer.nama;
      }
    });

    final Map<String, dynamic> newData = {
      'id_pelanggan': selectedPelangganId,
      'nama_hewan': _namaHewanController.text,
      'tanggal_penitipan': _tanggalPenitipanController.text,
      'tanggal_pengambilan': _tanggalPengambilanController.text,
    };

    final response = await http.post(
      Uri.parse(
          'https://tugas-besar-7e24d-default-rtdb.firebaseio.com/penitipan_hewan.json'),
      body: json.encode(newData),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Data berhasil ditambahkan"),
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.pop(context);
    } else {
      print(response.statusCode);
      print(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal menambahkan data"),
          duration: Duration(seconds: 3),
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }
}
