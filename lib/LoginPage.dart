import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tugas_besar/HomePage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<bool> _login(String username, String password) async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse(
        'https://tugas-besar-7e24d-default-rtdb.firebaseio.com/users.json'));

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data != null) {
        for (var user in data.values) {
          if (user['Username'] == username && user['Password'] == password) {
            return true;
          }
        }
      }
      print(response.body);
    }
    return false;
  }

  void _signIn() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (await _login(username, password)) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => HomePage(),
      ));
      print('Login berhasil');
    } else {
      // Gagal login
      // Tampilkan pesan kesalahan atau tindakan yang sesuai
      print('Username atau password salah');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              maxRadius: 100,
              child: Icon(
                Icons.person,
                size: 120,
                color: Colors.blue,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _signIn,
                    child: Text('Login'),
                  ),
          ],
        ),
      ),
    );
  }
}
