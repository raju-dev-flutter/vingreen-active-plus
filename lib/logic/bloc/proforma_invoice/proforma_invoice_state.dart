part of 'proforma_invoice_bloc.dart';

abstract class ProformaInvoiceState extends Equatable {
  const ProformaInvoiceState();

  @override
  List<Object> get props => [];
}

class ProformaInvoiceLoading extends ProformaInvoiceState {}

class ProformaInvoiceLoaded extends ProformaInvoiceState {
  final List<ProformaInvoiceList> proformaInvoiceList;

  const ProformaInvoiceLoaded(this.proformaInvoiceList);

  @override
  List<Object> get props => [proformaInvoiceList];
}

class ProformaInvoiceFailure extends ProformaInvoiceState {
  final String error;

  const ProformaInvoiceFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'Proforma Invoice Failure {$error}';
}
