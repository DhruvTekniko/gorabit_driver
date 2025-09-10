import 'package:flutter/material.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/screenSizeHelper.dart';
import 'package:gorabbit_driver/core/helperService/fireBase_services.dart';
import 'package:gorabbit_driver/screens/auth/onBoarding/ui/onObardingScreen.dart';
import 'package:gorabbit_driver/screens/homeScreeen/ui/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/app_colors.dart';
import '../Utils/custom_widgets/navigation_method.dart';
import 'auth/login/ui/loginScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseNotificationService _notificationService = FirebaseNotificationService();



  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notificationService.init(context);
    });
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      navPushReplace(context: context, action: const HomeScreen());

    } else {
    navPushReplace(context: context, action: onBoardingScreen());
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: context.screenWidth,
        height: context.screenHeight,
        clipBehavior: Clip.antiAlias,
        decoration: const ShapeDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ColorResource.primaryColor,
              ColorResource.primaryColor,
            ],
          ),
          shape: RoundedRectangleBorder(),
        ),
        // child: const Center(
        //   child: Text(
        //     "Go Rabit Driver",
        //     style: TextStyle(
        //       color: ColorResource.whiteColor,
        //       fontSize: 26,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),
        child: const Center(
          child: Text(
            "GoRabit Delivery Partner",
            style: TextStyle(
              color: ColorResource.whiteColor,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}