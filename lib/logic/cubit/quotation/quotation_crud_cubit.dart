import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../data/repositories/quotation_repositories.dart';
import '../../../data/repositories/user_repositories.dart';

part 'quotation_crud_state.dart';

class QuotationCrudCubit extends Cubit<QuotationCrudState> {
  final UserRepositories userRepositories;
  final QuotationRepositories quotationRepositories;

  QuotationCrudCubit(
      {required this.userRepositories, required this.quotationRepositories})
      : super(QuotationCrudLoading());

  Future<void> initialQuotationCrud() async {
    emit(QuotationCrudLoading());
    final userId = await userRepositories.hasUserId();
    await quotationRepositories.fetchQuotationAddApi(userId);
    emit(QuotationCrudLoaded());
  }

  Future<void> uploadQuotationAddSubmit(dynamic map) async {
    emit(QuotationCrudFromLoading());
    try {
      await quotationRepositories.fetchQuotationAddSubmitApi(map);
      emit(QuotationCrudFromSuccess());
    } catch (error) {
      emit(QuotationCrudFromFailed(error.toString()));
    }
  }

  Future<void> uploadQuotationEditSubmit(dynamic map) async {
    emit(QuotationCrudFromLoading());
    try {
      dynamic response =
          await quotationRepositories.fetchQuotationEditSubmitApi(map);
      debugPrint(response.toString());
      emit(QuotationCrudFromSuccess());
    } catch (error) {
      emit(QuotationCrudFromFailed(error.toString()));
    }
  }
}
