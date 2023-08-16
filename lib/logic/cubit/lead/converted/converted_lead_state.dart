part of 'converted_lead_cubit.dart';

abstract class ConvertedLeadState extends Equatable {
  const ConvertedLeadState();

  @override
  List<Object> get props => [];
}

class ConvertedLeadLoading extends ConvertedLeadState {}

class ConvertedLeadDetailLoaded extends ConvertedLeadState {
  final List<LeadList> convertedLead;

  const ConvertedLeadDetailLoaded(this.convertedLead);

  @override
  List<Object> get props => [convertedLead];
}

class ConvertedLeadFailure extends ConvertedLeadState {
  final String error;

  const ConvertedLeadFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'Task Start Failure: {$error}';
}
