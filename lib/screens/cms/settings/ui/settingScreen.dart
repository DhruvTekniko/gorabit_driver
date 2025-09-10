// import 'package:flutter/material.dart';
// import 'package:grab_meal/Utils/app_colors.dart';
// import 'package:grab_meal/Utils/custom_widgets/customAppBar.dart';
// import 'package:grab_meal/Utils/custom_widgets/navigation_method.dart';
// import 'package:grab_meal/core/app_url.dart';
// import 'package:grab_meal/helper/helper_functions.dart';
// import 'package:grab_meal/screen/splashScreen.dart';
//
//
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../../Utils/custom_widgets/custom_app_button.dart';
//
//
// class SettingsScreen extends StatefulWidget {
//   const SettingsScreen({super.key});
//
//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }
//
// class _SettingsScreenState extends State<SettingsScreen> {
//   bool _switchValue = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: const CustomAppBar(title: "Settings"),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//         child: Column(
//           children: [
//             _buildNotificationSwitch(),
//             const SizedBox(height: 20),
//             _buildLogOutAccountButton(context),
//             const SizedBox(height: 10),
//             _buildDeleteAccountButton(context),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNotificationSwitch() {
//     return Container(
//       decoration: _boxDecoration(),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Notification',
//               style: _textStyle(16, FontWeight.w500, Colors.black),
//             ),
//             Transform.scale(
//               scale: 0.9,
//               child: Switch(
//                 value: _switchValue,
//                 activeColor: Colors.white,
//                 activeTrackColor: ColorResource.primaryColor,
//                 inactiveThumbColor: Colors.white,
//                 inactiveTrackColor: Colors.black45,
//                 onChanged: (value) {
//                   setState(() {
//                     _switchValue = value;
//                   });
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLogOutAccountButton(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         showCustomPopup(context,"Logout" );
//       },
//       child: Container(
//         decoration: _boxDecoration(),
//         child: Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Logout',
//                 style: _textStyle(16, FontWeight.w500, ColorResource.primaryColor),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//   Widget _buildDeleteAccountButton(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         showCustomPopup(context, "Delete");
//       },
//       child: Container(
//         decoration: _boxDecoration(),
//         child: Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Delete Account',
//                 style: _textStyle(16, FontWeight.w500, Colors.red),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//   BoxDecoration _boxDecoration() {
//     return BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(12.0),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.2),
//           spreadRadius: 1,
//           blurRadius: 1,
//           offset: const Offset(0, 1),
//         ),
//       ],
//     );
//   }
//
//   TextStyle _textStyle(double fontSize, FontWeight fontWeight, Color color) {
//     return TextStyle(
//       color: color,
//       fontSize: fontSize,
//       fontFamily: 'Poppins',
//       fontWeight: fontWeight,
//     );
//   }
//
//   void showCustomPopup(BuildContext context, String popType) {
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           backgroundColor: Colors.transparent,
//           child: Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(15),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.2),
//                   blurRadius: 10,
//                   offset: const Offset(0, 5),
//                 ),
//               ],
//             ),
//             width: width * 0.8,
//             height: height * 0.3,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   '$popType Account?',
//                   style: _textStyle(18, FontWeight.bold, Colors.black
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                  Text(
//                   'Are you sure you want to $popType your account?',
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     _buildDialogButton("Cancel", Colors.white, () {
//                       navPop(context: context);
//                     }),
//                     _buildDialogButton(popType, Colors.red, () async {
//                       if(popType == "Logout"){
//                         final prefs = await SharedPreferences.getInstance();
//                         final token = prefs.clear();
//                         print(token);
//                         navPushRemove(context: context, action: SplashScreen());
//                       } else {
//                         final prefs = await SharedPreferences.getInstance();
//                         final userId = prefs.getString('userId');
//                         await HelperFunctions.launchExternalUrl(context,'${AppUrl.baseUrl}/api/user/delete-user/$userId');
//                       }
//                     }),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildDialogButton(String title, Color color, VoidCallback onPressed) {
//     return Container(
//       width: MediaQuery.of(context).size.width * 0.25,
//       height: MediaQuery.of(context).size.height * 0.08,
//       child: CustomAppButton(
//         color: color,
//         title: title,
//         textColor: Colors.white,
//         onPressed: onPressed,
//       ),
//     );
//   }
// }