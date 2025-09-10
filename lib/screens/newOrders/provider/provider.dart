import 'package:flutter/material.dart';
import 'package:gorabbit_driver/screens/newOrders/model/newOrderModel.dart';
import 'package:gorabbit_driver/screens/newOrders/repository/newOrder_Repository.dart';

class NewOrderViewModel extends ChangeNotifier {
  final NewOrderListRepository _repository = NewOrderListRepository();

  NewOrderList? newOrderList;
  bool isLoading = false;
  String? errorMessage;
  bool showTimer = false;

  Future<void> fetchNewOrders() async {
    isLoading = true;
    notifyListeners();

    try {
      newOrderList = await _repository.getNewOrderListApi();
      showTimer = true;
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
      newOrderList = null;
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
      newOrderList = null;
      fetchNewOrders();
      notifyListeners();
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
      newOrderList = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

