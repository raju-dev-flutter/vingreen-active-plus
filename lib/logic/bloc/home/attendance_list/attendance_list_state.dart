part of 'attendance_list_bloc.dart';

abstract class AttendanceListState extends Equatable {
  const AttendanceListState();
  @override
  List<Object> get props => [];
}

class AttendanceListLoading extends AttendanceListState {}

class AttendanceListLoaded extends AttendanceListState {
  final List<AttendanceList> attendanceList;
  const AttendanceListLoaded(this.attendanceList);

  @override
  List<Object> get props => [attendanceList];

  @override
  String toString() => 'Attendance List Loaded {$attendanceList}';
}
class AttendanceListFailure extends AttendanceListState {
  final String error;
  const AttendanceListFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'Dashboard Count Failure {$error}';
}