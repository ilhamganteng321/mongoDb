import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'add_penitipan_hewan.dart';
import 'edit.dart';

class PenitipanHewanScreen extends StatefulWidget {
  @override
  _PenitipanHewanScreenState createState() => _PenitipanHewanScreenState();
}

class _PenitipanHewanScreenState extends State<PenitipanHewanScreen> {
  List<dynamic> _penitipanHewan = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(
        Uri.parse('https://tugas-besar-7e24d-default-rtdb.firebaseio.com/penitipan_hewan.json'));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData != null && responseData is Map<String, dynamic>) {
        final List<dynamic> penitipanHewanList = [];
        responseData.forEach((id, penitipanHewanData) {
          penitipanHewanList.add({
            'id': id,
            'id_pelanggan': penitipanHewanData['id_pelanggan'],
            'nama_hewan': penitipanHewanData['nama_hewan'],
            'tanggal_pengambilan': penitipanHewanData['tanggal_pengambilan'],
            'tanggal_penitipan': penitipanHewanData['tanggal_penitipan'],
            'isExpanded': false,
          });
        });
        setState(() {
          _penitipanHewan = penitipanHewanList;
          _isLoading = false;
        });
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> deleteData(String penitipanId) async {
    try {
      final response = await http.delete(Uri.parse(
          'https://tugas-besar-7e24d-default-rtdb.firebaseio.com/penitipan_hewan/$penitipanId.json'));

      if (response.statusCode == 200) {
        setState(() {
          _penitipanHewan
              .removeWhere((penitipan) => penitipan['id'] == penitipanId);
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Data Penitipan Hewan berhasil dihapus")));
      } else {
        throw Exception('Failed to delete data');
      }
    } catch (error) {
      print('Error deleting data: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => FormTambahPenitipanHewan()
          )).then((_){
            setState(() {
              fetchData();
            });
          });
        },
        child: Icon(Icons.add),
      ),

      appBar: AppBar(
        title: Text('Penitipan Hewan'),
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: _penitipanHewan.length,
        itemBuilder: (context, index) {
          final penitipan = _penitipanHewan[index];
          return ExpansionTile(
            trailing: IconButton(icon: Icon(Icons.delete),onPressed: (){
              deleteData(penitipan['id']);
            },),
            title: Text('Nama Hewan: ${penitipan['nama_hewan']}'),
            leading: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                _editPenitipanHewan(penitipan['id']);
              },
            ),
            children: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ID Pelanggan: ${penitipan['id_pelanggan']}'),
                    Text('Tanggal Penitipan: ${penitipan['tanggal_penitipan']}'),
                    Text('Tanggal Pengambilan: ${penitipan['tanggal_pengambilan']}'),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _editPenitipanHewan(String penitipanId) {
    final selectedPenitipan = _penitipanHewan.firstWhere((penitipan) => penitipan['id'] == penitipanId);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => FormEditPenitipanHewan(
      penitipanId: penitipanId,
      initialSelectedPelanggan: selectedPenitipan['id_pelanggan'],
      initialNamaHewan: selectedPenitipan['nama_hewan'],
      initialTanggalPenitipan: selectedPenitipan['tanggal_penitipan'],
      initialTanggalPengambilan: selectedPenitipan['tanggal_pengambilan'],
    ),)).then((_){
      setState(() {
        fetchData();
      });
    });
  }
}
