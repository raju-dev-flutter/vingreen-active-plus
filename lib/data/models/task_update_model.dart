import 'dart:convert';

import 'package:flutter/src/material/list_tile.dart';

TaskUpdate editTaskFromJson(String str) =>
    TaskUpdate.fromJson(json.decode(str));

String editTaskToJson(TaskUpdate data) => json.encode(data.toJson());

class TaskUpdate {
  TaskUpdate({
    this.apiSuccess,
    this.apiMessage,
    this.taskId,
    this.clientName,
    this.projectName,
    this.description,
    this.taskName,
    this.assignTo,
    this.statusDescription,
    this.attachment,
    this.createdBy,
    this.createdTime,
    this.updatedBy,
    this.updatedDate,
    this.updatedTime,
    this.updatedAt,
    this.taskStatusName,
    this.taskStatus,
    required this.statusList,
  });

  String? apiSuccess;
  String? apiMessage;
  int? taskId;
  String? clientName;
  String? projectName;
  String? description;
  String? taskName;
  String? assignTo;
  String? statusDescription;
  dynamic attachment;
  String? createdBy;
  String? createdTime;
  String? updatedBy;
  String? updatedDate;
  String? updatedTime;
  String? updatedAt;
  String? taskStatusName;
  String? taskStatus;
  List<StatusList> statusList;

  factory TaskUpdate.fromJson(Map<String, dynamic> json) => TaskUpdate(
        apiSuccess: json["api_success"],
        apiMessage: json["api_message"],
        taskId: json["task_id"],
        clientName: json["client_name"],
        projectName: json["project_name"],
        description: json["description"],
        taskName: json["task_name"],
        assignTo: json["assign_to"],
        statusDescription: json["status_description"],
        attachment: json["attachment"],
        createdBy: json["created_by"],
        createdTime: json["created_time"],
        updatedBy: json["updated_by"],
        updatedDate: json["updated_date"],
        updatedTime: json["updated_time"],
        updatedAt: json["updated_at"],
        taskStatusName: json["task_status_name"],
        taskStatus: json["task_status"],
        statusList: List<StatusList>.from(
            json["status_list"].map((x) => StatusList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "api_success": apiSuccess,
        "api_message": apiMessage,
        "task_id": taskId,
        "client_name": clientName,
        "project_name": projectName,
        "description": description,
        "task_name": taskName,
        "assign_to": assignTo,
        "status_description": statusDescription,
        "attachment": attachment,
        "created_by": createdBy,
        "created_time": createdTime,
        "updated_by": updatedBy,
        "updated_date": updatedDate,
        "updated_time": updatedTime,
        "updated_at": updatedAt,
        "task_status_name": taskStatusName,
        "task_status": taskStatus,
        "status_list": List<dynamic>.from(statusList.map((x) => x.toJson())),
      };
}

class StatusList {
  StatusList({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory StatusList.fromJson(Map<String, dynamic> json) => StatusList(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  map(ListTile Function(dynamic e) param0) {}
}
