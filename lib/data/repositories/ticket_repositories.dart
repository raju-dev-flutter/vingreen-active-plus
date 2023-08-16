import 'package:flutter/material.dart';
import '../models/ticket_details_model.dart';
import '../models/ticket_model.dart';

import '../services/base_api_service.dart';
import '../services/network_api_service.dart';
import '../services/url.dart';

class TicketRepositories {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> fetchTicketsApi(dynamic data, dynamic statusId) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(
          '${AppUrl.ticketListEndPoint}?id=$data&status_id=$statusId');
      final jsonData = TicketModel.fromJson(response);
      List<Tickets> ticketsList = jsonData.tickets!;
      debugPrint('Ticket List EndPoint : ${ticketsList.length}');
      return ticketsList;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> fetchTicketDetailApi(dynamic ticketId) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(
          '${AppUrl.ticketDetailsEndPoint}?ticket_id=$ticketId');
      final jsonData = TicketDetailsModel.fromJson(response);
      return jsonData;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> fetchtcketAddApi(dynamic data) async {
    try {
      dynamic response = await _apiServices
          .getGetApiResponse('${AppUrl.ticketEditEndPoint}?user_id=$data');

      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> updateAddNewTicket(dynamic data) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(
          AppUrl.ticketSubmitEndPoint, data);

      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> fetchTicketUpdateDetailApi(dynamic ticketId) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(
          '${AppUrl.ticketDetailsEndPoint}?ticket_id=$ticketId');

      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> updateSubmitDataApi(dynamic data) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(
          AppUrl.ticketUpdateSubmitEndPoint, data);

      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> fetchTicketsFilterListApi(dynamic id,
      dynamic fromDate,
      dynamic toDate,
      List<dynamic> customerId,
      List<dynamic> priorityId) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(
          '${AppUrl
              .ticketFilterListEndPoint}?id=$id&from_date=$fromDate&to_date=$toDate&priority_id=$priorityId&client_id=$customerId');
      final jsonData = TicketModel.fromJson(response);
      List<Tickets> ticketsList = jsonData.tickets!;
      debugPrint('Ticket List EndPoint : ${ticketsList.length}');
      return ticketsList;
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
