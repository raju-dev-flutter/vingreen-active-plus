import 'package:flutter/material.dart';

import '../models/attendance_model.dart';
import '../models/user_detail_model.dart';
import '../services/base_api_service.dart';
import '../services/network_api_service.dart';
import '../services/url.dart';

class HomepageRepositories {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> userDetails(dynamic data) async {
    try {
      dynamic response = await _apiServices
          .getGetApiResponse('${AppUrl.userDetailsEndPoint}?id=$data');

      final jsonData = UserDetails.fromJson(response);

      return jsonData;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Future<dynamic> checkStatus(dynamic data) async {
  //   try {
  //     dynamic response = await _apiServices.getGetApiResponse(
  //         '${AppUrl.currentDayStatusEndPoint}?user_id=$data');
  //     return response;
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }

  Future<dynamic> attendanceStatus(dynamic data) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(
          '${AppUrl.attendanceStatusEndPoint}?user_id=$data');
      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> count(dynamic data) async {
    try {
      dynamic response = await _apiServices
          .getGetApiResponse('${AppUrl.countEndPoint}?id=$data');
      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> attendanceList(dynamic data) async {
    try {
      dynamic response = await _apiServices
          .getGetApiResponse('${AppUrl.attendanceListEndPoint}?user_id=$data');
      final jsonData = AttendanceModel.fromJson(response);
      List<AttendanceList> attendanceList = jsonData.attendanceList;
      return attendanceList;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> submitCheckInData(Map data) async {
    try {
      dynamic response =
          await _apiServices.getPostApiResponse(AppUrl.checkinEndPoint, data);

      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> submitCheckOutData(Map data) async {
    try {
      dynamic response =
          await _apiServices.getPostApiResponse(AppUrl.checkoutEndPoint, data);

      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
