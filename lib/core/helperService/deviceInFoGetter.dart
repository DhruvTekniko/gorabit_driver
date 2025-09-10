import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';


class AndroidDeviceInfoService {
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  Future<String?> getAndroidDeviceId() async {
    if (Platform.isAndroid) {
      try {
        AndroidDeviceInfo androidInfo = await _deviceInfoPlugin.androidInfo;
        return androidInfo.id;
      } catch (e) {
        print("Failed to get device ID: $e");
        return null;
      }
    } else {
      print("This function is specific to Android devices.");
      return null;
    }
  }
}
