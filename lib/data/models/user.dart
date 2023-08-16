class UserModel {
  String? apiSuccess;
  String? message;
  User? user;
  String? token;

  UserModel({this.apiSuccess, this.message, this.user, this.token});

  UserModel.fromJson(Map<String, dynamic> json) {
    apiSuccess = json['api_success'];
    message = json['message'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['api_success'] = apiSuccess;
    data['message'] = message;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['token'] = token;
    return data;
  }
}

class User {
  int? id;
  String? firstName;
  String? email;
  String? emailVerifiedAt;
  int? createdBy;
  int? updatedBy;
  String? createdAt;
  String? updatedAt;
  String? deleted;
  String? deletedReason;
  String? backgroundMode;
  String? backgroundView;
  String? backgroundImage;
  String? navbarColor;
  String? lastName;
  String? employeeCode;
  String? employeeName;
  String? gender;
  String? dateOfBirth;
  String? personalMailId;
  String? officialMailId;
  String? personalMobileNumber;
  String? emergencyContactNumber;
  String? bloodGroup;
  String? dateOfJoining;
  String? designationId;
  String? departmentId;
  String? teamId;
  String? reportingToId;
  String? profileUpload;
  String? countryId;
  String? stateId;
  String? cityId;
  int? pinCode;
  String? address;
  String? addressUpload;
  String? otp;
  String? customFields;
  String? shiftId;
  String? shiftDescription;
  String? shiftTimingId;
  String? fromTime;
  String? toTime;

  User(
      {this.id,
      this.firstName,
      this.email,
      this.emailVerifiedAt,
      this.createdBy,
      this.updatedBy,
      this.createdAt,
      this.updatedAt,
      this.deleted,
      this.deletedReason,
      this.backgroundMode,
      this.backgroundView,
      this.backgroundImage,
      this.navbarColor,
      this.lastName,
      this.employeeCode,
      this.employeeName,
      this.gender,
      this.dateOfBirth,
      this.personalMailId,
      this.officialMailId,
      this.personalMobileNumber,
      this.emergencyContactNumber,
      this.bloodGroup,
      this.dateOfJoining,
      this.designationId,
      this.departmentId,
      this.teamId,
      this.reportingToId,
      this.profileUpload,
      this.countryId,
      this.stateId,
      this.cityId,
      this.pinCode,
      this.address,
      this.addressUpload,
      this.otp,
      this.customFields,
      this.shiftId,
      this.shiftDescription,
      this.shiftTimingId,
      this.fromTime,
      this.toTime});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deleted = json['deleted'];
    deletedReason = json['deleted_reason'];
    backgroundMode = json['background_mode'];
    backgroundView = json['background_view'];
    backgroundImage = json['background_image'];
    navbarColor = json['navbar_color'];
    lastName = json['last_name'];
    employeeCode = json['employee_code'];
    employeeName = json['employee_name'];
    gender = json['gender'];
    dateOfBirth = json['date_of_birth'];
    personalMailId = json['personal_mail_id'];
    officialMailId = json['official_mail_id'];
    personalMobileNumber = json['personal_mobile_number'];
    emergencyContactNumber = json['emergency_contact_number'];
    bloodGroup = json['blood_group'];
    dateOfJoining = json['date_of_joining'];
    designationId = json['designation_id'];
    departmentId = json['department_id'];
    teamId = json['team_id'];
    reportingToId = json['reporting_to_id'];
    profileUpload = json['profile_upload'];
    countryId = json['country_id'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    pinCode = json['pin_code'];
    address = json['address'];
    addressUpload = json['address_upload'];
    otp = json['otp'];
    customFields = json['custom_fields'];
    shiftId = json['shift_id'];
    shiftDescription = json['shift_description'];
    shiftTimingId = json['shift_timing_id'];
    fromTime = json['from_time'];
    toTime = json['to_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted'] = deleted;
    data['deleted_reason'] = deletedReason;
    data['background_mode'] = backgroundMode;
    data['background_view'] = backgroundView;
    data['background_image'] = backgroundImage;
    data['navbar_color'] = navbarColor;
    data['last_name'] = lastName;
    data['employee_code'] = employeeCode;
    data['employee_name'] = employeeName;
    data['gender'] = gender;
    data['date_of_birth'] = dateOfBirth;
    data['personal_mail_id'] = personalMailId;
    data['official_mail_id'] = officialMailId;
    data['personal_mobile_number'] = personalMobileNumber;
    data['emergency_contact_number'] = emergencyContactNumber;
    data['blood_group'] = bloodGroup;
    data['date_of_joining'] = dateOfJoining;
    data['designation_id'] = designationId;
    data['department_id'] = departmentId;
    data['team_id'] = teamId;
    data['reporting_to_id'] = reportingToId;
    data['profile_upload'] = profileUpload;
    data['country_id'] = countryId;
    data['state_id'] = stateId;
    data['city_id'] = cityId;
    data['pin_code'] = pinCode;
    data['address'] = address;
    data['address_upload'] = addressUpload;
    data['otp'] = otp;
    data['custom_fields'] = customFields;
    data['shift_id'] = shiftId;
    data['shift_description'] = shiftDescription;
    data['shift_timing_id'] = shiftTimingId;
    data['from_time'] = fromTime;
    data['to_time'] = toTime;
    return data;
  }
}
