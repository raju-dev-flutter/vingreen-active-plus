import 'package:flutter/material.dart';

import '../models/attendance_model.dart';
import '../models/user_detail_model.dart';
import '../services/base_api_service.dart';
import '../services/network_api_service.dart';
import '../services/url.dart';

class ProfileRepositories {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> fetchUserDetailsApi(dynamic data) async {
    try {
      dynamic response = await _apiServices
          .getGetApiResponse('${AppUrl.userProfileEndPoint}?id=$data');
      final jsonData = UserDetails.fromJson(response);

      debugPrint('User Details EndPoint : ${jsonData.userName}');
      return jsonData;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> fatchUploadUserDetails(dynamic data) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(
          AppUrl.userProfileUpdateEndPoint, data);

      debugPrint('User Upload Details : $response}');
      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> fatchUploadUserImage(
      Map<String, String> data, dynamic attachment) async {
    try {
      dynamic response = await _apiServices.getXFilePostApiResponse(
          AppUrl.userImageUpdateEndPoint, data, attachment);

      debugPrint('User Upload Image : $attachment}');
      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
