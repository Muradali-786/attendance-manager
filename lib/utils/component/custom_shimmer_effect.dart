import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:attendance_manager/size_config.dart';
import '../../constant/app_style/app_colors.dart';


class ShimmerLoadingEffect extends StatelessWidget {
  final double height;
  const ShimmerLoadingEffect({Key? key, this.height = 84}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      direction: ShimmerDirection.ttb,
      child: ListView.builder(
        itemCount: 4, // Number of shimmer items you want to show
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.circular(4),
            ),

            height: height,
            width: double.infinity,
          ),
        ),
      ),
    );
  }
}

class StdProfileShimmerEffect extends StatelessWidget {
  const StdProfileShimmerEffect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      direction: ShimmerDirection.ttb,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height:
            SizeConfig.screenHeight! * 0.26 - SizeConfig.screenHeight! * 0.06,
            decoration: const BoxDecoration(
              color: AppColor.kPrimaryColor,
            ),
          ),
          Shimmer.fromColors(
            baseColor: Colors.grey[500]!,
            highlightColor: Colors.grey[100]!,
            direction: ShimmerDirection.ttb,
            child: Padding(
              padding:  EdgeInsets.fromLTRB(30, SizeConfig.screenHeight! * 0.14, 30, 0),
              child: Container(
                height: SizeConfig.screenHeight! * 0.120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.kBlack.withOpacity(0.3),
                      spreadRadius: 0,
                      blurRadius: 1.5,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),

              ),
            ),
          ),
          Positioned(
            top: SizeConfig.screenHeight! * 0.01,
            right: SizeConfig.screenWidth! * 0.025,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.edit,
                color: AppColor.kGrey,
                size: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }


}