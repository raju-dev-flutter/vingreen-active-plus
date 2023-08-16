// To parse this JSON data, do
//
//     final attendance = attendanceFromJson(jsonString);

import 'dart:convert';

AttendanceModel attendanceFromJson(String str) =>
    AttendanceModel.fromJson(json.decode(str));

String attendanceToJson(AttendanceModel data) => json.encode(data.toJson());

class AttendanceModel {
  AttendanceModel({
    this.apiSuccess,
    required this.attendanceList,
  });

  String? apiSuccess;
  List<AttendanceList> attendanceList;

  factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
      AttendanceModel(
        apiSuccess: json["Api_success"],
        attendanceList: List<AttendanceList>.from(
            json["attendance_list"].map((x) => AttendanceList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Api_success": apiSuccess,
        "attendance_list":
            List<dynamic>.from(attendanceList.map((x) => x.toJson())),
      };
}

class AttendanceList {
  AttendanceList({
    this.attendanceId,
    this.userId,
    this.type,
    this.attendanceAt,
    this.description,
    this.attachments,
    this.workHours,
    this.earlierCheckin,
    this.earlierCheckout,
    this.overTime,
    this.deleted,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.ipAddress,
    this.countryName,
    this.regionName,
    this.cityName,
    this.zipCode,
    this.latitude,
    this.longitude,
    this.timeZone,
    this.checkinFrom,
  });

  int? attendanceId;
  int? userId;
  String? type;
  DateTime? attendanceAt;
  String? description;
  String? attachments;
  String? workHours;
  String? earlierCheckin;
  String? earlierCheckout;
  String? overTime;
  String? deleted;
  int? createdBy;
  DateTime? createdAt;
  dynamic updatedBy;
  dynamic updatedAt;
  String? ipAddress;
  String? countryName;
  String? regionName;
  String? cityName;
  String? zipCode;
  String? latitude;
  String? longitude;
  String? timeZone;
  String? checkinFrom;

  factory AttendanceList.fromJson(Map<String, dynamic> json) => AttendanceList(
        attendanceId: json["attendance_id"],
        userId: json["user_id"],
        type: json["type"],
        attendanceAt: DateTime.parse(json["attendance_at"]),
        description: json["description"],
        attachments: json["attachments"],
        workHours: json["work_hours"],
        earlierCheckin: json["earlier_checkin"],
        earlierCheckout: json["earlier_checkout"],
        overTime: json["over_time"],
        deleted: json["deleted"],
        createdBy: json["created_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedBy: json["updated_by"],
        updatedAt: json["updated_at"],
        ipAddress: json["ip_address"],
        countryName: json["country_name"],
        regionName: json["region_name"],
        cityName: json["city_name"],
        zipCode: json["zip_code"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        timeZone: json["time_zone"],
        checkinFrom: json["checkin_from"],
      );

  Map<String, dynamic> toJson() => {
        "attendance_id": attendanceId,
        "user_id": userId,
        "type": type,
        "attendance_at": attendanceAt,
        "description": description,
        "attachments": attachments,
        "work_hours": workHours,
        "earlier_checkin": earlierCheckin,
        "earlier_checkout": earlierCheckout,
        "over_time": overTime,
        "deleted": deleted,
        "created_by": createdBy,
        "created_at": createdAt,
        "updated_by": updatedBy,
        "updated_at": updatedAt,
        "ip_address": ipAddress,
        "country_name": countryName,
        "region_name": regionName,
        "city_name": cityName,
        "zip_code": zipCode,
        "latitude": latitude,
        "longitude": longitude,
        "time_zone": timeZone,
        "checkin_from": checkinFrom,
      };
}
