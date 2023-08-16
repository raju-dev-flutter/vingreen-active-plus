part of 'petty_cash_bloc.dart';

abstract class PettyCashState extends Equatable {
  const PettyCashState();

  @override
  List<Object> get props => [];
}

class PettyCashLoading extends PettyCashState {}

class PettyCashLoaded extends PettyCashState {
  final List<ExpenseList> expenseList;

  const PettyCashLoaded(this.expenseList);

  @override
  List<Object> get props => [expenseList];

  @override
  String toString() => 'PettyCash Loaded {$expenseList }';
}

class PettyCashFailure extends PettyCashState {
  final String error;

  const PettyCashFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'PettyCash Failure {$error}';
}
