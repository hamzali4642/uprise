
import 'package:flutter/material.dart';
import 'package:uprise/screens/dashboard/discovery.dart';
import 'package:uprise/screens/dashboard/home.dart';
import 'package:uprise/screens/dashboard/home/promos.dart';
import 'package:uprise/screens/dashboard/home/statistics.dart';

import '../screens/dashboard/home/event.dart';
import '../screens/dashboard/home/feed.dart';

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

  String _homeSelected = "Feed";

  String get homeSelected => _homeSelected;

  set homeSelected(String value) {
    _homeSelected = value;
    notifyListeners();
  }

  Widget homePage(){
    switch (_homeSelected){
      case "Feed" :
        return Feed();
      case "Events" :
        return Events();
      case "Promos" :
        return Promos();
      case "Statistics" :
        return Statistics();
      default:
        return Statistics();
    }
  }
}