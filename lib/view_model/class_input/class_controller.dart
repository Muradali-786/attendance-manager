import 'package:attendance_manager/model/class_model.dart';
import 'package:attendance_manager/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../constant/app_style/app_styles.dart';
import '../../utils/routes/route_name.dart';
import '../services/navigation/navigation_services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
      String docId = fireStore.collection(CLASS).doc().id;
      classInputModel.subjectId = docId;

      await fireStore
          .collection(CLASS)
          .doc(docId)
          .set(classInputModel.toMap())
          .then(
        (value) {
          setLoading(false);
          updateCreditAndSubjectCount();
          _navigationService.removeAndNavigateToRoute(RouteName.addStudentPage,
              id: docId);
        },
      );

      setLoading(false);

      Utils.toastMessage('Class created successfully');
    } catch (e) {
      setLoading(false);
      Utils.toastMessage('Error creating class');
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateClassData(ClassInputModel classInputModel) async {
    setLoading(true);
    try {
      await fireStore
          .collection(CLASS)
          .doc(classInputModel.subjectId)
          .update(classInputModel.toMap());
      setLoading(false);

      Utils.toastMessage('Class Updated');
    } catch (e) {
      setLoading(false);
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

  Future<List<int>> getCreditAndSubjectCount(String teacherId) async {
    int creditHour = 0;
    int courseLoad = 0;
    final subjectsCollection = fireStore.collection(CLASS);

    final querySnapshot =
        await subjectsCollection.where("teacherId", isEqualTo: teacherId).get();

    if (querySnapshot.docs.isNotEmpty) {
      final subjectList = querySnapshot.docs
          .map((doc) => ClassInputModel.fromMap(doc.data()))
          .toList();

      courseLoad = subjectList.length;

      subjectList.forEach((doc) {
        int c = int.parse(doc.creditHour);
        creditHour += c;
      });
    }

    return [creditHour, courseLoad];
  }

  Future<void> updateCreditAndSubjectCount() async {
    String teacherId = _auth.currentUser!.uid;

    try {
      final List<int> counts = await getCreditAndSubjectCount(teacherId);
      final int creditCount = counts[0];
      final int courseLoad = counts[1];

      await fireStore.collection(TEACHER).doc(teacherId).update({
        'totalCreditHour': creditCount.toString(),
        'courseLoad': courseLoad.toString()
      });
      print('success');
    } catch (e) {
      print('Error while updating credit hour Count');
    }
  }

  // Future<void> deleteClass(String classId) async {
  //   try {
  //     await fireStore.collection(CLASS).doc(classId).ccollection(Student).get();
  //     await fireStore
  //         .collection(CLASS)
  //         .doc(classId)
  //         .ccollection(Attendance)
  //         .get();
  //
  //     await fireStore.collection(CLASS).doc(classId).delete().then((value) {
  //       updateCreditAndSubjectCount();
  //     });
  //
  //     Utils.toastMessage('Class deleted successfully');
  //   } catch (e) {
  //     Utils.toastMessage('Error deleting class: ${e.toString()}');
  //   }
  // }

  Future<void> deleteClass(String classId) async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    WriteBatch batch = fireStore.batch();
    EasyLoading.show(status: 'Deleting...');

    try {
      DocumentReference classDocRef = fireStore.collection(CLASS).doc(classId);

      // Fetch and delete documents from the 'Student' sub-collection
      QuerySnapshot studentSnapshot =
          await classDocRef.collection(STUDENT).get();
      if (studentSnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot doc in studentSnapshot.docs) {
          batch.delete(doc.reference);
        }
      }
      // Fetch and delete documents from the 'Attendance' sub-collection
      QuerySnapshot attendanceSnapshot =
          await classDocRef.collection(ATTENDANCE).get();
      if (attendanceSnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot doc in attendanceSnapshot.docs) {
          batch.delete(doc.reference);
        }
      }
      // Add the main document deletion to the batch
      batch.delete(classDocRef);

      // Commit the batch
      await batch.commit();

      await updateCreditAndSubjectCount();

      Utils.toastMessage('Class deleted successfully');
      EasyLoading.dismiss();
    } catch (e) {
      // Show error message
      EasyLoading.dismiss();
      EasyLoading.showError('Error deleting class',
          duration: const Duration(seconds: 2));
      Utils.toastMessage('Error deleting class: ${e.toString()}');
    }
  }
}
