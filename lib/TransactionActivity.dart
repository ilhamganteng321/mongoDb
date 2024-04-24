import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './barang.dart';
import 'package:dropdown_search/dropdown_search.dart';

class AddTransactionForm extends StatefulWidget {
  @override
  _AddTransactionFormState createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  String? _selectedBarangId; // Perubahan: Menyimpan barangId yang dipilih

  late List<Barang> _daftarBarang = [];

  @override
  void initState() {
    super.initState();
    _loadBarang();
  }

  Future<void> _loadBarang() async {
    final url = 'https://tugas-besar-7e24d-default-rtdb.firebaseio.com/barang.json';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final List<Barang> loadedBarang = [];
        data.forEach((id, barangData) {
          loadedBarang.add(
            Barang(
              id: id,
              nama: barangData['nama'],
              merek: barangData['merek'],
              harga: barangData['harga'],
            ),
          );
        });
        setState(() {
          _daftarBarang = loadedBarang;
        });
      } else {
        print('Gagal memuat daftar barang. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Terjadi kesalahan: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Tambah Transaksi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _customerNameController,
                decoration: InputDecoration(labelText: 'Nama Pelanggan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nama pelanggan';
                  }
                  return null;
                },
              ),
              DropdownSearch<String>(
                popupProps: PopupProps.menu(
                  showSelectedItems: true,
                ),
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    label: Text("Pilih barang"),
                  ),
                ),
                selectedItem: null, // Perubahan: Ubah menjadi null
                onChanged: (newValue) {
                  setState(() {
                    final selectedBarang = _daftarBarang.firstWhere(
                            (barang) => barang.nama == newValue,
                        orElse: () => Barang(id: '', nama: '', merek: '', harga: 0));
                    _selectedBarangId = selectedBarang.id; // Perubahan: Simpan barangId yang dipilih
                  });
                },
                items: _daftarBarang.map((barang) => barang.nama).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilih barang';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _addTransaction();
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

  Future<void> _addTransaction() async {
    final url = 'https://tugas-besar-7e24d-default-rtdb.firebaseio.com/transaksi.json';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'customerName': _customerNameController.text,
          'barangId': _selectedBarangId, // Perubahan: Menggunakan barangId yang dipilih
        }),
      );

      if (response.statusCode == 200) {
        print('Transaksi berhasil ditambahkan.');
        _customerNameController.clear();
        setState(() {
          _selectedBarangId = null;
        });

        // Tampilkan Snackbar untuk memberi tahu user bahwa transaksi berhasil ditambahkan
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Transaksi berhasil ditambahkan'),
            duration: Duration(seconds: 2), // Atur durasi tampilan Snackbar
          ),
        );
      } else {
        print('Gagal menambahkan transaksi. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Terjadi kesalahan: $error');
    }
  }
}
