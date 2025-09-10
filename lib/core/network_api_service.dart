import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'app_exceptions.dart';
import 'base_api_service.dart';



class NetworkApiServices extends BaseApiServices {
  @override
  Future<dynamic> getApi(String url) async {
    if (kDebugMode) {
      log("Url=>>>  $url");
    }
    dynamic responseJson;
    final response = await http.get(Uri.parse(url)).timeout(
      const Duration(seconds: 10),
    );
    responseJson = returnResponse(response);
    try {} on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }
    print(responseJson);
    return responseJson;
  }

  @override
  Future<dynamic> getApiWithToken(String url) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString("token");

    if (kDebugMode) {
      log("Url=>>>  $url");
      log("token=>>>  $token");
    }

    dynamic responseJson;
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    }).timeout(
      const Duration(seconds: 10),
    );
    responseJson = returnResponse(response);
    try {} on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }
    if (kDebugMode) {
      log("ApiResponse=>>> of $url \n $responseJson");
    }
    return responseJson;
  }

  @override
  Future<dynamic> postApi(var data, String url) async {
    if (kDebugMode) {
      log("Url=>>>  $url");
      log("Data=>>>  $data");
    }

    dynamic responseJson;
    try {
      final response = await http
          .post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(data))
          .timeout(const Duration(seconds: 15));
      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    } on TimeoutException {
      throw RequestTimeOut('');
    }

    if (kDebugMode) {
      log("ApiResponse=>>> of $url \n $responseJson");
    }
    return responseJson;
  }
  @override
  Future<dynamic> postMultipartRegisterApi({
    required String url,
    required Map<String, String> fields,
    required Map<String, File> files,
  }) async {
    if (kDebugMode) {
      log("Multipart URL => $url");
      log("Fields => $fields");
      log("Files => ${files.keys}");
    }

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers['Content-Type'] = 'multipart/form-data';

      // Add fields
      request.fields.addAll(fields);

      // Add files
      files.forEach((key, file) async {
        request.files.add(await http.MultipartFile.fromPath(key, file.path));
      });

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (kDebugMode) {
        log("Response: ${response.body}");
      }

      return returnResponse(response);
    } on SocketException {
      throw InternetException('');
    } on TimeoutException {
      throw RequestTimeOut('');
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> patchMultipartApiWithToken({
    required String url,
    required Map<String, String> fields,
    required Map<String, File> files,
  }) async {
    if (kDebugMode) {
      log("Multipart PATCH URL => $url");
      log("Fields => $fields");
      log("Files => ${files.keys}");
    }

    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");


      if (token == null || token.isEmpty) {
        throw Exception("Authentication token not found.");
      }


      var request = http.MultipartRequest('PATCH', Uri.parse(url));
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      });
      request.fields.addAll(fields);
      for (var entry in files.entries) {
        request.files.add(await http.MultipartFile.fromPath(entry.key, entry.value.path));
      }
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (kDebugMode) {
        log("PATCH Response: ${response.body}");
      }

      return returnResponse(response);
    } on SocketException {
      throw InternetException('');
    } on TimeoutException {
      throw RequestTimeOut('');
    } catch (e) {
      rethrow;
    }
  }


  @override
  Future postApiWithToken( data, String url) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString("token");

    if (kDebugMode) {
      log("body=>>>  $data");
      log("Token=>>  $token");
    }

    dynamic responseJson;
    try {
      final response = await http
          .post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: json.encode(data))
          .timeout(const Duration(seconds: 15));
      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }
    if (kDebugMode) {
      log("ApiResponse= of $url ===>>> \n $responseJson");
    }
    return responseJson;
  }



  Future<dynamic> multipartPatchApi({
    required String url,
    required  data,
    required File imageFile,
  }) async {
    var token = (await SharedPreferences.getInstance()).getString("token");

    var request = http.MultipartRequest('PATCH', Uri.parse(url));

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    });

    data.forEach((key, value) {
      request.fields[key] = value;
    });

    request.files.add(await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
    ));

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Future<dynamic> multipartApi({
    Map<String, String>? data,
    String? url,
    File? profileImg,
  }) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString("token");

    if (kDebugMode) {
      log("Url=>>>  $url");
      log("Body=>>>  $data");
      log("profileImage>>>  $profileImg");
      log("Token=>>  $token");
    }

    var headers = {'Authorization': 'Bearer $token'};

    dynamic responseJson;

    try {
      if (profileImg != null) {
        // var request = http.MultipartRequest('PATCH', Uri.parse(url!));

        var request = http.MultipartRequest('PUT', Uri.parse(url!));

        request.fields.addAll(data!);

        request.files.add(
          http.MultipartFile.fromBytes(
            "profileImage",
            profileImg.readAsBytesSync(),
            filename: profileImg.path.split('/').last,
          ),
        );

        request.headers.addAll(headers);

        var response = await request.send();
        var responded = await http.Response.fromStream(response);
        responseJson = returnResponse(responded);
      } else {
        print("with out profile image");
        var response = await http.put(
          Uri.parse(url!),
          headers: headers,
          body: data,
        );
        //  print(response.url);
        responseJson = returnResponse(response);
      }
    } on SocketException {
      // Handle network error
      // Get.to(() => const NoNetworkScreen());
    } on HttpException {
      throw Exception("Something went wrong");
    } on FormatException {
      throw Exception("Bad response format");
    }

    if (kDebugMode) {
      log("ApiResponse=>>> of $url \n $responseJson");
    }

    return responseJson;
  }


  @override
  Future<dynamic> multipartWithPrimaryApi({
    required var data,
    required String url,
    required List<String>? galleryImgs,
    required String? primaryImg,
  }) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString("token");

    // Function to validate image file extensions
    bool isValidImageFile(String filePath) {
      final allowedExtensions = ['jpg', 'jpeg', 'png'];
      final extension = filePath.split('.').last.toLowerCase();
      return allowedExtensions.contains(extension);
    }

    if (kDebugMode) {
      log("Url=>>>  $url");
      log("Body=>>>  $data");
      log("galleryImage>>>  $galleryImgs");
      log("primaryImage>>>  $primaryImg");
      log("Token=>>  $token");
    }

    // Prepare headers for the request
    var headers = {'Authorization': 'Bearer $token'};

    // Create a multipart request
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(headers);

    // Add regular data fields
    request.fields.addAll(data);

    // Add primary image if available and valid
    if (primaryImg != null && isValidImageFile(primaryImg)) {
      try {
        request.files.add(
          await http.MultipartFile.fromPath(
            'primary_image',
            primaryImg,
            filename: primaryImg.split('/').last,
          ),
        );
      } catch (e) {
        log("Error adding primary image: $e");
      }
    } else if (primaryImg != null) {
      log("Invalid primary image file type");
    }

    // Add gallery images if any are available and valid
    if (galleryImgs != null && galleryImgs.isNotEmpty) {
      for (var galleryImg in galleryImgs) {
        if (isValidImageFile(galleryImg)) {
          try {
            request.files.add(
              await http.MultipartFile.fromPath(
                'gallery_image',
                galleryImg,
                filename: galleryImg.split('/').last,
              ),
            );
          } catch (e) {
            log("Error adding gallery image: $e");
          }
        } else {
          log("Invalid gallery image file type: $galleryImg");
        }
      }
    }

    // Send the request and handle the response
    try {
      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);

      if (kDebugMode) {
        log("ApiResponse=>>> of $url \n ${responseBody.body}");
      }

      return returnResponse(responseBody);
    } on SocketException {
      log("No network connection.");
      // Handle no network case (show a screen or alert the user)
    } on HttpException catch (e) {
      log("HttpException occurred: $e");
      throw Exception("Something went wrong: $e");
    } on FormatException catch (e) {
      log("FormatException occurred: $e");
      throw Exception("Bad response format: $e");
    } catch (e) {
      log("Unexpected error occurred: $e");
      throw Exception("An unexpected error occurred: $e");
    }
  }


  @override
  Future<dynamic> multipartWithAddShop({
    required var data,
    required String url,
    required List<String>? galleryImgs,
    required List<String>? menuImgs,
    required String? primaryImg,
  }) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString("token");

    // Function to validate image file extensions
    bool isValidImageFile(String filePath) {
      final allowedExtensions = ['jpg', 'jpeg', 'png'];
      final extension = filePath.split('.').last.toLowerCase();
      return allowedExtensions.contains(extension);
    }

    if (kDebugMode) {
      log("Url=>>>  $url");
      log("Body=>>>  $data");
      log("galleryImage>>>  $galleryImgs");
      log("menuImage>>>  $menuImgs");
      log("primaryImage>>>  $primaryImg");
      log("Token=>>  $token");
    }

    // Prepare headers for the request
    var headers = {'Authorization': 'Bearer $token'};

    // Create a multipart request
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(headers);

    // Add regular data fields
    request.fields.addAll(data);

    // Add primary image if available and valid
    if (primaryImg != null && isValidImageFile(primaryImg)) {
      try {
        request.files.add(
          await http.MultipartFile.fromPath(
            'shopImage',
            primaryImg,
            filename: primaryImg.split('/').last,
          ),
        );
      } catch (e) {
        log("Error adding primary image: $e");
      }
    } else if (primaryImg != null) {
      log("Invalid primary image file type");
    }

    // Add gallery images if any are available and valid
    if (galleryImgs != null && galleryImgs.isNotEmpty) {
      for (var galleryImg in galleryImgs) {
        if (isValidImageFile(galleryImg)) {
          try {
            request.files.add(
              await http.MultipartFile.fromPath(
                'galleryImage',
                galleryImg,
                filename: galleryImg.split('/').last,
              ),
            );
          } catch (e) {
            log("Error adding gallery image: $e");
          }
        } else {
          log("Invalid gallery image file type: $galleryImg");
        }
      }
    }
    // Add gallery images if any are available and valid
    if (menuImgs != null && menuImgs.isNotEmpty) {
      for (var menuImg in menuImgs) {
        if (isValidImageFile(menuImg)) {
          try {
            request.files.add(
              await http.MultipartFile.fromPath(
                'menu',
                menuImg,
                filename: menuImg.split('/').last,
              ),
            );
          } catch (e) {
            log("Error adding menu image: $e");
          }
        } else {
          log("Invalid gallery image file type: $menuImg");
        }
      }
    }

    // Send the request and handle the response
    try {
      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);

      if (kDebugMode) {
        log("ApiResponse=>>> of $url \n ${responseBody.body}");
      }

      return returnResponse(responseBody);
    } on SocketException {
      log("No network connection.");
      // Handle no network case (show a screen or alert the user)
    } on HttpException catch (e) {
      log("HttpException occurred: $e");
      throw Exception("Something went wrong: $e");
    } on FormatException catch (e) {
      log("FormatException occurred: $e");
      throw Exception("Bad response format: $e");
    } catch (e) {
      log("Unexpected error occurred: $e");
      throw Exception("An unexpected error occurred: $e");
    }
  }






  @override
  Future<dynamic> multipartOnlyImage({
    Map<String, String>? data,
    String? url,
    File? profileImg,
  }) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString("token");

    if (kDebugMode) {
      log("Url=>>>  $url");
      //log("Body=>>>  $data");
      log("profileImage>>>  $profileImg");
      log("Token=>>  $token");
    }

    var headers = {'Authorization': 'Bearer $token'};

    dynamic responseJson;

    try {
      if (profileImg != null) {
        // var request = http.MultipartRequest('PATCH', Uri.parse(url!));

        var request = http.MultipartRequest('PUT', Uri.parse(url!));

        //    request.fields.addAll(data!);

        request.files.add(
          http.MultipartFile.fromBytes(
            "profile_image",
            profileImg.readAsBytesSync(),
            filename: profileImg.path.split('/').last,
          ),
        );

        request.headers.addAll(headers);

        var response = await request.send();
        var responded = await http.Response.fromStream(response);
        responseJson = returnResponse(responded);
      } else {
        print("with out profile image");
        var response = await http.put(
          Uri.parse(url!),
          headers: headers,
          // body: data,
        );

        responseJson = returnResponse(response);
      }
    } on SocketException {
      // Handle network error
      // Get.to(() => const NoNetworkScreen());
    } on HttpException {
      throw Exception("Something went wrong");
    } on FormatException {
      throw Exception("Bad response format");
    }

    if (kDebugMode) {
      log("ApiResponse=>>> of $url \n $responseJson");
    }

    return responseJson;
  }

  @override
  Future<dynamic> multipartWithOnlyImageApi(String url, File profileImg) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString("token");
    if (kDebugMode) {
      log("Url=>>>  $url");
      log("profileImage>>>  $profileImg");
      log("Token=>>  $token");
    }

    var headers = {'Authorization': 'Bearer $token'};

    dynamic responseJson;

    var request = await http.MultipartRequest(
      'POST',
      Uri.parse(url),
    );

    request.files.add(http.MultipartFile.fromBytes(
        "profileImage", profileImg.readAsBytesSync(),
        filename: profileImg.path.toString().split('/').last));

    request.headers.addAll(headers);
    //  http.StreamedResponse response = await request.send();

    try {
      var response = await request.send();
      var responded = await http.Response.fromStream(response);
      responseJson = returnResponse(responded);
    } on SocketException {
      //Get.to(() => const NoNetworkScreen());
    } on HttpException {
      throw Exception("Something went wrong");
    } on FormatException {
      throw Exception("Bad response format");
    }

    if (kDebugMode) {
      log("ApiResponse=>>> of $url \n $responseJson");
    }
    return responseJson;
  }

  @override
  Future<dynamic> deleteApiWithToken(String url) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString("token");
    // var token="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY1OGVhOTU2NzdlZDZkMzIyYWY1ZTNlMiIsInBob25lIjoiNjM5NjkxNzc2OSIsImlhdCI6MTcwNTQ2ODgwN30._Na_Kvu-QzFfzpAZBJipjeb7HEhbVuvfafm2dRnrgmI";

    if (kDebugMode) {
      log("Url=>>>  $url");
      // log("Data=>>>  $WebServices");
      log("Token=>>  $token");
    }

    dynamic responseJson;
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        // body: json.encode(WebServices),
      ).timeout(const Duration(seconds: 15));
      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }
    if (kDebugMode) {
      log("ApiResponse=>>> of $url \n $responseJson");
    }
    return responseJson;
  }

  @override
  Future patchApiWithToken(data, String url) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString("token");

    if (kDebugMode) {
      log("Url=>>>  $url");
      log("body=>>>  $data");
      log("Token=>>  $token");
    }

    dynamic responseJson;
    try {
      final response = await http
          .patch(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: json.encode(data))
          .timeout(const Duration(seconds: 15));
      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException('');
    } on RequestTimeOut {
      throw RequestTimeOut('');
    }
    if (kDebugMode) {
      log("ApiResponse=>>> of $url \n $responseJson");
    }
    return responseJson;
  }

  @override
  Future<dynamic> multipartApiForPanAndAadhaar({
    Map<String, String>? data,
    String? url,
    File? profileImg,
    File? aadhaarFile,
    File? panImage,
  }) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString("token");

    if (kDebugMode) {
      log("Url=>>>  $url");
      log("body=>>>  $data");
      log("profileImage>>>  $profileImg");
      log("aadhaarFile>>>  $aadhaarFile");
      log("panImage>>>  $panImage");
      log("Token=>>  $token");
    }

    var headers = {'Authorization': 'Bearer $token'};
    dynamic responseJson;

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url!));

      // Add fields if provided
      if (data != null) {
        request.fields.addAll(data);
      }

      // Add files if provided
      if (profileImg != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            "photo",
            await profileImg.readAsBytes(),
            filename: profileImg.path.split('/').last,
          ),
        );
      }
      if (aadhaarFile != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            "aadharcard_photo",
            await aadhaarFile.readAsBytes(),
            filename: aadhaarFile.path.split('/').last,
          ),
        );
      }
      if (panImage != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            "pancard_photo",
            await panImage.readAsBytes(),
            filename: panImage.path.split('/').last,
          ),
        );
      }

      request.headers.addAll(headers);

      var response = await request.send();
      var responded = await http.Response.fromStream(response);
      responseJson = returnResponse(responded);
    } on SocketException {
      // Handle network error
      // Get.to(() => const NoNetworkScreen());
      throw Exception("No Internet Connection");
    } on HttpException {
      throw Exception("Something went wrong");
    } on FormatException {
      throw Exception("Bad response format");
    }

    if (kDebugMode) {
      log("ApiResponse=>>> of $url \n $responseJson");
    }

    return responseJson;
  }
}

dynamic returnResponse(http.Response response) {
  switch (response.statusCode) {
    case 201:
      dynamic responseJson = jsonDecode(response.body);
      return responseJson;
    case 200:
      dynamic responseJson = jsonDecode(response.body);
      return responseJson;
    case 400:
      dynamic responseJson = jsonDecode(response.body);
      return responseJson;
    case 401:
      dynamic responseJson = jsonDecode(response.body);
      return responseJson;
    case 500:
      dynamic responseJson = jsonDecode(response.body);
      return responseJson;
    case 501:
      dynamic responseJson = jsonDecode(response.body);
      return responseJson;

    case 403:
      dynamic responseJson = jsonDecode(response.body);
      return responseJson;
    case 404:
      dynamic responseJson = jsonDecode(response.body);
      return responseJson;

    default:
      throw FetchDataException(
          'Error accoured while communicating with server ' +
              response.statusCode.toString());
  }
}

Future<String> convertImageToBase64(File imageFile) async {
  List<int> imageBytes = await imageFile.readAsBytes();
  return base64Encode(imageBytes);
}
