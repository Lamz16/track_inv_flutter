import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:track_inv_flutter/components/card_long_item_last_update.dart';
import 'package:firebase_database/firebase_database.dart';

class TransaksiScreen extends StatefulWidget {
  const TransaksiScreen({super.key});

  @override
  State<TransaksiScreen> createState() => _TransaksiScreenState();
}

class _TransaksiScreenState extends State<TransaksiScreen> {
  final TextEditingController _searchController = TextEditingController();
   List<Map<String, String>> transactionData = [];
  List<Map<String, String>> filteredTransaction = [];

  @override
  void initState() {
    super.initState();
    _getTransactionData();
  }

  Future<void> _getTransactionData() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('data_transaksi');
    DataSnapshot snapshot = await ref.get();

    if (snapshot.exists){
      print('Data Firebase Transaksi ${snapshot.value}');
      Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.value as Map);
      setState(() {
        transactionData = data.entries.map((entry){
          final value = Map<String,dynamic>.from(entry.value);
          return {
            'idTransaction': value['idTransaksi']?.toString() ?? '',
            'typeTransaction': value['jenisTran']?.toString() ?? '',
            'nominalOfTran': value['nominal']?.toString() ?? '',
            'item': value['namaBarang']?.toString() ?? '',
            'partnerName': value['namaPartner']?.toString() ?? '',
            'dateOfTrans': value['tglTran']?.toString() ?? '',
          };
        }).toList();

        transactionData.sort((a,b) {
          DateTime dateA = DateFormat('dd-MM-yyyy').parse(a['dateOfTrans']!);
          DateTime dateB = DateFormat('dd-MM-yyyy').parse(b['dateOfTrans']!);
          return dateB.compareTo(dateA);
        });

        filteredTransaction = transactionData;
        print('Data transaksi $transactionData');
      });
    }else{
      print('No data Available');
    }
  }

  void _filterTransaction(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredTransaction = transactionData;
      } else {
        filteredTransaction = transactionData
            .where((item) =>
                item['item']!.toLowerCase().contains(query.toLowerCase()))
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
              onChanged: _filterTransaction,
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
                    itemCount: filteredTransaction.length,
                    itemBuilder: (context, index) {
                      var transaction = filteredTransaction[index];
                      print('Filtered Transaction Length: ${filteredTransaction.length}');
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: CardLongItemLastUpdate(
                            typeTransaction: transaction['typeTransaction']!,
                            nominalOfTran: transaction['nominalOfTran']!,
                            item: transaction['item']!,
                            partnerName: transaction['partnerName']!,
                            dateOfTrans: transaction['dateOfTrans']!),
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
