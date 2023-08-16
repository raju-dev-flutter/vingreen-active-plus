import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../../../../data/repositories/homepage_repositories.dart';
import '../../../../data/repositories/user_repositories.dart';

// ignore_for_file: unnecessary_null_comparison

part 'attendance_event.dart';

part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final UserRepositories userRepositories;
  final HomepageRepositories homepageRepositories;

  AttendanceBloc(
      {required this.userRepositories, required this.homepageRepositories})
      : assert(userRepositories != null),
        assert(homepageRepositories != null),
        super(AttendancestatusLoading()) {
    on<AttendanceEvent>((event, emit) async {
      if (event is AttendanceStatus) {
        // emit(AttendancestatusLoading());
        final String userId = await userRepositories.hasUserId();

        String status = 'null';
        String checkinTime = 'null';
        String checkoutTime = 'null';

        try {
          dynamic response =
              await homepageRepositories.attendanceStatus(userId);
          for (int i = 0; i < response['attendance_details'].length; i++) {
            if (response['attendance_details'][i]['type'] == 'checkin') {
              final splitted =
                  response['attendance_details'][i]['attendance_at'].split(' ');
              checkinTime = DateFormat.jm()
                  .format(DateFormat("hh:mm:ss").parse(splitted[1]));
              status = response['attendance_details'][i]['type'];

              debugPrint("==========$checkinTime ============= $status");
            } else if (response['attendance_details'][i]['type'] ==
                'checkout') {
              final splitted =
                  response['attendance_details'][i]['attendance_at'].split(' ');
              checkoutTime = DateFormat.jm()
                  .format(DateFormat("hh:mm:ss").parse(splitted[1]));
              status = response['attendance_details'][i]['type'];
            } else {
              debugPrint(null);
            }
          }
        } catch (e) {
          emit(const AttendancestatusFailure(error: 'Api Interaction Failed'));
        }
        emit(AttendanceStatusLoaded(status, checkinTime, checkoutTime));
      }
      if (event is PunchinButtonPressed) {
        emit(PunchButtonLoading());
        final String userId = await userRepositories.hasUserId();

        var position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        var latitude = position.latitude;
        var longitude = position.longitude;

        Map data = {
          'id': userId,
          'description': event.description,
          'longitude': longitude,
          'latitude': latitude,
        };
        try {
          await homepageRepositories.submitCheckInData(data);
          // debugPrint(response['']);
          emit(PunchSuccess());
        } catch (e) {
          emit(const PunchFailure(error: 'Punch In Failed'));
        }
      }
      if (event is PunchOutButtonPressed) {
        emit(PunchButtonLoading());

        final String userId = await userRepositories.hasUserId();

        var position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        var latitude = position.latitude;
        var longitude = position.longitude;

        Map data = {
          'id': userId,
          'description': event.description,
          'longitude': longitude,
          'latitude': latitude,
        };

        try {
          await homepageRepositories.submitCheckOutData(data);
          // debugPrint(response['']);
          emit(PunchSuccess());
        } catch (e) {
          emit(const PunchFailure(error: 'Punch Out Failed'));
        }
      }
    });
  }
}
