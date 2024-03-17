import 'package:attendance_manager/model/student_model.dart';
import 'package:attendance_manager/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../../constant/app_style/app_styles.dart';

class StudentController with ChangeNotifier {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  bool _loading = false;
  get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> migrateStudentsToClass(
      String referenceClassId, String currentClassId) async {
    setLoading(true);
    try {
      // Retrieve student data from the original class
      List<StudentModel> currentClassStudents =
          await getAllStudentsFromClass(referenceClassId);

      // Create a batch to efficiently add multiple students
      if (currentClassStudents.isNotEmpty) {
        final batch = _fireStore.batch();

        // Add each student to the new class collection
        for (final student in currentClassStudents) {
          //before adding data to firebase need to set some parameters to zero that's why
          student.attendancePercentage = student.totalLeaves =
              student.totalAbsent = student.totalPresent = 0;
          batch.set(
            _fireStore
                .collection(CLASS)
                .doc(currentClassId)
                .collection(STUDENT)
                .doc(student.studentId),
            student.toMap(),
          );
        }

        // Commit the batch operation in a single write
        await batch.commit();
        setLoading(false);
        Utils.toastMessage('Students Added To Class Successfully!');
      } else {
        setLoading(false);
        Utils.toastMessage(
            'The class you are referencing has no enrolled students.');
      }
    } catch (error) {
      setLoading(false);
      Utils.toastMessage('Error Adding Students: ${error.toString()}');
    } finally {
      setLoading(false);
    }
  }

  Future<List<StudentModel>> getAllStudentsFromClass(String classId) async {
    try {
      QuerySnapshot querySnapshot = await _fireStore
          .collection(CLASS)
          .doc(classId)
          .collection(STUDENT)
          .get();

      List<StudentModel> students = [];
      for (var doc in querySnapshot.docs) {
        students.add(StudentModel.fromMap(doc.data() as Map));
      }

      return students;
    } catch (e) {
      Utils.toastMessage('Error getting Student');
      return [];
    }
  }

  Future<void> addListOfStudent(
    String classId,
    List stdRollNoList,
    List stdNamesList,
  ) async {
    setLoading(true);

    try {
      WriteBatch batch = _fireStore.batch();

      for (int i = 0; i < stdRollNoList.length; i++) {
        if (stdNamesList[i].toString().length < 3 ||
            stdRollNoList[i].toString().length < 2) {
          Utils.toastMessage(
              'Attention: Student ${stdNamesList[i]} (${stdRollNoList[i]}) is not added due to short details');

          continue;
        }
        String docId = _fireStore
            .collection(CLASS)
            .doc(classId)
            .collection(STUDENT)
            .doc()
            .id;

        batch.set(
          _fireStore
              .collection(CLASS)
              .doc(classId)
              .collection(STUDENT)
              .doc(docId),
          {
            'studentName': stdNamesList[i].toString(),
            'studentId': docId.toString(),
            'attendancePercentage': 0,
            'totalAbsent': 0,
            'totalLeaves': 0,
            'totalPresent': 0,
            'studentRollNo': stdRollNoList[i].toString()
          },
        );
      }

      await batch.commit().then((_) {
        setLoading(false);
        Utils.toastMessage('Students Added successfully');
      });
      setLoading(false);
    } catch (e) {
      setLoading(false);
      Utils.toastMessage('Error during Students Added');
    } finally {
      setLoading(false);
    }
  }

  Future<void> addNewStudent(StudentModel studentModel, String classId) async {
    setLoading(true);

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
      setLoading(false);
    } catch (e) {
      Utils.toastMessage('Error during Student Added');
      setLoading(false);
    } finally {
      setLoading(false);
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

  Future<dynamic> getStudentDataToExport(String classId) {
    return _fireStore
        .collection(CLASS)
        .doc(classId)
        .collection(STUDENT)
        .get();
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
