import 'dart:io';
import 'package:attendance_manager/utils/routes/route_name.dart';
import 'package:attendance_manager/utils/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyBE_rbUwRR11oIhGGzF7EpyJGMTd7uaeSM",
            appId: "1:490857828192:android:c72f11e29b26aae8249805",
            messagingSenderId: "490857828192",
            projectId: "attendance-app-cd946",
            storageBucket: "gs://attendance-app-cd946.appspot.com",
          ),
        )
      : Firebase.initializeApp();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: false),
      title: 'Attendance Manager',
      initialRoute: RouteName.splash,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
