part of 'proforma_invoice_bloc.dart';

abstract class ProformaInvoiceEvent extends Equatable {
  const ProformaInvoiceEvent();

  @override
  List<Object> get props => [];
}

class ProformaInvoiceStatus extends ProformaInvoiceEvent {}
