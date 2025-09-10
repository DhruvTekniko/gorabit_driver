import 'package:gorabbit_driver/core/app_url.dart';
import 'package:gorabbit_driver/core/network_api_service.dart';
import 'package:gorabbit_driver/screens/wallet/model/walletModel.dart';

class WalletRepository{
  final _apiService = NetworkApiServices();

  Future<WalletModel> getWalletDetailsApi() async {
    try {
      final response = await _apiService.getApiWithToken(AppUrl.getWallet);
      print('dvdv: $response');

      if (response != null) {
        return WalletModel.fromJson(response);
      } else {
        throw Exception('Failed to load WalletModel data: response is null');
      }
    } catch (e) {
      print('Error fetching WalletModel data: $e');
      rethrow;
    }
  }

  Future<bool> postWalletRequestApi({
    required String amount_requested,
    required String message,
  }) async {
    try {
      final body = {
        "amount_requested": amount_requested,
        "message": message,
      };

      final response = await _apiService.postApiWithToken(
        body,
        AppUrl.postWalletRequest,
      );

      print('Add wallet request Response: $response');

      if (response != null && response['status'] == 'success') {
        // Successful request
        return true;
      } else {
        // API responded but with failure
        throw Exception(response['message'] ?? 'Failed to add wallet request');
      }
    } catch (e) {
      print('Error Add wallet: $e');
      rethrow; // Let ViewModel handle this
    }
  }

}