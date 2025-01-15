import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:track_inv_flutter/components/card_long_item_last_update.dart';
import 'package:track_inv_flutter/components/home_btn_io.dart';
import 'package:track_inv_flutter/components/home_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> transactionData = [];
  String todayDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _getLastUpdateTransactions();
  }

  /// Fungsi untuk mengambil data transaksi terbaru dari Firebase
  Future<void> _getLastUpdateTransactions() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('data_transaksi');
    DataSnapshot snapshot = await ref.get();

    if (snapshot.exists) {
      print('Data Firebase Transaksi ${snapshot.value}');
      Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.value as Map);

      setState(() {
        transactionData = data.entries.map((entry) {
          final value = Map<String, dynamic>.from(entry.value);
          return {
            'idTransaction': value['idTransaksi']?.toString() ?? '',
            'typeTransaction': value['jenisTran']?.toString() ?? '',
            'nominalOfTran': value['nominal']?.toString() ?? '',
            'item': value['namaBarang']?.toString() ?? '',
            'partnerName': value['namaPartner']?.toString() ?? '',
            'dateOfTrans': value['tglTran']?.toString() ?? '',
          };
        }).where((transaction){
          return transaction['dateOfTrans'] == todayDate;
        }).toList();
      });
    } else {
      print('No data available');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              "Track Inv",
              style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8.0),

            // Cards Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                HomeCard(
                  countItem: '12',
                  icUrl: 'assets/images/ic_stok_tersedia.png',
                  typeOf: 'Stok tersedia',
                ),
                HomeCard(
                  countItem: '50',
                  icUrl: 'assets/images/ic_item_menipis.png',
                  typeOf: 'Stok menipis',
                ),
                HomeCard(
                  countItem: '5',
                  icUrl: 'assets/images/ic_item_habis.png',
                  typeOf: 'Stok habis',
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Buttons Section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HomeBtnIo(
                  urlImg: 'assets/images/ic_stok_in.png',
                  text: 'Stok Masuk',
                ),
                SizedBox(width: 16.0),
                HomeBtnIo(
                  urlImg: 'assets/images/ic_stok_out.png',
                  text: 'Stok Keluar',
                ),
              ],
            ),
            const SizedBox(height: 36.0),

            // Last Update Header
            const Text(
              "Last Update",
              style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8.0),

            // Last Update Transactions List
            Expanded(
              child: transactionData.isEmpty
                  ? const Center(
                child: Text('No transactions available'),
              )
                  : ListView.builder(
                itemCount: transactionData.length,
                itemBuilder: (context, index) {
                  var transaction = transactionData[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: CardLongItemLastUpdate(
                      typeTransaction: transaction['typeTransaction']!,
                      nominalOfTran: transaction['nominalOfTran']!,
                      item: transaction['item']!,
                      partnerName: transaction['partnerName']!,
                      dateOfTrans: transaction['dateOfTrans']!,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
