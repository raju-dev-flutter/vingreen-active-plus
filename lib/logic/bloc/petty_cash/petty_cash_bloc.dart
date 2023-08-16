import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/pettycash_model.dart';
import '../../../data/repositories/petty_cash_repositories.dart';
import '../../../data/repositories/user_repositories.dart';

part 'petty_cash_event.dart';

part 'petty_cash_state.dart';

class PettyCashBloc extends Bloc<PettyCashEvent, PettyCashState> {
  final UserRepositories userRepositories;
  final PettyCashRepositories pettyCashRepositories;

  PettyCashBloc(
      {required this.userRepositories, required this.pettyCashRepositories})
      : super(PettyCashLoading()) {
    on<PettyCashEvent>((event, emit) async {
      if (event is PettyCashStatus) {
        emit(PettyCashLoading());
        final String userId = await userRepositories.hasUserId();

        try {
          dynamic jsonResponse =
              await pettyCashRepositories.fetchPettyCashDetailsApi(userId);
          emit(PettyCashLoaded(jsonResponse));
        } catch (e) {
          emit(const PettyCashFailure(error: 'Api Interaction Failed'));
        }
      }
    });
  }
}
