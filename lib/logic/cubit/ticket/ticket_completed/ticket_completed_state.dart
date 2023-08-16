part of 'ticket_completed_cubit.dart';

abstract class TicketCompletedState extends Equatable {
  const TicketCompletedState();

  @override
  List<Object> get props => [];
}

class TicketCompletedLoading extends TicketCompletedState {}

class TicketCompletedDetails extends TicketCompletedState {
  final List<Tickets> ticketList;

  const TicketCompletedDetails(this.ticketList);

  @override
  List<Object> get props => [ticketList];
}

class TicketCompletedFailure extends TicketCompletedState {
  final String error;

  const TicketCompletedFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'Task Start Failure: {$error}';
}
