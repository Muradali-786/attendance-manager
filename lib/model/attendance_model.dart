class AttendanceModel {
  final String classId;
  String? attendanceId;
  final int sortOrder;
  final String selectedDate;
  final String currentTime;
  final Map<dynamic, dynamic> attendanceList;

  AttendanceModel({
    required this.classId,
    this.attendanceId,
    this.sortOrder = 0,
    required this.selectedDate,
    required this.currentTime,
    required this.attendanceList,
  });

  AttendanceModel.fromMap(Map<String, dynamic> res)
      : classId = res['classId'],
        attendanceId = res['attendanceId'],
        sortOrder = res['sortOder'],
        selectedDate = res['selectedDate'],
        currentTime = res['currentTime'],
        attendanceList = Map<String, String>.from(res['attendanceList']);

  Map<String, dynamic> toMap() {
    return {
      'classId': classId,
      'attendanceId': attendanceId,
      'sortOder': sortOrder,
      'selectedDate': selectedDate,
      'currentTime': currentTime,
      'attendanceList': attendanceList,
    };
  }
}
