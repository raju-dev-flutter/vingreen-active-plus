import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../data/models/create_new_ticket_model.dart';
import '../../../../data/models/ticket_details_model.dart';
import '../../../../data/repositories/ticket_repositories.dart';
import '../../../../data/repositories/user_repositories.dart';

part 'ticket_crud_state.dart';

class TicketCrudCubit extends Cubit<TicketCrudState> {
  final UserRepositories userRepositories;
  final TicketRepositories ticketRepositories;

  TicketCrudCubit(
      {required this.userRepositories, required this.ticketRepositories})
      : super(TicketCrudLoading());

  Future<void> getTicketDetails(int ticketId) async {
    try {
      dynamic jsonResponse =
          await ticketRepositories.fetchTicketDetailApi(ticketId);
      emit(TicketCrudDetailLoaded(jsonResponse));
    } catch (e) {
      emit(const TicketCrudFailure(error: 'Api Interaction Failed'));
    }
  }

  Future<void> getTicketUpdateDetails(dynamic ticketId) async {
    emit(TicketCrudLoading());
    final String userId = await userRepositories.hasUserId();
    try {
      final jsonResponse =
          await ticketRepositories.fetchTicketUpdateDetailApi(ticketId);
      final ticketUpdate = TicketDetailsModel.fromJson(jsonResponse);

      List<TicketStatus> statusList = ticketUpdate.ticketStatusDetails!;
      late TicketStatus statusListInit;
      debugPrint('statusListLength : ${ticketUpdate.statusId}');
      for (int i = 0; i < statusList.length; i++) {
        if (statusList[i].name == ticketUpdate.statusId!) {
          statusListInit = statusList[i];
          break;
        } else {
          statusListInit = statusList.first;
        }
      }
      emit(TicketCrudUpdate(userId, statusList, statusListInit,
          TextEditingController(text: ticketUpdate.description ?? '')));
    } catch (e) {
      emit(const TicketCrudFailure(error: 'Api Interaction Failed'));
    }
  }

  Future<void> submitTicketUpdateDetails(dynamic data) async {
    emit(TicketCrudFormLoading());
    try {
      await ticketRepositories.updateSubmitDataApi(data);
      emit(TicketCrudFormSuccess());
    } catch (e) {
      emit(const TicketCrudFormFailure(error: 'Api Interaction Failed'));
    }
  }

  Future<void> getCreateNewTicketDetails() async {
    emit(TicketCrudLoading());
    final String userId = await userRepositories.hasUserId();
    try {
      final jsonResponse = await ticketRepositories.fetchtcketAddApi(userId);
      final createNewTicket = CreateNewTicketModel.fromJson(jsonResponse);

      emit(CreateNewTicketLoaded(
          userId: userId,
          subject: TextEditingController(text: ''),
          description: TextEditingController(text: ''),
          clientDetailsList: createNewTicket.clientDetails!,
          customersContactLists: createNewTicket.customersContactLists!,
          ticketTypeDetailsList: createNewTicket.ticketTypeDetails!,
          ticketPriorityDetailsList: createNewTicket.ticketPriorityDetails!,
          ticketSourceDetailsList: createNewTicket.ticketSourceDetails!,
          userDetailsListList: createNewTicket.userDetails!,
          ticketStatusDetailsList: createNewTicket.ticketStatusDetails!,
          ticketCreatedTypeList: createNewTicket.ticketCreatedTypeDetails!,
          clientDetailsListInit: createNewTicket.clientDetails!.first,
          customersContactListsInit:
              createNewTicket.customersContactLists!.first,
          ticketTypeDetailsListInit: createNewTicket.ticketTypeDetails!.first,
          ticketPriorityDetailsListInit:
              createNewTicket.ticketPriorityDetails!.first,
          ticketSourceDetailsListInit:
              createNewTicket.ticketSourceDetails!.first,
          userDetailsListListInit: createNewTicket.userDetails!.first,
          ticketStatusDetailsListInit:
              createNewTicket.ticketStatusDetails!.first,
          ticketCreatedTypeListInit:
              createNewTicket.ticketCreatedTypeDetails!.first));
    } catch (e) {
      emit(const TicketCrudFailure(error: 'Api Interaction Failed'));
    }
  }

  Future<void> submitAddNewTask(dynamic data) async {
    emit(TicketCrudFormLoading());
    try {
      await ticketRepositories.updateAddNewTicket(data);
      emit(TicketCrudFormSuccess());
    } catch (e) {
      emit(const TicketCrudFormFailure(error: 'Api Interaction Failed'));
    }
  }
}
