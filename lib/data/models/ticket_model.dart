class TicketModel {
  String? apiSuccess;
  List<Tickets>? tickets;
  List<UserLists>? userLists;
  List<TicketStatusDetails>? ticketStatusDetails;

  TicketModel(
      {this.apiSuccess,
      this.tickets,
      this.userLists,
      this.ticketStatusDetails});

  TicketModel.fromJson(Map<String, dynamic> json) {
    apiSuccess = json['Api_success'];
    if (json['tickets'] != null) {
      tickets = <Tickets>[];
      json['tickets'].forEach((v) {
        tickets!.add(Tickets.fromJson(v));
      });
    }
    if (json['user_lists'] != null) {
      userLists = <UserLists>[];
      json['user_lists'].forEach((v) {
        userLists!.add(UserLists.fromJson(v));
      });
    }
    if (json['ticket_status_details'] != null) {
      ticketStatusDetails = <TicketStatusDetails>[];
      json['ticket_status_details'].forEach((v) {
        ticketStatusDetails!.add(TicketStatusDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Api_success'] = apiSuccess;
    if (tickets != null) {
      data['tickets'] = tickets!.map((v) => v.toJson()).toList();
    }
    if (userLists != null) {
      data['user_lists'] = userLists!.map((v) => v.toJson()).toList();
    }
    if (ticketStatusDetails != null) {
      data['ticket_status_details'] =
          ticketStatusDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tickets {
  int? ticketId;
  String? clientName;
  String? firstName;
  String? ticketTypeName;
  String? priorityName;
  String? createdAt;
  String? assignTo;
  String? subject;
  String? description;
  String? ticketStatusName;
  String? ticketUpdate;
  String? ticketCreatedTypeName;
  String? createdBy;
  String? ticketSourceName;
  int? updatedTypeId;
  String? updatedBy;
  String? customFields;
  String? deleted;
  String? deletedReason;

  Tickets(
      {this.ticketId,
      this.clientName,
      this.firstName,
      this.ticketTypeName,
      this.priorityName,
      this.createdAt,
      this.assignTo,
      this.subject,
      this.description,
      this.ticketStatusName,
      this.ticketUpdate,
      this.ticketCreatedTypeName,
      this.createdBy,
      this.ticketSourceName,
      this.updatedTypeId,
      this.updatedBy,
      this.customFields,
      this.deleted,
      this.deletedReason});

  Tickets.fromJson(Map<String, dynamic> json) {
    ticketId = json['ticket_id'];
    clientName = json['client_name'];
    firstName = json['first_name'];
    ticketTypeName = json['ticket_type_name'];
    priorityName = json['priority_name'];
    createdAt = json['created_at'];
    assignTo = json['assign_to'];
    subject = json['subject'];
    description = json['description'];
    ticketStatusName = json['ticket_status_name'];
    ticketUpdate = json['ticket_update'];
    ticketCreatedTypeName = json['ticket_created_type_name'];
    createdBy = json['created_by'];
    ticketSourceName = json['ticket_source_name'];
    updatedTypeId = json['updated_type_id'];
    updatedBy = json['updated_by'];
    customFields = json['custom_fields'];
    deleted = json['deleted'];
    deletedReason = json['deleted_reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ticket_id'] = ticketId;
    data['client_name'] = clientName;
    data['first_name'] = firstName;
    data['ticket_type_name'] = ticketTypeName;
    data['priority_name'] = priorityName;
    data['created_at'] = createdAt;
    data['assign_to'] = assignTo;
    data['subject'] = subject;
    data['description'] = description;
    data['ticket_status_name'] = ticketStatusName;
    data['ticket_update'] = ticketUpdate;
    data['ticket_created_type_name'] = ticketCreatedTypeName;
    data['created_by'] = createdBy;
    data['ticket_source_name'] = ticketSourceName;
    data['updated_type_id'] = updatedTypeId;
    data['updated_by'] = updatedBy;
    data['custom_fields'] = customFields;
    data['deleted'] = deleted;
    data['deleted_reason'] = deletedReason;
    return data;
  }
}

class UserLists {
  int? id;
  String? firstName;

  UserLists({this.id, this.firstName});

  UserLists.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    return data;
  }
}

class TicketStatusDetails {
  int? ticketStatusId;
  String? ticketStatusName;

  TicketStatusDetails({this.ticketStatusId, this.ticketStatusName});

  TicketStatusDetails.fromJson(Map<String, dynamic> json) {
    ticketStatusId = json['ticket_status_id'];
    ticketStatusName = json['ticket_status_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ticket_status_id'] = ticketStatusId;
    data['ticket_status_name'] = ticketStatusName;
    return data;
  }
}
