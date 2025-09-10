import '../../../../core/app_url.dart';
import '../../../../core/network_api_service.dart';


class LoginRepository {
  final _apiService = NetworkApiServices();

  Future<dynamic> logInApi(var data) async {
    try {
      dynamic response =
      await _apiService.postApi(data, AppUrl.login);
      return response;
    } catch (e) {
      throw e;
    }
  }
}