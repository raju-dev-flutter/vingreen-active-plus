part of 'lead_crud_cubit.dart';

abstract class LeadCrudState extends Equatable {
  const LeadCrudState();

  @override
  List<Object> get props => [];
}

class LeadCrudLoading extends LeadCrudState {}

class LeadCrudDetailLoaded extends LeadCrudState {
  final LeadDetail leadDetail;

  const LeadCrudDetailLoaded(this.leadDetail);

  @override
  List<Object> get props => [leadDetail];

  @override
  String toString() => 'Lead Details Failure: {$leadDetail}';
}

class LeadDetailLoaded extends LeadCrudState {
  final LeadDetails leadDetails;

  const LeadDetailLoaded(this.leadDetails);

  @override
  List<Object> get props => [leadDetails];

  @override
  String toString() => 'Lead Details Failure: {$leadDetails}';
}

class LeadCrudFailure extends LeadCrudState {
  final String error;

  const LeadCrudFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'Lead Edit Failure: {$error}';
}

class LeadCrudFormLoadinge extends LeadCrudState {}

class LeadCrudFormSuccess extends LeadCrudState {}

class LeadCrudFormFailure extends LeadCrudState {
  final String error;

  const LeadCrudFormFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'Lead Edit Failure: {$error}';
}
