import 'package:attendance_manager/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class LoginController with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;

  bool _loading = false;
  get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> loginAsTeacher(String email, String password) async {
    setLoading(true);
    try {
      await auth
          .signInWithEmailAndPassword(
        email: email.toString(),
        password: password.toString(),
      ).then((e) {
        setLoading(false);
        Utils.toastMessage('Login Successful');
      }).onError((error, stackTrace) {
        setLoading(false);
      });
    } catch (e) {
      setLoading(false);
      Utils.toastMessage('Error While Using Login');
    }
  }
}
