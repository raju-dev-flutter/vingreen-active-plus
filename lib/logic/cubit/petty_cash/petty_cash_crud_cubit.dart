import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/models/pettycash_model.dart';
import '../../../data/repositories/petty_cash_repositories.dart';
import '../../../data/repositories/user_repositories.dart';

part 'petty_cash_crud_state.dart';

class PettyCashCrudCubit extends Cubit<PettyCashCrudState> {
  final UserRepositories userRepositories;
  final PettyCashRepositories pettyCashRepositories;

  PettyCashCrudCubit(
      {required this.userRepositories, required this.pettyCashRepositories})
      : super(PettyCashCrudLoading());

  Future<void> getUserDetails() async {
    emit(PettyCashCrudLoading());
    final String userId = await userRepositories.hasUserId();
    try {
      final jsonResponse =
          await pettyCashRepositories.fetchPettyCashUserListApi(userId);
      Pettycash pettyCash = Pettycash.fromJson(jsonResponse);

      emit(PettyCashCrudLoaded(
        userId,
        pettyCash.usersList ?? [],
        pettyCash.usersList!.first,
      ));
    } catch (e) {
      emit(const PettyCashCrudFailure(error: 'Api Interaction Failed'));
    }
  }

  Future<void> submitPettyCashDetails(
      Map<String, String> data, List<XFile> attachment) async {
    emit(PettyCashFormLoading());

    // debugPrint("========= : ${data['amount']}");
    try {
      final responce =
          await pettyCashRepositories.fetchPettyCashSubmitApi(data, attachment);

      // debugPrint(responce);
      emit(PettyCashFormSuccess());
    } catch (e) {
      emit(const PettyCashFormFailure(error: 'Api Interaction Failed'));
    }
  }

  Future<void> submitPettyCashDelete(dynamic data) async {
    emit(PettyCashFormLoading());

    try {
      final responce =
          await pettyCashRepositories.fetchPettyCashDeleteApi(data);

      debugPrint(responce);
      emit(PettyCashFormSuccess());
    } catch (e) {
      emit(const PettyCashFormFailure(error: 'Api Interaction Failed'));
    }
  }
}
