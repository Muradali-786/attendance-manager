import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/app_style/app_styles.dart';
import 'package:attendance_manager/constant/constant_size.dart';
import 'package:attendance_manager/size_config.dart';
import 'package:attendance_manager/utils/routes/route_name.dart';
import 'package:attendance_manager/view_model/attendance/attendance_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../model/attendance_model.dart';
import '../../../utils/component/custom_round_botton.dart';
import '../../../utils/component/custom_shimmer_effect.dart';
import '../../home/home_page.dart';

class AttendanceTab extends StatefulWidget {
  final String subjectId;

  const AttendanceTab({Key? key, this.subjectId = ''}) : super(key: key);

  @override
  State<AttendanceTab> createState() => _AttendanceTabState();
}

class _AttendanceTabState extends State<AttendanceTab> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();

  final AttendanceController _controller = AttendanceController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TableCalendar<void>(
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontSize: 16,
                color: AppColor.kTextGreyColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            focusedDay: _selectedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            firstDay: DateTime(2015),
            lastDay: DateTime(2099),
            onDaySelected: _handleDaySelected,
            calendarFormat: _calendarFormat,
            startingDayOfWeek: StartingDayOfWeek.monday,
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                color: AppColor.kTextGreyColor,
                fontSize: 13,
              ),
              weekendStyle: TextStyle(color: AppColor.kSecondaryTextColor),
            ),
            calendarStyle: CalendarStyle(
              defaultTextStyle: const TextStyle(fontSize: 13),
              weekendTextStyle:
                  const TextStyle(color: AppColor.kSecondaryTextColor),
              todayDecoration: BoxDecoration(
                color: AppColor.kPrimaryColor.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              selectedDecoration: const BoxDecoration(
                color: AppColor.kSecondaryColor,
                shape: BoxShape.circle,
              ),
            ),
            rowHeight: getProportionalHeight(42),
            calendarBuilders: CalendarBuilders(
              outsideBuilder: (context, day, dayOfWeek) =>
                  const SizedBox.shrink(),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _controller.getAllStudentAttendance(widget.subjectId),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Expanded(
                  child: ShimmerLoadingEffect(height: 45),
                );
              } else if (snapshot.hasError) {
                return const ErrorClass();
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Center(
                    child: Text('No student has been taken of the class.'),
                  ),
                );
              } else {
                List<AttendanceModel> snap = snapshot.data!.docs.map((doc) {
                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;

                  return AttendanceModel.fromMap(data);
                }).toList();

                return Expanded(
                  child: ListView.builder(
                    itemCount: snap.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, RouteName.updateAttendance,
                              arguments: {'data': snap[index].toMap()});
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                          child: Container(
                            height: 45,
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                                color: AppColor.kWhite,
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColor.kBlack.withOpacity(0.3),
                                    spreadRadius: 0,
                                    blurRadius: 1.5,
                                    offset: const Offset(
                                      0,
                                      1,
                                    ), // controls the shadow position
                                  )
                                ]),
                            child: Row(
                              children: [
                                Container(
                                  height: 17,
                                  width: 17,
                                  decoration: BoxDecoration(
                                    color:
                                        AppColor.kPrimaryColor.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: SizeConfig.screenWidth! * 0.05),
                                Text(
                                  snap[index].currentTime,
                                  style: AppStyles().defaultStyle(
                                    getProportionalWidth(24),
                                    AppColor.kTextBlackColor,
                                    FontWeight.w400,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () async{
                                    await _controller.deleteAttendanceRecord(
                                      widget.subjectId,
                                      snap[index].attendanceId!,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: AppColor.kSecondaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding:
            const EdgeInsets.only(left: 100, right: 100, bottom: kPadding16),
        child: CustomRoundButton2(
          height: getProportionalHeight(38),
          title: 'TAKE ATTENDANCE',
          onPress: () => Navigator.pushNamed(
            context,
            RouteName.studentAttendancePage,
            arguments: {
              'classId': widget.subjectId,
              'selectedDate': _selectedDay.toString(),
            },
          ),
          buttonColor: AppColor.kSecondaryColor,
        ),
      ),
    );
  }

  void _handleDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
    });
  }
}
