import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gorabbit_driver/Utils/app_colors.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/navigation_method.dart';
import 'package:gorabbit_driver/screens/SplashScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:in_app_update/in_app_update.dart';

class HelperFunctions {
  static final ImagePicker _picker = ImagePicker();

  static void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: ColorResource.primaryColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
  static void makePhoneCall(BuildContext context, String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No contact found')),
      );
      return;
    }
print(phoneNumber);
    var status = await Permission.phone.status;
    if (status.isDenied) {

      if (await Permission.phone.request().isGranted) {
        _launchPhoneDialer(context, phoneNumber);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Phone call permission denied')),
        );
      }
    } else if (status.isGranted) {
      _launchPhoneDialer(context, phoneNumber);
    }
  }

  static void _launchPhoneDialer(BuildContext context, String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: '+91$phoneNumber',
    );
    try {
      if (await canLaunch(launchUri.toString())) {
        await launch(launchUri.toString());
      } else {
        print('Could not launch $launchUri');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  static Future<void> launchExternalDeleteUrl(BuildContext context,String url) async {
    final Uri uri = Uri.parse(url);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.clear();
      print(token);
      navPushRemove(context: context, action: SplashScreen());
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  ///
  static void showImageSourceOptions(BuildContext context, Function(File) onImagePicked) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 150,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () {
                  pickImage(ImageSource.camera, onImagePicked);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Gallery'),
                onTap: () {
                  pickImage(ImageSource.gallery, onImagePicked);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> pickImage(ImageSource source, Function(File) onImagePicked) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      onImagePicked(File(pickedFile.path));
    }
  }

  static Future<void> openMapWithDirections(String lat, String long) async {
    // final Uri mapsUrl = Uri.parse(
    //   "https://www.google.com/maps/dir/?api=1&destination=${lat.trim()},${long.trim()}",
    // );
    final Uri mapsUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$long&travelmode=driving'
    );

    print("Launching Google Maps URL: $mapsUrl");
    if (await canLaunchUrl(mapsUrl)) {
      final launched = await launchUrl(
        mapsUrl,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        await launchUrl(mapsUrl, mode: LaunchMode.inAppWebView);
      }
    } else {
      print("Could not launch Google Maps");
    }
  }

  static Future<void> checkForUpdate(BuildContext context) async {
    try {
      final info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        if (info.immediateUpdateAllowed) {
          // Force update
          await InAppUpdate.performImmediateUpdate();
        } else if (info.flexibleUpdateAllowed) {
          // Optional update
          await InAppUpdate.startFlexibleUpdate();
        }
      }
    } catch (e) {
      debugPrint("Update check failed: $e");
    }
  }
}
