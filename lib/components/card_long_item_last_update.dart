import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CardLongItemLastUpdate extends StatelessWidget {
  String typeTransaction;
  String nominalOfTran;
  String item;
  String partnerName;
  String dateOfTrans;

  CardLongItemLastUpdate(
      {super.key,
      required this.typeTransaction,
      required this.nominalOfTran,
      required this.item,
      required this.partnerName,
      required this.dateOfTrans});

  @override
  Widget build(BuildContext context) {
    const padItemUpdate = 8.0;
    final formattedNominal = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    ).format(int.tryParse(nominalOfTran) ?? 0);
    var fixedColor = typeTransaction == 'Keluar' ? Colors.green : Colors.red;
    String fixNominal = typeTransaction == 'Keluar'
        ? '+ Rp. $formattedNominal'
        : '- Rp. $formattedNominal';

    return Container(
      width: double.infinity,
      height: 100.0,
      decoration: BoxDecoration(
        color: Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.only(
                  left: padItemUpdate,
                  right: padItemUpdate,
                  top: padItemUpdate),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/ic_list_barang.png',
                    width: 24.0,
                    height: 24.0,
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    typeTransaction,
                    style: TextStyle(
                        color: fixedColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0),
                  ),
                  Spacer(),
                  Text(
                    fixNominal,
                    style: TextStyle(
                        color: fixedColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0),
                  ),
                ],
              )),
          const Divider(
            color: Colors.black,
            thickness: 1.0,
            height: 20.0,
          ),
          Padding(
            padding: EdgeInsets.all(padItemUpdate),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(item),
                Spacer(),
                Text(partnerName),
                Spacer(),
                Text(dateOfTrans)
              ],
            ),
          )
        ],
      ),
    );
  }
}
