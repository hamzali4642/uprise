import 'package:flutter/material.dart';
import 'package:uprise/screens/dashboard/discovery.dart';
import 'package:uprise/screens/dashboard/home.dart';

class DashboardProvider with ChangeNotifier{
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }

  List<Widget?> pages = [
    Home(),
    null,
    Discovery(),
  ];
}