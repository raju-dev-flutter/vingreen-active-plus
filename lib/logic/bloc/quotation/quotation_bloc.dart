import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/quotation_model.dart';
import '../../../data/repositories/quotation_repositories.dart';
import '../../../data/repositories/user_repositories.dart';

part 'quotation_event.dart';

part 'quotation_state.dart';

class QuotationBloc extends Bloc<QuotationEvent, QuotationState> {
  final UserRepositories userRepositories;
  final QuotationRepositories quotationRepositories;

  QuotationBloc(
      {required this.userRepositories, required this.quotationRepositories})
      : super(QuotationLoading()) {
    on<QuotationEvent>((event, emit) async {
      if (event is QuotationStatus) {
        emit(QuotationLoading());
        final String userId = await userRepositories.hasUserId();

        try {
          dynamic jsonResponse =
              await quotationRepositories.fetchQuotationListApi(userId);
          emit(QuotationLoaded(jsonResponse));
        } catch (e) {
          emit(const QuotationFailure(error: 'Api Interaction Failed'));
        }
      }
    });
  }
}
