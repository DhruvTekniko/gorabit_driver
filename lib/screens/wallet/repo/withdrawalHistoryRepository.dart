import 'package:gorabbit_driver/core/app_url.dart';
import 'package:gorabbit_driver/core/network_api_service.dart';
import 'package:gorabbit_driver/screens/wallet/model/withdrawalHistoryModel.dart';

class WithdrawalHistoryRepository{
  final _apiService = NetworkApiServices();

  Future<WithdrawalRequestModel> getWithdrawalWalletHistoryApi() async {
    try {
      final response = await _apiService.getApiWithToken(AppUrl.postWalletRequest);
      print('dvdv: $response');

      if (response != null) {
        return WithdrawalRequestModel.fromJson(response);
      } else {
        throw Exception('Failed to load WithdrawalRequestModel data: response is null');
      }
    } catch (e) {
      print('Error fetching WithdrawalRequestModel data: $e');
      rethrow;
    }
  }
}