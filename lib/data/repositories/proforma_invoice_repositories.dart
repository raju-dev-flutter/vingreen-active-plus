import 'package:flutter/material.dart';

import '../models/proforma_invoice_model.dart';
import '../services/base_api_service.dart';
import '../services/network_api_service.dart';
import '../services/url.dart';

class ProformaInvoiceRepositories {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> fetchProformaInvoiceListApi(dynamic data) async {
    try {
      dynamic response = await _apiServices
          .getGetApiResponse('${AppUrl.proformaListEndPoint}?id=$data');
      final jsonData = ProformaInvoiceModel.fromJson(response);
      List<ProformaInvoiceList> proformaInvoiceList =
          jsonData.proformaInvoiceList!;
      return proformaInvoiceList;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> fetchProformaInvoiceAddApi(dynamic data) async {
    try {
      dynamic response = await _apiServices
          .getGetApiResponse('${AppUrl.proformaListEndPoint}?id=$data');
      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> fetchProformaInvoiceAddSubmitApi(dynamic data) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(
          AppUrl.proformaInvoiceAddSubmitEndPoint, data);
      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> fetchProformaInvoiceEditDetailApi(
      dynamic userId, dynamic proformaInvoiceId) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(
          '${AppUrl.proformaInvoiceEditEndPoint}?proforma_invoice_id=$proformaInvoiceId&user_id=$userId');

      debugPrint("================\n${response.toString()}\n================");

      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> fetchProformaInvoiceEditSubmitApi(dynamic data) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(
          AppUrl.proformaInvoiceEditSubmitEndPoint, data);
      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
