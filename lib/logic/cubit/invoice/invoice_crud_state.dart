part of 'invoice_crud_cubit.dart';

abstract class InvoiceCrudState extends Equatable {
  const InvoiceCrudState();

  @override
  List<Object> get props => [];
}

class InvoiceCrudLoading extends InvoiceCrudState {}

class InvoiceCrudLoaded extends InvoiceCrudState {}

class InvoiceCrudFromLoading extends InvoiceCrudState {}

class InvoiceCrudFromSuccess extends InvoiceCrudState {}

class InvoiceCrudFromFailed extends InvoiceCrudState {
  final String error;

  const InvoiceCrudFromFailed(this.error);

  @override
  List<Object> get props => [error];
}
