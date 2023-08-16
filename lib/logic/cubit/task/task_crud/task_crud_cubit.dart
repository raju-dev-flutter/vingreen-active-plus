import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../data/models/create_new_task_modelo.dart';
import '../../../../data/models/task_update_model.dart';
import '../../../../data/repositories/task_repositories.dart';
import '../../../../data/repositories/user_repositories.dart';
import '../../../rxdart/task/task_filter_bloc.dart';

part 'task_crud_state.dart';

class TaskCrudCubit extends Cubit<TaskCrudState> {
  final UserRepositories userRepositories;
  final TaskRepositories taskRepositories;
  final TaskFilterBloc taskFilterBloc = TaskFilterBloc();

  TaskCrudCubit(
      {required this.userRepositories, required this.taskRepositories})
      : super(TaskCrudLoading());

  Future<void> getUpdateDetails(dynamic taskId) async {
    emit(TaskCrudLoading());
    final String userId = await userRepositories.hasUserId();
    try {
      final jsonResponse = await taskRepositories.fetchTaskUpdateApi(taskId);
      TaskUpdate taskUpdate = TaskUpdate.fromJson(jsonResponse);

      List<StatusList> statusList = taskUpdate.statusList;
      late StatusList statusListInit;
      debugPrint('statusListLength : ${statusList.length}');
      for (int i = 0; i < statusList.length; i++) {
        if (statusList[i].id == int.parse(taskUpdate.taskStatus!)) {
          statusListInit = statusList[i];
          break;
        } else {
          statusListInit = statusList.first;
        }
      }
      emit(TaskUpdateLoaded(userId, statusList, statusListInit,
          TextEditingController(text: taskUpdate.description ?? '')));
    } catch (e) {
      emit(const TaskCrudFailure(error: 'Api Interaction Failed'));
    }
  }

  Future<void> submitTaskUpdateDetails(dynamic data) async {
    emit(TaskCrudFormLoading());
    try {
      await taskRepositories.fetchTaskUpdateSubmitApi(data);
      emit(TaskCrudFormSuccess());
    } catch (e) {
      emit(const TaskCrudFormFailure(error: 'Api Interaction Failed'));
    }
  }

  Future<void> getCreateNewTaskDetails() async {
    emit(TaskCrudLoading());
    final String userId = await userRepositories.hasUserId();
    try {
      final jsonResponse = await taskRepositories.fetchCreateNewTaskApi(userId);
      CreateNewTaskModel createNewTask =
          CreateNewTaskModel.fromJson(jsonResponse);

      emit(CreateNewTaskLoaded(
        userId: userId,
        taskName: TextEditingController(text: ''),
        description: TextEditingController(text: ''),
        clientDetailsList: createNewTask.clientDetails!,
        projectDetailsList: createNewTask.projectDetails!,
        statusDetailsList: createNewTask.statusDetails!,
        priorityDetailsList: createNewTask.taskPriorityDetails!,
        userDetailsList: createNewTask.userDetails!,
        clientDetailsListInit: createNewTask.clientDetails!.first,
        projectDetailsListInit: createNewTask.projectDetails!.first,
        statusDetailsListInit: createNewTask.statusDetails!.first,
        priorityDetailsListInit: createNewTask.taskPriorityDetails!.first,
        userDetailsListInit: createNewTask.userDetails!.first,
      ));
    } catch (e) {
      emit(const TaskCrudFailure(error: 'Api Interaction Failed'));
    }
  }

  Future<void> submitCreateNewTask(dynamic data) async {
    emit(TaskCrudFormLoading());
    try {
      await taskRepositories.fetchCreateNewTaskSubmitApi(data);
      emit(TaskCrudFormSuccess());
    } catch (e) {
      emit(const TaskCrudFormFailure(error: 'Api Interaction Failed'));
    }
  }
}
