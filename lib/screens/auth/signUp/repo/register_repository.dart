import 'dart:io';

import 'package:gorabbit_driver/core/app_url.dart';
import 'package:gorabbit_driver/core/network_api_service.dart';
import 'package:gorabbit_driver/screens/auth/signUp/model/driver_profile_model.dart';

class RegisterRepository {
  final _apiService = NetworkApiServices();

  Future<dynamic> registerDriverApi({
    required Map<String, String> fields,
    required Map<String, File> files,
  }) async {
    try {
      final response = await _apiService.postMultipartRegisterApi(
        url: AppUrl.registerDriver,
        fields: fields,
        files: files,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> updateDriverApi({
    required Map<String, String> fields,
    required Map<String, File> files,
  }) async {
    try {
      final response = await _apiService.patchMultipartApiWithToken(
        url: AppUrl.driverProfile,
        fields: fields,
        files: files,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<DriverProfileModel> getDriverDetailsApi() async {
    try {
      final response = await _apiService.getApiWithToken(AppUrl.driverProfile);
      print('DriverProfileModel: $response');

      if (response != null) {
        return DriverProfileModel.fromJson(response);
      } else {
        throw Exception('Failed to load DriverProfileModel data: response is null');
      }
    } catch (e) {
      print('Error fetching DriverProfileModel data: $e');
      rethrow;
    }
  }
}
