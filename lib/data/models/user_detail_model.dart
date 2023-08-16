class UserDetails {
  String? userName;
  String? email;
  String? employeeCode;
  String? gender;
  String? dateOfBirth;
  String? personalMobileNumber;
  String? emergencyContactNumber;
  String? bloodGroup;
  String? dateOfJoining;
  String? designationId;
  String? profileUpload;
  String? countryId;
  String? stateId;
  String? cityId;
  int? pinCode;
  String? address;
  String? apiSuccess;
  String? apiMessage;

  UserDetails(
      {this.userName,
      this.email,
      this.employeeCode,
      this.gender,
      this.dateOfBirth,
      this.personalMobileNumber,
      this.emergencyContactNumber,
      this.bloodGroup,
      this.dateOfJoining,
      this.designationId,
      this.profileUpload,
      this.countryId,
      this.stateId,
      this.cityId,
      this.pinCode,
      this.address,
      this.apiSuccess,
      this.apiMessage});

  UserDetails.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];
    email = json['email'];
    employeeCode = json['employee_code'];
    gender = json['gender'];
    dateOfBirth = json['date_of_birth'];
    personalMobileNumber = json['personal_mobile_number'];
    emergencyContactNumber = json['emergency_contact_number'];
    bloodGroup = json['blood_group'];
    dateOfJoining = json['date_of_joining'];
    designationId = json['designation_id'];
    profileUpload = json['profile_upload'];
    countryId = json['country_id'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    pinCode = json['pin_code'];
    address = json['address'];
    apiSuccess = json['Api_success'];
    apiMessage = json['Api_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_name'] = userName;
    data['email'] = email;
    data['employee_code'] = employeeCode;
    data['gender'] = gender;
    data['date_of_birth'] = dateOfBirth;
    data['personal_mobile_number'] = personalMobileNumber;
    data['emergency_contact_number'] = emergencyContactNumber;
    data['blood_group'] = bloodGroup;
    data['date_of_joining'] = dateOfJoining;
    data['designation_id'] = designationId;
    data['profile_upload'] = profileUpload;
    data['country_id'] = countryId;
    data['state_id'] = stateId;
    data['city_id'] = cityId;
    data['pin_code'] = pinCode;
    data['address'] = address;
    data['Api_success'] = apiSuccess;
    data['Api_message'] = apiMessage;
    return data;
  }
}
