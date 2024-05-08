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
        title: Text('Supplier'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: _data.length,
                itemBuilder: (context, index) {
                  final data = _data[index];

                  return InkWell(
                    onTap: () {},
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            image: DecorationImage(
                              image: NetworkImage(
                                  'https://picsum.photos/id/$index/200/300'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15.0),
                                bottomRight: Radius.circular(15.0),
                              ),
                              color: Colors.black.withOpacity(0.5),
                            ),
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nama: ${data['nama']}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  'Alamat: ${data['alamat']}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  'Jabatan: ${data['jabatan']}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  'Email: ${data['email']}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  'Nomor Telepon: ${data['nomor_telepon']}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  // Pilih data yang akan diedit
                                  editData(context, data);
                                },
                                icon: Icon(Icons.edit, color: Colors.white),
                              ),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Delete Confirmation'),
                                        content: Text(
                                            'Are you sure you want to delete this item?'),
                                        actions: <Widget>[
                                          ElevatedButton(
                                            onPressed: () {
                                              // Do something when cancel button is pressed
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              // Do something when delete button is pressed
                                              Navigator.of(context).pop();
                                              // Add your delete functionality here
                                              _deleteProduct(
                                                      data['id_supplier'])
                                                  .then((_) {
                                                setState(() {
                                                  fetchData();
                                                });
                                              });
                                            },
                                            child: Text('Delete'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: Icon(Icons.delete, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )),
    );
  }

  void editData(BuildContext context, Map<String, dynamic> data) {
    Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) => UpdateDataScreensupplier(karyawan: data),
    ))
        .then((_) {
      setState(() {
        fetchData(); // Memperbarui data setelah proses editing selesai
      });
    });
  }
}
