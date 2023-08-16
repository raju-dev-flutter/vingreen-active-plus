class CreateNewTaskModel {
  List<CommonList>? clientDetails;
  List<CommonList>? projectDetails;
  List<CommonList>? statusDetails;
  List<CommonList>? taskPriorityDetails;
  List<CommonList>? userDetails;

  CreateNewTaskModel(
      {this.clientDetails,
      this.projectDetails,
      this.statusDetails,
      this.taskPriorityDetails,
      this.userDetails});

  CreateNewTaskModel.fromJson(Map<String, dynamic> json) {
    if (json['client_details'] != null) {
      clientDetails = <CommonList>[];
      json['client_details'].forEach((v) {
        clientDetails!.add(CommonList.fromJson(v));
      });
    }
    if (json['project_details'] != null) {
      projectDetails = <CommonList>[];
      json['project_details'].forEach((v) {
        projectDetails!.add(CommonList.fromJson(v));
      });
    }
    if (json['status_details'] != null) {
      statusDetails = <CommonList>[];
      json['status_details'].forEach((v) {
        statusDetails!.add(CommonList.fromJson(v));
      });
    }
    if (json['task_priority_details'] != null) {
      taskPriorityDetails = <CommonList>[];
      json['task_priority_details'].forEach((v) {
        taskPriorityDetails!.add(CommonList.fromJson(v));
      });
    }
    if (json['user_details'] != null) {
      userDetails = <CommonList>[];
      json['user_details'].forEach((v) {
        userDetails!.add(CommonList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (clientDetails != null) {
      data['client_details'] = clientDetails!.map((v) => v.toJson()).toList();
    }
    if (projectDetails != null) {
      data['project_details'] = projectDetails!.map((v) => v.toJson()).toList();
    }
    if (statusDetails != null) {
      data['status_details'] = statusDetails!.map((v) => v.toJson()).toList();
    }
    if (taskPriorityDetails != null) {
      data['task_priority_details'] =
          taskPriorityDetails!.map((v) => v.toJson()).toList();
    }
    if (userDetails != null) {
      data['user_details'] = userDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommonList {
  int? id;
  String? name;

  CommonList({this.id, this.name});

  CommonList.fromJson(Map<String, dynamic> json) {
    if (json['client_name'] != null) {
      id = json['client_id'];
      name = json['client_name'];
    }
    if (json['project_name'] != null) {
      id = json['project_id'];
      name = json['project_name'];
    }
    if (json['status_name'] != null) {
      id = json['status_id'];
      name = json['status_name'];
    }
    if (json['priority_name'] != null) {
      id = json['priority_id'];
      name = json['priority_name'];
    }
    if (json['first_name'] != null) {
      id = json['id'];
      name = json['first_name'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
