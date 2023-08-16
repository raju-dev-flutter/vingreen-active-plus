import 'package:flutter/material.dart';

import '../models/task_detail_model.dart';
import '../models/task_model.dart';
import '../services/base_api_service.dart';
import '../services/network_api_service.dart';
import '../services/url.dart';

class TaskRepositories {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> fetchTaskListApi(dynamic data, dynamic statusId) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(
          '${AppUrl.taskListEndPoint}?id=$data&status_id=$statusId');
      final jsonData = TaskModel.fromJson(response);
      List<TaskList> taskList = jsonData.taskList!;
      debugPrint('Ticket List EndPoint : ${taskList.length}');
      return taskList;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> fetchTaskDetailApi(dynamic data) async {
    try {
      dynamic response = await _apiServices
          .getGetApiResponse('${AppUrl.taskDetailsEndPoint}?task_id=$data');
      final jsonData = TaskDetailModel.fromJson(response);
      return jsonData;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> fetchTaskUpdateApi(dynamic data) async {
    try {
      dynamic response = await _apiServices
          .getGetApiResponse('${AppUrl.taskEditEndPoint}?task_id=$data');

      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> fetchTaskUpdateSubmitApi(dynamic data) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(
          AppUrl.taskSubmitEndPoint, data);

      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> fetchCreateNewTaskApi(dynamic data) async {
    try {
      dynamic response = await _apiServices
          .getGetApiResponse('${AppUrl.addNewTaskEndPoint}?user_id=$data');

      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> fetchCreateNewTaskSubmitApi(dynamic data) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(
          AppUrl.addNewTaskSubmitEndPoint, data);

      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> fetchTaskFilterListApi(dynamic data, String fromDate,
      String toDate, List<dynamic> clientId, List<dynamic> priorityId) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(
          '${AppUrl.taskListFilterEndPoint}?id=$data&from_date=$fromDate&to_date=$toDate&customer_id=$clientId&priority_id=$priorityId');
      final jsonData = TaskModel.fromJson(response);
      List<TaskList> taskList = jsonData.taskList!;
      debugPrint('Task List EndPoint : ${taskList.length}');
      return taskList;
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
