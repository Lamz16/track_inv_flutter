import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:track_inv_flutter/components/card_long_inventory_item.dart';
import 'package:track_inv_flutter/components/fab_add.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> inventoryData = [
    {
      'itemName': 'Gula Pasir',
      'stock': '200',
      'buyPrice': '12.000',
      'sellPrice': '13.000'
    },
    {
      'itemName': 'Beras',
      'stock': '50',
      'buyPrice': '12.000',
      'sellPrice': '13.000'
    },
  ];
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
      print('Data Firebase : ${snapshot.value}');
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

        inventoryData.sort((a,b) => a['itemName']!.compareTo(b['itemName']!));

        filteredData = inventoryData;
      });
    } else {
      print('No data available');
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
                child: ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      var inventory = filteredData[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: CardLongInventoryItem(
                            itemName: inventory['itemName']!,
                            stock: inventory['stock']!,
                            buyPrice: inventory['buyPrice']!,
                            sellPrice: inventory['sellPrice']!),
                      );
                    }))
          ],
        ),
      ),
      floatingActionButton: FabAdd(),
    );
  }
}
