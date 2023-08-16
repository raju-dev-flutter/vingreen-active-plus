part of 'ticket_filter_cubit.dart';

abstract class TicketFilterState extends Equatable {
  const TicketFilterState();

  @override
  List<Object> get props => [];
}

class TicketFilterLoading extends TicketFilterState {}

class TicketFilterLoaded extends TicketFilterState {}

class TicketFilterFailure extends TicketFilterState {}

class TicketFilterPageLoading extends TicketFilterState {}

class TicketFilterPageLoaded extends TicketFilterState {
  final List<Tickets> ticketList;

  const TicketFilterPageLoaded(this.ticketList);

  @override
  List<Object> get props => [ticketList];
}

class TicketFilterPageFailure extends TicketFilterState {
  final String error;

  const TicketFilterPageFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'Ticket Filter Page Failure: {$error}';
}
