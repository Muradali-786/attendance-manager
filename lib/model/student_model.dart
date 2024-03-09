class StudentModel {
  String? studentId;
  final String studentName;
  final String studentRollNo;
  int? attendancePercentage;
  int? totalPresent;
  int? totalAbsent;
  int? totalLeaves;

  StudentModel({
    this.studentId,
    required this.studentName,
    required this.studentRollNo,
    this.attendancePercentage,
    this.totalPresent,
    this.totalAbsent,
    this.totalLeaves,
  });

  StudentModel.fromMap(Map<dynamic, dynamic> res)
      : studentId = res['studentId'],
        studentName = res['studentName'],
        studentRollNo = res['studentRollNo'],
        attendancePercentage = res['attendancePercentage'],
        totalPresent = res['totalPresent'],
        totalAbsent = res['totalAbsent'],
        totalLeaves = res['totalLeaves'];

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'studentRollNo': studentRollNo,
      'attendancePercentage': attendancePercentage,
      'totalPresent': totalPresent,
      'totalAbsent': totalAbsent,
      'totalLeaves': totalLeaves,
    };
  }
}
