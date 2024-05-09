import 'package:attendance_manager/model/sign_up_model.dart';
import 'package:attendance_manager/view_model/class_input/class_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  Future<void> registerTeacher(SignUpModel signUpModel, String password) async {
    setLoading(true);
    try {
      await auth
          .createUserWithEmailAndPassword(
              email: signUpModel.email, password: password)
          .then((e) {
        signUpModel.teacherId = e.user!.uid;
        saveTeacherData(signUpModel).then((value) {
          setLoading(false);
        });
        setLoading(false);
        Utils.toastMessage('register Successful');
      });
    } catch (e) {
      setLoading(false);
      Utils.toastMessage('error during signup');
    }
  }

  Future<QuerySnapshot> getTeacherData() {
    return fireStore.collection(TEACHER).get();
  }
  Future<void> updateTeacherProfile(String teacherId,String name) {
    return fireStore.collection(TEACHER).doc(teacherId).update({
      'name':name,
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


}
