import 'package:attendance_manager/utils/routes/route_name.dart';
import 'package:attendance_manager/view/add_students/add_students.dart';
import 'package:attendance_manager/view/class_input/class_input_page.dart';
import 'package:attendance_manager/view/home/home_page.dart';
import 'package:attendance_manager/view/login/login_page.dart';
import 'package:attendance_manager/view/myTabBar/attendance/attendance_tab.dart';
import 'package:attendance_manager/view/myTabBar/attendance/update_attendance/update_attendance.dart';
import 'package:attendance_manager/view/myTabBar/history/attendance_history/student_attedance_history.dart';
import 'package:attendance_manager/view/myTabBar/history/history_tab.dart';
import 'package:attendance_manager/view/myTabBar/my_tab_bar.dart';
import 'package:attendance_manager/view/myTabBar/student/std_attendance/student_attendance_page.dart';
import 'package:attendance_manager/view/myTabBar/student/student_profiile/student_profile.dart';
import 'package:attendance_manager/view/myTabBar/student/students_tab.dart';
import 'package:attendance_manager/view/sign_up/sign_up_page.dart';
import 'package:attendance_manager/view/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

//
class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    switch (settings.name) {
      case RouteName.splash:
        return MaterialPageRoute(builder: (_) => const Splash());
      case RouteName.signUp:
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case RouteName.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case RouteName.homePage:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case RouteName.classInputPage:
        return MaterialPageRoute(builder: (_) => const ClassInputPage());
      case RouteName.addStudentPage:
        return MaterialPageRoute(
            builder: (_) => AddStudentPage(data: settings.arguments as Map));
      case RouteName.myTabBar:
        return MaterialPageRoute(
            builder: (_) => MyTabBar(data: settings.arguments as Map));
      case RouteName.attendanceTab:
        return MaterialPageRoute(builder: (_) => const AttendanceTab());
      case RouteName.studentTab:
        return MaterialPageRoute(builder: (_) => StudentTab());
      case RouteName.historyTab:
        return MaterialPageRoute(builder: (_) => HistoryTab());
      case RouteName.studentProfile:
        return MaterialPageRoute(
            builder: (_) => StudentProfile(data: settings.arguments as Map));
      case RouteName.studentAttendancePage:
        return MaterialPageRoute(
            builder: (_) =>
                StudentAttendancePage(data: settings.arguments as Map));
      case RouteName.studentAttendanceHistoryPage:
        return MaterialPageRoute(
            builder: (_) =>
                StudentAttendanceHistory(data: settings.arguments as Map));
      case RouteName.updateAttendance:
        return MaterialPageRoute(
            builder: (_) => UpdateAttendance(data: settings.arguments as Map));

      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          );
        });
    }
  }
}
