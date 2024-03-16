import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';

class MediaServices {
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
}
