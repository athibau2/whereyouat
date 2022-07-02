import 'package:flutter/material.dart';

Widget formatDateTime(DateTime date) {
    int hour = date.hour;
    dynamic minute = date.minute;
    String timeOfDay = 'AM';
    if (date.hour > 12) {
      hour = date.hour - 12;
      timeOfDay = 'PM';
    }
    if (minute == 0) minute = '00';
    if (minute < 10) minute = '0' + minute.toString();

    String getWeekday(int weekday) {
      switch (weekday) {
        case 1:
          return 'Monday';
        case 2:
          return 'Tuesday';
        case 3:
          return 'Wednesday';
        case 4:
          return 'Thursday';
        case 5:
          return 'Friday';
        case 6:
          return 'Saturday';
        case 7:
          return 'Sunday';
        default:
          return '';
      }
    }

    return Text(getWeekday(date.weekday) +
        ', ' +
        date.month.toString() +
        '/' +
        date.day.toString() +
        '/' +
        date.year.toString() +
        ', ' +
        hour.toString() +
        ':' +
        minute.toString() +
        ' $timeOfDay');
  }