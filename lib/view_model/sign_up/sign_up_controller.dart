import 'package:attendance_manager/model/sign_up_model.dart';
import 'package:attendance_manager/view_model/class_input/class_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../constant/app_style/app_styles.dart';
import '../../utils/utils.dart';

class SignUpController with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  bool _loading = false;
  get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> registerTeacher(SignUpModel signUpModel) async {
    setLoading(true);
    try {
      await auth
          .createUserWithEmailAndPassword(
        email: signUpModel.email,
        password: signUpModel.password.toString(),
      )
          .then((e) {
        signUpModel.teacherId = e.user!.uid;
        saveTeacherData(signUpModel).then((value) {
          setLoading(false);
        });
        setLoading(false);
        Utils.toastMessage('register Successful');
        EasyLoading.showInfo(
          'Account creation successful! Please wait for admin approval to log in.',
          duration: const Duration(
            seconds: 3,
          ),
        );
      });
    } catch (e) {
      setLoading(false);
      Utils.toastMessage('error during signup');
    }
  }

  Future<QuerySnapshot> getTeacherData(String teacherId) {
    return fireStore
        .collection(TEACHER)
        .where('teacherId', isEqualTo: teacherId)
        .get();
  }

  Future<void> updateTeacherProfile(String teacherId, String name) {
    return fireStore.collection(TEACHER).doc(teacherId).update({
      'name': name,
    }).then((value) {
      Utils.toastMessage('Profile Updated');
    }).onError((error, stackTrace) {
      Utils.toastMessage('Error While updating Profile');
    });
  }

  Future<void> saveTeacherData(SignUpModel signUpModel) async {
    try {
      await fireStore
          .collection(TEACHER)
          .doc(signUpModel.teacherId)
          .set(signUpModel.toMap())
          .then((value) {
        print('successfully save data of teacher');
      });
    } catch (e) {
      print('error while storing  teacher data ');
    }
  }

  Future<bool> checkForAccessPermission(String teacherId) async {
    EasyLoading.show(status: 'Checking access rights');
    try {
      QuerySnapshot snapshot = await getTeacherData(teacherId);

      if (snapshot.docs.isEmpty) {
        Utils.toastMessage('Teacher not found');
        return false;
      }

      var teacherData = snapshot.docs.first.data() as Map<String, dynamic>;

      bool control = teacherData['control'] ?? false;
      EasyLoading.dismiss();
      return control;
    } catch (e) {
      Utils.toastMessage('Something went wrong');
      EasyLoading.dismiss();
      return false;
    }
  }
}
