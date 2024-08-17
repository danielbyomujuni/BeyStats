import 'package:bey_stats/battlepass/database_instance.dart';
import 'package:bey_stats/structs/launch_data.dart';

import 'package:flutter/material.dart';

class DatabaseObserver extends ChangeNotifier {
  static final DatabaseObserver _instance = DatabaseObserver._internal();

  factory DatabaseObserver() {
    return _instance;
  }

  DatabaseObserver._internal();

  int _allTimeMax = 0;
  int _sessionMax = 0;
  int _sessionCount = 0;
  int _launchCount = 0;
  List<int> _launches = [];
  List<LaunchData> _launchData = [];
  List<LaunchData> _topFive = [];

  int get allTimeMax => _allTimeMax;
  int get sessionMax => _sessionMax;
  int get sessionCount => _sessionCount;
  int get launchCount => _launchCount;
  List<int> get launches => _launches;
  List<LaunchData> get launchData => _launchData;
  List<LaunchData> get topFive => _topFive;

  Future<void> updateMaxValues() async {
    var db = await DatabaseInstance.getInstance();
    _allTimeMax = await db.getAllTimeMax();
    _sessionMax = await db.getSessionTimeMax();
    _sessionCount = await db.getSessionCount();
    _launchCount = await db.getLaunchCount();
    _launches = await db.getLaunches();
    _launchData = await db.getLaunchData();
    _topFive = await db.getTopFive();

    notifyListeners();
  }
}
