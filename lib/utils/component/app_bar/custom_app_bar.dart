
import 'package:attendance_manager/constant/app_styles.dart';
import 'package:attendance_manager/constant/constant_size.dart';
import 'package:flutter/material.dart';
import 'package:attendance_manager/constant/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  final double preferredHeight;
  final TextStyle? textStyle;
  final bool automaticallyImplyLeading,showLeading;

  const CustomAppBar({
    Key? key,
    required this.titleText,
    required this.preferredHeight,
    this.textStyle,
    this.automaticallyImplyLeading=false,
    this.showLeading=false,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(preferredHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.kTransparentColor,
      elevation: 0,
      centerTitle: true,
      leading: showLeading
          ? Padding(
        padding: const EdgeInsets.only(left: kPadding8),
        child: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.kWhite),
        ),
      )
          : null,
      automaticallyImplyLeading: automaticallyImplyLeading,
      flexibleSpace: PreferredSize(
        preferredSize: Size.fromHeight(preferredHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.kPrimaryLinearGradient,
          ),
          child: Center(
            child: Text(
              titleText,
              style: textStyle ??
                  AppStyles().defaultStyleWithHt(24, AppColors.kTextWhiteColor, FontWeight.w700,3.5),
            ),
          ),
        ),
      ),
    );
  }
}



//
// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String title;
//   final Color appBarColor, appBarTitleColor;
//   final Widget? leading;
//   final Widget? titleWidget;
//   final bool showActionButton;
//   final VoidCallback? onMenuActionTap;
//
//   const CustomAppBar({
//     Key? key,
//     this.title = '',
//     this.leading,
//     this.appBarColor = AppColor.kWhite,
//     this.appBarTitleColor = AppColor.kTextBlackColor,
//     this.titleWidget,
//     this.showActionButton = false,
//     this.onMenuActionTap,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Container(
//         decoration: BoxDecoration(color: appBarColor),
//         child: Padding(
//           padding:
//           const EdgeInsets.symmetric(horizontal: 25, vertical: 25 / 2.5),
//           child: Stack(
//             children: [
//               Positioned.fill(
//                 child: titleWidget != null
//                     ? Center(
//                   child: titleWidget!,
//                 )
//                     : Center(
//                   child: Text(
//                     title,
//                     // style: AppStyle().interFontStyle(
//                     //     18, appBarTitleColor, FontWeight.w600),
//                   ),
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   leading ??
//                       Transform.translate(
//                         offset: const Offset(-14, 0),
//                         child: IconButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             icon: const Icon(Icons.arrow_back_ios)),
//                       ),
//                   if (showActionButton)
//                     Transform.translate(
//                       offset: const Offset(18, 7),
//                       child: TextButton(
//                         onPressed: () {
//
//                         },
//                         child: Text(
//                           'Skip',
//                         ),
//                       ),
//                     ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Size get preferredSize => const Size(double.maxFinite, 80);
// }
//
// class AppBarBackButton extends StatelessWidget {
//   const AppBarBackButton({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 40,
//       width: 40,
//       decoration: BoxDecoration(
//         color: AppColor.kPrimary54Color,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Center(
//         child: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(
//             Icons.arrow_back,
//             color: AppColor.kPrimaryColor,
//           ),
//         ),
//       ),
//     );
//   }
// }
