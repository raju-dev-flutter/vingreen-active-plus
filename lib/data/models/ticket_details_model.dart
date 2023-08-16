class TicketDetailsModel {
  String? apiSuccess;
  int? ticketId;
  String? clientId;
  String? customerContactId;
  String? subject;
  String? description;
  String? ticketTypeId;
  String? priorityId;
  String? sourceId;
  String? statusId;
  String? assignTo;
  String? ticketCreatedTypeId;
  String? createdBy;
  String? createdAt;
  String? updatedBy;
  String? updatedAt;
  List<TicketAttachments>? ticketAttachments;
  List<TicketStatus>? ticketStatusDetails;

  TicketDetailsModel(
      {this.apiSuccess,
      this.ticketId,
      this.clientId,
      this.customerContactId,
      this.subject,
      this.description,
      this.ticketTypeId,
      this.priorityId,
      this.sourceId,
      this.statusId,
      this.assignTo,
      this.ticketCreatedTypeId,
      this.createdBy,
      this.createdAt,
      this.updatedBy,
      this.updatedAt,
      this.ticketAttachments,
      this.ticketStatusDetails});

  TicketDetailsModel.fromJson(Map<String, dynamic> json) {
    apiSuccess = json['api_success'];
    ticketId = json['ticket_id'];
    clientId = json['client_id'];
    customerContactId = json['customer_contact_id'];
    subject = json['subject'];
    description = json['description'];
    ticketTypeId = json['ticket_type_id'];
    priorityId = json['priority_id'];
    sourceId = json['source_id'];
    statusId = json['status_id'];
    assignTo = json['assign_to'];
    ticketCreatedTypeId = json['ticket_created_type_id'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedBy = json['updated_by'];
    updatedAt = json['updated_at'];
    if (json['ticket_attachments'] != null) {
      ticketAttachments = <TicketAttachments>[];
      json['ticket_attachments'].forEach((v) {
        ticketAttachments!.add(TicketAttachments.fromJson(v));
      });
    }
    if (json['ticket_status_details'] != null) {
      ticketStatusDetails = <TicketStatus>[];
      json['ticket_status_details'].forEach((v) {
        ticketStatusDetails!.add(TicketStatus.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['api_success'] = apiSuccess;
    data['ticket_id'] = ticketId;
    data['client_id'] = clientId;
    data['customer_contact_id'] = customerContactId;
    data['subject'] = subject;
    data['description'] = description;
    data['ticket_type_id'] = ticketTypeId;
    data['priority_id'] = priorityId;
    data['source_id'] = sourceId;
    data['status_id'] = statusId;
    data['assign_to'] = assignTo;
    data['ticket_created_type_id'] = ticketCreatedTypeId;
    data['created_by'] = createdBy;
    data['created_at'] = createdAt;
    data['updated_by'] = updatedBy;
    data['updated_at'] = updatedAt;
    if (ticketAttachments != null) {
      data['ticket_attachments'] =
          ticketAttachments!.map((v) => v.toJson()).toList();
    }
    if (ticketStatusDetails != null) {
      data['ticket_status_details'] =
          ticketStatusDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TicketAttachments {
  String? attachment;

  TicketAttachments({this.attachment});

  TicketAttachments.fromJson(Map<String, dynamic> json) {
    attachment = json['attachment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['attachment'] = attachment;
    return data;
  }
}

class TicketStatus {
  int? id;
  String? name;

  TicketStatus({this.id, this.name});

  TicketStatus.fromJson(Map<String, dynamic> json) {
    id = json['ticket_status_id'];
    name = json['ticket_status_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ticket_status_id'] = id;
    data['ticket_status_name'] = name;
    return data;
  }
}
