import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gorabbit_driver/screens/auth/signUp/model/driver_profile_model.dart';
import 'package:gorabbit_driver/screens/auth/signUp/repo/register_repository.dart';
import 'package:flutter/foundation.dart';

class DriverDetailsViewModel extends ChangeNotifier {
  final RegisterRepository _repository = RegisterRepository();

  DriverProfileModel? driverDetails;
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchDriverDetails() async {
    isLoading = true;
    notifyListeners();

    try {
      driverDetails = await _repository.getDriverDetailsApi();
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
      driverDetails = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateDriverDetails({
    required Map<String, String> fields,
    required Map<String, File> files,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      print(files);
      final response = await _repository.updateDriverApi(fields: fields, files: files);
      if (response['success'] == true) {
        await fetchDriverDetails();
        errorMessage = null;
      } else {
        errorMessage = response['message'] ?? 'Failed to update driver details';
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> registerDriver({
    required Map<String, String> fields,
    required Map<String, File> files,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await _repository.registerDriverApi(fields: fields, files: files);
      if (response['success'] == true) {
        // Handle successful registration (e.g., navigate to login screen)
        errorMessage = null;
      } else {
        errorMessage = response['message'] ?? 'Failed to register driver';
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}