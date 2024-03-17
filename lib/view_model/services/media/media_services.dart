import 'dart:io';
import 'dart:typed_data';

import 'package:attendance_manager/model/attendance_model.dart';
import 'package:attendance_manager/model/student_model.dart';
import 'package:attendance_manager/view_model/add_students/students_controller.dart';
import 'package:attendance_manager/view_model/attendance/attendance_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class MediaServices {
  final StudentController _studentController = StudentController();
  final AttendanceController _attendanceController = AttendanceController();

  Future<PlatformFile?> pickExcelSheetFromLibrary() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['xls', 'xlsx']);

    if (pickedFile != null) {
      return pickedFile.files[0];
    }
    return null;
  }

  Future<List<List<dynamic>>> getStudentDataFromExcel() async {
    List<dynamic> stdNameList = [];
    List<dynamic> stdRollNoList = [];

    var path = await pickExcelSheetFromLibrary();
    if (path != null) {
      Uint8List bytes = File(path.path.toString()).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      for (var table in excel.tables.keys) {
        for (var row in excel[table].rows.skip(1)) {
          if (row.isEmpty || row.first == null || row[1] == null) {
            // this condition is to check wether a row is not null or one of value in row is not missing
            continue;
          }

          stdRollNoList.add(row.first!.value.toString());
          stdNameList.add(row[1]!.value.toString());
        }
      }
    }
    return [stdNameList, stdRollNoList];
  }

  Future<void> createAndShareExcelFile() async {
    var excel = Excel.createExcel();

    String name = 'student-attendance';
    final fileName = '${DateTime.now().millisecondsSinceEpoch}$name.xlsx';

    final fileBytes = excel.save();
    var directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');

    file
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);

    await Share.shareXFiles([XFile(file.path)], text: 'Student-attendance');
  }

  String classId = 'X96F0ycFpqaeMFNAq71Y';
  Future<void> createAndShareExcelFile2() async {
    dynamic studentSnapshot =
        await _studentController.getStudentDataToExport(classId);
    dynamic attendanceSnapshot =
        await _attendanceController.getAllStudentAttendanceToExport(classId);

    final studentList = studentSnapshot.docs
        .map((doc) => StudentModel.fromMap(doc.data()))
        .toList();
    final attendanceList = attendanceSnapshot.docs
        .map((doc) => AttendanceModel.fromMap(doc.data()))
        .toList();

    var excel = Excel.createExcel();

    Sheet sheet = excel['Sheet1'];

    for (int i = 0; i < studentList.length; i++) {
      StudentModel std = studentList[i];
      print('in first loop ');
      print(std.studentName);

      for (int i = 0; i < attendanceList.length; i++) {
        AttendanceModel model = attendanceList[i];
        print('in second loop ');
        print(model.currentTime);

      }
    }

    // sheet.appendRow(
    //     [TextCellValue('Student Rolls'), TextCellValue('Student Name')]);
    // for (int i = 0; i < studentList.length; i++) {
    //   print(studentList[i].studentName);
    //
    //   var cell1 = sheet
    //       .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i + 1));
    //   var cell2 = sheet
    //       .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i + 1));
    //
    //   cell1.value = TextCellValue(studentList[i].studentRollNo);
    //   cell2.value = TextCellValue(studentList[i].studentName);
    // }

    // sheet.appendRow(data1);
    //   sheet.appendRow(data1);
    //   sheet.appendRow(data1);
    //   sheet.appendRow(data1);

    // print(snapshot.docs.data);

    // sheet.appendRow(snap);
    // for (var student in snap) {
    //   sheet.appendRow(snap);
    // }

    // List<CellValue> dataList = [TextCellValue('Roll Number'), TextCellValue('Names'), TextCellValue('Flutter'), TextCellValue('and'), TextCellValue('Flutter'), TextCellValue('loves'), TextCellValue('Excel')];
    // sheet.insertRowIterables(dataList,0);

    // String name = 'student-attendance';
    // final fileName = '${DateTime.now().millisecondsSinceEpoch}$name.xlsx';
    //
    // final fileBytes = excel.save();
    // var directory = await getApplicationDocumentsDirectory();
    // final file = File('${directory.path}/$fileName');
    //
    // file
    //   ..createSync(recursive: true)
    //   ..writeAsBytesSync(fileBytes!);
    //
    // await Share.shareXFiles([XFile(file.path)], text: 'Student-attendance');
  }
}
