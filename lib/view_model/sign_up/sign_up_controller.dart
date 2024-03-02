import 'package:attendance_manager/model/sign_up_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/utils.dart';

final String TEACHER = 'Teachers';

class SignUpController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<void> registerTeacher(SignUpModel signUpModel,String password) async {
    try {
      await auth
          .createUserWithEmailAndPassword(
        email: signUpModel.email,
        password: password,
      )
          .then((e) {
        signUpModel.teacherId = e.user!.uid;
        saveTeacherData(signUpModel);

        Utils.toastMessage('register Successful');
      });
    } catch (e) {
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
