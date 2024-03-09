import 'package:attendance_manager/model/student_model.dart';
import 'package:attendance_manager/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddStudentsController {
  final fireStore = FirebaseFirestore.instance.collection('Class');
  Future<void> addStudentToClass(String classId, String subject,
      String studentName, String rollNumber) async {
    try {
      // Check if the class document exists
      final classDoc = await fireStore.doc(classId).get();
      if (classDoc.exists) {
        final subCollectionRef = classDoc.reference.collection(subject);

        // Add a new document with student data
        await subCollectionRef.add({
          'studentName': studentName.toString(),
          'rollNumber': rollNumber.toString(),
        });

        Utils.toastMessage('Student added ');
      } else {
        Utils.toastMessage('Class does not exist');
      }
    } catch (e) {
      Utils.toastMessage('Error adding student to class: ${e.toString()}');
    }
  }

  Future<void> updateStudentInClass(
    String classId,
    String subject,
    String studentId,
    String updatedStudentName,
    String updatedRollNumber,
  ) async {
    try {
      final classDoc = await fireStore.doc(classId).get();
      if (classDoc.exists) {
        final subCollectionRef = classDoc.reference.collection(subject);
        final studentDocument = subCollectionRef.doc(studentId);
        await studentDocument.update({
          'studentName': updatedStudentName.toString(),
          'rollNumber': updatedRollNumber.toString(),
        });
      } else {
        Utils.toastMessage('Class does not exist');
      }
    } catch (e) {
      Utils.toastMessage('Error updating student in class: ${e.toString()}');
    }
  }

  Future<void> deleteStudentFromClass(
    String classId,
    String subject,
    String studentId,
  ) async {
    try {
      final classDoc = await fireStore.doc(classId).get();
      if (classDoc.exists) {
        final subCollectionRef = classDoc.reference.collection(subject);
        final studentDocument = subCollectionRef.doc(studentId);

        await studentDocument.delete().onError((error, stackTrace) {
          Utils.toastMessage(error.toString());
        });
      } else {
        Utils.toastMessage('Class does not exist');
      }
    } catch (e) {
      Utils.toastMessage('Error deleting student from class: ${e.toString()}');
    }
  }
}

const String STUDENT = 'Students';
const String CLASS = 'Classes';

class StudentController {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<void> addNewStudent(StudentModel studentModel, String classId) async {
    try {
      await _fireStore
          .collection(CLASS)
          .doc(classId)
          .collection(STUDENT)
          .add(studentModel.toMap());
    } catch (e) {
      print('Error adding student: $e');
    }
  }
}
