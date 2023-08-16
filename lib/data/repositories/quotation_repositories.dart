import 'package:flutter/material.dart';

import '../models/quotation_model.dart';
import '../services/base_api_service.dart';
import '../services/network_api_service.dart';
import '../services/url.dart';

class QuotationRepositories {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> fetchQuotationListApi(dynamic data) async {
    try {
      dynamic response = await _apiServices
          .getGetApiResponse('${AppUrl.quotationListEndPoint}?id=$data');
      final jsonData = QuotationModel.fromJson(response);
      List<QuotationList> quotationList = jsonData.quotationList!;
      return quotationList;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> fetchQuotationAddApi(dynamic data) async {
    try {
      dynamic response = await _apiServices
          .getGetApiResponse('${AppUrl.quotationListEndPoint}?id=$data');
      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> fetchQuotationAddSubmitApi(dynamic data) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(
          AppUrl.quotationAddSubmitEndPoint, data);
      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> fetchQuotationEditDetailApi(
      dynamic userId, dynamic quotationId) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(
          '${AppUrl.quotationEditDetailEndPoint}?quotation_id=$quotationId&user_id=$userId');

      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> fetchQuotationEditSubmitApi(dynamic data) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(
          AppUrl.quotationEditSubmitEndPoint, data);
      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
