import '../../../core/app_url.dart';
import '../../../core/network_api_service.dart';
import '../model/cms_model.dart';

class CmsRepository {
  final _apiService = NetworkApiServices();

  Future<CmsPageModel> getCmsPageApi() async {
    try {
      final response = await _apiService.getApiWithToken(AppUrl.cmsPages);
      print('resssposssnscee:$response');
      return CmsPageModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}