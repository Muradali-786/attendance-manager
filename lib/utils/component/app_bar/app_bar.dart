import 'package:flutter/material.dart';

class CustomAppBarTwo extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Color>? gradientColors;
  final TextStyle? textStyle;
  final double toolbarHeight;
  final bool showLeading;
  final VoidCallback? leadingCallback; // New parameter for leading icon callback

  const CustomAppBarTwo({super.key, 
    required this.title,
    this.gradientColors,
    this.textStyle,
    this.toolbarHeight = 80,
    this.showLeading = true,
    this.leadingCallback, // Pass a function to be called when the leading icon is tapped
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors ?? [Colors.blue, Colors.green],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: AppBar(
        toolbarHeight: toolbarHeight,
        title: Text(
          title,
          style: textStyle ??
              const TextStyle(
                  fontSize: 22, color: Colors.black, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,

      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);
}
