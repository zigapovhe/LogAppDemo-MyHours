import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myhours_logapp/components/custom_nav_bar.dart';
import 'package:myhours_logapp/constraints.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:table_calendar/table_calendar.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DateTime _currentTime = DateTime.now();
  var accessToken = "";
  DateTime _selectedDay;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final logData = ['Log1', "Log2", "Log3"];

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
                print(_selectedDay);
              });
            },
          ),
            Expanded(
              child: ListView.builder(
                itemCount: logData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(logData[index]),
                  );
                }
                ),
            ),
            TextButton(
              child: Text("Fetch logs"),
              onPressed: () async {
                print(_currentTime);
                if(accessToken == null || accessToken == ""){
                  loginRequest().then((res) {
                    final jsonData = convert.jsonDecode(res.toString());
                    accessToken = jsonData["accessToken"];
                    print(fetchLogs(accessToken, _selectedDay, _currentTime));
                  }).catchError((e) => print("Got error: $e"));
                } else {
                  print(fetchLogs(accessToken, _selectedDay, _currentTime));
                }
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



Future fetchLogs(String authToken, DateTime firstDay, DateTime lastDay) async {
  var logRequestURL = "https://mhapitesting2.azurewebsites.net/api/Logs?startIndex=0&step=1&maxDate=$lastDay&date=$firstDay";

  print("AuthToken: " + authToken);
  final res = await http.get(
      logRequestURL,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $authToken'
      }
  );
  print(res.statusCode.toString()+ ", "+ res.body);
  return res.body;
}

Future loginRequest() async {
  var url = "https://mhapitesting2.azurewebsites.net/api/Tokens/login";

  final data = convert.jsonEncode({
    "grantType": "password",
    "email": "luke.skywalker@myhours.com",
    "password": "luke123",
    "clientId": "9b3b476a-3c60-486f-8f5c-b1b8cd4248e5"
  });

  final response = await http.post(
      url,
      headers: {HttpHeaders.contentTypeHeader:'application/json'},
      body: data
  );

  return response.body;
}