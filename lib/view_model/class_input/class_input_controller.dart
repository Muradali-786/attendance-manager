import 'package:attendance_manager/model/class_model.dart';
import 'package:attendance_manager/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../utils/routes/route_name.dart';
import '../services/navigation_services.dart';

const String CLASS = 'Classes';

class ClassController with ChangeNotifier {
  final fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final NavigationService _navigationService = NavigationService();

  bool _loading = false;
  get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> createNewClass(ClassInputModel classInputModel) async {
    setLoading(true);
    try {
      await fireStore
          .collection(CLASS)
          .add(classInputModel.toMap())
          .then((doc) {
        _navigationService.removeAndNavigateToRoute(RouteName.addStudentPage,
            id: doc.id);

        updateClassId(doc.id);
        setLoading(false);

        Utils.toastMessage('Class created successfully');
      });
    } catch (e) {
      setLoading(false);
      Utils.toastMessage('Error creating class');
    }
  }

  Future<void> updateClassId(String subjectId) async {
    setLoading(true);
    try {
      await fireStore
          .collection(CLASS)
          .doc(subjectId)
          .update({'subjectId': subjectId});

      Utils.toastMessage('Id Updated');
    } catch (e) {
      Utils.toastMessage('Error While Updating  Id');
    }
  }

  Future<void> updateClassData(ClassInputModel classInputModel) async {
    setLoading(true);
    try {
      await fireStore
          .collection(CLASS)
          .doc(classInputModel.subjectId)
          .update(classInputModel.toMap());

      Utils.toastMessage('Class Updated');
    } catch (e) {
      Utils.toastMessage('Error While Updating updating class data');
    }
  }

  Stream<QuerySnapshot> getClassData() {
    String teacherId = _auth.currentUser!.uid;
    return fireStore
        .collection(CLASS)
        .where('teacherId', isEqualTo: teacherId)
        .snapshots();
  }

  Future<void> deleteClass(String classId) async {
    try {
      await fireStore.collection(CLASS).doc(classId).delete();

      Utils.toastMessage('Class deleted successfully');
    } catch (e) {
      Utils.toastMessage('Error deleting class: ${e.toString()}');
      print(e.toString());
    }
  }
}
