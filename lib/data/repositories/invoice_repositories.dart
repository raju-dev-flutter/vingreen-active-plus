import 'package:flutter/material.dart';

import '../models/invoice_model.dart';
import '../services/base_api_service.dart';
import '../services/network_api_service.dart';
import '../services/url.dart';

class InvoiceRepositories {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> fetchInvoiceListApi(dynamic data) async {
    try {
      dynamic response = await _apiServices
          .getGetApiResponse('${AppUrl.invoiceListEndPoint}?id=$data');
      final jsonData = InvoiceModel.fromJson(response);
      List<InvoiceList> invoiceList = jsonData.invoiceList!;
      return invoiceList;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> fetchInvoiceAddApi(dynamic data) async {
    try {
      dynamic response = await _apiServices
          .getGetApiResponse('${AppUrl.invoiceListEndPoint}?id=$data');
      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> fetchInvoiceAddSubmitApi(dynamic data) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(
          AppUrl.invoiceAddSubmitEndPoint, data);
      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> fetchInvoiceEditDetailApi(
      dynamic userId, dynamic invoiceId) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(
          '${AppUrl.invoiceEditEndPoint}?invoice_id=$invoiceId&user_id=$userId');

      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> fetchInvoiceEditSubmitApi(dynamic data) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(
          AppUrl.invoiceEditSubmitEndPoint, data);
      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
