import 'package:gorabbit_driver/core/app_url.dart';
import 'package:gorabbit_driver/core/network_api_service.dart';
import 'package:gorabbit_driver/screens/homeScreeen/model/home_model.dart';


class HomeRepository {
  final _apiService = NetworkApiServices();
  Future<HomeStatsModel> getHomeDataApi() async {
    try {
      final response = await _apiService.getApiWithToken(AppUrl.getHomeData);
      print('HomeStatsModel: $response');

      if (response != null) {
        return HomeStatsModel.fromJson(response);
      } else {
        throw Exception('Failed to load HomeStatsModelRepository data: response is null');
      }
    } catch (e) {
      print('Error fetching HomeStatsModelRepository data: $e');
      rethrow;
    }
  }

}