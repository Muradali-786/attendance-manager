import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/utils/component/dialoge_boxes/delete_confirmations.dart';
import 'package:attendance_manager/utils/component/dialoge_boxes/update_user_profile.dart';
import 'package:attendance_manager/view_model/login/login_controller.dart';
import 'package:attendance_manager/view_model/sign_up/sign_up_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SignUpController _signUpController = SignUpController();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FutureBuilder(
            future: _signUpController
                .getTeacherData(_auth.currentUser!.uid.toString()),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ReusableProfile();
              } else if (snapshot.hasError) {
                return const ReusableProfile();
              } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                final data = snapshot.data!.docs;

                return ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    UserAccountsDrawerHeader(
                        decoration: BoxDecoration(
                            color: AppColor.kSubmarine.withOpacity(0.6),
                        ),
                        accountName: Text(data[0]['name'].toString(),
                            style: const TextStyle(fontSize: 17)),
                        accountEmail: Text(data[0]['email'].toString(),
                            style: const TextStyle(fontSize: 16)),
                        currentAccountPicture: GestureDetector(
                          onTap: () {
                            updateUserProfileDialog(
                                context, data[0]['teacherId'], data[0]['name']);
                          },
                          child: CircleAvatar(
                            backgroundColor: AppColor.kPrimaryColor,
                            child: Text(
                              data[0]['name'].toString().substring(0, 1),
                              style: const TextStyle(
                                  fontSize: 25,
                                  color: AppColor.kWhite,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )),
                  ],
                );
              } else {
                return const ReusableProfile();
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.home, color: AppColor.kPrimaryColor),
            title: const Text('Home',
                style: TextStyle(color: AppColor.kPrimaryTextColor)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const ListTile(
            leading: Icon(Icons.share, color: AppColor.kPrimaryColor),
            title: Text(
              'Share',
              style: TextStyle(color: AppColor.kPrimaryTextColor),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.rate_review, color: AppColor.kPrimaryColor),
            title: Text('Rate Us',
                style: TextStyle(color: AppColor.kPrimaryTextColor)),
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: AppColor.kPrimaryColor,
            ),
            title: const Text('Log Out',
                style: TextStyle(color: AppColor.kPrimaryTextColor)),
            onTap: () async {
              await showLogOutConfirmationDialog(context);
            },
          ),
        ],
      ),
    );
  }
}

class ReusableProfile extends StatelessWidget {
  const ReusableProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children:  [
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(color:AppColor.kSubmarine.withOpacity(0.6),),
          accountName: const Text('####', style: TextStyle(fontSize: 17)),
          accountEmail:const  Text('####@gmail.com', style: TextStyle(fontSize: 16)),
          currentAccountPicture:const  CircleAvatar(
            backgroundColor: AppColor.kPrimaryColor,
            child: Text(
              '#',
              style: TextStyle(
                  fontSize: 25,
                  color: AppColor.kWhite,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
