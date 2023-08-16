class LeadEditModel {
  String? apiSuccess;
  LeadDetail? leadDetail;
  List<CommonObj>? leadStages;
  List<CommonObj>? leadSubStages;
  List<CommonObj>? leadSources;
  List<CommonObj>? leadSubSources;
  List<CommonObj>? campaigns;
  List<CommonObj>? productsCategoryList;
  List<CommonObj>? productsList;
  List<CommonObj>? adNameList;
  List<CommonObj>? mediumLists;
  List<CommonObj>? countries;
  List<CommonObj>? states;
  List<CommonObj>? cities;

  LeadEditModel({this.apiSuccess, this.leadDetail, this.leadStages});

  LeadEditModel.fromJson(Map<String, dynamic> json) {
    apiSuccess = json['Api_success'];
    leadDetail = json['lead_details'] != null
        ? LeadDetail.fromJson(json['lead_details'])
        : null;
    if (json['lead_stages'] != null) {
      leadStages = <CommonObj>[];
      json['lead_stages'].forEach((v) {
        leadStages!.add(CommonObj.fromJson(v));
      });
    }
    if (json['lead_sub_stages'] != null) {
      leadSubStages = <CommonObj>[];
      json['lead_sub_stages'].forEach((v) {
        leadSubStages!.add(CommonObj.fromJson(v));
      });
    }
    if (json['lead_sources'] != null) {
      leadSources = <CommonObj>[];
      json['lead_sources'].forEach((v) {
        leadSources!.add(CommonObj.fromJson(v));
      });
    }
    if (json['lead_sub_sources'] != null) {
      leadSubSources = <CommonObj>[];
      json['lead_sub_sources'].forEach((v) {
        leadSubSources!.add(CommonObj.fromJson(v));
      });
    }
    if (json['campaigns'] != null) {
      campaigns = <CommonObj>[];
      json['campaigns'].forEach((v) {
        campaigns!.add(CommonObj.fromJson(v));
      });
    }
    if (json['products_category_list'] != null) {
      productsCategoryList = <CommonObj>[];
      json['products_category_list'].forEach((v) {
        productsCategoryList!.add(CommonObj.fromJson(v));
      });
    }
    if (json['products_list'] != null) {
      productsList = <CommonObj>[];
      json['products_list'].forEach((v) {
        productsList!.add(CommonObj.fromJson(v));
      });
    }
    if (json['ad_name_list'] != null) {
      adNameList = <CommonObj>[];
      json['ad_name_list'].forEach((v) {
        adNameList!.add(CommonObj.fromJson(v));
      });
    }
    if (json['medium_lists'] != null) {
      mediumLists = <CommonObj>[];
      json['medium_lists'].forEach((v) {
        mediumLists!.add(CommonObj.fromJson(v));
      });
    }
    if (json['countries'] != null) {
      countries = <CommonObj>[];
      json['countries'].forEach((v) {
        countries!.add(CommonObj.fromJson(v));
      });
    }
    if (json['states'] != null) {
      states = <CommonObj>[];
      json['states'].forEach((v) {
        states!.add(CommonObj.fromJson(v));
      });
    }
    if (json['cities'] != null) {
      cities = <CommonObj>[];
      json['cities'].forEach((v) {
        cities!.add(CommonObj.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Api_success'] = apiSuccess;
    if (leadDetail != null) {
      data['lead_details'] = leadDetail!.toJson();
    }
    if (leadStages != null) {
      data['lead_stages'] = leadStages!.map((v) => v.toJson()).toList();
    }
    if (leadSubStages != null) {
      data['lead_sub_stages'] = leadSubStages!.map((v) => v.toJson()).toList();
    }
    if (leadSources != null) {
      data['lead_sources'] = leadSources!.map((v) => v.toJson()).toList();
    }
    if (leadSubSources != null) {
      data['lead_sub_sources'] =
          leadSubSources!.map((v) => v.toJson()).toList();
    }
    if (campaigns != null) {
      data['campaigns'] = campaigns!.map((v) => v.toJson()).toList();
    }
    if (productsCategoryList != null) {
      data['products_category_list'] =
          productsCategoryList!.map((v) => v.toJson()).toList();
    }
    if (productsList != null) {
      data['products_list'] = productsList!.map((v) => v.toJson()).toList();
    }
    if (adNameList != null) {
      data['ad_name_list'] = adNameList!.map((v) => v.toJson()).toList();
    }
    if (mediumLists != null) {
      data['medium_lists'] = mediumLists!.map((v) => v.toJson()).toList();
    }
    if (countries != null) {
      data['countries'] = countries!.map((v) => v.toJson()).toList();
    }
    if (states != null) {
      data['states'] = states!.map((v) => v.toJson()).toList();
    }
    if (cities != null) {
      data['cities'] = cities!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LeadDetail {
  int? leadId;
  String? leadName;
  String? mobileNumber;
  String? alterMobileNumber;
  String? emailId;
  String? alterEmailId;
  int? age;
  int? leadStageId;
  int? leadSubStageId;
  int? mediumId;
  int? sourceId;
  int? subSourceId;
  int? campaignId;
  int? leadOwner;
  int? adNameId;
  int? productCategoryId;
  int? productId;
  int? countryId;
  int? stateId;
  int? cityId;
  String? pincode;
  String? address;
  int? communicationMediumId;
  int? communicationMediumTypeId;
  String? firstActivityBy;
  String? firstActivity;
  String? firstActivityAt;
  String? lastActivityBy;
  String? lastActivity;
  String? lastActivityAt;
  String? lastComments;
  String? leadQuality;
  String? leadAge;
  String? customFields;
  String? deleted;
  String? deletedReason;
  int? createdBy;
  String? createdAt;
  int? updatedBy;
  String? updatedAt;

  LeadDetail(
      {this.leadId,
      this.leadName,
      this.mobileNumber,
      this.alterMobileNumber,
      this.emailId,
      this.alterEmailId,
      this.age,
      this.leadStageId,
      this.leadSubStageId,
      this.mediumId,
      this.sourceId,
      this.subSourceId,
      this.campaignId,
      this.leadOwner,
      this.adNameId,
      this.productCategoryId,
      this.productId,
      this.countryId,
      this.stateId,
      this.cityId,
      this.pincode,
      this.address,
      this.communicationMediumId,
      this.communicationMediumTypeId,
      this.firstActivityBy,
      this.firstActivity,
      this.firstActivityAt,
      this.lastActivityBy,
      this.lastActivity,
      this.lastActivityAt,
      this.lastComments,
      this.leadQuality,
      this.leadAge,
      this.customFields,
      this.deleted,
      this.deletedReason,
      this.createdBy,
      this.createdAt,
      this.updatedBy,
      this.updatedAt});

  LeadDetail.fromJson(Map<String, dynamic> json) {
    leadId = json['lead_id'];
    leadName = json['lead_name'];
    mobileNumber = json['mobile_number'];
    alterMobileNumber = json['alter_mobile_number'];
    emailId = json['email_id'];
    alterEmailId = json['alter_email_id'];
    age = json['age'];
    leadStageId = json['lead_stage_id'];
    leadSubStageId = json['lead_sub_stage_id'];
    mediumId = json['medium_id'];
    sourceId = json['source_id'];
    subSourceId = json['sub_source_id'];
    campaignId = json['campaign_id'];
    leadOwner = json['lead_owner'];
    adNameId = json['ad_name_id'];
    productCategoryId = json['product_category_id'];
    productId = json['product_id'];
    countryId = json['country_id'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    pincode = json['pincode'];
    address = json['address'];
    communicationMediumId = json['communication_medium_id'];
    communicationMediumTypeId = json['communication_medium_type_id'];
    firstActivityBy = json['first_activity_by'];
    firstActivity = json['first_activity'];
    firstActivityAt = json['first_activity_at'];
    lastActivityBy = json['last_activity_by'];
    lastActivity = json['last_activity'];
    lastActivityAt = json['last_activity_at'];
    lastComments = json['last_comments'];
    leadQuality = json['lead_quality'];
    leadAge = json['lead_age'];
    customFields = json['custom_fields'];
    deleted = json['deleted'];
    deletedReason = json['deleted_reason'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedBy = json['updated_by'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lead_id'] = leadId;
    data['lead_name'] = leadName;
    data['mobile_number'] = mobileNumber;
    data['alter_mobile_number'] = alterMobileNumber;
    data['email_id'] = emailId;
    data['alter_email_id'] = alterEmailId;
    data['age'] = age;
    data['lead_stage_id'] = leadStageId;
    data['lead_sub_stage_id'] = leadSubStageId;
    data['medium_id'] = mediumId;
    data['source_id'] = sourceId;
    data['sub_source_id'] = subSourceId;
    data['campaign_id'] = campaignId;
    data['lead_owner'] = leadOwner;
    data['ad_name_id'] = adNameId;
    data['product_category_id'] = productCategoryId;
    data['product_id'] = productId;
    data['country_id'] = countryId;
    data['state_id'] = stateId;
    data['city_id'] = cityId;
    data['pincode'] = pincode;
    data['address'] = address;
    data['communication_medium_id'] = communicationMediumId;
    data['communication_medium_type_id'] = communicationMediumTypeId;
    data['first_activity_by'] = firstActivityBy;
    data['first_activity'] = firstActivity;
    data['first_activity_at'] = firstActivityAt;
    data['last_activity_by'] = lastActivityBy;
    data['last_activity'] = lastActivity;
    data['last_activity_at'] = lastActivityAt;
    data['last_comments'] = lastComments;
    data['lead_quality'] = leadQuality;
    data['lead_age'] = leadAge;
    data['custom_fields'] = customFields;
    data['deleted'] = deleted;
    data['deleted_reason'] = deletedReason;
    data['created_by'] = createdBy;
    data['created_at'] = createdAt;
    data['updated_by'] = updatedBy;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class CommonObj {
  dynamic id;
  String? name;

  CommonObj({this.id, this.name});

  CommonObj.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    if (json['lead_stage_name'] != null) {
      id = json['lead_stage_id'];
      name = json['lead_stage_name'];
    }
    if (json['lead_sub_stage'] != null) {
      id = json['lead_sub_stage_id'];
      name = json['lead_sub_stage'];
    }
    if (json['lead_source_name'] != null) {
      id = json['lead_source_id'];
      name = json['lead_source_name'];
    }
    if (json['lead_sub_source_name'] != null) {
      id = json['lead_sub_source_id'];
      name = json['lead_sub_source_name'];
    }
    if (json['campaign_name'] != null) {
      id = json['campaign_id'];
      name = json['campaign_name'];
    }

    if (json['product_category_name'] != null) {
      id = json['product_category_id'];
      name = json['product_category_name'];
    }
    if (json['product_name'] != null) {
      id = json['product_id'];
      name = json['product_name'];
    }

    if (json['ad_name'] != null) {
      id = json['ad_name_id'];
      name = json['ad_name'];
    }
    if (json['medium_name'] != null) {
      id = json['medium_id'];
      name = json['medium_name'];
    }
    if (json['communication_medium'] != null) {
      id = json['communication_medium_id'];
      name = json['communication_medium'];
    }
    if (json['communication_type'] != null) {
      id = json['communication_type_id  '];
      name = json['communication_type'];
    }
    if (json['country_name'] != null) {
      id = json['country_id'];
      name = json['country_name'];
    }
    if (json['state_name'] != null) {
      id = json['state_id'];
      name = json['state_name'];
    }
    if (json['city_name'] != null) {
      id = json['city_id'];
      name = json['city_name'];
    }
    if (json['Name'] != null) {
      name = json['Name'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Name'] = name;
    return data;
  }
}

class LeadStageBasedLeadSubStage {
  String? apiSuccess;
  List<CommonObj>? leadSubStageList;

  LeadStageBasedLeadSubStage({this.apiSuccess, this.leadSubStageList});

  LeadStageBasedLeadSubStage.fromJson(Map<String, dynamic> json) {
    apiSuccess = json['Api_success'];
    if (json['lead_sub_stages'] != null) {
      leadSubStageList = <CommonObj>[];
      json['lead_sub_stages'].forEach((v) {
        leadSubStageList!.add(CommonObj.fromJson(v));
      });
    }
  }
}

class ProductsCategoryBasedProducts {
  String? apiSuccess;
  List<CommonObj>? productList;

  ProductsCategoryBasedProducts({this.apiSuccess, this.productList});

  ProductsCategoryBasedProducts.fromJson(Map<String, dynamic> json) {
    apiSuccess = json['Api_success'];
    if (json['product_list'] != null) {
      productList = <CommonObj>[];
      json['product_list'].forEach((v) {
        productList!.add(CommonObj.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Api_success'] = apiSuccess;
    if (productList != null) {
      data['product_list'] = productList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CountryBasedState {
  String? apiSuccess;
  List<CommonObj>? stateLists;

  CountryBasedState({this.apiSuccess, this.stateLists});

  CountryBasedState.fromJson(Map<String, dynamic> json) {
    apiSuccess = json['Api_success'];
    if (json['state_lists'] != null) {
      stateLists = <CommonObj>[];
      json['state_lists'].forEach((v) {
        stateLists!.add(CommonObj.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Api_success'] = apiSuccess;
    if (stateLists != null) {
      data['state_lists'] = stateLists!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StateBasedCity {
  String? apiSuccess;
  List<CommonObj>? citiesLists;

  StateBasedCity({this.apiSuccess, this.citiesLists});

  StateBasedCity.fromJson(Map<String, dynamic> json) {
    apiSuccess = json['Api_success'];
    if (json['cities_lists'] != null) {
      citiesLists = <CommonObj>[];
      json['cities_lists'].forEach((v) {
        citiesLists!.add(CommonObj.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Api_success'] = apiSuccess;
    if (citiesLists != null) {
      data['cities_lists'] = citiesLists!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommunicationMedium {
  String? apiSuccess;
  List<CommonObj>? communicationMediums;

  CommunicationMedium({this.apiSuccess, this.communicationMediums});

  CommunicationMedium.fromJson(Map<String, dynamic> json) {
    apiSuccess = json['Api_success'];
    if (json['communication_mediums'] != null) {
      communicationMediums = <CommonObj>[];
      json['communication_mediums'].forEach((v) {
        communicationMediums!.add(CommonObj.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Api_success'] = apiSuccess;
    if (communicationMediums != null) {
      data['communication_mediums'] =
          communicationMediums!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommunicationType {
  String? apiSuccess;
  List<CommonObj>? communicationTypes;

  CommunicationType({this.apiSuccess, this.communicationTypes});

  CommunicationType.fromJson(Map<String, dynamic> json) {
    apiSuccess = json['Api_success'];
    if (json['communication_types'] != null) {
      communicationTypes = <CommonObj>[];
      json['communication_types'].forEach((v) {
        communicationTypes!.add(CommonObj.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Api_success'] = apiSuccess;
    if (communicationTypes != null) {
      data['communication_types'] =
          communicationTypes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
