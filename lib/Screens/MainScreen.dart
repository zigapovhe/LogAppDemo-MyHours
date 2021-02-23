import 'package:flutter/material.dart';
import 'package:myhours_logapp/components/custom_nav_bar.dart';
import 'package:myhours_logapp/components/table_calendar.dart';
import 'package:myhours_logapp/constraints.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DateTime _currentTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    DateTime _firstDay = DateTime(_currentTime.year, _currentTime.month, (_currentTime.day - _currentTime.weekday)+1);
    DateTime _lastDay = DateTime(_currentTime.year, _currentTime.month, _currentTime.day + 5);
    return Scaffold(
      appBar: AppBar(
        title: Text(appName),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              WeeklyCalendarTable(firstDay: _firstDay, lastDay: _lastDay,)
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(),
    );
  }
}