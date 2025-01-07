import 'package:flutter/material.dart';
import 'package:track_inv_flutter/components/home_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Track Inv",
                    style: TextStyle(fontSize: 32.0),
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
                              icUrl: 'assets/images/ic_stok_tersedia.png'),
                          HomeCard(
                              countItem: '50',
                              icUrl: 'assets/images/ic_item_menipis.png'),
                          HomeCard(
                              countItem: '5',
                              icUrl: 'assets/images/ic_item_habis.png'),
                        ],
                      )
                    ],
                  )
                ],
              )))),
    );
  }
}
