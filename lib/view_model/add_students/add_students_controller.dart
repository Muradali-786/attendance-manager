import 'package:attendance_manager/model/student_model.dart';
import 'package:attendance_manager/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constant/app_style/app_styles.dart';



class StudentController {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<void> addNewStudent(StudentModel studentModel, String classId) async {
    try {
      String docId = _fireStore
          .collection(CLASS)
          .doc(classId)
          .collection(STUDENT)
          .doc()
          .id;
      studentModel.studentId = docId;

      await _fireStore
          .collection(CLASS)
          .doc(classId)
          .collection(STUDENT)
          .doc(docId)
          .set(studentModel.toMap())
          .then((value) {
        Utils.toastMessage('Student Added');
      });
    } catch (e) {
      Utils.toastMessage('Error during Student Added');
    }
  }

  Future<void> updateStudentData(StudentModel studentModel, classId) async {
    try {
      await _fireStore
          .collection(CLASS)
          .doc(classId)
          .collection(STUDENT)
          .doc(studentModel.studentId)
          .update({
        'studentName': studentModel.studentName,
        'studentRollNo': studentModel.studentRollNo,
      }).then((value) {
        Utils.toastMessage('Student data Updated');
      });
    } catch (e) {
      Utils.toastMessage('Error during Student data updation');
    }
  }

  Stream<QuerySnapshot> getAllStudentData(String classId) {
    return _fireStore
        .collection(CLASS)
        .doc(classId)
        .collection(STUDENT)
        .snapshots();
  }

  Stream<DocumentSnapshot> getSingleStudentData(String classId, String stdId) {
    return _fireStore
        .collection(CLASS)
        .doc(classId)
        .collection(STUDENT)
        .doc(stdId)
        .snapshots();
  }

  Future<void> deleteStudent(String studentId, classId) async {
    try {
      await _fireStore
          .collection(CLASS)
          .doc(classId)
          .collection(STUDENT)
          .doc(studentId)
          .delete()
          .then((value) {
        Utils.toastMessage('Student deleted');
      });
    } catch (e) {
      Utils.toastMessage('Error during Student deletion');
    }
  }
}
