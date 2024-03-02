import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/view_model/login/login_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'utils/routes/route_name.dart';
import 'utils/routes/routes.dart';
import 'view_model/sign_up/sign_up_controller.dart';

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
    return MultiProvider(providers: [
      ChangeNotifierProvider<SignUpController>(create: (_) => SignUpController()),
      ChangeNotifierProvider<LoginController>(create: (_) => LoginController()),

    ],
    child: MaterialApp(
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



    ),
    );
  }
}
