import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tugas_besar/penjualan/add_penjualan.dart';
import 'package:tugas_besar/penjualan/update_date.dart';

class SalesDataTable extends StatefulWidget {
  @override
  _SalesDataTableState createState() => _SalesDataTableState();
}

class _SalesDataTableState extends State<SalesDataTable> {
  late List<Map<String, dynamic>> salesData = [];

  @override
  void initState() {
    super.initState();
    _fetchSalesData();
  }

  Future<void> _fetchSalesData() async {
    final String baseUrl =
        'https://tugas-besar-7e24d-default-rtdb.firebaseio.com/data_penjualan.json';

    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic>? data = json.decode(response.body);

        if (data != null) {
          List<Map<String, dynamic>> fetchedSalesData = [];
          data.forEach((key, value) {
            fetchedSalesData.add({
              'id': key, // tambahkan id untuk referensi saat menghapus
              'customer_name': value['nama_customer'],
              'product_name': value['nama_produk'],
              'price': value['harga'],
              'quantity': value['qty'],
              'total_price': value['harga_total'],
            });
          });

          setState(() {
            salesData = fetchedSalesData;
          });
        }
      } else {
        throw Exception(
            'Failed to load sales data: Status code ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to load sales data: $error');
    }
  }

  Future<void> _deleteSalesData(String id) async {
    final String baseUrl =
        'https://tugas-besar-7e24d-default-rtdb.firebaseio.com/data_penjualan/$id.json';

    try {
      final response = await http.delete(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        setState(() {
          // hapus data dari list saat berhasil dihapus dari server
          salesData.removeWhere((element) => element['id'] == id);
        });
      } else {
        throw Exception(
            'Failed to delete sales data: Status code ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to delete sales data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
                  builder: (context) => AddSalesScreen(),
                ))
                .then((_) => {
                      setState(() {
                        _fetchSalesData();
                      })
                    });
          },
          icon: Icon(Icons.add)),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          border: TableBorder(
            bottom: BorderSide(color: Colors.black, width: 10),
          ),
          dataRowColor: MaterialStatePropertyAll(Colors.blue),
          dataTextStyle: TextStyle(fontFamily: 'arial', color: Colors.white),
          columns: [
            DataColumn(label: Text('Customer Name'), numeric: true),
            DataColumn(
              label: Text('Product Name'),
            ),
            DataColumn(label: Text('Price')),
            DataColumn(label: Text('Quantity')),
            DataColumn(label: Text('Total Price')),
            DataColumn(label: Text("Aksi"))
          ],
          rows: salesData.map((sales) {
            return DataRow(
              color: MaterialStatePropertyAll(Colors.blue),
              cells: [
                DataCell(
                  Text(sales['customer_name']),
                ),
                DataCell(Text(sales['product_name'])),
                DataCell(Text('\Rp${sales['price'].toStringAsFixed(2)}')),
                DataCell(Text(sales['quantity'].toString())),
                DataCell(Text('\Rp${sales['total_price'].toStringAsFixed(2)}')),
                DataCell(Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                          builder: (context) =>
                              UpdateSalesScreen(salesData: sales),
                        ))
                            .then((value) {
                          setState(() {
                            _fetchSalesData();
                          });
                        });
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Edit",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    IconButton(
                        onPressed: () {
                          _deleteSalesData(sales['id']);
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.white,
                        )),
                    Text(
                      "Hapus",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ))
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
