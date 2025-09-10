
import 'dart:io';

abstract class BaseApiServices {

  Future<dynamic> getApi(String url) ;

  Future<dynamic> getApiWithToken(String url) ;


  Future<dynamic> postApi(dynamic data, String url) ;

  Future<dynamic> postApiWithToken(dynamic data, String url) ;


  Future<dynamic> multipartApi({Map<String,String>  data, String url,File profileImg}) ;

  Future<dynamic> multipartApiForPanAndAadhaar(
      {Map<String,String>  data,
        String url,
        File profileImg,
        File aadhaarFile,
        File panImage,
      }) ;


  Future<dynamic> multipartWithOnlyImageApi(String url,File profileImg) ;

  Future<dynamic> deleteApiWithToken(String url) ;

  Future<dynamic> patchApiWithToken(dynamic data,String url) ;





}