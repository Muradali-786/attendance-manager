import 'package:attendance_manager/utils/utils.dart';
import 'package:attendance_manager/view_model/services/navigation_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/routes/route_name.dart';

class LoginController with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final NavigationService _navigationService = NavigationService();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> loginAsTeacher(String email, String password) async {
    setLoading(true);
    try {
      await _auth
          .signInWithEmailAndPassword(
        email: email.toString(),
        password: password.toString(),
      )
          .then((value) {
        _navigationService.removeAndNavigateToRoute(RouteName.homePage);
        setLoading(false);
      });

      Utils.toastMessage('Login Successful');
    } catch (e) {
      setLoading(false);
      Utils.toastMessage('Login failed. Please try again');
    }finally{
      setLoading(false);
    }
  }

  Future<void> logOutAsTeacher() async {
    try {
      await _auth.signOut().then((value) {
        _navigationService.removeAndNavigateToRoute(RouteName.login);
      });

      Utils.toastMessage('Log out Successful');
    } catch (e) {
      setLoading(false);
      Utils.toastMessage('Error While Using Log out');
    }
  }
}
