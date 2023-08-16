import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../data/models/create_new_task_modelo.dart';
import '../../../data/repositories/task_repositories.dart';
import '../../../data/repositories/user_repositories.dart';
import '../../cubit/task/task_filter/task_filter_cubit.dart';

class TaskFilterBloc {
  final userRepositories = UserRepositories();
  final taskRepositories = TaskRepositories();
  List<int> selectedClientList = [];

  final _startDate = BehaviorSubject<DateTime>();
  final _selectedStartDate = BehaviorSubject<String>();

  final _endDate = BehaviorSubject<DateTime>();
  final _selectedEndDate = BehaviorSubject<String>();

  late List<CommonList> client = [];
  final _clientList = BehaviorSubject<List<CommonList>>.seeded([]);
  final _selectClientListFilter = BehaviorSubject<List<CommonList>>.seeded([]);

  late List<CommonList> project = [];
  final _projectList = BehaviorSubject<List<CommonList>>.seeded([]);
  final _selectProjectListFilter = BehaviorSubject<List<CommonList>>.seeded([]);

  ValueStream<List<CommonList>> get clientList => _clientList.stream;

  Stream<List<CommonList>> get selectClientListFilter =>
      _selectClientListFilter.stream;

  Stream<List<CommonList>> get projectList => _projectList.stream;

  Stream<List<CommonList>> get selectProjectListFilter =>
      _selectProjectListFilter.stream;

  ValueStream<DateTime> get startDate => _startDate.stream;

  ValueStream<String> get selectedStartDate => _selectedStartDate.stream;

  ValueStream<DateTime> get endDate => _endDate.stream;

  ValueStream<String> get selectedEndDate => _selectedEndDate.stream;

  Future<void> fetchTaskList() async {
    debugPrint('===============');
    final userId = await userRepositories.hasUserId();
    dynamic response = await taskRepositories.fetchCreateNewTaskApi(userId);
    CreateNewTaskModel taskModel = CreateNewTaskModel.fromJson(response);
    client = taskModel.clientDetails ?? [];
    project = taskModel.projectDetails ?? [];
    _clientList.sink.add(taskModel.clientDetails ?? []);
    _projectList.sink.add(taskModel.projectDetails ?? []);
    debugPrint('========${_clientList.value.last.name}=======');
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

  void updateClientListSelectedFilters(CommonList filter) {
    List<CommonList> currentFilters = _selectClientListFilter.value;
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

  void updateProjectListSelectedFilters(CommonList filter) {
    List<CommonList> currentFilters = _selectProjectListFilter.value;
    if (currentFilters.contains(filter)) {
      currentFilters.remove(filter);
    } else {
      currentFilters.add(filter);
    }
    _selectProjectListFilter.add(currentFilters);

    for (var i = 0; i < _selectProjectListFilter.value.length; i++) {
      debugPrint(_selectProjectListFilter.value[i].name.toString());
    }
  }

  Future<void> fetchTaskFilterLoaded(BuildContext context) async {
    final taskFilterCubit =
        BlocProvider.of<TaskFilterCubit>(context, listen: false);

    List<int> clientListFilter = [];
    List<int> projectListFilter = [];
    for (var i = 0; i < _selectClientListFilter.value.length; i++) {
      clientListFilter.add(_selectClientListFilter.value[i].id!);
    }
    for (var i = 0; i < _selectProjectListFilter.value.length; i++) {
      projectListFilter.add(_selectProjectListFilter.value[i].id!);
    }

    taskFilterCubit.submitTaskFilter(_selectedStartDate.valueOrNull!,
        _selectedEndDate.valueOrNull!, clientListFilter, projectListFilter);
  }
}
