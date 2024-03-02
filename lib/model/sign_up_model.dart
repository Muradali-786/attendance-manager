class SignUpModel {
  String? teacherId;
  final String name;
  final String email;
  List<String>? subjectIds;

  SignUpModel({
    this.teacherId,
    required this.name,
    required this.email,

    this.subjectIds,
  });

  SignUpModel.fromMap(Map<dynamic, dynamic> res)
      : teacherId = res['teacherId'],
        name = res['name'],
        email = res['email'],
        subjectIds = res['subjectIds']?.cast<String>().toList();

  Map<String, Object?> toMap() {
    return {
      'teacherId': teacherId,
      'name': name,
      'email': email,
      'subjectIds': subjectIds,
    };
  }
}
