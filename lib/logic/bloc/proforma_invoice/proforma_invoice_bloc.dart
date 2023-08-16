import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/proforma_invoice_model.dart';
import '../../../data/repositories/proforma_invoice_repositories.dart';
import '../../../data/repositories/user_repositories.dart';

part 'proforma_invoice_event.dart';

part 'proforma_invoice_state.dart';

class ProformaInvoiceBloc
    extends Bloc<ProformaInvoiceEvent, ProformaInvoiceState> {
  final UserRepositories userRepositories;
  final ProformaInvoiceRepositories proformaInvoiceRepositories;

  ProformaInvoiceBloc(
      {required this.userRepositories,
      required this.proformaInvoiceRepositories})
      : super(ProformaInvoiceLoading()) {
    on<ProformaInvoiceEvent>((event, emit) async {
      if (event is ProformaInvoiceStatus) {
        emit(ProformaInvoiceLoading());

        final String userId = await userRepositories.hasUserId();

        try {
          dynamic jsonResponse = await proformaInvoiceRepositories
              .fetchProformaInvoiceListApi(userId);
          emit(ProformaInvoiceLoaded(jsonResponse));
        } catch (e) {
          emit(const ProformaInvoiceFailure(error: 'Api Interaction Failed'));
        }
      }
    });
  }
}
