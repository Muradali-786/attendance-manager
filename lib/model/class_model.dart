class ClassInputModel {
  late final int? id;
  final String? subjectName;
  final String? departmentName;
  final String? batchName;
  final int? percentage;

  ClassInputModel({
    required this.id,
    required this.subjectName,
    required this.departmentName,
    required this.batchName,
    required this.percentage,
  });
  ClassInputModel.fromMap(Map<dynamic, dynamic> res)
      : id = res['id'],
        subjectName = res['subjectName'],
        departmentName = res['departmentName'],
        batchName = res['batchName'],
        percentage = res['percentage'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'subjectName': subjectName,
      'departmentName': departmentName,
      'batchName': batchName,
      'percentage': percentage,
    };
  }
}
