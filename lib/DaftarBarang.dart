import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './barang.dart';

class DaftarBarang extends StatefulWidget {
  @override
  _DaftarBarangState createState() => _DaftarBarangState();
}

class _DaftarBarangState extends State<DaftarBarang> {
  late List<Barang> _daftarBarang = [];
  bool _isLoading = true;

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
          _isLoading = false;
        });
      } else {
        print('Gagal memuat daftar barang. Status code: ${response.statusCode}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      print('Terjadi kesalahan: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Barang'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        ),
        itemCount: _daftarBarang.length,
        itemBuilder: (context, index) {
          final barang = _daftarBarang[index];
          return GestureDetector(
            onTap: () async {
              final updatedBarang = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailBarang(barang: barang),
                ),
              );
              if (updatedBarang != null) {
                setState(() {
                  // Find the updated item and update it in the list
                  final index = _daftarBarang.indexWhere((element) => element.id == updatedBarang.id);
                  if (index != -1) {
                    _daftarBarang[index] = updatedBarang;
                  }
                });
              }
            },
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0),
                      ),
                      child: Image.network(
                        'https://picsum.photos/id/${index + 1}/200/300',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          barang.nama,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Merek: ${barang.merek}',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Harga: ${barang.harga}',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class DetailBarang extends StatefulWidget {
  final Barang barang;

  const DetailBarang({required this.barang});

  @override
  _DetailBarangState createState() => _DetailBarangState();
}

class _DetailBarangState extends State<DetailBarang> {
  late TextEditingController _namaController;
  late TextEditingController _merekController;
  late TextEditingController _hargaController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.barang.nama);
    _merekController = TextEditingController(text: widget.barang.merek);
    _hargaController = TextEditingController(text: widget.barang.harga.toString());
  }

  @override
  void dispose() {
    _namaController.dispose();
    _merekController.dispose();
    _hargaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.barang.nama}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _namaController,
              decoration: InputDecoration(labelText: 'Nama', icon: Icon(Icons.person_add)),
            ),
            TextFormField(
              controller: _merekController,
              decoration: InputDecoration(labelText: 'Merek', icon: Icon(Icons.add_shopping_cart)),
            ),
            TextFormField(
              controller: _hargaController,
              decoration: InputDecoration(labelText: 'Harga', icon: Icon(Icons.price_change)),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final updatedBarang = Barang(
                  id: widget.barang.id,
                  nama: _namaController.text,
                  merek: _merekController.text,
                  harga: int.parse(_hargaController.text),
                );

                try {
                  final url = 'https://tugas-besar-7e24d-default-rtdb.firebaseio.com/barang/${widget.barang.id}.json';
                  final response = await http.put(
                    Uri.parse(url),
                    body: json.encode({
                      'nama': updatedBarang.nama,
                      'merek': updatedBarang.merek,
                      'harga': updatedBarang.harga,
                    }),
                  );

                  if (response.statusCode == 200) {
                    Navigator.of(context).pop(updatedBarang);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Data berhasil diupdate",), duration: Duration(seconds: 2),)
                    );
                  } else {
                    print('Gagal mengupdate barang. Status code: ${response.statusCode}');
                  }
                } catch (error) {
                  print('Terjadi kesalahan: $error');
                }
              },
              child: Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}
