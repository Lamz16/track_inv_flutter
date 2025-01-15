import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CardLongInventoryItem extends StatelessWidget {
  final String itemName;
  final String stock;
  final String sellPrice;
  final String buyPrice;

  const CardLongInventoryItem(
      {super.key,
      required this.itemName,
      required this.stock,
      required this.buyPrice,
      required this.sellPrice});

  @override
  Widget build(BuildContext context) {
    double padItemInventory = 8.0;
    final formattedBuyPrice = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    ).format(int.tryParse(buyPrice) ?? 0);

    final formattedSellPrice = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    ).format(int.tryParse(sellPrice) ?? 0);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.only(
                  left: padItemInventory,
                  right: padItemInventory,
                  top: padItemInventory),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/ic_list_barang.png',
                    width: 24.0,
                    height: 24.0,
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    itemName,
                    style: TextStyle(
                        color: Colors.indigo.shade900,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0),
                  ),
                ],
              )),
          Divider(
            color: Colors.black,
            thickness: 1.0,
            height: 20.0,
          ),
          Padding(
            padding: EdgeInsets.only(
                right: padItemInventory, left: padItemInventory),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Stok'),
                Spacer(),
                Text('Harga Jual'),
                Spacer(),
                Text('Harga Beli')
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(padItemInventory),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(stock),
                Spacer(),
                Text('Rp. $formattedSellPrice'),
                Spacer(),
                Text('Rp. $formattedBuyPrice')
              ],
            ),
          )
        ],
      ),
    );
  }
}
