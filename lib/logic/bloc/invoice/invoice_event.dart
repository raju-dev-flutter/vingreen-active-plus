part of 'invoice_bloc.dart';

abstract class InvoiceEvent extends Equatable {
  const InvoiceEvent();

  List<Object?> get props => [];
}

class InvoiceStatus extends InvoiceEvent {}
