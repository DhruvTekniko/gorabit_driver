import 'package:flutter/material.dart';
import 'package:gorabbit_driver/screens/orderHistory/model/orderHistory_model.dart';
import 'package:gorabbit_driver/screens/orderHistory/repository/orderHistory_repository.dart';

class OrderHistoryListViewModel extends ChangeNotifier {
  final OrderHistoryListRepository _repository = OrderHistoryListRepository();

  HistoryOrderList? OrderHistoryList;
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchOrderHistorys() async {
    isLoading = true;
    notifyListeners();

    try {
      OrderHistoryList = await _repository.getOrderHistoryListApi();
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
      OrderHistoryList = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
