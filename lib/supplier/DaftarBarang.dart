import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tugas_besar/supplier/add.dart';
import 'package:tugas_besar/supplier/update.dart';

class FirebaseDataScreen extends StatefulWidget {
  @override
  _FirebaseDataScreenState createState() => _FirebaseDataScreenState();
}

class _FirebaseDataScreenState extends State<FirebaseDataScreen> {
  List<dynamic> _data = [];
  bool _isLoading = false;

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://tugas-besar-7e24d-default-rtdb.firebaseio.com/data_supplier.json'));

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      List<dynamic> dataList = [];
      responseData.forEach((id, data) {
        data['id_supplier'] = id;
        dataList.add(data);
      });
      setState(() {
        _data = dataList;
      });
      print(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _deleteProduct(String idSupplier) async {
    setState(() {
      _isLoading = true;
    });

    final String baseUrl =
        'https://tugas-besar-7e24d-default-rtdb.firebaseio.com/data_supplier/$idSupplier.json';
    final url = Uri.parse(baseUrl);

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        // Hapus item dari _data
        setState(() {
          _data.removeWhere((item) => item['id_supplier'] == idSupplier);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Data berhasil dihapus"),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        throw Exception(
            'Failed to delete product: Status code ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to delete product: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddDataScreen()))
              .then((_) {
            setState(() {
              fetchData();
            });
          });
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('Firebase Data Display'),
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: _data.length,
        itemBuilder: (context, index) {
          final data = _data[index];

          return SingleChildScrollView(
            child: Card(
              child: InkWell(
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text('nama :'+
                            data['nama'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('alamat :'+
                            data['alamat'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('jabatan :'+
                            data['jabatan'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),Text('email :'+
                            data['email'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),Text('nomor_telepon :'+
                            data['nomor_telepon'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: IconButton(
                        onPressed: () {
                          // Pilih data yang akan diedit
                          editData(context, data);
                        },
                        icon: Icon(Icons.edit),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          _deleteProduct(data['id_supplier']).then((_) {
                            setState(() {
                              fetchData();
                            });
                          });
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void editData(BuildContext context, Map<String, dynamic> data) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => UpdateDataScreensupplier(karyawan: data),
    )).then((_) {
      setState(() {
        fetchData(); // Memperbarui data setelah proses editing selesai
      });
    });
  }
}
