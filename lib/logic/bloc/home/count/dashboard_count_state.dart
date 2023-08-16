part of 'dashboard_count_bloc.dart';

abstract class DashboardCountState extends Equatable {
  const DashboardCountState();

  @override
  List<Object> get props => [];
}

class DashboardCountLoading extends DashboardCountState {}

class DashboardCountLoaded extends DashboardCountState {
  final String leadCount;
  final String ticketCount;
  final String pettyCashCount;
  final String quotationCount;

  const DashboardCountLoaded(this.leadCount, this.ticketCount,
      this.pettyCashCount, this.quotationCount);

  @override
  List<Object> get props =>
      [leadCount, ticketCount, pettyCashCount, quotationCount];

  @override
  String toString() =>
      'Count {Lead Count:$leadCount Tickets Count:$ticketCount Petty Cash Count:$pettyCashCount Quotation Count:$quotationCount}';
}

class DashboardCountFailure extends DashboardCountState {
  final String error;

  const DashboardCountFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'Dashboard Count Failure {$error}';
}
