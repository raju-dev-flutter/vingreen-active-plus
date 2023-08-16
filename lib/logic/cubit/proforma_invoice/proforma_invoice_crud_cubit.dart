import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../data/repositories/proforma_invoice_repositories.dart';
import '../../../data/repositories/user_repositories.dart';
import '../../rxdart/proforma_invoice/proforma_invoice_add_bloc.dart';
import '../../rxdart/proforma_invoice/proforma_invoice_edit_bloc.dart';

part 'proforma_invoice_crud_state.dart';

class ProformaInvoiceCrudCubit extends Cubit<ProformaInvoiceCrudState> {
  final UserRepositories userRepositories;
  final ProformaInvoiceRepositories proformaInvoiceRepositories;

  final proformaInvoiceAddBloc = ProformaInvoiceAddBloc();
  final proformaInvoiceEditBloc = ProformaInvoiceEditBloc();

  ProformaInvoiceCrudCubit(
      {required this.userRepositories,
      required this.proformaInvoiceRepositories})
      : super(ProformaInvoiceCrudLoading());

  Future<void> initialProformaInvoiceAddCrud() async {
    emit(ProformaInvoiceCrudLoading());
    await proformaInvoiceAddBloc.fetchProformaInvoiceDetailLoaded();
    emit(ProformaInvoiceCrudLoaded());
  }

  Future<void> initialProformaInvoiceEditCrud(dynamic proformaInvoiceId) async {
    emit(ProformaInvoiceCrudLoading());
    await proformaInvoiceEditBloc
        .fetchProformaInvoiceDetailLoaded(proformaInvoiceId);
    emit(ProformaInvoiceCrudLoaded());
  }

  Future<void> uploadProformaInvoiceAddSubmit(dynamic map) async {
    emit(ProformaInvoiceCrudFromLoading());
    try {
      await proformaInvoiceRepositories.fetchProformaInvoiceAddSubmitApi(map);
      emit(ProformaInvoiceCrudFromSuccess());
    } catch (error) {
      emit(ProformaInvoiceCrudFromFailed(error.toString()));
    }
  }

  Future<void> uploadProformaInvoiceEditSubmit(dynamic map) async {
    emit(ProformaInvoiceCrudFromLoading());
    try {
      dynamic response = await proformaInvoiceRepositories
          .fetchProformaInvoiceEditSubmitApi(map);
      debugPrint(response.toString());
      emit(ProformaInvoiceCrudFromSuccess());
    } catch (error) {
      emit(ProformaInvoiceCrudFromFailed(error.toString()));
    }
  }
}
