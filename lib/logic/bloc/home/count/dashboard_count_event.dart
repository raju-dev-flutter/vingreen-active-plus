part of 'dashboard_count_bloc.dart';

abstract class DashboardCountEvent extends Equatable {
  const DashboardCountEvent();

  @override
  List<Object> get props => [];
}

class DashboardCount extends DashboardCountEvent {}
