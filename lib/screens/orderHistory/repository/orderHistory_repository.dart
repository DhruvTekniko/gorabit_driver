import 'package:gorabbit_driver/core/app_url.dart';
import 'package:gorabbit_driver/core/network_api_service.dart';
import 'package:gorabbit_driver/screens/orderHistory/model/orderHistory_model.dart';

class OrderHistoryListRepository {
  final _apiService = NetworkApiServices();

  Future<HistoryOrderList> getOrderHistoryListApi() async {
    try {
      final response = await _apiService.getApiWithToken(AppUrl.getOrderHistory);
      print('dvdv: $response');

      if (response != null) {
        return HistoryOrderList.fromJson(response);
      } else {
        throw Exception('Failed to load HistoryOrderListRepository data: response is null');
      }
    } catch (e) {
      print('Error fetching HistoryOrderListRepository data: $e');
      rethrow;
    }
  }
}