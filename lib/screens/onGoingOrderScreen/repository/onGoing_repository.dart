import 'package:gorabbit_driver/core/app_url.dart';
import 'package:gorabbit_driver/core/network_api_service.dart';
import 'package:gorabbit_driver/screens/onGoingOrderScreen/model/ongoingOrderModel.dart';

class OnGoingOrderListRepository {
  final _apiService = NetworkApiServices();

  Future<OnGoingOrderList> getOnGoingOrderListApi() async {
    try {
      final response = await _apiService.getApiWithToken('${AppUrl.getOnGoingOrder}');
      print('dvdv: $response');

      if (response != null) {
        return OnGoingOrderList.fromJson(response);
      } else {
        throw Exception('Failed to load OnGoingOrderListRepository data: response is null');
      }
    } catch (e) {
      print('Error fetching OnGoingOrderListRepository data: $e');
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