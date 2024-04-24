import 'package:flutter/material.dart';
import 'package:tugas_besar/HomePage.dart';
import 'package:tugas_besar/RegisterActivity.dart';
import './DatabaseHelper.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    var dbHelper = DatabaseHelper();
    var users = await dbHelper.getUsers();
    bool isAuthenticated = false;
    for (var user in users) {
      if (user['username'] == username && user['password'] == password) {
        isAuthenticated = true;
        break;
      }
    }
    if (isAuthenticated) {
      // Navigasi ke halaman selanjutnya setelah login berhasil
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage(),));
      print('Login berhasil');
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Gagal'),
            content: Text('Username atau password salah'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.white),
        title: Text('Login',),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        maxRadius: 70,
                        child: Icon(Icons.person, size: 80,),
                      ),
                      SizedBox(height: 40,),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(Icons.person, color: Colors.blue), // Ikonya sekarang berwarna biru
                          filled: true,
                          fillColor: Colors.grey[200], // Warna latar belakang field
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue), // Warna garis saat field dalam fokus
                            borderRadius: BorderRadius.circular(10), // Bentuk sudut field saat dalam fokus
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[400]!), // Warna garis saat field tidak dalam fokus
                            borderRadius: BorderRadius.circular(10), // Bentuk sudut field saat tidak dalam fokus
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Masukkan username';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock, color: Colors.blue), // Ikonya sekarang berwarna biru
                          filled: true,
                          fillColor: Colors.grey[200], // Warna latar belakang field
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue), // Warna garis saat field dalam fokus
                            borderRadius: BorderRadius.circular(10), // Bentuk sudut field saat dalam fokus
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[400]!), // Warna garis saat field tidak dalam fokus
                            borderRadius: BorderRadius.circular(10), // Bentuk sudut field saat tidak dalam fokus
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Masukkan password';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _login();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Warna latar belakang tombol
                          textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white// Ukuran teks tombol
                          ),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30), // Padding tombol
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // Bentuk sudut tombol
                          ),
                        ),
                        child: Text('Login'),
                      ),
                      SizedBox(height: 20,), // Spasi antara tombol

                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => RegistrationPage(),));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, // Warna latar belakang tombol
                          textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18, //
                              color: Colors.white// Ukuran teks tombol
                          ),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30), // Padding tombol
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // Bentuk sudut tombol
                          ),
                        ),
                        child: Text('Registrasi'),
                      ),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
