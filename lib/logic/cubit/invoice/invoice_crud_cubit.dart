import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../data/repositories/invoice_repositories.dart';
import '../../../data/repositories/user_repositories.dart';
import '../../rxdart/invoice/invoice_add_bloc.dart';
import '../../rxdart/invoice/invoice_edit_bloc.dart';

part 'invoice_crud_state.dart';

class InvoiceCrudCubit extends Cubit<InvoiceCrudState> {
  final UserRepositories userRepositories;
  final InvoiceRepositories invoiceRepositories;

  final InvoiceAddBloc invoiceAddBloc = InvoiceAddBloc();
  final InvoiceEditBloc invoiceEditBloc = InvoiceEditBloc();

  InvoiceCrudCubit(
      {required this.userRepositories, required this.invoiceRepositories})
      : super(InvoiceCrudLoading());

  Future<void> initialInvoiceAddCrud() async {
    emit(InvoiceCrudLoading());
    await invoiceAddBloc.fetchInvoiceDetailLoaded();
    emit(InvoiceCrudLoaded());
  }

  Future<void> initialInvoiceEditCrud(dynamic invoiceId) async {
    emit(InvoiceCrudLoading());
    await invoiceEditBloc.fetchInvoiceDetailLoaded(invoiceId);
    emit(InvoiceCrudLoaded());
  }

  Future<void> uploadInvoiceAddSubmit(dynamic map) async {
    emit(InvoiceCrudFromLoading());
    try {
      await invoiceRepositories.fetchInvoiceAddSubmitApi(map);
      emit(InvoiceCrudFromSuccess());
    } catch (error) {
      emit(InvoiceCrudFromFailed(error.toString()));
    }
  }

  Future<void> uploadInvoiceEditSubmit(dynamic map) async {
    emit(InvoiceCrudFromLoading());
    try {
      dynamic response =
          await invoiceRepositories.fetchInvoiceEditSubmitApi(map);
      debugPrint(response.toString());
      emit(InvoiceCrudFromSuccess());
    } catch (error) {
      emit(InvoiceCrudFromFailed(error.toString()));
    }
  }
}
