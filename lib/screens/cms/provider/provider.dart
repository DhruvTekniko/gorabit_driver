import 'package:flutter/material.dart';

import '../model/cms_model.dart';
import '../repo/repository.dart';

class CmsPageViewModel extends ChangeNotifier {
  final CmsRepository _cmsPageRepository = CmsRepository();

  CmsPageModel? CmsPage;
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchCmsPage() async {
    isLoading = true;
    notifyListeners();

    try {
      CmsPage = await _cmsPageRepository.getCmsPageApi();
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
      CmsPage = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}