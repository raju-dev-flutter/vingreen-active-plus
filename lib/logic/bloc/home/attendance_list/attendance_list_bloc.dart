import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../data/models/attendance_model.dart';
import '../../../../data/repositories/homepage_repositories.dart';
import '../../../../data/repositories/user_repositories.dart';

part 'attendance_list_event.dart';
part 'attendance_list_state.dart';

class AttendanceListBloc
    extends Bloc<AttendanceListEvent, AttendanceListState> {
  final UserRepositories userRepositories;
  final HomepageRepositories homepageRepositories;

  AttendanceListBloc(
      {required this.userRepositories, required this.homepageRepositories})
      : super(AttendanceListLoading()) {
    on<AttendanceListEvent>((event, emit) async {
      if (event is GetAttendanceList) {
        final String userId = await userRepositories.hasUserId();
        debugPrint("======$userId=========");
        try {
       dynamic response = await homepageRepositories.attendanceList(userId);
          List<AttendanceList> attendanceList = response;
          debugPrint("=============== :$response"); 
          emit(  AttendanceListLoaded(attendanceList));
        } catch (e) {
          emit(const AttendanceListFailure(error: 'Api Interaction Failed'));
        }
      }
    });
  }
}
