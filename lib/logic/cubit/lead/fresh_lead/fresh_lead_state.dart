part of 'fresh_lead_cubit.dart';

abstract class FreshLeadState extends Equatable {
  const FreshLeadState();

  @override
  List<Object> get props => [];
}

class FreshLeadLoading extends FreshLeadState {}

class FreshLeadDetailLoaded extends FreshLeadState {
  final List<LeadList> freshLead;

  const FreshLeadDetailLoaded(this.freshLead);

  @override
  List<Object> get props => [freshLead];
}

class FreshLeadFailure extends FreshLeadState {
  final String error;

  const FreshLeadFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'Task Start Failure: {$error}';
}
