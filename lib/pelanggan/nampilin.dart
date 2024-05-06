import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/customer.dart';

class UpdateCustomerForm extends StatefulWidget {
  final String customerId;
  UpdateCustomerForm({required this.customerId});

  @override
  _UpdateCustomerFormState createState() => _UpdateCustomerFormState();
}

class _UpdateCustomerFormState extends State<UpdateCustomerForm> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nomorTeleponController = TextEditingController();
  DateTime _tanggalController = DateTime.now();
  String _tanggalFormatted = '';

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCustomerData();
  }

  Future<void> _fetchCustomerData() async {
    final url = Uri.parse('https://tugas-besar-7e24d-default-rtdb.firebaseio.com/data_pelanggan/${widget.customerId}.json');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          _namaController.text = data['nama'];
          _alamatController.text = data['alamat'];
          _emailController.text = data['email'];
          _nomorTeleponController.text = data['nomor_telepon'];
          _tanggalController = DateTime.parse(data['tanggal']);
          _tanggalFormatted = _formatDate(_tanggalController);
        });
      } else {
        throw Exception('Failed to load customer data');
      }
    } catch (error) {
      throw Exception('An error occurred: $error');
    }
  }


  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _updateCustomer() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('https://tugas-besar-7e24d-default-rtdb.firebaseio.com/data_pelanggan/${widget.customerId}.json');

    try {
      final response = await http.put(
        url,
        body: json.encode({
          'nama': _namaController.text,
          'alamat': _alamatController.text,
          'email': _emailController.text,
          'nomor_telepon': _nomorTeleponController.text,
          'tanggal': _tanggalController.toString(),
        }),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Customer data updated successfully'),
            duration: Duration(seconds: 3),
          ),
        );
        setState(() {
          Navigator.of(context).pop();
        });
      } else {
        throw Exception('Failed to update customer data');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String _tanggal = DateTime.now().toString();
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Customer Data'),
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
            child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _namaController,
                decoration: InputDecoration(labelText: 'Nama',
                icon: Icon(Icons.person)),
              ),
              TextField(
                controller: _alamatController,
                decoration: InputDecoration(labelText: 'Alamat',icon: Icon(Icons.map)),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email', icon: Icon(Icons.email)),
              ),
              TextField(
                controller: _nomorTeleponController,
                decoration: InputDecoration(labelText: 'Nomor Telepon', icon: Icon(Icons.numbers)),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20,),
              Text(
                _tanggal,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _tanggalFormatted,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateCustomer,
                  child: Text('Update Customer'),
                ),
              ),
            ],
                    ),
                  ),
          ),
    );
  }
}