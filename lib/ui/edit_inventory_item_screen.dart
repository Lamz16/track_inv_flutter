import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EditInventoryItemScreen extends StatefulWidget {
  final Map<String, String> item;

  const EditInventoryItemScreen({super.key, required this.item});

  @override
  State<EditInventoryItemScreen> createState() =>
      _EditInventoryItemScreenState();
}

class _EditInventoryItemScreenState extends State<EditInventoryItemScreen> {
  final double textFieldPaddingHorizontal = 36.0;
  final double textFieldPaddingVertical = 100.0;
  late TextEditingController _namaBarangController;
  late TextEditingController _stokBarangController;
  late TextEditingController _hargaBeliController;
  late TextEditingController _hargaJualController;

  @override
  void initState() {
    super.initState();
    _namaBarangController =
        TextEditingController(text: widget.item['itemName']);
    _stokBarangController =
        TextEditingController(text: widget.item['stock']);
    _hargaBeliController =
        TextEditingController(text: widget.item['buyPrice']);
    _hargaJualController =
        TextEditingController(text: widget.item['sellPrice']);
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
                          'Ubah Data',
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
                            )),
                        IconButton(
                            onPressed: _deleteInventoryItem,
                            icon: Icon(
                              Icons.delete_outline,
                              color: Colors.red.shade500,
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
                          _updateInventoryItem();
                        },
                        style: FilledButton.styleFrom(
                            backgroundColor: Color(0xFFFFCA0E)),
                        child: const Text(
                          'Simpan Perubahan',
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

  void _updateInventoryItem() {
    final DatabaseReference databaseRef = FirebaseDatabase.instance.ref('data_barang');

    // Konversi nilai input dari TextField
    int stokBarang = int.tryParse(_stokBarangController.text) ?? 0;
    String hargaBeli = _hargaBeliController.text;
    String hargaJual = _hargaJualController.text;

    // Data yang akan diperbarui
    Map<String, dynamic> updatedItem = {
      'idBarang': widget.item['idBarang'],
      'namaBarang': _namaBarangController.text,
      'stokBarang': stokBarang,
      'buy': hargaBeli,
      'sell': hargaJual,
    };

    // Update data di Firebase
    databaseRef.child(widget.item['idBarang']!).update(updatedItem).then((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data berhasil diperbarui!')),
        );
        Navigator.pop(context, true);
      }
    }).catchError((error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui data: $error')),
        );
      }
    });
  }

  void _deleteInventoryItem() {
    final DatabaseReference databaseRef = FirebaseDatabase.instance.ref('data_barang');

    // Konfirmasi penghapusan
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Data'),
        content: Text('Apakah Anda yakin ingin menghapus data ini?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              // Hapus data dari Firebase
              databaseRef.child(widget.item['idBarang']!).remove().then((_) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Data berhasil dihapus!')),
                  );
                  Navigator.pop(context); // Tutup dialog
                  Navigator.pop(context, true); // Kembali ke halaman sebelumnya
                }
              }).catchError((error) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal menghapus data: $error')),
                  );
                }
              });
            },
            child: Text(
              'Hapus',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }



}
