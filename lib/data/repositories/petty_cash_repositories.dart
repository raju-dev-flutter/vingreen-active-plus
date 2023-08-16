import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/pettycash_model.dart';
import '../services/base_api_service.dart';
import '../services/network_api_service.dart';
import '../services/url.dart';

class PettyCashRepositories {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> fetchPettyCashDetailsApi(dynamic data) async {
    try {
      dynamic response = await _apiServices
          .getGetApiResponse('${AppUrl.pettyCashListEndPoint}?id=$data');
      final jsonData = Pettycash.fromJson(response);
      List<ExpenseList> expenseList = jsonData.expenseList!;
      return expenseList;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> fetchPettyCashUserListApi(dynamic data) async {
    try {
      dynamic response = await _apiServices
          .getGetApiResponse('${AppUrl.pettyCashListEndPoint}?id=$data');

      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> fetchPettyCashSubmitApi(
      Map<String, String> data, List<XFile> attachment) async {
    try {
      dynamic response = await _apiServices.getListofXFilePostApiResponse(
          AppUrl.pettyCashSubmitEndPoint, data, attachment);
      debugPrint(response);
      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> fetchPettyCashDeleteApi(dynamic data) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(
          AppUrl.pettyCashDeleteEndPoint, data);
      debugPrint(response);
      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
