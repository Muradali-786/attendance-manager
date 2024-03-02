import 'package:attendance_manager/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginController {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> loginAsTeacher(String email, String password) async {
    try {
      await auth
          .signInWithEmailAndPassword(
            email: email.toString(),
            password: password.toString(),
          )
          .then((e) {

            Utils.toastMessage('Login Successful');
      });
    } catch (e) {
      Utils.toastMessage('Error While Using Login');
    }
  }
}
