import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:track_inv_flutter/components/card_long_inventory_item.dart';
import 'package:track_inv_flutter/ui/edit_inventory_item_screen.dart';

import 'add_inventory_item_screen.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> inventoryData = [];
  List<Map<String, String>> filteredData = [];

  @override
  void initState() {
    super.initState();
    _getDataInventory();
  }

  Future<void> _getDataInventory() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('data_barang');
    DataSnapshot snapshot = await ref.get();
    if (snapshot.exists) {
      Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);
      setState(() {
        inventoryData = data.entries.map((entry) {
          final value = Map<String, dynamic>.from(entry.value);
          return {
            "idBarang": value['idBarang']?.toString() ?? '',
            'itemName': value['namaBarang']?.toString() ?? '',
            'stock': value['stokBarang']?.toString() ?? '',
            'buyPrice': value['buy']?.toString() ?? '',
            'sellPrice': value['sell']?.toString() ?? ''
          };
        }).toList();

        inventoryData.sort((a, b) => a['itemName']!.compareTo(b['itemName']!));

        filteredData = inventoryData;
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tidak dapat menemukan data!')),
        );
      }
    }
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredData = inventoryData;
      } else {
        filteredData = inventoryData
            .where((item) =>
            item['itemName']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _showItemDialog(Map<String, String> item) {
    final formattedBuyPrice = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    ).format(int.tryParse('${item['buyPrice']}') ?? 0);
    final formattedSellPrice = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    ).format(int.tryParse('${item['sellPrice']}') ?? 0);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/ic_list_barang.png',
                    width: 24.0,
                    height: 24.0,
                  ),
                  Spacer(),
                  Text(
                    'Detail Barang',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0),
                  ),
                  Spacer(),
                ],
              ),
              Divider(
                color: Colors.black,
                thickness: 1.0,
                height: 20.0,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nama Barang'),
                      Text('Stok'),
                      Text('Harga Beli'),
                      Text('Harga Jual'),
                    ],
                  ),
                  SizedBox(width: 8.0),
                  Column(
                    children: [
                      Text(':'),
                      Text(':'),
                      Text(':'),
                      Text(':'),
                    ],
                  ),
                  SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${item['itemName']}'),
                      Text('${item['stock']}'),
                      Text('Rp. $formattedBuyPrice'),
                      Text('Rp. $formattedSellPrice'),
                    ],
                  )
                ],
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EditInventoryItemScreen(item: item)))
                    .then((isUpdated) {
                  if (isUpdated == true) {
                    _getDataInventory();
                  }
                });
              },
              child: Text('Edit', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Tutup',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: _filterItems,
              decoration: InputDecoration(
                labelText: 'Search Items',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
                child: filteredData.isEmpty
                    ? Center(child: Text('Nama Barang tidak tersedia'))
                    : ListView.builder(
                        itemCount: filteredData.length,
                        itemBuilder: (context, index) {
                          var inventory = filteredData[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: CardLongInventoryItem(
                              itemName: inventory['itemName']!,
                              stock: inventory['stock']!,
                              buyPrice: inventory['buyPrice']!,
                              sellPrice: inventory['sellPrice']!,
                              onTap: () => _showItemDialog(inventory),
                            ),
                          );
                        }))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AddInventoryItemScreen()),
          ).then((isAdded) {
            if (isAdded == true) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Data berhasil ditambahkan!')),
              );
            }
          });
        },
        shape: CircleBorder(),
        backgroundColor: Color(0xFF3B3B3C),
        child: Icon(
          Icons.add,
          color: Color(0xFFFFCA0E),
        ),
      ),
    );
  }
}
