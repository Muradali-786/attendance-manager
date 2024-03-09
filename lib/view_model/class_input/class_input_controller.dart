import 'package:attendance_manager/model/class_model.dart';
import 'package:attendance_manager/utils/utils.dart';
import 'package:attendance_manager/view_model/sign_up/sign_up_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/routes/route_name.dart';
import '../services/navigation_services.dart';

class ClassInputController with ChangeNotifier {
  final fireStore = FirebaseFirestore.instance.collection('Class');

  Future<void> addClass(String classId, String subject, String department,
      String batch, int percentage) async {
    try {
      await fireStore.doc(classId).set({
        'classId': classId.toString(),
        'subject': subject,
        'department': department,
        'batch': batch,
        'percentage': percentage.toString(),
      }).then((value) {
        Utils.toastMessage('Success');
      }).onError((error, stackTrace) {
        Utils.toastMessage('Error');
      });
    } catch (e) {
      Utils.toastMessage(e.toString());
    }
  }

  Future<void> updateClass(String classId, String subject, String department,
      String batch, int percentage) async {
    try {
      await fireStore.doc(classId).update({
        'subject': subject,
        'department': department,
        'batch': batch,
        'percentage': percentage.toString(),
      }).then((value) {
        Utils.toastMessage('Class updated successfully');
      }).onError((error, stackTrace) {
        Utils.toastMessage('Error updating class');
      });
    } catch (e) {
      Utils.toastMessage('Error updating class: ${e.toString()}');
    }
  }

  Future<void> deleteClass(String classId) async {
    try {
      await fireStore.doc(classId).delete().then((value) {
        Utils.toastMessage('Class deleted successfully');
      }).onError((error, stackTrace) {
        Utils.toastMessage('Error deleting class');
      });
    } catch (e) {
      Utils.toastMessage('Error deleting class: ${e.toString()}');
    }
  }
}

final String CLASS = 'Classes';

class ClassController with ChangeNotifier {
  final fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final NavigationService _navigationService = NavigationService();

  bool _loading = false;
  get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> createNewClass(ClassInputModel classInputModel) async {
    setLoading(true);
    try {
      await fireStore
          .collection(CLASS)
          .add(classInputModel.toMap())
          .then((doc) {
        _navigationService.removeAndNavigateToRoute(RouteName.addStudentPage,
            id: doc.id);

        updateClassId(doc.id);
        setLoading(false);

        Utils.toastMessage('Class created successfully');
      });
    } catch (e) {
      setLoading(false);
      Utils.toastMessage('Error creating class');
    }
  }

  Future<void> updateClassId(String subjectId) async {
    setLoading(true);
    try {
      await fireStore
          .collection(CLASS)
          .doc(subjectId)
          .update({'subjectId': subjectId});

      Utils.toastMessage('Id Updated');
    } catch (e) {
      Utils.toastMessage('Error While Updating  Id');
    }
  }

  Stream<QuerySnapshot> getSubjectData() {
    String teacherId = _auth.currentUser!.uid;
    return fireStore
        .collection(CLASS)
        .where('teacherId', isEqualTo: teacherId)
        .snapshots();
  }

  Future<void> deleteClass(String classId) async {
    setLoading(true);
    try {
      await fireStore.doc(classId).delete();
      setLoading(false);
      Utils.toastMessage('Class deleted successfully');
    } catch (e) {
      setLoading(false);
      Utils.toastMessage('Error deleting class: ${e.toString()}');
    }
  }
}
