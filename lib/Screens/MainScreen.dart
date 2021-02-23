import 'package:flutter/material.dart';
import 'package:myhours_logapp/ApiProvider.dart';
import 'package:myhours_logapp/Models/Log.dart';
import 'package:myhours_logapp/components/custom_nav_bar.dart';
import 'package:myhours_logapp/constraints.dart';
import 'dart:convert' as convert;
import 'package:table_calendar/table_calendar.dart';

class MainScreen extends StatefulWidget{
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {

  DateTime _currentTime = DateTime.now();
  var accessToken = "";
  DateTime _selectedDay;
  CalendarController _calendarController;
  List<Log>logData;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();

    if (accessToken == null || accessToken == "") {
      ApiProvider.loginRequest().then((res) {
        final jsonData = convert.jsonDecode(res.toString());
        accessToken = jsonData["accessToken"];
        ApiProvider.fetchLogs(accessToken, _currentTime).then((logs) {
          logData = logs;
        });
      }).catchError((e) => print("Got error: $e"));
    } else {
      ApiProvider.fetchLogs(accessToken, _currentTime).then((logs) {
        logData = logs;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(appName),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
          TableCalendar(
            calendarController: _calendarController,
            startingDayOfWeek: StartingDayOfWeek.monday,
            initialCalendarFormat: CalendarFormat.week,
            onDaySelected: (date, events,holidays) {
              setState(() {
                _selectedDay = date;
                ApiProvider.fetchLogs(accessToken, _selectedDay).then((logs) {
                  logData = logs;
                });
              });
            },
          ),
          GestureDetector(
            child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: logData==null ? 0 : logData.length,
                      itemBuilder: (context, index) {
                        Log log = logData[index];
                        return ListTile(
                          title: Text(log.userId.toString()),
                        );
                      }
                  ),
            onHorizontalDragEnd: (DragEndDetails details){
              if(details.primaryVelocity > 0){
                setState(() {
                  _calendarController.previousPage();
                });
              } else {
                setState(() {
                  _calendarController.nextPage();
                });
              }
            },
          ),
            TextButton(
              child: Text("Fetch logs"),
              onPressed: () async {
                print(_currentTime);
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(),
    );
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }
}

