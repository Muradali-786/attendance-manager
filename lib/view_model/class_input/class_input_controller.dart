import 'package:attendance_manager/model/class_model.dart';
import 'package:attendance_manager/utils/utils.dart';
import 'package:attendance_manager/view_model/sign_up/sign_up_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

class ClassController {
  final fireStore = FirebaseFirestore.instance;

  Future<void> createNewClass(ClassInputModel classInputModel) async {
    try {
      await fireStore
          .collection(CLASS)
          .add(classInputModel.toMap())
          .then((doc) {
        Utils.toastMessage('Success');
      });
    } catch (e) {
      print('error during creating class');
    }
  }

  Future<void> updateTeacherSubjectIds(
      String teacherId, String subjectId) async {
    String tid = "VOk6MgJ95BNzk8XcpO7g";
    try {
      await fireStore.collection(TEACHER).doc(tid).update({
        'subjectIds': FieldValue.arrayUnion([subjectId])
      });
      print('subject register to teacher');
    } catch (e) {
      print('error during updating teacher subject IDs: $e');
    }
  }
}
