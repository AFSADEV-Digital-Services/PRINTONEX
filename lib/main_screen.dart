import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:printonex_final/views/pages/cart.dart';
import 'package:printonex_final/views/pages/chat.dart';
import 'package:printonex_final/views/pages/home.dart';
import 'package:printonex_final/views/pages/order_history.dart';
import 'package:printonex_final/views/pages/print.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final _pages = [Home(), Print(), Cart(), OrderHistory(), Chat()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavyBar(
        containerHeight: 60,
        selectedIndex: _currentIndex,
        showElevation: true,
        itemCornerRadius: 24,
        curve: Curves.elasticInOut,
        onItemSelected: (index) => setState(() => _currentIndex = index),
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
            activeColor: Colors.pinkAccent,
            inactiveColor: Colors.greenAccent,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.print),
            title: Text(
              'Print',
            ),
            activeColor: Colors.pinkAccent,
            inactiveColor: Colors.greenAccent,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.shopping_bag),
            title: Text('Cart'),
            activeColor: Colors.pinkAccent,
            inactiveColor: Colors.greenAccent,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.list),
            title: Text('Order'),
            activeColor: Colors.pinkAccent,
            inactiveColor: Colors.greenAccent,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.chat),
            title: Text('Chat'),
            activeColor: Colors.pinkAccent,
            inactiveColor: Colors.greenAccent,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
