part of 'attendance_bloc.dart';

abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();
  @override
  List<Object> get props => [];
}

class AttendanceStatus extends AttendanceEvent {}

class PunchinButtonPressed extends AttendanceEvent {
  final String description;

  const PunchinButtonPressed({required this.description});

  @override
  List<Object> get props => [description];

  @override
  String toString() => 'PunchingButtonPressed {  Description: $description   }';
}

class PunchOutButtonPressed extends AttendanceEvent {
  final String description;

  const PunchOutButtonPressed({required this.description});

  @override
  List<Object> get props => [description];

  @override
  String toString() => 'PunchOutButtonPressed { Description: $description }';
}
