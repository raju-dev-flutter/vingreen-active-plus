import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../data/repositories/lead_repositories.dart';
import '../../../data/repositories/user_repositories.dart';
import '../../cubit/lead/lead_filter/lead_filter_cubit.dart';

class LeadFilterBloc {
  final userRepositories = UserRepositories();
  final leadRepositories = LeadRepositories();
  List<int> selectedClientList = [];

  final _startDate = BehaviorSubject<DateTime>();
  final _selectedStartDate = BehaviorSubject<String>();

  final _endDate = BehaviorSubject<DateTime>();
  final _selectedEndDate = BehaviorSubject<String>();

  ValueStream<DateTime> get startDate => _startDate.stream;

  ValueStream<String> get selectedStartDate => _selectedStartDate.stream;

  ValueStream<DateTime> get endDate => _endDate.stream;

  ValueStream<String> get selectedEndDate => _selectedEndDate.stream;

  // Future<void> fetchLeadList() async {
  //   debugPrint('===============');
  //   final userId = await userRepositories.hasUserId();
  //   dynamic response = await taskRepositories.fetchCreateNewTaskApi(userId);
  //   CreateNewTaskModel taskModel = CreateNewTaskModel.fromJson(response);
  //   client = taskModel.clientDetails ?? [];
  //   project = taskModel.projectDetails ?? [];
  //   _clientList.sink.add(taskModel.clientDetails ?? []);
  //   _projectList.sink.add(taskModel.projectDetails ?? []);
  //   debugPrint('========${_clientList.value.last.name}=======');
  // }

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

  // void updateClientListSelectedFilters(CommonList filter) {
  //   List<CommonList> currentFilters = _selectClientListFilter.value;
  //   if (currentFilters.contains(filter)) {
  //     currentFilters.remove(filter);
  //   } else {
  //     currentFilters.add(filter);
  //   }
  //   _selectClientListFilter.add(currentFilters);
  //
  //   for (var i = 0; i < _selectClientListFilter.value.length; i++) {
  //     debugPrint(_selectClientListFilter.value[i].name.toString());
  //   }
  // }
  //
  // void updateProjectListSelectedFilters(CommonList filter) {
  //   List<CommonList> currentFilters = _selectProjectListFilter.value;
  //   if (currentFilters.contains(filter)) {
  //     currentFilters.remove(filter);
  //   } else {
  //     currentFilters.add(filter);
  //   }
  //   _selectProjectListFilter.add(currentFilters);
  //
  //   for (var i = 0; i < _selectProjectListFilter.value.length; i++) {
  //     debugPrint(_selectProjectListFilter.value[i].name.toString());
  //   }
  // }

  Future<void> fetchLeadFilterLoaded(BuildContext context) async {
    final leadFilterCubit =
        BlocProvider.of<LeadFilterCubit>(context, listen: false);

    // List<int> clientListFilter = [];
    // List<int> projectListFilter = [];
    // for (var i = 0; i < _selectClientListFilter.value.length; i++) {
    //   clientListFilter.add(_selectClientListFilter.value[i].id!);
    // }
    // for (var i = 0; i < _selectProjectListFilter.value.length; i++) {
    //   projectListFilter.add(_selectProjectListFilter.value[i].id!);
    // }

    leadFilterCubit.submitLeadFilter(
      _selectedStartDate.valueOrNull!,
      _selectedEndDate.valueOrNull!,
    );
  }
}
