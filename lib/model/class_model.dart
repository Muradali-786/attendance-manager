class ClassInputModel {
  String? subjectId;
  final String? subjectName;
  final String? departmentName;
  final String? batchName;
  final int? percentage;

  ClassInputModel({
    this.subjectId,
    required this.subjectName,
    required this.departmentName,
    required this.batchName,
    required this.percentage,
  });
  ClassInputModel.fromMap(Map<dynamic, dynamic> res)
      : subjectId = res['subjectId'],
        subjectName = res['subjectName'],
        departmentName = res['departmentName'],
        batchName = res['batchName'],
        percentage = res['percentage'];

  Map<String, Object?> toMap() {
    return {
      'subjectId': subjectId,
      'subjectName': subjectName,
      'departmentName': departmentName,
      'batchName': batchName,
      'percentage': percentage,
    };
  }
}
