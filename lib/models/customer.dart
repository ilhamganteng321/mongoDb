import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Customer {
  String id;
  String nama;
  String alamat;
  String email;
  String nomorTelepon;
  String tanggal;

  Customer({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.email,
    required this.nomorTelepon,
    required this.tanggal,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'], // Menggunakan 'id' sebagai kunci untuk ID pelanggan
      nama: json['nama'],
      alamat: json['alamat'],
      email: json['email'],
      nomorTelepon: json['nomor_telepon'],
      tanggal: json['tanggal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'alamat': alamat,
      'email': email,
      'nomor_telepon': nomorTelepon,
      'tanggal': tanggal,
    };
  }
}

class CustomerService {
  final String baseUrl = 'https://tugas-besar-7e24d-default-rtdb.firebaseio.com/data_pelanggan';

  Future<List<Customer>> getCustomers() async {
    final url = Uri.parse('$baseUrl/NwD-ZyigHRvlfBK4I-g.json');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<Customer> customers = [];
        final Map<String, dynamic> data = json.decode(response.body);
        data.forEach((customerId, customerData) {
          customers.add(Customer.fromJson({
            'id_pelanggan': customerId,
            ...customerData,
          }));
        });
        return customers;
      } else {
        throw Exception('Failed to load customers');
      }
    } catch (error) {
      throw Exception('An error occurred: $error');
    }
  }

  Future<void> addCustomer(Customer customer) async {
    final url = Uri.parse('$baseUrl/NwD-ZyigHRvlfBK4I-g.json');

    try {
      final response = await http.post(
        url,
        body: json.encode(customer.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to add customer');
      }
    } catch (error) {
      throw Exception('An error occurred: $error');
    }
  }

  Future<void> updateCustomer(Customer customer) async {
    final url = Uri.parse('$baseUrl/NwD-ZyigHRvlfBK4I-g/${customer.id}.json');

    try {
      final response = await http.patch(
        url,
        body: json.encode(customer.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update customer');
      }
    } catch (error) {
      throw Exception('An error occurred: $error');
    }
  }

  Future<void> deleteCustomer(String customerId) async {
    final url = Uri.parse('$baseUrl/NwD-ZyigHRvlfBK4I-g/$customerId.json');

    try {
      final response = await http.delete(url);

      if (response.statusCode != 200) {
        throw Exception('Failed to delete customer');
      }
    } catch (error) {
      throw Exception('An error occurred: $error');
    }
  }
}
