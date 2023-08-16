class TaskDetailModel {
  String? apiSuccess;
  String? apiMessage;
  int? taskId;
  String? clientName;
  String? projectName;
  String? description;
  String? taskName;
  String? assignTo;
  String? statusDescription;
  String? attachment;
  String? createdBy;
  String? createdDate;
  String? createdTime;
  String? updatedBy;
  String? updatedDate;
  String? updatedTime;
  String? updatedAt;
  String? taskStatusName;
  String? taskStatus;
  List<StatusList>? statusList;

  TaskDetailModel(
      {this.apiSuccess,
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
      this.createdDate,
      this.createdTime,
      this.updatedBy,
      this.updatedDate,
      this.updatedTime,
      this.updatedAt,
      this.taskStatusName,
      this.taskStatus,
      this.statusList});

  TaskDetailModel.fromJson(Map<String, dynamic> json) {
    apiSuccess = json['api_success'];
    apiMessage = json['api_message'];
    taskId = json['task_id'];
    clientName = json['client_name'];
    projectName = json['project_name'];
    description = json['description'];
    taskName = json['task_name'];
    assignTo = json['assign_to'];
    statusDescription = json['status_description'];
    attachment = json['attachment'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    createdTime = json['created_time'];
    updatedBy = json['updated_by'];
    updatedDate = json['updated_date'];
    updatedTime = json['updated_time'];
    updatedAt = json['updated_at'];
    taskStatusName = json['task_status_name'];
    taskStatus = json['task_status'];
    if (json['status_list'] != null) {
      statusList = <StatusList>[];
      json['status_list'].forEach((v) {
        statusList!.add(StatusList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['api_success'] = apiSuccess;
    data['api_message'] = apiMessage;
    data['task_id'] = taskId;
    data['client_name'] = clientName;
    data['project_name'] = projectName;
    data['description'] = description;
    data['task_name'] = taskName;
    data['assign_to'] = assignTo;
    data['status_description'] = statusDescription;
    data['attachment'] = attachment;
    data['created_by'] = createdBy;
    data['created_date'] = createdDate;
    data['created_time'] = createdTime;
    data['updated_by'] = updatedBy;
    data['updated_date'] = updatedDate;
    data['updated_time'] = updatedTime;
    data['updated_at'] = updatedAt;
    data['task_status_name'] = taskStatusName;
    data['task_status'] = taskStatus;
    if (statusList != null) {
      data['status_list'] = statusList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StatusList {
  int? id;
  String? name;

  StatusList({this.id, this.name});

  StatusList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
