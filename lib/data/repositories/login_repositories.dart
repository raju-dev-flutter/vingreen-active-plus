import 'package:flutter/material.dart';

import '../services/base_api_service.dart';
import '../services/network_api_service.dart';
import '../services/url.dart';

class LoginRepositories {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> loginApi(dynamic data) async {
    try {
      dynamic response =
          await _apiServices.getPostApiResponse(AppUrl.loginEndPoint, data);

      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> firebaseAppKeyApi(dynamic data) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(
          AppUrl.firebaseAppKeyEndPoint, data);

      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
