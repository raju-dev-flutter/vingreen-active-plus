part of 'ticket_start_cubit.dart';

abstract class TicketStartState extends Equatable {
  const TicketStartState();

  @override
  List<Object> get props => [];
}

class TicketStartLoading extends TicketStartState {}

class TicketStartDetails extends TicketStartState {
  final List<Tickets> ticketList;

  const TicketStartDetails(this.ticketList);

  @override
  List<Object> get props => [ticketList];
}

class TicketStartFailure extends TicketStartState {
  final String error;

  const TicketStartFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'Task Start Failure: {$error}';
}
