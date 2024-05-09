import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/model/attendance_model.dart';
import 'package:attendance_manager/model/class_model.dart';
import 'package:attendance_manager/model/student_model.dart';
import 'package:attendance_manager/utils/routes/route_name.dart';
import 'package:attendance_manager/view_model/add_students/students_controller.dart';
import 'package:attendance_manager/view_model/attendance/attendance_controller.dart';
import 'package:attendance_manager/view_model/class_input/class_controller.dart';
import 'package:attendance_manager/view_model/login/login_controller.dart';
import 'package:flutter/material.dart';

Future<void> showDeleteClassConfirmationDialog(
    BuildContext context, ClassInputModel model) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Delete"),
        content: Text(
            "Are you sure you want to delete class ${model.subjectName}(${model.departmentName}-${model.batchName}).All the attendance history for this class will be lost"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, RouteName.homePage, (route) => false);
            },
            child: const Text(
              "CANCEL",
              style: TextStyle(color: AppColor.kSecondaryColor),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();

              await ClassController().deleteClass(model.subjectId.toString());
            },
            child: const Text("DELETE",
                style: TextStyle(color: AppColor.kSecondaryColor)),
          ),
        ],
      );
    },
  );
}

Future<void> showDeleteStudentConfirmationDialog(
    BuildContext context, StudentModel model, String classId) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Delete"),
        content: Text(
            "Are you sure you want to delete student ${model.studentName}(${model.studentRollNo}).All the attendance history for this student will be lost"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "CANCEL",
              style: TextStyle(color: AppColor.kSecondaryColor),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();

              await StudentController()
                  .deleteStudent(model.studentId.toString(), classId);
            },
            child: const Text("DELETE",
                style: TextStyle(color: AppColor.kSecondaryColor)),
          ),
        ],
      );
    },
  );
}

Future<void> showDeleteAttendanceConfirmationDialog(
    BuildContext context, AttendanceModel model, String subjectId) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Delete"),
        content: Text(
            "Are you sure you want to delete the selected attendance(${model.currentTime})."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "CANCEL",
              style: TextStyle(color: AppColor.kSecondaryColor),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await AttendanceController().deleteAttendanceRecord(
                subjectId,
                model.attendanceId!,
              );

              await AttendanceController().updateAttendanceCount(subjectId);

              await StudentController().calculateStudentAttendance(
                  subjectId, model.attendanceList.keys.toList());
            },
            child: const Text("DELETE",
                style: TextStyle(color: AppColor.kSecondaryColor)),
          ),
        ],
      );
    },
  );
}

Future<void> showLogOutConfirmationDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Log Out"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "CANCEL",
              style: TextStyle(color: AppColor.kSecondaryColor),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await LoginController().logOutAsTeacher();
            },
            child: const Text("LOG-OUT",
                style: TextStyle(color: AppColor.kSecondaryColor)),
          ),
        ],
      );
    },
  );
}
