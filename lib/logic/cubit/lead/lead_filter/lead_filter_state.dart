part of 'lead_filter_cubit.dart';

abstract class LeadFilterState extends Equatable {
  const LeadFilterState();

  @override
  List<Object> get props => [];
}

class LeadFilterLoading extends LeadFilterState {}

class LeadFilterLoaded extends LeadFilterState {}

class LeadFilterFailure extends LeadFilterState {}

class LeadFilterPageLoading extends LeadFilterState {}

class LeadFilterPageLoaded extends LeadFilterState {
  final List<LeadList> leadList;

  const LeadFilterPageLoaded(this.leadList);

  @override
  List<Object> get props => [leadList];
}

class LeadFilterPageFailure extends LeadFilterState {
  final String error;

  const LeadFilterPageFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'Task Crud Form Failure: {$error}';
}
