import 'package:attendance_manager/model/sign_up_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';

final String TEACHER = 'Teachers';

class SignUpController with ChangeNotifier{

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;


  bool _loading =false;
  get loading =>_loading;

  setLoading(bool value){

    _loading=value;
    notifyListeners();

  }

  Future<void> registerTeacher(SignUpModel signUpModel,String password) async {
    setLoading(true);
    try {
      await auth
          .createUserWithEmailAndPassword(
        email: signUpModel.email,
        password: password,
      )
          .then((e) {
        setLoading(false);
        signUpModel.teacherId = e.user!.uid;
        saveTeacherData(signUpModel);

        Utils.toastMessage('register Successful');
      });
    } catch (e) {
      setLoading(false);
      Utils.toastMessage('error during signup');
    }
  }

  Future<void> saveTeacherData(SignUpModel signUpModel) async {
    try {

      await fireStore
          .collection(TEACHER)
          .doc()
          .set(signUpModel.toMap())
          .then((value) {
        print('successfully save data of teacher');
      });
    } catch (e) {
      print('error while storing  teacher data ');
    }
  }
}
