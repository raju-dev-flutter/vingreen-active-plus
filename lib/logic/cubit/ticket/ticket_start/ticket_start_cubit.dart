import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/models/ticket_model.dart';
import '../../../../data/repositories/ticket_repositories.dart';
import '../../../../data/repositories/user_repositories.dart';

part 'ticket_start_state.dart';

class TicketStartCubit extends Cubit<TicketStartState> {
  final UserRepositories userRepositories;
  final TicketRepositories ticketRepositories;

  TicketStartCubit(
      {required this.userRepositories, required this.ticketRepositories})
      : super(TicketStartLoading());

  Future<void> getTicketStartDetails() async {
    final String userId = await userRepositories.hasUserId();

    try {
      dynamic jsonResponse =
          await ticketRepositories.fetchTicketsApi(userId, 1);
      emit(TicketStartDetails(jsonResponse));
    } catch (e) {
      emit(const TicketStartFailure(error: 'Api Interaction Failed'));
    }
  }
}
