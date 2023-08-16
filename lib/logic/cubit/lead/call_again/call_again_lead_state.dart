part of 'call_again_lead_cubit.dart';

abstract class CallAgainLeadState extends Equatable {
  const CallAgainLeadState();

  @override
  List<Object> get props => [];
}

class CallAgainLeadLoading extends CallAgainLeadState {}

class CallAgainLeadDetailLoaded extends CallAgainLeadState {
  final List<LeadList> callAgainLead;

  const CallAgainLeadDetailLoaded(this.callAgainLead);

  @override
  List<Object> get props => [callAgainLead];
}

class CallAgainLeadFailure extends CallAgainLeadState {
  final String error;

  const CallAgainLeadFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'Task Start Failure: {$error}';
}
