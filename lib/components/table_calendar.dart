import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class WeeklyCalendarTable extends StatefulWidget {
  WeeklyCalendarTable({Key key, this.firstDay, this.lastDay}) : super(key: key);


  final DateTime firstDay;
  final DateTime lastDay;
  
  
  @override
  _WeeklyCalendarTableState createState() => _WeeklyCalendarTableState();
}

class _WeeklyCalendarTableState extends State<WeeklyCalendarTable> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _currentTime = DateTime.now();
  DateTime _selectedDay;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: widget.firstDay,
      lastDay: widget.lastDay,
      focusedDay: _currentTime,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        // Use `selectedDayPredicate` to determine which day is currently selected.
        // If this returns true, then `day` will be marked as selected.

        // Using `isSameDay` is recommended to disregard
        // the time-part of compared DateTime objects.
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          // Call `setState()` when updating the selected day
          setState(() {
            _selectedDay = selectedDay;
            _currentTime = focusedDay;
          });
        }
      },
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          // Call `setState()` when updating calendar format
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {
        // No need to call `setState()` here
        _currentTime = focusedDay;
      },
    );
  }
}
