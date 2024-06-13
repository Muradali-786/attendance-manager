import 'package:attendance_manager/constant/app_style/app_styles.dart';
import 'package:attendance_manager/utils/utils.dart';
import 'package:attendance_manager/view_model/services/navigation/navigation_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../utils/routes/route_name.dart';

class LoginController with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final NavigationService _navigationService = NavigationService();
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

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
        checkTeacherStatus(value.user!.uid.toString());
        setLoading(false);
      });
    } catch (e) {
      setLoading(false);
      Utils.toastMessage('Login failed. Please try again');
    } finally {
      setLoading(false);
    }
  }

  Future<void> checkTeacherStatus(String teacherId) async {
    EasyLoading.show(status: 'Checking access rights...');
    try {
      final docSnapshot =
          await fireStore.collection(TEACHER).doc(teacherId).get();

      if (docSnapshot.exists) {
        bool checkStatus = docSnapshot.data()!['status'];

        if (checkStatus) {
          Utils.toastMessage('Login Successful');
          EasyLoading.dismiss();
          _navigationService.removeAndNavigateToRoute(RouteName.homePage);
        } else {
          EasyLoading.showInfo(
            'Admin approval required. Please contact administrator',
            duration: const Duration(
              seconds: 2,
            ),
          );
        }
      } else {
        Utils.toastMessage('User Does not Exist');
      }
    } catch (e) {
      Utils.toastMessage('Login failed. Please try again');
    } finally {}
  }

  Future<void> updateTeacherStatus(String teacherId, bool newStatus) async {
    try {
      await fireStore.collection(TEACHER).doc(teacherId).update({
        'status': newStatus,
      });
      Utils.toastMessage('Status updated successfully');
    } catch (e) {
      Utils.toastMessage('Failed to update status');
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
