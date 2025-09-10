import 'package:flutter/material.dart';
import 'package:gorabbit_driver/Utils/app_colors.dart';
import 'package:slide_to_act/slide_to_act.dart';

class SwipeButton extends StatelessWidget {
  final VoidCallback onSubmit;
  final String? buttonTitle;

  const SwipeButton({
    Key? key, 
    required this.onSubmit,
    this.buttonTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SlideAction(
        borderRadius: 30,
        elevation: 2,
        innerColor: Colors.white,
        outerColor: ColorResource.primaryColor,
        text: buttonTitle ?? 'Swipe To Accept',
        textStyle: TextStyle(color: Colors.white),
        sliderButtonIcon: Icon(Icons.arrow_forward_ios, color: Colors.green),
        onSubmit: () async {
          onSubmit();
        },
      ),
    );
  }
}