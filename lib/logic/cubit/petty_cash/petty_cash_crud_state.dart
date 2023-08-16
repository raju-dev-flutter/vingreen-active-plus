part of 'petty_cash_crud_cubit.dart';

abstract class PettyCashCrudState extends Equatable {
  const PettyCashCrudState();

  @override
  List<Object> get props => [];
}

class PettyCashCrudLoading extends PettyCashCrudState {}

class PettyCashCrudLoaded extends PettyCashCrudState {
  final String userId;
  final List<UsersList> usersList;
  final UsersList usersListInit;

  const PettyCashCrudLoaded(this.userId, this.usersList, this.usersListInit);

  @override
  List<Object> get props => [userId, usersList, usersListInit];
}

class PettyCashCrudFailure extends PettyCashCrudState {
  final String error;

  const PettyCashCrudFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'Task Crud Failure: {$error}';
}

class PettyCashFormLoading extends PettyCashCrudState {}

class PettyCashFormSuccess extends PettyCashCrudState {}

class PettyCashFormFailure extends PettyCashCrudState {
  final String error;

  const PettyCashFormFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'Task Crud Failure: {$error}';
}
