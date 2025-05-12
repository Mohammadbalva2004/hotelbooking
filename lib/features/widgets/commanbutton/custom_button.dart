import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double height;
  final double width;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final TextStyle textStyle;
  final BorderRadiusGeometry borderRadius;
  final bool showBorder; // ✅ New optional parameter for border

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.height = 60,
    this.width = 200,
    this.padding = const EdgeInsets.only(right: 20, left: 20),
    this.backgroundColor = Colors.black,
    this.textStyle = const TextStyle(
      fontSize: 20,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.showBorder = false, // ✅ Default: false (no border)
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius,
            border:
                showBorder
                    ? Border.all(color: Colors.black, width: 1)
                    : null, // No border if showBorder is false
          ),
          child: Center(child: Text(text, style: textStyle)),
        ),
      ),
    );
  }
}
