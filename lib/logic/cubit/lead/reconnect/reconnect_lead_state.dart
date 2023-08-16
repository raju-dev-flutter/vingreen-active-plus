part of 'reconnect_lead_cubit.dart';

abstract class ReconnectLeadState extends Equatable {
  const ReconnectLeadState();

  @override
  List<Object> get props => [];
}

class ReconnectLeadLoading extends ReconnectLeadState {}

class ReconnectLeadDetailLoaded extends ReconnectLeadState {
  final List<LeadList> reconnectLead;

  const ReconnectLeadDetailLoaded(this.reconnectLead);

  @override
  List<Object> get props => [reconnectLead];
}

class ReconnectLeadFailure extends ReconnectLeadState {
  final String error;

  const ReconnectLeadFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'Task Start Failure: {$error}';
}
