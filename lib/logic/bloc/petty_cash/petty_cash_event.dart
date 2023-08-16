part of 'petty_cash_bloc.dart';

abstract class PettyCashEvent extends Equatable {
  const PettyCashEvent();

  @override
  List<Object?> get props => [];
}

class PettyCashStatus extends PettyCashEvent {}
