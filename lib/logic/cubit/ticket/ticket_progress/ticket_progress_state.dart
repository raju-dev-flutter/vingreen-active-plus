part of 'ticket_progress_cubit.dart';

abstract class TicketProgressState extends Equatable {
  const TicketProgressState();

  @override
  List<Object> get props => [];
}

class TicketProgressLoading extends TicketProgressState {}

class TicketProgressDetails extends TicketProgressState {
  final List<Tickets> ticketList;

  const TicketProgressDetails(this.ticketList);

  @override
  List<Object> get props => [ticketList];
}

class TicketProgressFailure extends TicketProgressState {
  final String error;

  const TicketProgressFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'Task Start Failure: {$error}';
}
