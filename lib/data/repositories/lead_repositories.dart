import 'package:flutter/material.dart';

import '../models/lead_edit_model.dart';
import '../models/lead_model.dart';
import '../services/base_api_service.dart';
import '../services/network_api_service.dart';
import '../services/url.dart';

class LeadRepositories {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> fetchleadListApi(dynamic data, dynamic pageKey,
      dynamic pageLimit, dynamic statusId) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(
          '${AppUrl.leadListEndPoint}?id=$data&status_id=$statusId&page=$pageKey&limit=$pageLimit');
      final jsonData = LeadModel.fromJson(response);
      List<LeadList> leadList = jsonData.leadList!;
      return leadList;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> fetchleadDetailsApi(dynamic data) async {
    try {
      dynamic response = await _apiServices
          .getGetApiResponse('${AppUrl.leadDetailsEndPoint}?id=$data');
      final jsonData = LeadDetailsModel.fromJson(response);
      LeadDetails leadDetails = jsonData.leadDetails!;
      // debugPrint('lead Details EndPoint : ${leadDetails.emailId}');
      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

//
  Future<dynamic> fetchleadEditsApi(dynamic data) async {
    try {
      dynamic response = await _apiServices
          .getGetApiResponse('${AppUrl.leadEditEndPoint}?lead_id=$data');
      // final jsonData = LeadEditModel.fromJson(response);
      // debugPrint('lead Details EndPoint : ${jsonData.apiSuccess}');
      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> fetchSubStagesApi(dynamic data) async {
    try {
      dynamic response = await _apiServices
          .getGetApiResponse('${AppUrl.subStageEndPoint}?lead_stage_id=$data');
      // debugPrint('lead Details EndPoint : ${jsonData.apiSuccess}');
      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> fetchProductApi(dynamic data) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(
          '${AppUrl.productsEndPoint}?product_category_id=$data');
      // debugPrint('lead Details EndPoint : ${jsonData.apiSuccess}');
      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

//
  Future<dynamic> fetchStateApi(dynamic data) async {
    try {
      dynamic response = await _apiServices
          .getGetApiResponse('${AppUrl.statesEndPoint}?country_id=$data');
      // debugPrint('lead Details EndPoint : ${jsonData.apiSuccess}');
      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> fetchCityApi(dynamic data) async {
    try {
      dynamic response = await _apiServices
          .getGetApiResponse('${AppUrl.citiesEndPoint}?state_id=$data');
      // debugPrint('lead Details EndPoint : ${jsonData.apiSuccess}');
      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> updateLeadData(dynamic data) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(
          AppUrl.leadUpdateEndPoint, data);

      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> fetchleadFilterListApi(
      dynamic userId, String fromDate, String toDate) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(
          '${AppUrl.leadListFilterEndPoint}?id=$userId&from_date=$fromDate&to_date=$toDate');

      final jsonData = LeadModel.fromJson(response);
      List<LeadList> leadList = jsonData.leadList!;
 
      return leadList;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> fetchCommunicationMediumApi() async {
    try {
      dynamic response = await _apiServices
          .getGetApiResponse(AppUrl.leadCommunicationMediumEndPoint);
      debugPrint('fetchCommunicationMediumApi : $response');
      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> fetchCommunicationMediumTypeApi() async {
    try {
      dynamic response = await _apiServices
          .getGetApiResponse(AppUrl.leadCommunicationTypeEndPoint);
      debugPrint('fetchCommunicationMediumTypeApi : $response');
      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

// Future<dynamic> updateLeadTimeData(dynamic data) async {
//   try {
//     dynamic response = await _apiServices.getPostApiResponse(
//         AppUrl.leadTimelineAddEndPoint, data);
//
//     return response;
//   } catch (e) {
//     debugPrint(e.toString());
//   }
// }
}
