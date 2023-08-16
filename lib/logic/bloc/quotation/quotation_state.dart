part of 'quotation_bloc.dart';

abstract class QuotationState extends Equatable {
  const QuotationState();

  @override
  List<Object> get props => [];
}

class QuotationLoading extends QuotationState {}

class QuotationLoaded extends QuotationState {
  final List<QuotationList> quotationList;

  const QuotationLoaded(this.quotationList);

  @override
  List<Object> get props => [quotationList];

  @override
  String toString() => ' Quotation List: {$quotationList}';
}

class QuotationFailure extends QuotationState {
  final String error;

  const QuotationFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => ' Quotation List Error: {$error}';
}
