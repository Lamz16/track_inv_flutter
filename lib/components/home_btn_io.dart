import 'package:flutter/material.dart';

class HomeBtnIo extends StatelessWidget {
  final String urlImg;
  final String text;
  const HomeBtnIo({super.key, required this.urlImg, required this.text});

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Image.asset(urlImg, width: 28.0, height: 28.0)),
          Spacer(),
          Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Text(text, style: TextStyle(color: Colors.white)))
        ],
      ),
    );
  }
}
