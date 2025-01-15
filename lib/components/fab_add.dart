import 'package:flutter/material.dart';
import 'package:track_inv_flutter/ui/add_inventory_item_screen.dart';

class FabAdd extends StatelessWidget {
  const FabAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const AddInventoryItemScreen()));
      },
      shape: CircleBorder(),
      backgroundColor: Color(0xFF3B3B3C),
      child: Icon(
        Icons.add,
        color: Color(0xFFFFCA0E),
      ),
    );
  }
}
