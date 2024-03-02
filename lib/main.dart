import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/utils/routes/route_name.dart';
import 'package:attendance_manager/utils/routes/routes.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCGFzozTh1w79r1R2WJB79fg1f82ZJ-zOA",
      appId: "1:868175613153:android:6992370f24caf82278fba0",
      messagingSenderId: "868175613153",
      projectId: "attendance-manager-4e159",
    ),
  );

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        scaffoldBackgroundColor: AppColor.kBgColor,
        appBarTheme: const AppBarTheme(
          color: AppColor.kPrimaryColor,
        ),
      ),
      title: 'Attendance Manager',

      initialRoute: RouteName.splash,
      onGenerateRoute: Routes.generateRoute,


    );
  }
}
