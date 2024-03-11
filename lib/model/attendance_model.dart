class AttendanceModel {
  final String classId;
  final String selectedDate;
  final String currentTime;
  final Map<String, String> attendanceList;

  AttendanceModel({
    required this.classId,
    required this.selectedDate,
    required this.currentTime,
    required this.attendanceList,
  });

  AttendanceModel.fromMap(Map<String, dynamic> res)
      : classId = res['classId'],
        selectedDate = res['selectedDate'],
        currentTime = res['currentTime'],
        attendanceList = Map<String, String>.from(res['attendanceList']);

  Map<String, dynamic> toMap() {
    return {
      'classId': classId,
      'selectedDate': selectedDate,
      'currentTime': currentTime,
      'attendanceList': attendanceList,
    };
  }
}
