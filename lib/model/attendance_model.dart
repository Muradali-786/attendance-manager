class AttendanceModel {
  final String classId;
  final DateTime selectedDate;
  final DateTime currentTime;
  final List<String> studentIdList;
  final List<String> statusList;

  AttendanceModel({
    required this.classId,
    required this.selectedDate,
    required this.currentTime,
    required this.studentIdList,

    required this.statusList,
  });

  AttendanceModel.fromMap(Map<String, dynamic> map)
      : classId = map['classId'],
        selectedDate = DateTime.parse(map['selectedDate']),
        currentTime = DateTime.parse(map['currentTime']),
        studentIdList = List<String>.from(map['studentIdList']),
        statusList = List<String>.from(map['statusList']);

  Map<String, dynamic> toMap() {
    return {
      'classId': classId,
      'selectedDate': selectedDate.toIso8601String(),
      'currentTime': currentTime.toIso8601String(),
      'studentIdList': studentIdList,
      'statusList': statusList,
    };
  }
}
