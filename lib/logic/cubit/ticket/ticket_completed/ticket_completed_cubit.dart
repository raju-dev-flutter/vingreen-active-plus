import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/models/ticket_model.dart';
import '../../../../data/repositories/ticket_repositories.dart';
import '../../../../data/repositories/user_repositories.dart';

part 'ticket_completed_state.dart';

class TicketCompletedCubit extends Cubit<TicketCompletedState> {
  final UserRepositories userRepositories;
  final TicketRepositories ticketRepositories;

  TicketCompletedCubit(
      {required this.userRepositories, required this.ticketRepositories})
      : super(TicketCompletedLoading());

  Future<void> getTicketCompletedDetails() async {
    final String userId = await userRepositories.hasUserId();

    try {
      dynamic jsonResponse =
          await ticketRepositories.fetchTicketsApi(userId, 5);
      emit(TicketCompletedDetails(jsonResponse));
    } catch (e) {
      emit(const TicketCompletedFailure(error: 'Api Interaction Failed'));
    }
  }
}
