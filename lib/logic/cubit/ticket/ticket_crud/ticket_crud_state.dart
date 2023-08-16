part of 'ticket_crud_cubit.dart';

abstract class TicketCrudState extends Equatable {
  const TicketCrudState();

  @override
  List<Object> get props => [];
}

class TicketCrudLoading extends TicketCrudState {}

class TicketCrudDetailLoaded extends TicketCrudState {
  final TicketDetailsModel ticketDetails;

  const TicketCrudDetailLoaded(this.ticketDetails);

  @override
  List<Object> get props => [ticketDetails];

  @override
  String toString() => 'Ticket Details  : {$ticketDetails}';
}

class TicketCrudFailure extends TicketCrudState {
  final String error;

  const TicketCrudFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'Task Crud Failure: {$error}';
}

class TicketCrudFormLoading extends TicketCrudState {}

class TicketCrudUpdate extends TicketCrudState {
  final String userId;
  final List<TicketStatus> statusList;
  final TicketStatus statusListInit;
  final TextEditingController description;

  const TicketCrudUpdate(
      this.userId, this.statusList, this.statusListInit, this.description);

  @override
  List<Object> get props => [userId, statusList, statusListInit, description];
}

class CreateNewTicketLoaded extends TicketCrudState {
  final String userId;
  final TextEditingController subject;
  final TextEditingController description;

  final List<CommonTicketObj> clientDetailsList;
  final List<CommonTicketObj> customersContactLists;
  final List<CommonTicketObj> ticketTypeDetailsList;
  final List<CommonTicketObj> ticketPriorityDetailsList;
  final List<CommonTicketObj> ticketSourceDetailsList;
  final List<CommonTicketObj> userDetailsListList;
  final List<CommonTicketObj> ticketStatusDetailsList;
  final List<CommonTicketObj> ticketCreatedTypeList;

  final CommonTicketObj clientDetailsListInit;
  final CommonTicketObj customersContactListsInit;
  final CommonTicketObj ticketTypeDetailsListInit;
  final CommonTicketObj ticketPriorityDetailsListInit;
  final CommonTicketObj ticketSourceDetailsListInit;
  final CommonTicketObj userDetailsListListInit;
  final CommonTicketObj ticketStatusDetailsListInit;
  final CommonTicketObj ticketCreatedTypeListInit;

  const CreateNewTicketLoaded(
      {required this.userId,
      required this.subject,
      required this.description,
      required this.clientDetailsList,
      required this.customersContactLists,
      required this.ticketTypeDetailsList,
      required this.ticketPriorityDetailsList,
      required this.ticketSourceDetailsList,
      required this.userDetailsListList,
      required this.ticketStatusDetailsList,
      required this.ticketCreatedTypeList,
      required this.clientDetailsListInit,
      required this.customersContactListsInit,
      required this.ticketTypeDetailsListInit,
      required this.ticketPriorityDetailsListInit,
      required this.ticketSourceDetailsListInit,
      required this.userDetailsListListInit,
      required this.ticketStatusDetailsListInit,
      required this.ticketCreatedTypeListInit});

  @override
  List<Object> get props => [
        userId,
        subject,
        description,
        clientDetailsList,
        customersContactLists,
        ticketTypeDetailsList,
        ticketPriorityDetailsList,
        ticketSourceDetailsList,
        userDetailsListList,
        ticketStatusDetailsList,
        ticketCreatedTypeList,
        clientDetailsListInit,
        customersContactListsInit,
        ticketTypeDetailsListInit,
        ticketPriorityDetailsListInit,
        ticketSourceDetailsListInit,
        userDetailsListListInit,
        ticketStatusDetailsListInit,
        ticketCreatedTypeListInit
      ];
}

class TicketCrudFormSuccess extends TicketCrudState {}

class TicketCrudFormFailure extends TicketCrudState {
  final String error;

  const TicketCrudFormFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'Task Crud Form Failure: {$error}';
}
