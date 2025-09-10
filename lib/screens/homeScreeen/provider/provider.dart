import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:gorabbit_driver/screens/homeScreeen/model/home_model.dart';
import 'package:gorabbit_driver/screens/homeScreeen/repo/home_repository.dart';


class EarningsViewModel extends ChangeNotifier {
  final HomeRepository _repository = HomeRepository();
  HomeStatsModel? homeStatsModel;
  bool isLoading = false;
  String? errorMessage;
  Future<void> fetchHomeData() async {
    isLoading = true;
    notifyListeners();

    try {
      homeStatsModel = await _repository.getHomeDataApi();
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
      homeStatsModel = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
