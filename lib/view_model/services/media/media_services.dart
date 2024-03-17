import 'dart:io';
import 'dart:typed_data';
import 'package:attendance_manager/model/attendance_model.dart';
import 'package:attendance_manager/model/student_model.dart';
import 'package:attendance_manager/utils/utils.dart';
import 'package:attendance_manager/view_model/add_students/students_controller.dart';
import 'package:attendance_manager/view_model/attendance/attendance_controller.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class MediaServices with ChangeNotifier{
  final StudentController _studentController = StudentController();
  final AttendanceController _attendanceController = AttendanceController();

  bool _loading = false;
  bool get loading => _loading;
  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

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

  Future<List<dynamic>> getStudentDetails(String classId) async {
    dynamic studentSnapshot =
        await _studentController.getStudentDataToExport(classId);
    final studentList = studentSnapshot.docs
        .map((doc) => StudentModel.fromMap(doc.data()))
        .toList();
    return studentList;
  }

  Future<List<dynamic>> getAttendanceDetails(String classId) async {
    dynamic attendanceSnapshot =
        await _attendanceController.getAllStudentAttendanceToExport(classId);

    final attendanceList = attendanceSnapshot.docs
        .map((doc) => AttendanceModel.fromMap(doc.data()))
        .toList();
    return attendanceList;
  }

  void addHeaderOfSheet(Sheet sheet, attendanceList) {
    List<CellValue> headerList = [
      const TextCellValue('Registration No'),
      const TextCellValue('Student Name'),
    ];

    for (var date in attendanceList) {
      AttendanceModel model = date;
      headerList.add(TextCellValue(model.selectedDate));
    }
    sheet.appendRow(headerList);
  }

  void addDetailsToExcel(Sheet sheet, studentList, attendanceList) {
    for (int i = 0; i < studentList.length; i++) {
      StudentModel std = studentList[i];
      // Set student roll number and name
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i + 1))
          .value = TextCellValue(std.studentRollNo);
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i + 1))
          .value = TextCellValue(std.studentName);

      // Set attendance status for each student
      for (int j = 0; j < attendanceList.length; j++) {
        AttendanceModel model = attendanceList[j];
        if (model.attendanceList.containsKey(std.studentId)) {
          sheet
              .cell(CellIndex.indexByColumnRow(
                  columnIndex: j + 2, rowIndex: i + 1))
              .value = TextCellValue(model.attendanceList[std.studentId]);
        } else {
          sheet
              .cell(CellIndex.indexByColumnRow(
                  columnIndex: j + 2, rowIndex: i + 1))
              .value = const TextCellValue('--');
        }
      }
    }
  }

  Future<void> createAndShareExcelSheet(String classId) async {
    setLoading(true);
    try {
      var excel = Excel.createExcel();
      Sheet sheet = excel['Sheet1'];

      final studentList = await getStudentDetails(classId);
      final attendanceList = await getAttendanceDetails(classId);

      addHeaderOfSheet(sheet, attendanceList);
      addDetailsToExcel(sheet, studentList, attendanceList);

      String name = 'student-attendance';
      final fileName = '${DateTime.now().millisecondsSinceEpoch}$name.xlsx';

      final fileBytes = excel.save();
      var directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');

      file
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes!);

      await Share.shareXFiles([XFile(file.path)], text: 'Student-attendance');
      setLoading(false);
    } catch (e) {
      Utils.toastMessage('Some thing went wrong while Exporting Sheet');
      setLoading(false);
    }finally{
      setLoading(false);
    }
  }
}
