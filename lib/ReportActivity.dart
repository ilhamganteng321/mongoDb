import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './barang.dart';

class DaftarTransaksi extends StatefulWidget {
  @override
  _DaftarTransaksiState createState() => _DaftarTransaksiState();
}

class _DaftarTransaksiState extends State<DaftarTransaksi> {
  late List<Barang> _daftarTransaksi = [];
  int _totalHarga = 0;

  @override
  void initState() {
    super.initState();
    _loadTransaksi();
  }

  Future<void> _loadTransaksi() async {
    final url = 'https://tugas-besar-7e24d-default-rtdb.firebaseio.com/transaksi.json';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final List<Barang> loadedTransaksi = [];
        int totalHarga = 0;

        await Future.forEach(data.entries, (entry) async {
          final id = entry.key;
          final transaksiData = entry.value as Map<String, dynamic>;
          final customerName = transaksiData['customerName'];
          final barangId = transaksiData['barangId'];

          final barangResponse = await http.get(
            Uri.parse(
                'https://tugas-besar-7e24d-default-rtdb.firebaseio.com/barang/$barangId.json'),
          );

          if (barangResponse.statusCode == 200) {
            final barangData = json.decode(barangResponse.body);
            final itemName = barangData['merek'];
            final itemPrice = barangData['harga'];

            loadedTransaksi.add(
              Barang(
                id: id,
                nama: customerName,
                merek: itemName,
                harga: itemPrice as int, // Cast harga menjadi integer
              ),
            );

            totalHarga += itemPrice as int; // Menambahkan harga barang ke total harga
          } else {
            print(
                'Gagal mengambil informasi barang. Status code: ${barangResponse.statusCode}');
          }
        });

        setState(() {
          _totalHarga = totalHarga;
          _daftarTransaksi = loadedTransaksi;
        });
      } else {
        print('Gagal memuat daftar transaksi. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Terjadi kesalahan: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Report - Total:Rp $_totalHarga"),
        centerTitle: true,
      ),
      body: _daftarTransaksi.isEmpty
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: _daftarTransaksi.length,
          itemBuilder: (context, index) {
            final transaksi = _daftarTransaksi[index];
            return ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text(transaksi.nama),
              subtitle: Text('Barang: ${transaksi.merek} - Harga: ${transaksi.harga}'),
            );
          },
        ),
      ),
    );
  }
}
