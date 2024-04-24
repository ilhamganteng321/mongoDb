import 'package:flutter/material.dart';
import 'package:tugas_besar/DaftarBarang.dart';
import 'package:tugas_besar/ProductActivity.dart';
import 'package:tugas_besar/ReportActivity.dart';
import 'package:tugas_besar/TransactionActivity.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: isActive ? Colors.black : Colors.white),
        actions: [
          Switch(
            value: isActive,
            onChanged: (value) {
              setState(() {
                isActive = value;
              });
            },
          )
        ],
        backgroundColor: isActive ? Colors.white : Colors.black,
        centerTitle: true,
        title: Text('Home Page', style: TextStyle(color: isActive ? Colors.black : Colors.white),),
      ),
      drawer: Drawer(
        shadowColor: Colors.white,
        backgroundColor: isActive ? Colors.black : Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: isActive ? Colors.white : Colors.black,
              ),
              child: Text(
                'Halaman Utama',
                style: TextStyle(
                  color: isActive ? Colors.black : Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.money, color: isActive ? Colors.white : Colors.black,),
              title: Text('Transaction' , style: TextStyle(color: isActive ? Colors.white : Colors.black),),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddTransactionForm(),
                ));
              },
            ),
            ListTile(
              leading: Icon(Icons.report,color: isActive ? Colors.white : Colors.black,),
              title: Text('Report' , style: TextStyle(color: isActive ? Colors.white : Colors.black),),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DaftarTransaksi(),
                ));
              },
            ),
            ListTile(
              leading: Icon(Icons.add_chart,color: isActive ? Colors.white : Colors.black,),
              title: Text('Product' , style: TextStyle(color: isActive ? Colors.white : Colors.black),),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddBarangForm(),
                ));
              },
            ),
            ListTile(
              leading: Icon(Icons.add, color: isActive ? Colors.white : Colors.black,),
              title: Text('List' , style: TextStyle(color: isActive ? Colors.white : Colors.black),),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => DaftarBarang(),));
              },
            )
          ],
        ),
      ),
      body: Center(
        child: Text(
          textAlign: TextAlign.center,
          'Halaman Home\nMclaren Lu warna apa bos',
          style: TextStyle(fontSize: 24,color: isActive? Colors.white : Colors.black),
        ),
      ),
      backgroundColor: isActive ? Colors.black : Colors.white,
    );
  }
}
