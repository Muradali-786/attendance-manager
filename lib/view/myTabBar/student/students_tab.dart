import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/app_style/app_styles.dart';
import 'package:attendance_manager/constant/constant_size.dart';
import 'package:attendance_manager/size_config.dart';
import 'package:attendance_manager/utils/component/custom_list_tile.dart';
import 'package:attendance_manager/utils/component/custom_round_botton.dart';
import 'package:attendance_manager/utils/component/dialoge_boxes/add_student_dialog.dart';
import 'package:attendance_manager/utils/component/dialoge_boxes/import_dialog_box.dart';
import 'package:attendance_manager/utils/component/dialoge_boxes/update_std_dialog.dart';
import 'package:attendance_manager/utils/routes/route_name.dart';
import 'package:attendance_manager/utils/utils.dart';
import 'package:attendance_manager/view_model/add_students/add_students_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../utils/component/custom_shimmer_effect.dart';
import '../../../utils/component/input_text_filed/custom_input_text_filed.dart';

// class StudentTab extends StatefulWidget {
//   String classId, subject;
//
//   StudentTab({super.key, this.classId = '', this.subject = ''});
//
//   @override
//   State<StudentTab> createState() => _StudentTabState();
// }
//
// class _StudentTabState extends State<StudentTab> {
//   late final Stream<QuerySnapshot> fireStoreSubCollectRef;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     fireStoreSubCollectRef = FirebaseFirestore.instance
//         .collection('Class')
//         .doc(widget.classId)
//         .collection(widget.subject)
//         .snapshots();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       backgroundColor: AppColors.kAppBackgroundColor,
//       resizeToAvoidBottomInset: true,
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           StreamBuilder<QuerySnapshot>(
//               stream: fireStoreSubCollectRef,
//               builder: (BuildContext context,
//                   AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   // Show shimmer loading effect while data is loading
//                   return const Expanded(child: ShimmerLoadingEffect());
//                 }
//                 else if (snapshot.hasError) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         const Icon(
//                           Icons.error_outline,
//                           color: AppColors.kAlertColor,
//                           size: 45,
//                         ),
//                         Text(
//                           'Oops..!',
//                           style: AppStyles().defaultStyle(
//                               23,
//                               AppColors.kTextBlackColor,
//                               FontWeight.w600),
//                         ),
//                         const SizedBox(
//                           height: 8,
//                         ),
//                         Text(
//                           'Sorry, Something went wrong',
//                           style: AppStyles().defaultStyle(
//                               16,
//                               AppColors.kTextBlackColor,
//                               FontWeight.w400),
//                         )
//                       ],
//                     ),
//                   );
//                 }
//
//                 else if (snapshot.hasData) {
//                   return Expanded(
//                     child: ListView.builder(
//                         physics: const BouncingScrollPhysics(),
//                         itemCount: snapshot.data!.docs.length,
//                         itemBuilder: (context, index) {
//                           final data = snapshot.data!.docs[index];
//                           final studentId = snapshot.data!.docs[index].id;
//                           return CustomListTile(
//                               title: data['studentName'],
//                               subtitle: data['rollNumber'].toString(),
//                               trailingFirstText: '0%',
//                               trailingSecondText: 'Attendance',
//                               onPress: () {
//                                 Navigator.pushNamed(
//                                     context, RouteName.studentProfile,
//                                     arguments: {
//                                       'studentName': data['studentName'],
//                                       'studentRollNumber':
//                                       data['rollNumber'].toString(),
//                                     'studentId':studentId.toString(),
//                                       'subject':widget.subject,
//                                       'classId':widget.classId
//
//                                     });
//                               },
//                               onLongPress: () {
//                                 String title = 'Edit Student';
//                                 String firstText = 'EDIT STUDENT';
//                                 String secondText = 'DELETE STUDENT';
//                                 showImportDialog(
//                                     context, title, firstText, secondText, () {
//                                   Navigator.pop(context);
//
//                                   String titleVal = 'Edit Student';
//                                   String firstButton = 'SAVE';
//                                   String secondButton = 'CLOSE';
//                                   updateStudentDialog(
//                                       context,
//                                       studentId,
//                                       data['studentName'],
//                                       data['rollNumber'].toString(),
//                                       widget.classId,
//                                       widget.subject,
//                                       titleVal,
//                                       firstButton,
//                                       secondButton);
//
//                                 }, () {
//                                   AddStudentsController()
//                                       .deleteStudentFromClass(widget.classId,
//                                           widget.subject, studentId)
//                                       .then((value) {
//                                     Utils.toastMessage(
//                                         'Student ${data['studentName']}(${data['rollNumber'].toString()})} deleted');
//                                     Navigator.pop(context);
//                                   });
//                                 });
//                               });
//                         }),
//                   );
//                 } else {
//                   return const Center(
//                       child: Text('Click on the button to add student '));
//                 }
//               }),
//         ],
//       ),
//       bottomNavigationBar: Padding(
//         padding:
//             const EdgeInsets.only(left: 100, right: 100, bottom: kPadding16),
//         child: CustomRoundButton(
//             title: 'ADD STUDENTS',
//             gradient: false,
//             height: 35,
//             textStyle: AppStyles().defaultStyle(
//                 15, AppColors.kTextWhiteColor, FontWeight.bold),
//             borderRaduis: kBorderRadius5,
//             color: AppColors.kThemePinkColor,
//             onPress: () {
//               String title = 'Edit Students';
//               String firstButton = 'ADD ANOTHER';
//               String secondButton = 'SAVE & CLOSE';
//
//               addStudentDialog(context, widget.classId, widget.subject, title,
//                   firstButton, secondButton);
//             }),
//       ),
//     );
//   }
// }

class StudentTab extends StatefulWidget {
  const StudentTab({super.key});

  @override
  State<StudentTab> createState() => _StudentTabState();
}

class _StudentTabState extends State<StudentTab> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [],
      ),
      bottomNavigationBar: Padding(
          padding:
              const EdgeInsets.only(left: 120, right: 120, bottom: kPadding16),
          child: CustomRoundButton2(
            height: getProportionalHeight(38),
            title: 'ADD STUDENT',
            onPress: () {

            },
            buttonColor: AppColor.kSecondaryColor,
          )),
    );
  }
}
