import 'package:flutter/material.dart';
import 'package:track_inv_flutter/components/card_long_item_last_update.dart';

class TransaksiScreen extends StatefulWidget {
  const TransaksiScreen({super.key});

  @override
  State<TransaksiScreen> createState() => _TransaksiScreenState();
}

class _TransaksiScreenState extends State<TransaksiScreen> {
  final TextEditingController _searchController = TextEditingController();
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
  List<Map<String, String>> filteredTransaction = [];

  @override
  void initState() {
    super.initState();
    filteredTransaction = transactionData;
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
