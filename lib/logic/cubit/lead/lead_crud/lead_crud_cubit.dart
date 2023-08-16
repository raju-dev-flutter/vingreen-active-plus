import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../data/models/lead_edit_model.dart';
import '../../../../data/models/lead_model.dart';
import '../../../../data/repositories/lead_repositories.dart';
import '../../../../data/repositories/user_repositories.dart';

part 'lead_crud_state.dart';

class LeadCrudCubit extends Cubit<LeadCrudState> {
  final UserRepositories userRepositories;
  final LeadRepositories leadRepositories;

  LeadCrudCubit(
      {required this.userRepositories, required this.leadRepositories})
      : super(LeadCrudLoading());

  Future<void> getLeadEditDetail(dynamic leadId) async {
    emit(LeadCrudLoading());
    final String userId = await userRepositories.hasUserId();

    try {
      dynamic jsonResponse = await leadRepositories.fetchleadEditsApi(leadId);
      LeadEditModel leadEdit = LeadEditModel.fromJson(jsonResponse);
      LeadDetail leadDetail = leadEdit.leadDetail!;

      emit(LeadCrudDetailLoaded(leadDetail));
    } catch (e) {
      emit(const LeadCrudFailure(error: 'Api Interaction Failed'));
    }
  }

  Future<void> getLeadDetail(dynamic leadId) async {
    emit(LeadCrudLoading());
    final String userId = await userRepositories.hasUserId();

    try {
      dynamic jsonResponse = await leadRepositories.fetchleadDetailsApi(leadId);
      // LeadEditModel leadEdit = LeadEditModel.fromJson(jsonResponse);
      // LeadDetail leadDetail = leadEdit.leadDetail!;
      final jsonData = LeadDetailsModel.fromJson(jsonResponse);
      LeadDetails leadDetails = jsonData.leadDetails!;
      emit(LeadDetailLoaded(leadDetails));
    } catch (e) {
      emit(const LeadCrudFailure(error: 'Api Interaction Failed'));
    }
  }

  Future<void> uploadLeadEditDetails(dynamic data) async {
    emit(LeadCrudFormLoadinge());
    try {
      await leadRepositories.updateLeadData(data);

      emit(LeadCrudFormSuccess());
    } catch (e) {
      emit(const LeadCrudFormFailure(error: 'Api Interaction Failed'));
    }
  }
}
