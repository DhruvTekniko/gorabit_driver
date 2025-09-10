
import 'package:flutter/cupertino.dart';

class CustomGestureDetector extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const CustomGestureDetector({super.key, required this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(child: child,  onTap: onPressed);
  }
}
