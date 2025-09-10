import 'package:flutter/material.dart';
import 'package:gorabbit_driver/Utils/app_colors.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/custom_app_button.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/custom_image_view.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/navigation_method.dart';
import 'package:gorabbit_driver/screens/auth/login/ui/loginScreen.dart';
import 'package:gorabbit_driver/screens/auth/signUp/ui/registerScreen.dart';



class onBoardingScreen extends StatelessWidget {
  const onBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImageView(imagePath: 'assets/images/ob2.png'),
            SizedBox(height: 10),
            Text(
              'Join us today',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Enter your details to proceed further',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 18.0,right: 18,top:5),
              child: CustomAppButton(
                title: 'Log in',
                color: ColorResource.primaryColor,
                onPressed: () {
                  navPush(context: context, action: LoginScreen());
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0,right: 18,top:5),
              child: CustomAppButton(
                title: 'Register',
                color: ColorResource.primaryColor,
                textColor: ColorResource.whiteColor,
                onPressed: () {
                  navPush(context: context, action: RegistrationScreen());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
