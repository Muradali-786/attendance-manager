import 'package:attendance_manager/model/attendance_model.dart';
import 'package:attendance_manager/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constant/app_style/app_colors.dart';

class StdAttendanceController {
  Future<void> recordAttendance(
      String classId,
      String subject,
      String date,
      String time,
      List<String> studentIds,
      List<dynamic> studentNames,
      List<String> rollNumbers,
      List<String> statuses) async {
    try {
      final classReference =
          FirebaseFirestore.instance.collection('Class').doc(classId);

      // Create a FireStore reference for the specific class's attendance records
      final attendanceRecordsRef =
          classReference.collection('AttendanceRecords');

      // Create a new attendance record for the specified date and subject
      final attendanceRecordDoc =
          attendanceRecordsRef.doc(); // Creates a unique document ID

      // Set the attendance record data
      await attendanceRecordDoc.set({
        'ClassID': classReference, // Reference to the class document
        'Date': date,
        'Time': time,
        'Subject': subject,
      });

      // Add attendance data for each student to the attendance record
      for (int i = 0; i < studentIds.length; i++) {
        attendanceRecordDoc.collection('Attendance').doc(studentIds[i]).set({
          'studentName': studentNames[i],
          'rollNumber': rollNumbers[i],
          'Status': statuses[i],
        });
      }
    } catch (e) {
      Utils.toastMessage('Error recording attendance: ${e.toString()}');
    }
  }

  Future<void> updateAttendanceRecord(
    String classId,
    String recordId,
    String newTime,
    List<String> studentIds,
    List<String> newStatuses,
  ) async {
    try {
      final classReference =
          FirebaseFirestore.instance.collection('Class').doc(classId);

      // Reference to the specific attendance record
      final attendanceRecordRef =
          classReference.collection('AttendanceRecords').doc(recordId);

      final attendanceSnapshot = await attendanceRecordRef.get();

      if (attendanceSnapshot.exists) {
        // Update the time in the attendance record
        await attendanceRecordRef.update({'Time': newTime});

        // Update attendance data for each student in the subcollection
        for (int i = 0; i < studentIds.length; i++) {
          final studentAttendanceRef =
              attendanceRecordRef.collection('Attendance').doc(studentIds[i]);

          // Check if the student's attendance document exists
          final studentAttendanceSnapshot = await studentAttendanceRef.get();

          if (studentAttendanceSnapshot.exists) {
            // Update the student's status
            await studentAttendanceRef.update({'Status': newStatuses[i]});
          }
        }

        Utils.toastMessage('Attendance record updated successfully.');
      } else {
        Utils.toastMessage('Attendance record not found.');
      }
    } catch (e) {
      Utils.toastMessage('Error updating attendance record: ${e.toString()}');
    }
  }

  Future<void> deleteAttendanceRecordById(
    String classId,
    String recordId,
  ) async {
    try {
      final classReference =
          FirebaseFirestore.instance.collection('Class').doc(classId);

      // Reference to the specific attendance record
      final attendanceRecordRef =
          classReference.collection('AttendanceRecords').doc(recordId);

      final attendanceSnapshot = await attendanceRecordRef.get();

      if (attendanceSnapshot.exists) {
        // Delete the main attendance record document
        await attendanceRecordRef.delete();

        // Delete all documents in the 'Attendance' subCollection
        final subCollectionRef = attendanceRecordRef.collection('Attendance');
        final subCollectionSnapshot = await subCollectionRef.get();

        for (final subDoc in subCollectionSnapshot.docs) {
          await subDoc.reference.delete();
        }

        Utils.toastMessage('Attendance record  deleted successfully.');
      } else {
        Utils.toastMessage('Attendance record not found.');
      }
    } catch (e) {
      Utils.toastMessage('Error deleting attendance record: ${e.toString()}');
    }
  }
}

const String ATTENDANCE = 'Attendance';
const String CLASS = 'Classes';

class AttendanceController extends ChangeNotifier {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  bool _loading = false;
  bool get loading => _loading;

  List<String> _attendanceStatus = [];

  attendanceStatusProvider(int length) {
    _attendanceStatus = List.generate(length, (index) => "P");
  }

  List<String> get attendanceStatus => _attendanceStatus;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> saveAllStudentAttendance(AttendanceModel model) async {
    setLoading(true);
    try {
      await _fireStore
          .collection(CLASS)
          .doc(model.classId)
          .collection(ATTENDANCE)
          .doc()
          .set(model.toMap())
          .then((value) {
        setLoading(false);
        Utils.toastMessage('Attendance Taken');
      });
      setLoading(false);
    } catch (e) {
      setLoading(false);
      Utils.toastMessage('Error recording attendance: ${e.toString()}');
    }
  }

  Future<int> getAttendanceLength(String classId) async {
    final querySnapshot = await _fireStore
        .collection(CLASS)
        .doc(classId)
        .collection(ATTENDANCE)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      int length = querySnapshot.docs.length;
      return length;
    } else {
      return 0;
    }
  }

  Stream<QuerySnapshot> getAllStudentAttendance(String subjectId) {
    return _fireStore
        .collection(CLASS)
        .doc(subjectId)
        .collection(ATTENDANCE)
        .orderBy('currentTime', descending: true)
        .snapshots();
  }

  void updateStatus(int index) {
    if (_attendanceStatus[index] == 'P') {
      _attendanceStatus[index] = 'A';
    } else if (_attendanceStatus[index] == 'A') {
      _attendanceStatus[index] = 'L';
    } else {
      _attendanceStatus[index] = 'P';
    }
    notifyListeners();
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'A':
        return AppColor.kSecondaryColor;
      case 'L':
        return AppColor.kSecondary54Color;
      default:
        return AppColor.kPrimaryTextColor;
    }
  }
}
