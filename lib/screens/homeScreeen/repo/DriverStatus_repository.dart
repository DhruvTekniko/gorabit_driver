import 'package:gorabbit_driver/core/app_url.dart';
import 'package:gorabbit_driver/core/network_api_service.dart';

class DriverStatusRepository {
  final _apiService = NetworkApiServices();

  Future<dynamic> driverStatusApi(var data, String driverId) async {
    try {
      dynamic response =
      await _apiService.patchApiWithToken(data, '${AppUrl.driverStatus}/$driverId');
      return response;
    } catch (e) {
      throw e;
    }
  }
}