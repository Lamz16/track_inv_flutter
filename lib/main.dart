import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:track_inv_flutter/ui/home_screen.dart';
import 'package:track_inv_flutter/ui/inventory_screen.dart';
import 'package:track_inv_flutter/ui/transaksi_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = <Widget>[
    HomeScreen(),
    InventoryScreen(),
    TransaksiScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _screens[_selectedIndex]),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.blue.shade50,
          labelTextStyle: WidgetStateProperty.all(
            TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFCA0E)),
          ),
          iconTheme: WidgetStateProperty.all(IconThemeData(size: 24.0)),
          backgroundColor: Color(0xFF3B3B3C),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          destinations: const [
            NavigationDestination(
              icon: ImageIcon(
                AssetImage('assets/images/ic_home.png'),
                color: Color(0xFFFFCA0E),
              ),
              label: 'Home',
            ),
            NavigationDestination(
              icon: ImageIcon(
                AssetImage('assets/images/ic_inventory.png'),
                color: Color(0xFFFFCA0E),
              ),
              label: 'Inventory',
            ),
            NavigationDestination(
              icon: ImageIcon(
                AssetImage('assets/images/ic_transactions.png'),
                color: Color(0xFFFFCA0E),
              ),
              label: 'Transactions',
            ),
          ],
        ),
      ),
    );
  }
}
