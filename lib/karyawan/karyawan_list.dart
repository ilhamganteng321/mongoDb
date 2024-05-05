import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'ada_karyawan.dart';
import 'update_karyawan.dart';

class KaryawanScreen extends StatefulWidget {
  @override
  _KaryawanScreenState createState() => _KaryawanScreenState();
}

class _KaryawanScreenState extends State<KaryawanScreen> {
  List<Map<String, dynamic>> _karyawanList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final url = 'https://tugas-besar-7e24d-default-rtdb.firebaseio.com/data_karyawan.json';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final List<Map<String, dynamic>> loadedKaryawan = [];
        data.forEach((karyawanId, karyawanData) {
          loadedKaryawan.add({
            'id': karyawanId,
            'nama': karyawanData['nama'],
            'jabatan': karyawanData['jabatan'],
            'nomor_telepon': karyawanData['nomor_telepon'],
            'email': karyawanData['email'],
            'url': karyawanData['url'],
          });
        });
        setState(() {
          _karyawanList = loadedKaryawan;
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('An error occurred: $error');
    }
  }


  Future<void> deleteData(String karyawanId) async {
    try {
      final response = await http.delete(Uri.parse(
          'https://tugas-besar-7e24d-default-rtdb.firebaseio.com/data_karyawan/$karyawanId.json'));

      if (response.statusCode == 200) {
        setState(() {
          _karyawanList
              .removeWhere((karyawan) => karyawan['id'] == karyawanId);
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Data Karyawan berhasil dihapus")));
      } else {
        throw Exception('Failed to delete data');
      }
    } catch (error) {
      print('Error deleting data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => TambahKaryawanScreen()))
              .then((_) {
            fetchData();
          });
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('Data Karyawan'),
        centerTitle: true,
      ),
      body: _karyawanList.isEmpty
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: _karyawanList.length,
          itemBuilder: (context, index) {
            final karyawan = _karyawanList[index];
            return Card(
              color: Colors.blue.withOpacity(0.3),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                      builder: (context) => UpdateKaryawanScreen(
                          karyawan: karyawan)))
                      .then((_) {
                    fetchData();
                  });
                },
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    karyawan['url'],
                    width: 80.0,
                    height: 80.0,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(karyawan['nama'],style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Jabatan: ${karyawan['jabatan']}',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    Text('Nomor Telepon: ${karyawan['nomor_telepon']}',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    Text('Email: ${karyawan['email']}',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  ],
                ),
                trailing: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Hapus Karyawan'),
                        content:
                        Text('Anda yakin ingin menghapus karyawan ini?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                              deleteData(karyawan['id']).then((_) {
                                fetchData();
                              });
                            },
                            child: Text('Hapus'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: Icon(Icons.delete, color: Colors.white),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
