import 'package:flutter/material.dart';
import 'package:myhours_logapp/ApiProvider.dart';
import 'package:myhours_logapp/Models/Log.dart';
import 'package:myhours_logapp/components/custom_nav_bar.dart';
import 'package:myhours_logapp/constraints.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
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
  Future<http.Response> logData;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();

    if (accessToken == null || accessToken == "") {
      ApiProvider.loginRequest().then((res) {
        final jsonData = convert.jsonDecode(res.toString());
        accessToken = jsonData["accessToken"];
        logData = ApiProvider.fetchLogs(accessToken, _currentTime);
      }).catchError((e) => print("Got error: $e"));
    } else {
      logData = ApiProvider.fetchLogs(accessToken, _currentTime);
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
                logData = ApiProvider.fetchLogs(accessToken, _selectedDay);
              });
            },
          ),
          Expanded(
            child: GestureDetector(
              child: FutureBuilder(
                  future: logData,
                  builder: (_, snapshot) {
                  if (snapshot.hasData){
                    List<Log> logs = logsFromJson(snapshot.data.body);
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: logs==null ? 0 : logs.length,
                        itemBuilder: (context, index) {
                          Log log = logs[index];
                          return ListTile(
                            title: Text("Log "+(index+1).toString()),
                            trailing: Text(log.id.toString()),
                          );
                        }
                    );
                  }
                  else {
                    return SizedBox.shrink();
                  }
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
          ),
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

