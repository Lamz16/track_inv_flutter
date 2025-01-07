import 'package:flutter/material.dart';

class CardLongItemLastUpdate extends StatelessWidget {
  String typeTransaction;
  String nominalOfTran;
  String item;
  String partnerName;
  String dateOfTrans;
    CardLongItemLastUpdate({super.key, required this.typeTransaction, required this.nominalOfTran, required this.item, required this.partnerName, required this.dateOfTrans});

  @override
  Widget build(BuildContext context) {

    double padItemUpdate = 8.0;

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
                  SizedBox(width: 8.0),
                  Text(
                    typeTransaction,
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0),
                  ),
                  Spacer(),
                  Text(
                    '+ Rp. $nominalOfTran',
                    style: TextStyle(
                        color: Colors.green,
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
