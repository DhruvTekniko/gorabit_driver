import 'package:gorabbit_driver/core/app_url.dart';
import 'package:gorabbit_driver/core/network_api_service.dart';
import 'package:gorabbit_driver/screens/newOrders/model/newOrderModel.dart';

class NewOrderListRepository {
  final _apiService = NetworkApiServices();

  Future<NewOrderList> getNewOrderListApi() async {
    try {
      final response = await _apiService.getApiWithToken('${AppUrl.getNewOrder}');
      print('dvdv: $response');

      if (response != null) {
        return NewOrderList.fromJson(response);
      } else {
        throw Exception('Failed to load NewOrderListRepository data: response is null');
      }
    } catch (e) {
      print('Error fetching NewOrderListRepository data: $e');
      rethrow;
    }
  }

  Future<dynamic> updateStatusApi(var data,String orderId) async {
    try {
      dynamic response =
      await _apiService.patchApiWithToken(data, '${AppUrl.updateStatus}/${orderId}');
      return response;
    } catch (e) {
      throw e;
    }
  }
}