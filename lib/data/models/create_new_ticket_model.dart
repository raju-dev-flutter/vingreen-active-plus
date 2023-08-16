class CreateNewTicketModel {
  List<CommonTicketObj>? clientDetails;
  List<CommonTicketObj>? customersContactLists;
  List<CommonTicketObj>? ticketTypeDetails;
  List<CommonTicketObj>? ticketPriorityDetails;
  List<CommonTicketObj>? ticketSourceDetails;
  List<CommonTicketObj>? userDetails;
  List<CommonTicketObj>? ticketStatusDetails;
  List<CommonTicketObj>? ticketCreatedTypeDetails;

  CreateNewTicketModel(
      {this.clientDetails,
      this.customersContactLists,
      this.ticketTypeDetails,
      this.ticketPriorityDetails,
      this.ticketSourceDetails,
      this.userDetails});

  CreateNewTicketModel.fromJson(Map<String, dynamic> json) {
    if (json['client_details'] != null) {
      clientDetails = <CommonTicketObj>[];
      json['client_details'].forEach((v) {
        clientDetails!.add(CommonTicketObj.fromJson(v));
      });
    }
    if (json['customers_contact_lists'] != null) {
      customersContactLists = <CommonTicketObj>[];
      json['customers_contact_lists'].forEach((v) {
        customersContactLists!.add(CommonTicketObj.fromJson(v));
      });
    }
    if (json['ticket_type_details'] != null) {
      ticketTypeDetails = <CommonTicketObj>[];
      json['ticket_type_details'].forEach((v) {
        ticketTypeDetails!.add(CommonTicketObj.fromJson(v));
      });
    }
    if (json['ticket_priority_details'] != null) {
      ticketPriorityDetails = <CommonTicketObj>[];
      json['ticket_priority_details'].forEach((v) {
        ticketPriorityDetails!.add(CommonTicketObj.fromJson(v));
      });
    }
    if (json['ticket_source_details'] != null) {
      ticketSourceDetails = <CommonTicketObj>[];
      json['ticket_source_details'].forEach((v) {
        ticketSourceDetails!.add(CommonTicketObj.fromJson(v));
      });
    }
    if (json['user_details'] != null) {
      userDetails = <CommonTicketObj>[];
      json['user_details'].forEach((v) {
        userDetails!.add(CommonTicketObj.fromJson(v));
      });
    }
    if (json['ticket_status_details'] != null) {
      ticketStatusDetails = <CommonTicketObj>[];
      json['ticket_status_details'].forEach((v) {
        ticketStatusDetails!.add(CommonTicketObj.fromJson(v));
      });
    }
    if (json['ticket_created_type_details'] != null) {
      ticketCreatedTypeDetails = <CommonTicketObj>[];
      json['ticket_created_type_details'].forEach((v) {
        ticketCreatedTypeDetails!.add(CommonTicketObj.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (clientDetails != null) {
      data['client_details'] = clientDetails!.map((v) => v.toJson()).toList();
    }
    if (customersContactLists != null) {
      data['customers_contact_lists'] =
          customersContactLists!.map((v) => v.toJson()).toList();
    }
    if (ticketTypeDetails != null) {
      data['ticket_type_details'] =
          ticketTypeDetails!.map((v) => v.toJson()).toList();
    }
    if (ticketPriorityDetails != null) {
      data['ticket_priority_details'] =
          ticketPriorityDetails!.map((v) => v.toJson()).toList();
    }
    if (ticketSourceDetails != null) {
      data['ticket_source_details'] =
          ticketSourceDetails!.map((v) => v.toJson()).toList();
    }
    if (userDetails != null) {
      data['user_details'] = userDetails!.map((v) => v.toJson()).toList();
    }
    if (ticketStatusDetails != null) {
      data['ticket_status_details'] =
          ticketStatusDetails!.map((v) => v.toJson()).toList();
    }
    if (ticketCreatedTypeDetails != null) {
      data['ticket_created_type_details'] =
          ticketCreatedTypeDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommonTicketObj {
  int? id;
  String? name;

  CommonTicketObj({this.id, this.name});

  CommonTicketObj.fromJson(Map<String, dynamic> json) {
    if (json['client_name'] != null) {
      id = json['client_id'];
      name = json['client_name'];
    }
    if (json['first_name'] != null) {
      id = json['customer_contact_id'];
      name = json['first_name'];
    }
    if (json['ticket_type_name'] != null) {
      id = json['ticket_type_id'];
      name = json['ticket_type_name'];
    }
    if (json['priority_name'] != null) {
      id = json['priority_id'];
      name = json['priority_name'];
    }
    if (json['ticket_source_name'] != null) {
      id = json['ticket_source_id'];
      name = json['ticket_source_name'];
    }
    if (json['first_name'] != null) {
      id = json['id'];
      name = json['first_name'];
    }
    if (json['ticket_status_name'] != null) {
      id = json['ticket_status_id'];
      name = json['ticket_status_name'];
    }
    if (json['ticket_created_type_name'] != null) {
      id = json['ticket_created_type_id'];
      name = json['ticket_created_type_name'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
