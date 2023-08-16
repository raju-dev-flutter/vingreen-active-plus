class LeadModel {
  String? apiSuccess;
  List<LeadList>? leadList;
  List<UserLists>? userLists;
  List<StatusDetails>? statusDetails;

  LeadModel(
      {this.apiSuccess, this.leadList, this.userLists, this.statusDetails});

  LeadModel.fromJson(Map<String, dynamic> json) {
    apiSuccess = json['Api_success'];
    if (json['lead_details'] != null) {
      leadList = <LeadList>[];
      json['lead_details'].forEach((v) {
        leadList!.add(LeadList.fromJson(v));
      });
    }
    if (json['user_lists'] != null) {
      userLists = <UserLists>[];
      json['user_lists'].forEach((v) {
        userLists!.add(UserLists.fromJson(v));
      });
    }
    if (json['status_details'] != null) {
      statusDetails = <StatusDetails>[];
      json['status_details'].forEach((v) {
        statusDetails!.add(StatusDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Api_success'] = apiSuccess;
    if (leadList != null) {
      data['lead_details'] = leadList!.map((v) => v.toJson()).toList();
    }
    if (userLists != null) {
      data['user_lists'] = userLists!.map((v) => v.toJson()).toList();
    }
    if (statusDetails != null) {
      data['status_details'] = statusDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LeadList {
  int? leadId;
  String? leadName;
  String? mobileNumber;
  String? emailId;
  String? alterEmailId;
  int? age;
  String? leadStageName;
  String? leadSubStage;
  String? mediumName;
  String? leadSourceName;
  String? leadSubSourceName;
  String? campaignName;
  String? leadOwner;
  String? adName;
  String? productCategoryName;
  String? productName;
  String? countryName;
  String? stateName;
  String? cityName;
  String? address;
  String? pincode;
  String? communicationMedium;
  String? communicationType;
  String? createdBy;
  String? createdAt;

  LeadList(
      {this.leadId,
      this.leadName,
      this.mobileNumber,
      this.emailId,
      this.alterEmailId,
      this.age,
      this.leadStageName,
      this.leadSubStage,
      this.mediumName,
      this.leadSourceName,
      this.leadSubSourceName,
      this.campaignName,
      this.leadOwner,
      this.adName,
      this.productCategoryName,
      this.productName,
      this.countryName,
      this.stateName,
      this.cityName,
      this.address,
      this.pincode,
      this.communicationMedium,
      this.communicationType,
      this.createdBy,
      this.createdAt});

  LeadList.fromJson(Map<String, dynamic> json) {
    leadId = json['lead_id'];
    leadName = json['lead_name'];
    mobileNumber = json['mobile_number'];
    emailId = json['email_id'];
    alterEmailId = json['alter_email_id'];
    age = json['age'];
    leadStageName = json['lead_stage_name'];
    leadSubStage = json['lead_sub_stage'];
    mediumName = json['medium_name'];
    leadSourceName = json['lead_source_name'];
    leadSubSourceName = json['lead_sub_source_name'];
    campaignName = json['campaign_name'];
    leadOwner = json['lead_owner'];
    adName = json['ad_name'];
    productCategoryName = json['product_category_name'];
    productName = json['product_name'];
    countryName = json['country_name'];
    stateName = json['state_name'];
    cityName = json['city_name'];
    address = json['address'];
    pincode = json['pincode'];
    communicationMedium = json['communication_medium'];
    communicationType = json['communication_type'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lead_id'] = leadId;
    data['lead_name'] = leadName;
    data['mobile_number'] = mobileNumber;
    data['email_id'] = emailId;
    data['alter_email_id'] = alterEmailId;
    data['age'] = age;
    data['lead_stage_name'] = leadStageName;
    data['lead_sub_stage'] = leadSubStage;
    data['medium_name'] = mediumName;
    data['lead_source_name'] = leadSourceName;
    data['lead_sub_source_name'] = leadSubSourceName;
    data['campaign_name'] = campaignName;
    data['lead_owner'] = leadOwner;
    data['ad_name'] = adName;
    data['product_category_name'] = productCategoryName;
    data['product_name'] = productName;
    data['country_name'] = countryName;
    data['state_name'] = stateName;
    data['city_name'] = cityName;
    data['address'] = address;
    data['pincode'] = pincode;
    data['communication_medium'] = communicationMedium;
    data['communication_type'] = communicationType;
    data['created_by'] = createdBy;
    data['created_at'] = createdAt;
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

class StatusDetails {
  int? leadStageId;
  String? leadStageName;

  StatusDetails({this.leadStageId, this.leadStageName});

  StatusDetails.fromJson(Map<String, dynamic> json) {
    leadStageId = json['lead_stage_id'];
    leadStageName = json['lead_stage_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lead_stage_id'] = leadStageId;
    data['lead_stage_name'] = leadStageName;
    return data;
  }
}

class LeadDetailsModel {
  String? apiSuccess;
  LeadDetails? leadDetails;
  List<TimelineDetails>? timelineDetails;

  LeadDetailsModel({this.apiSuccess, this.leadDetails, this.timelineDetails});

  LeadDetailsModel.fromJson(Map<String, dynamic> json) {
    apiSuccess = json['Api_success'];
    leadDetails = json['lead_details'] != null
        ? LeadDetails.fromJson(json['lead_details'])
        : null;
    if (json['timeline_details'] != null) {
      timelineDetails = <TimelineDetails>[];
      json['timeline_details'].forEach((v) {
        timelineDetails!.add(TimelineDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Api_success'] = apiSuccess;
    if (leadDetails != null) {
      data['lead_details'] = leadDetails!.toJson();
    }
    if (timelineDetails != null) {
      data['timeline_details'] =
          timelineDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LeadDetails {
  int? leadId;
  String? leadName;
  String? mobileNumber;
  String? emailId;
  String? alterEmailId;
  int? age;
  String? leadStageName;
  String? leadSubStage;
  String? mediumName;
  String? leadSourceName;
  String? leadSubSourceName;
  String? campaignName;
  String? leadOwner;
  String? adName;
  String? productCategoryName;
  String? productName;
  String? countryName;
  String? stateName;
  String? cityName;
  String? address;
  String? pincode;
  String? communicationMedium;
  String? communicationType;
  String? createdBy;
  String? createdAt;

  LeadDetails(
      {this.leadId,
      this.leadName,
      this.mobileNumber,
      this.emailId,
      this.alterEmailId,
      this.age,
      this.leadStageName,
      this.leadSubStage,
      this.mediumName,
      this.leadSourceName,
      this.leadSubSourceName,
      this.campaignName,
      this.leadOwner,
      this.adName,
      this.productCategoryName,
      this.productName,
      this.countryName,
      this.stateName,
      this.cityName,
      this.address,
      this.pincode,
      this.communicationMedium,
      this.communicationType,
      this.createdBy,
      this.createdAt});

  LeadDetails.fromJson(Map<String, dynamic> json) {
    leadId = json['lead_id'];
    leadName = json['lead_name'];
    mobileNumber = json['mobile_number'];
    emailId = json['email_id'];
    alterEmailId = json['alter_email_id'];
    age = json['age'];
    leadStageName = json['lead_stage_name'];
    leadSubStage = json['lead_sub_stage'];
    mediumName = json['medium_name'];
    leadSourceName = json['lead_source_name'];
    leadSubSourceName = json['lead_sub_source_name'];
    campaignName = json['campaign_name'];
    leadOwner = json['lead_owner'];
    adName = json['ad_name'];
    productCategoryName = json['product_category_name'];
    productName = json['product_name'];
    countryName = json['country_name'];
    stateName = json['state_name'];
    cityName = json['city_name'];
    address = json['address'];
    pincode = json['pincode'];
    communicationMedium = json['communication_medium'];
    communicationType = json['communication_type'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lead_id'] = leadId;
    data['lead_name'] = leadName;
    data['mobile_number'] = mobileNumber;
    data['email_id'] = emailId;
    data['alter_email_id'] = alterEmailId;
    data['age'] = age;
    data['lead_stage_name'] = leadStageName;
    data['lead_sub_stage'] = leadSubStage;
    data['medium_name'] = mediumName;
    data['lead_source_name'] = leadSourceName;
    data['lead_sub_source_name'] = leadSubSourceName;
    data['campaign_name'] = campaignName;
    data['lead_owner'] = leadOwner;
    data['ad_name'] = adName;
    data['product_category_name'] = productCategoryName;
    data['product_name'] = productName;
    data['country_name'] = countryName;
    data['state_name'] = stateName;
    data['city_name'] = cityName;
    data['address'] = address;
    data['pincode'] = pincode;
    data['communication_medium'] = communicationMedium;
    data['communication_type'] = communicationType;
    data['created_by'] = createdBy;
    data['created_at'] = createdAt;
    return data;
  }
}

class TimelineDetails {
  int? timelineForId;
  int? timelineId;
  String? leadStageName;
  String? leadSubStage;
  String? communicationMedium;
  String? communicationType;
  String? description;

  TimelineDetails(
      {this.timelineForId,
      this.timelineId,
      this.leadStageName,
      this.leadSubStage,
      this.communicationMedium,
      this.communicationType,
      this.description});

  TimelineDetails.fromJson(Map<String, dynamic> json) {
    timelineForId = json['timeline_for_id'];
    timelineId = json['timeline_id'];
    leadStageName = json['lead_stage_name'];
    leadSubStage = json['lead_sub_stage'];
    communicationMedium = json['communication_medium'];
    communicationType = json['communication_type'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['timeline_for_id'] = timelineForId;
    data['timeline_id'] = timelineId;
    data['lead_stage_name'] = leadStageName;
    data['lead_sub_stage'] = leadSubStage;
    data['communication_medium'] = communicationMedium;
    data['communication_type'] = communicationType;
    data['description'] = description;
    return data;
  }
}
