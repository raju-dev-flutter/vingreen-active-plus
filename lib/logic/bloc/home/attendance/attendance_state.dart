part of 'attendance_bloc.dart';

abstract class AttendanceState extends Equatable {
  const AttendanceState();
  @override
  List<Object> get props => [];
}

class AttendancestatusLoading extends AttendanceState {}

class AttendanceStatusLoaded extends AttendanceState {
  final String status;
  final String checkInTime;
  final String checkOutTime;

  const AttendanceStatusLoaded(
      this.status, this.checkInTime, this.checkOutTime);

  @override
  List<Object> get props => [status, checkInTime, checkOutTime];

  @override
  String toString() => 'Attendance Status {Attendance Status: $status}';
}

class AttendancestatusFailure extends AttendanceState {
  final String error;
  const AttendancestatusFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'AttendancestatusFailure {$error}';
}

class PunchButtonLoading extends AttendanceState {}

class PunchSuccess extends AttendanceState {}

class PunchFailure extends AttendanceState {
  final String error;
  const PunchFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'PunchFailure {$error}';
}
