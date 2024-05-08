import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/view_model/login/login_controller.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    LoginController _controller = LoginController();
    return Drawer(
        child: ListView(
      children: [
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(color: AppColor.kSecondary54Color),
          accountName: Text('Murad Ali Khan', style: TextStyle(fontSize: 17)),
          accountEmail:
              Text('itsmurad@gmail.com', style: TextStyle(fontSize: 16)),
          currentAccountPicture: CircleAvatar(
            backgroundColor: AppColor.kPrimaryColor,
            child: Text(
              'M',
              style: TextStyle(fontSize: 25, color: AppColor.kWhite,fontWeight: FontWeight.bold),
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.home, color: AppColor.kPrimaryColor),
          title:
              Text('Home', style: TextStyle(color: AppColor.kPrimaryTextColor)),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.share, color: AppColor.kPrimaryColor),
          title: Text(
            'Share',
            style: TextStyle(color: AppColor.kPrimaryTextColor),
          ),
        ),
        ListTile(
          leading: Icon(Icons.rate_review, color: AppColor.kPrimaryColor),
          title: Text('Rate Us',
              style: TextStyle(color: AppColor.kPrimaryTextColor)),
        ),
        ListTile(
          leading: Icon(
            Icons.logout,
            color: AppColor.kPrimaryColor,
          ),
          title: Text('Log Out',
              style: TextStyle(color: AppColor.kPrimaryTextColor)),
          onTap: () async {
            await _controller.logOutAsTeacher();
          },
        ),
      ],
    ),);
  }
}
