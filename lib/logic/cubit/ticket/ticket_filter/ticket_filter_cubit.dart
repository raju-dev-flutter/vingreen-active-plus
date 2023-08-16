import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/models/ticket_model.dart';
import '../../../../data/repositories/ticket_repositories.dart';
import '../../../../data/repositories/user_repositories.dart';
import '../../../rxdart/ticket/ticket_filter_bloc.dart';

part 'ticket_filter_state.dart';

class TicketFilterCubit extends Cubit<TicketFilterState> {
  final UserRepositories userRepositories;
  final TicketRepositories ticketRepositories;

  final TicketFilterBloc ticketFilterBloc = TicketFilterBloc();

  TicketFilterCubit(
      {required this.userRepositories, required this.ticketRepositories})
      : super(TicketFilterLoading());

  Future<void> fetchTicketFilterInitial() async {
    emit(TicketFilterLoading());
    await ticketFilterBloc.fetchTicketList();
    emit(TicketFilterLoaded());
  }

  Future<void> submitTicketFilter(String fromDate, String toDate,
      List<dynamic> clientId, List<dynamic> priorityId) async {
    emit(TicketFilterPageLoading());
    final String userId = await userRepositories.hasUserId();
    try {
      final response = await ticketRepositories.fetchTicketsFilterListApi(
          userId, fromDate, toDate, clientId, priorityId);
      emit(TicketFilterPageLoaded(response));
    } catch (e) {
      emit(const TicketFilterPageFailure(error: 'Api Interaction Failed'));
    }
  }
}
