import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddInventoryItemScreen extends StatefulWidget {
  const AddInventoryItemScreen({super.key});

  @override
  State<AddInventoryItemScreen> createState() => _AddInventoryItemScreenState();
}

class _AddInventoryItemScreenState extends State<AddInventoryItemScreen> {
  final double textFieldPaddingHorizontal = 36.0;
  final double textFieldPaddingVertical = 100.0;
  final _namaBarangController = TextEditingController();
  final _stokBarangController = TextEditingController();
  final _hargaBeliController = TextEditingController();
  final _hargaJualController = TextEditingController();

  final DatabaseReference _databaseRef =
      FirebaseDatabase.instance.ref().child('data_barang');

  // Fungsi untuk menambahkan data ke Firebase
  void _addInventoryItem() {
    String idBarang = _databaseRef.push().key!; // Generate ID otomatis

    Map<String, dynamic> newItem = {
      'idBarang': idBarang,
      'namaBarang': _namaBarangController.text,
      'stokBarang': int.parse(_stokBarangController.text),
      'buy': _hargaBeliController.text,
      'sell': _hargaJualController.text,
    };

    _databaseRef.child(idBarang).set(newItem).then((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data berhasil ditambahkan!')),
        );
        _clearFields();
      }
    }).catchError((error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan data: $error')),
        );
      }
    });
  }

  // Fungsi untuk membersihkan input field
  void _clearFields() {
    _namaBarangController.clear();
    _stokBarangController.clear();
    _hargaBeliController.clear();
    _hargaJualController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Tambah Data',
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.w600),
                        ),
                        Spacer(),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.close,
                              color: Color(0xFF3B3B3C),
                            ))
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            top: textFieldPaddingVertical,
                            left: textFieldPaddingHorizontal,
                            right: textFieldPaddingHorizontal),
                        child: Column(
                          children: [
                            _buildTextField(
                                _namaBarangController, 'Nama Barang'),
                            const SizedBox(height: 24.0),
                            _buildTextField(
                                _stokBarangController, 'Stok Barang'),
                            const SizedBox(height: 24.0),
                            _buildTextField(_hargaBeliController, 'Harga Beli'),
                            const SizedBox(height: 24.0),
                            _buildTextField(_hargaJualController, 'Harga Jual'),
                          ],
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Center(
                          child: FilledButton(
                        onPressed: () {
                          _addInventoryItem();
                        },
                        style: FilledButton.styleFrom(
                            backgroundColor: Color(0xFFFFCA0E)),
                        child: const Text(
                          'Tambah',
                          style: TextStyle(color: Colors.black),
                        ),
                      )),
                    )
                  ],
                ),
              ))),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFD9D9D9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          labelText: label,
        ),
      ),
    );
  }
}
