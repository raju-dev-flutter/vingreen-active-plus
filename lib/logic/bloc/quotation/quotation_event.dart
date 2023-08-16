part of 'quotation_bloc.dart';

abstract class QuotationEvent extends Equatable {
  const QuotationEvent();

  @override
  List<Object?> get props => [];
}

class QuotationStatus extends QuotationEvent {}
