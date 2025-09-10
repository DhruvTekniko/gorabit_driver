import 'package:flutter/material.dart';
import '../app_colors.dart';
import 'custom_bounce.dart';
class CustomAppButton extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;
  final double? buttonWidth;
  final bool? isIconsShow;
  final double? borderRadius;
  final double? buttonHeight;
  final double? textHeight;

  const CustomAppButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.color,
    this.textColor,
    this.buttonHeight,
    this.textHeight,
    this.buttonWidth,
    this.borderRadius,
    this.isIconsShow = false,
  }) : super(key: key);

  @override
  State<CustomAppButton> createState() => _CustomAppButtonState();
}

class _CustomAppButtonState extends State<CustomAppButton> {
  @override
  Widget build(BuildContext context) {
    return CustomGestureDetector(
      onPressed: widget.onPressed,
      child: Container(
        height: widget.buttonHeight ?? 45,
        width: widget.buttonWidth ?? MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Colors.transparent, // Set the border color if needed
            width: 2, // Set the border width if needed
          ),
        ),
        child: Center(
          child: Text(
            widget.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: widget.textColor ?? Colors.white,
              fontSize: widget.textHeight ?? 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}