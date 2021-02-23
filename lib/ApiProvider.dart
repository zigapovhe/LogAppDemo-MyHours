import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'Models/Log.dart';

class ApiProvider{
  static Future<List<Log>> fetchLogs(String authToken, DateTime selectedDay) async {
    var nextDay = DateTime(selectedDay.year, selectedDay.month, selectedDay.day + 1);
    print(selectedDay);
    print(nextDay);
    var logRequestURL = "https://mhapitesting2.azurewebsites.net/api/Logs?startIndex=0&step=1&maxDate=$nextDay&date=$selectedDay";
    final res = await http.get(
        logRequestURL,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $authToken'
        }
    );
    if (res.body.isNotEmpty) {
      List<Log> logs = logsFromJson(res.body);
      return logs;
    } else {
      return <Log>[];
    }
  }

  static Future loginRequest() async {
    var url = "https://mhapitesting2.azurewebsites.net/api/Tokens/login";

    final data = json.encode({
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
}
