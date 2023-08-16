part of 'quotation_crud_cubit.dart';

abstract class QuotationCrudState extends Equatable {
  const QuotationCrudState();

  @override
  List<Object> get props => [];
}

class QuotationCrudLoading extends QuotationCrudState {}

class QuotationCrudLoaded extends QuotationCrudState {}

class QuotationCrudFromLoading extends QuotationCrudState {}

class QuotationCrudFromSuccess extends QuotationCrudState {}

class QuotationCrudFromFailed extends QuotationCrudState {
  final String error;

  const QuotationCrudFromFailed(this.error);

  @override
  List<Object> get props => [error];
}
