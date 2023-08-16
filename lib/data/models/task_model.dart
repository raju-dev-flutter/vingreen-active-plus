class TaskModel {
  String? apiSuccess;
  List<TaskList>? taskList;
  List<StatusList>? statusList;

  TaskModel({this.apiSuccess, this.taskList, this.statusList});

  TaskModel.fromJson(Map<String, dynamic> json) {
    apiSuccess = json['Api_success'];
    if (json['task_list'] != null) {
      taskList = <TaskList>[];
      json['task_list'].forEach((v) {
        taskList!.add(TaskList.fromJson(v));
      });
    }
    if (json['status_list'] != null) {
      statusList = <StatusList>[];
      json['status_list'].forEach((v) {
        statusList!.add(StatusList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Api_success'] = apiSuccess;
    if (taskList != null) {
      data['task_list'] = taskList!.map((v) => v.toJson()).toList();
    }
    if (statusList != null) {
      data['status_list'] = statusList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TaskList {
  int? taskId;
  String? taskName;
  String? description;
  String? statusDescription;
  String? taskStatus;
  String? attachment;
  String? createdAt;
  String? updatedAt;
  String? clientName;
  String? projectName;
  String? assignTo;
  String? createdBy;
  String? updatedBy;
  String? statusName;

  TaskList(
      {this.taskId,
      this.taskName,
      this.description,
      this.statusDescription,
      this.taskStatus,
      this.attachment,
      this.createdAt,
      this.updatedAt,
      this.clientName,
      this.projectName,
      this.assignTo,
      this.createdBy,
      this.updatedBy,
      this.statusName});

  TaskList.fromJson(Map<String, dynamic> json) {
    taskId = json['task_id'];
    taskName = json['task_name'];
    description = json['description'];
    statusDescription = json['status_description'];
    taskStatus = json['task_status'];
    attachment = json['attachment'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    clientName = json['client_name'];
    projectName = json['project_name'];
    assignTo = json['assign_to'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    statusName = json['status_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['task_id'] = taskId;
    data['task_name'] = taskName;
    data['description'] = description;
    data['status_description'] = statusDescription;
    data['task_status'] = taskStatus;
    data['attachment'] = attachment;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['client_name'] = clientName;
    data['project_name'] = projectName;
    data['assign_to'] = assignTo;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['status_name'] = statusName;
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
