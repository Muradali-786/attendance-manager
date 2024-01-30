import 'package:attendance_manager/constant/app_colors.dart';
import 'package:attendance_manager/constant/app_styles.dart';
import 'package:attendance_manager/constant/image_constant/image_constant.dart';
import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

class TimeLineWidget extends StatelessWidget {
  bool isFirstPage;
  TimeLineWidget({super.key, required this.isFirstPage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Timeline.tileBuilder(
        scrollDirection: Axis.horizontal,
        builder: TimelineTileBuilder.connected(
          connectionDirection: ConnectionDirection.before,
          itemCount: 2,
          contentsBuilder: (context, index) {
            if (index == 0) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'class',
                      style: AppStyles().defaultStyle(14,
                          AppColors.kBlack.withOpacity(0.6), FontWeight.normal),
                    ),
                  ),
                ],
              );
            }
            if (index == 1) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Students',
                      style: AppStyles().defaultStyle(13,
                          AppColors.kBlack.withOpacity(0.6), FontWeight.normal),
                    ),
                  ),
                ],
              );
            }
            return null;
          },
          indicatorBuilder: (context, index) {
            if (isFirstPage) {
              if (index == 1) {
                return Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.kGrey,
                      width: 4,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: const BoxDecoration(
                        color: AppColors.kGreenColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              } else {
                return Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.kGreenColor,
                      width: 4,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage(ImageConstant.kIconDone))),
                    ),
                  ),
                );
              }
            } else {
              if (index == 0) {
                return Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isFirstPage
                          ? AppColors.kGreenColor
                          : AppColors.kGrey,
                      width: 4,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: const BoxDecoration(
                        color: AppColors.kGreenColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              } else {
                return Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey,
                      width: 4,
                    ),
                  ),
                );
              }
            }
          },
          connectorBuilder: (_, index, type) {
            if (isFirstPage) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.18,
                child: const SolidLineConnector(
                  color: AppColors
                      .kGreenColor, // Change to green on the first page
                  // indent: 3,
                  // endIndent: 3,
                  thickness: 2,
                ),
              );
            } else {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.18,
                child: const SolidLineConnector(
                  color: AppColors.kGrey,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
