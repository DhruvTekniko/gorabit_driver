import 'package:flutter/material.dart';
import 'package:gorabbit_driver/screens/onGoingOrderScreen/model/ongoingOrderModel.dart';
import 'package:gorabbit_driver/screens/onGoingOrderScreen/repository/onGoing_repository.dart';


class OnGoingOrderViewModel extends ChangeNotifier {
  final OnGoingOrderListRepository _repository = OnGoingOrderListRepository();

  OnGoingOrderList? onGoingOrderList;
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchOnGoingOrders() async {
    isLoading = true;
    notifyListeners();

    try {
      onGoingOrderList = await _repository.getOnGoingOrderListApi();
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
      onGoingOrderList = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  Future<void> updateOrder(String updatedStatus, String orderId) async {
    isLoading = true;
    notifyListeners();

    try {
      var payload = {
        "status" : updatedStatus,
      };
      await _repository.updateStatusApi(payload, orderId);
      // onGoingOrderList = null;
      fetchOnGoingOrders();
      notifyListeners();
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
      onGoingOrderList = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}