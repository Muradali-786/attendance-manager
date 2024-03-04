import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class AppController extends ChangeNotifier {
  String _teacherId = '';
  String get teacherId => _teacherId;

  void setTeacherId(String teacherId) async {
    _teacherId = teacherId;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('teacherId', _teacherId);
    notifyListeners();
  }

  void getTeacherId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _teacherId = prefs.getString('teacherId') ?? '';
    notifyListeners();
  }
}
