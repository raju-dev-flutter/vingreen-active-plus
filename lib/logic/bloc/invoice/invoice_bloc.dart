import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/invoice_model.dart';
import '../../../data/repositories/invoice_repositories.dart';
import '../../../data/repositories/user_repositories.dart';

part 'invoice_event.dart';

part 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final UserRepositories userRepositories;
  final InvoiceRepositories invoiceRepositories;

  InvoiceBloc(
      {required this.userRepositories, required this.invoiceRepositories})
      : super(InvoiceLoading()) {
    on<InvoiceEvent>((event, emit) async {
      if (event is InvoiceStatus) {
        emit(InvoiceLoading());

        final String userId = await userRepositories.hasUserId();

        try {
          dynamic jsonResponse =
              await invoiceRepositories.fetchInvoiceListApi(userId);
          emit(InvoiceLoaded(jsonResponse));
        } catch (e) {
          emit(const InvoiceFailure(error: 'Api Interaction Failed'));
        }
      }
    });
  }
}
