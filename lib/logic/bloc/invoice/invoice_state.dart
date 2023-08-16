part of 'invoice_bloc.dart';

abstract class InvoiceState extends Equatable {
  const InvoiceState();

  @override
  List<Object> get props => [];
}

class InvoiceLoading extends InvoiceState {}

class InvoiceLoaded extends InvoiceState {
  final List<InvoiceList> invoiceList;

  const InvoiceLoaded(this.invoiceList);

  @override
  List<Object> get props => [invoiceList];
}

class InvoiceFailure extends InvoiceState {
  final String error;

  const InvoiceFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'Invoice Failure {$error}';
}
