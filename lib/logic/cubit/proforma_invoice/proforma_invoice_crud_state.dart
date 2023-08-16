part of 'proforma_invoice_crud_cubit.dart';

abstract class ProformaInvoiceCrudState extends Equatable {
  const ProformaInvoiceCrudState();

  @override
  List<Object> get props => [];
}

class ProformaInvoiceCrudLoading extends ProformaInvoiceCrudState {}

class ProformaInvoiceCrudLoaded extends ProformaInvoiceCrudState {}

class ProformaInvoiceCrudFromLoading extends ProformaInvoiceCrudState {}

class ProformaInvoiceCrudFromSuccess extends ProformaInvoiceCrudState {}

class ProformaInvoiceCrudFromFailed extends ProformaInvoiceCrudState {
  final String error;

  const ProformaInvoiceCrudFromFailed(this.error);

  @override
  List<Object> get props => [error];
}
