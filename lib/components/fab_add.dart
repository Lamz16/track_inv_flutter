import 'package:flutter/material.dart';

class FabAdd extends StatelessWidget {
  const FabAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      shape: CircleBorder(),
      backgroundColor: Color(0xFF3B3B3C),
      child: Icon(
        Icons.add,
        color: Color(0xFFFFCA0E),
      ),
    );
  }
}
