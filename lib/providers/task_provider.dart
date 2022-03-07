import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskProvider with ChangeNotifier {
  DateTime _date = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime get date => _date;

  String get dateString => DateFormat('dd/MM/yyyy').format(date);

  set setDate(DateTime? date) {
    if (date != null) {
      _date = date;
      print(_date);
      notifyListeners();
    }
  }
}
