import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeleteDataScreen extends StatefulWidget {
  final String productId;

  DeleteDataScreen({required this.productId});

  @override
  _DeleteDataScreenState createState() => _DeleteDataScreenState();
}

class _DeleteDataScreenState extends State {
  List<dynamic> _data = [];
  bool _isLoading = false;

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://tugas-besar-7e24d-default-rtdb.firebaseio.com/data_supplier.json'));

    if (response.statusCode == 200) {
      setState(() {
        _data = json.decode(response.body).values.toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

Future<void> _deleteProduct(int id) async {
  setState(() {
    _isLoading = true; // Menandai bahwa proses penghapusan sedang berlangsung
  });

  final String baseUrl =
      'https://tugas-besar-7e24d-default-rtdb.firebaseio.com/data_supplier/$id.json';
  final url = Uri.parse(baseUrl);

  try {
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      Navigator.of(context).pop();
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
      _isLoading = false; // Menandai bahwa proses penghapusan telah selesai
    });
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Delete Data'),
    ),
    body: Center(
      child: TextButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Konfirmasi'),
                content: Text('Apakah Anda yakin ingin menghapus data?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Batal'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Hapus'),
                  ),
                ],
              );
            },
          );
        },
        child: Text('Hapus Data'),
      ),

    ),
  );
}
}