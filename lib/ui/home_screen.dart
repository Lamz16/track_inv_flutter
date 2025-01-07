import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:track_inv_flutter/components/card_long_item_last_update.dart';
import 'package:track_inv_flutter/components/home_btn_io.dart';
import 'package:track_inv_flutter/components/home_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> transactionData = [
    {
      'typeTransaction': 'Keluar',
      'nominalOfTran': '50.000',
      'item': 'Beras',
      'partnerName': 'Hartik',
      'dateOfTrans': '08-01-2025'
    },
    {
      'typeTransaction': 'Masuk',
      'nominalOfTran': '100.000',
      'item': 'Gula',
      'partnerName': 'Santi',
      'dateOfTrans': '09-01-2025'
    },
    {
      'typeTransaction': 'Keluar',
      'nominalOfTran': '25.000',
      'item': 'Minyak',
      'partnerName': 'Deni',
      'dateOfTrans': '10-01-2025'
    },
    {
      'typeTransaction': 'Keluar',
      'nominalOfTran': '25.000',
      'item': 'Minyak',
      'partnerName': 'Deni',
      'dateOfTrans': '10-01-2025'
    },
    {
      'typeTransaction': 'Keluar',
      'nominalOfTran': '25.000',
      'item': 'Minyak',
      'partnerName': 'Deni',
      'dateOfTrans': '10-01-2025'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Track Inv",
                style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600),
                textAlign: TextAlign.start,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                  SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      HomeBtnIo(
                          urlImg: 'assets/images/ic_stok_in.png',
                          text: 'Stok Masuk'),
                      SizedBox(
                        width: 16.0,
                      ),
                      HomeBtnIo(
                          urlImg: 'assets/images/ic_stok_out.png',
                          text: 'Stok Keluar'),
                    ],
                  ),
                  SizedBox(
                    height: 36.0,
                  ),
                ],
              ),
              Text(
                "Last Update",
                style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w600),
                textAlign: TextAlign.start,
              ),
              Expanded(
                child: ListView.builder(
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
          ))),
    );
  }
}
