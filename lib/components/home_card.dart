import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  final String icUrl;
  final String countItem;
  final String typeOf;
  const HomeCard({super.key, required this.countItem, required this.icUrl, required this.typeOf});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF3B3B3C),
        borderRadius: BorderRadius.circular(20.0),
      ),
      width: 100.0,
      height: 100.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(left: 8.0,top: 8.0),
              child: Image.asset(icUrl,
                  width: 24.0, height: 24.0)),
          Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  Text(countItem, style: TextStyle(color: Colors.white)),
                  SizedBox(width: 8.0),
                  Text('items', style: TextStyle(color: Colors.white))
                ],
              )),
          Spacer(),
          Padding(
              padding: EdgeInsets.only(left: 8.0, bottom: 16.0),
              child:
                  Text(typeOf, style: TextStyle(color: Colors.white)))
        ],
      ),
    );
  }
}
