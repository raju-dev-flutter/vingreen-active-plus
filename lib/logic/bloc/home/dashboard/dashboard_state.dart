part of 'dashboard_bloc.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
  @override
  List<Object> get props => [];
}

class DashboardLoading extends DashboardState {}

class GetUserDetailsLoaded extends DashboardState {
  final UserDetails userDetails;

  const GetUserDetailsLoaded(this.userDetails);

  @override
  List<Object> get props => [userDetails];

  @override
  String toString() => 'GetUserDetails {User Details: $userDetails}';
}

class LogoutSuccess extends DashboardState {}

class DashboardFailure extends DashboardState {
  final String error;
  const DashboardFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'DashboardFailure {$error}';
}
