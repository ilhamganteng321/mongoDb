import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tugas_besar/models/customer.dart';
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
import 'package:tugas_besar/pelanggan/tambah.dart';
import 'nampilin.dart'; // Make sure to import the update_customer_form.dart file
import 'package:http/http.dart' as http;

class Customers extends StatefulWidget {
  @override
  _CustomersState createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  List<Customer> customers = [];

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  Future<void> _fetchCustomers() async {
    final String baseUrl = 'https://tugas-besar-7e24d-default-rtdb.firebaseio.com/data_pelanggan.json';
    final url = Uri.parse(baseUrl);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic>? data = json.decode(response.body);

        if (data != null) {
          print('Received data: $data'); // Tampilkan data yang diterima dari server
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
          print(response.statusCode);
        } else {
          throw Exception('Failed to load customers: Response body is null');
        }
      } else {
        throw Exception('Failed to load customers: Status code ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to load customers: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddCustomerForm(),)).then((_) {
            setState(() {
              _fetchCustomers();
            });
          });
        },
      ),
      appBar: AppBar(
        title: Text('Data pelanggan'),
        centerTitle: true,
      ),
      body: customers.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              semanticsLabel: ("Memuat"),
              semanticsValue: "memuat",
            ),
            Text("memuat")
          ],
        ),
      )
          : Padding(
        padding: EdgeInsets.all(8.0),
        child: DataTable(
          columns: [
            DataColumn(label: Text('Nama')),
            DataColumn(label: Text('Alamat')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Nomor Telepon')),
            DataColumn(label: Text('Tanggal')),
            DataColumn(label: Text('aksi'))
          ],
          rows: customers.map((customer) {
            return DataRow(
              cells: [
                DataCell(Text(customer.nama)),
                DataCell(Text(customer.alamat)),
                DataCell(Text(customer.email)),
                DataCell(Text(customer.nomorTelepon)),
                DataCell(Text(customer.tanggal)),
                DataCell(
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      DropdownButton<String>(
                        value: null,
                        onChanged: (value) {
                          if (value == 'update') {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdateCustomerForm(customerId: customer.id),)).then((_){
                              setState(() {
                                _fetchCustomers();
                              });
                            });
                          } else if (value == 'delete') {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return DeleteCustomerDialog(customerId: customer.id);
                              },
                            ).then((_) {
                              setState(() {
                                _fetchCustomers();
                              });
                            });
                          }
                        },
                        items: [
                          DropdownMenuItem(
                            value: 'update',
                            child: Text('Update'),
                          ),
                          DropdownMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class DeleteCustomerDialog extends StatefulWidget {
  final String customerId;

  DeleteCustomerDialog({required this.customerId});

  @override
  _DeleteCustomerDialogState createState() => _DeleteCustomerDialogState();
}

class _DeleteCustomerDialogState extends State<DeleteCustomerDialog> {
  bool _isLoading = false;

  Future<void> _deleteCustomer() async {
    setState(() {
      _isLoading = true;
    });

    final String baseUrl = 'https://tugas-besar-7e24d-default-rtdb.firebaseio.com/data_pelanggan/${widget.customerId}.json';
    final url = Uri.parse(baseUrl);

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data berhasil di hapus'),
          duration: Duration(seconds: 3),),
        );
        setState(() {
          Navigator.of(context).pop();
        });
      } else {
        throw Exception('Failed to delete customer: Status code ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to delete customer: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete Customer'),
      content: Text('Are you sure you want to delete this customer?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: _isLoading ? null : _deleteCustomer,
          child: _isLoading
              ? CircularProgressIndicator()
              : Text('Delete'),
        ),
      ],
    );
  }
}