import 'package:flutter/material.dart';
import 'package:gorabbit_driver/screens/wallet/model/walletModel.dart';
import 'package:gorabbit_driver/screens/wallet/repo/walletRepository.dart';


class WalletViewModel extends ChangeNotifier {
  final WalletRepository _walletRepository = WalletRepository();

  WalletModel? walletData;
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchWallet() async {
    isLoading = true;
    notifyListeners();

    try {
      walletData = await _walletRepository.getWalletDetailsApi();
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
      walletData = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> raiseWalletRequest({
    required String amountRequested,
    required String message,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final success = await _walletRepository.postWalletRequestApi(
        amount_requested: amountRequested,
        message: message,
      );
      if (success) {
        errorMessage = null;
        await fetchWallet();
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
