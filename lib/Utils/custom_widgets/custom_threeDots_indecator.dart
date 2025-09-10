import 'package:flutter/material.dart';
import 'package:gorabbit_driver/Utils/app_colors.dart';

class ThreeDotsLoader extends StatefulWidget {
  final Color color;
  final double dotSize;
  final double spacing;



  const ThreeDotsLoader({
    Key? key,
    this.color = ColorResource.primaryColor,
    this.dotSize = 10.0,
    this.spacing = 3.0,
  }) : super(key: key);



  @override
  _ThreeDotsLoaderState createState() => _ThreeDotsLoaderState();
}

class _ThreeDotsLoaderState extends State<ThreeDotsLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;



  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
  
  

    _animations = List.generate(3, (index) {
    final start = index * 0.2;
    final end = start + 0.6;
    return TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 0.2, end: 1.0), weight: 50),
    TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.2), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Interval(start, end, curve: Curves.easeInOut)));
    });
  }



  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }



  Widget _buildDot(int index) {
    return FadeTransition(
      opacity: _animations[index],
      child: Container(
        width: widget.dotSize,
        height: widget.dotSize,
        margin: EdgeInsets.symmetric(horizontal: widget.spacing / 2),
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, _buildDot),
    );
  }
}

