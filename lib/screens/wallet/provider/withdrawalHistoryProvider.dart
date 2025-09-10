import 'package:flutter/material.dart';
import 'package:gorabbit_driver/screens/wallet/model/withdrawalHistoryModel.dart';
import 'package:gorabbit_driver/screens/wallet/repo/withdrawalHistoryRepository.dart';


class WithdrawalRequestViewModel extends ChangeNotifier {
  final WithdrawalHistoryRepository _withdrawalHistoryRepository = WithdrawalHistoryRepository();

  WithdrawalRequestModel? withdrawalRequestData;
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchWithdrawalHistory() async {
    isLoading = true;
    notifyListeners();

    try {
      withdrawalRequestData = await _withdrawalHistoryRepository.getWithdrawalWalletHistoryApi();
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
      withdrawalRequestData = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
