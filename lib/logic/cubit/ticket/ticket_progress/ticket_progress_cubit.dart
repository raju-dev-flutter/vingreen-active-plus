import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/models/ticket_model.dart';
import '../../../../data/repositories/ticket_repositories.dart';
import '../../../../data/repositories/user_repositories.dart';

part 'ticket_progress_state.dart';

class TicketProgressCubit extends Cubit<TicketProgressState> {
  final UserRepositories userRepositories;
  final TicketRepositories ticketRepositories;

  TicketProgressCubit(
      {required this.userRepositories, required this.ticketRepositories})
      : super(TicketProgressLoading());

  Future<void> getTicketProgressDetails() async {
    final String userId = await userRepositories.hasUserId();

    try {
      dynamic jsonResponse =
          await ticketRepositories.fetchTicketsApi(userId, 4);
      emit(TicketProgressDetails(jsonResponse));
    } catch (e) {
      emit(const TicketProgressFailure(error: 'Api Interaction Failed'));
    }
  }
}
