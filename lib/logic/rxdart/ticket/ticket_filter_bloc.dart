import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../data/models/create_new_ticket_model.dart';
import '../../../data/repositories/ticket_repositories.dart';
import '../../../data/repositories/user_repositories.dart';
import '../../cubit/ticket/ticket_filter/ticket_filter_cubit.dart';

class TicketFilterBloc {
  final userRepositories = UserRepositories();
  final ticketRepositories = TicketRepositories();
  List<int> selectedClientList = [];

  final _startDate = BehaviorSubject<DateTime>();
  final _selectedStartDate = BehaviorSubject<String>();

  final _endDate = BehaviorSubject<DateTime>();
  final _selectedEndDate = BehaviorSubject<String>();

  late List<CommonTicketObj> client = [];

  // final _clientList = BehaviorSubject<List<CommonTicketObj>>.seeded([]);
  final _selectClientListFilter =
      BehaviorSubject<List<CommonTicketObj>>.seeded([]);

  late List<CommonTicketObj> priority = [];

  // final _priorityList = BehaviorSubject<List<CommonTicketObj>>.seeded([]);
  final _selectPriorityListFilter =
      BehaviorSubject<List<CommonTicketObj>>.seeded([]);

  // ValueStream<List<CommonTicketObj>> get clientList => _clientList.stream;

  Stream<List<CommonTicketObj>> get selectClientListFilter =>
      _selectClientListFilter.stream;

  // Stream<List<CommonTicketObj>> get prList => _priorityList.stream;

  Stream<List<CommonTicketObj>> get selectProjectListFilter =>
      _selectPriorityListFilter.stream;

  ValueStream<DateTime> get startDate => _startDate.stream;

  ValueStream<String> get selectedStartDate => _selectedStartDate.stream;

  ValueStream<DateTime> get endDate => _endDate.stream;

  ValueStream<String> get selectedEndDate => _selectedEndDate.stream;

  Future<void> fetchTicketList() async {
    debugPrint('===============');
    final userId = await userRepositories.hasUserId();
    dynamic response = await ticketRepositories.fetchtcketAddApi(userId);
    CreateNewTicketModel ticketModel = CreateNewTicketModel.fromJson(response);
    client = ticketModel.clientDetails ?? [];
    priority = ticketModel.ticketPriorityDetails ?? [];
    // _clientList.sink.add(ticketModel.clientDetails ?? []);
    // _priorityList.sink.add(ticketModel.ticketPriorityDetails ?? []);
    // debugPrint('========${_clientList.value.last.name}=======');
  }

  void selectStartDate(DateTime date) {
    List<String> splitDateTime = date.toString().split(' ');
    _startDate.sink.add(date);
    _selectedStartDate.sink.add(splitDateTime[0]);
  }

  void selectEndDate(DateTime date) {
    List<String> splitDateTime = date.toString().split(' ');
    _endDate.sink.add(date);
    _selectedEndDate.sink.add(splitDateTime[0]);
  }

  void updateClientListSelectedFilters(CommonTicketObj filter) {
    List<CommonTicketObj> currentFilters = _selectClientListFilter.value;
    if (currentFilters.contains(filter)) {
      currentFilters.remove(filter);
    } else {
      currentFilters.add(filter);
    }
    _selectClientListFilter.add(currentFilters);

    for (var i = 0; i < _selectClientListFilter.value.length; i++) {
      debugPrint(_selectClientListFilter.value[i].name.toString());
    }
  }

  void updatePriorityListSelectedFilters(CommonTicketObj filter) {
    List<CommonTicketObj> currentFilters = _selectPriorityListFilter.value;
    if (currentFilters.contains(filter)) {
      currentFilters.remove(filter);
    } else {
      currentFilters.add(filter);
    }
    _selectPriorityListFilter.add(currentFilters);

    for (var i = 0; i < _selectPriorityListFilter.value.length; i++) {
      debugPrint(_selectPriorityListFilter.value[i].name.toString());
    }
  }

  Future<void> fetchTicketFilterLoaded(BuildContext context) async {
    final ticketFilterCubit =
        BlocProvider.of<TicketFilterCubit>(context, listen: false);

    List<int> clientListFilter = [];
    List<int> priorityListFilter = [];
    for (var i = 0; i < _selectClientListFilter.value.length; i++) {
      clientListFilter.add(_selectClientListFilter.value[i].id!);
    }
    for (var i = 0; i < _selectPriorityListFilter.value.length; i++) {
      priorityListFilter.add(_selectPriorityListFilter.value[i].id!);
    }

    ticketFilterCubit.submitTicketFilter(_selectedStartDate.valueOrNull!,
        _selectedEndDate.valueOrNull!, clientListFilter, priorityListFilter);
  }
}
