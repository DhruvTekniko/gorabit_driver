
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/custom_threeDots_indecator.dart';
import 'package:gorabbit_driver/core/helperService/deviceInFoGetter.dart';

import 'package:gorabbit_driver/screens/auth/login/repo/login_repository.dart';
import 'package:gorabbit_driver/screens/homeScreeen/ui/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../Utils/app_colors.dart';
import '../../../../Utils/custom_widgets/navigation_method.dart';


class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  String? deviceId;
  String? deviceToken;

  @override
  void initState() {
    super.initState();
    _getDeviceId();
    _initFCMToken();
  }


  Future<void> _getDeviceId() async {
    String? id = await AndroidDeviceInfoService().getAndroidDeviceId();
    setState(() {
      deviceId = id;
    });
    print("Device ID: $deviceId");
  }

  Future<void> _initFCMToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    setState(() {
      deviceToken = token;
    });
    print("FCM Token: $token");
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: screenWidth,
        height: screenHeight,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: screenHeight * 0.12),
                      Image.asset(
                        "assets/images/AppLogo.png",
                        width:screenWidth * 0.8,
                        height:screenHeight * 0.4,
                        fit: BoxFit.contain,
                      ),
                      // Center(
                      //     child: Text('Welcome to GoRabit', style: TextStyle(
                      //         fontSize: 22, fontWeight: FontWeight.w500))),
                      // SizedBox(height: screenHeight * 0.07),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildInputField(
                          controller: mobileNumberController,
                          hintText: "Enter Mobile Number",
                          maxLength: 10,
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: _buildInputField(
                          controller: passwordController,
                          hintText: "Enter Password",
                          icon: Icons.lock,
                          keyboardType: TextInputType.text,
                          maxLength: 10,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : () async {
                          setState(() {
                            _isLoading = true;
                          });

                          var payload = {
                            "mobileNo": mobileNumberController.text.trim(),
                            "password": passwordController.text.trim(),
                            "deviceId": deviceId ?? "",
                            "deviceToken": deviceToken ?? "",
                          };

                          try {
                            var response = await LoginRepository().logInApi(payload);
                            if (response['status'] == true) {
                              final token = response['token'];
                              final driverId = response['data']['user']['_id'];
                              SharedPreferences pref = await SharedPreferences.getInstance();
                              pref.setString('token', token);
                              pref.setString('driverId', driverId);
                              navPushRemove(context: context, action: HomeScreen());
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(response['message'] ?? "Something went wrong")));
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("An error occurred: $e")));
                          } finally {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                        icon: Icon(Icons.bike_scooter, color: Colors.white),
                        label: _isLoading
                            ? ThreeDotsLoader(color: ColorResource.primaryColor,)
                            : Text('LogIn Driver'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: ColorResource.primaryColor,
                          foregroundColor: ColorResource.whiteColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      Spacer(),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0x7F013F30), width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
        style: TextStyle(fontSize: 16),
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: Color(0xff3C5B54),
              fontSize: 14,
              fontWeight: FontWeight.w400),
          prefixIcon: Icon(icon, color: Color(0xff3C5B54)),
        ),
      ),
    );
  }
}



