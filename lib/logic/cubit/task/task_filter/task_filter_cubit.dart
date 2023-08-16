import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/models/task_model.dart';
import '../../../../data/repositories/task_repositories.dart';
import '../../../../data/repositories/user_repositories.dart';
import '../../../rxdart/task/task_filter_bloc.dart';

part 'task_filter_state.dart';

class TaskFilterCubit extends Cubit<TaskFilterState> {
  final UserRepositories userRepositories;
  final TaskRepositories taskRepositories;
  final TaskFilterBloc taskFilterBloc = TaskFilterBloc();

  TaskFilterCubit(
      {required this.userRepositories, required this.taskRepositories})
      : super(TaskFilterLoading());

  Future<void> fetchTaskFilterInitial() async {
    emit(TaskFilterLoading());
    await taskFilterBloc.fetchTaskList();
    emit(TaskFilterLoaded());
  }

  Future<void> submitTaskFilter(String fromDate, String toDate,
      List<dynamic> clientId, List<dynamic> priorityId) async {
    emit(TaskFilterPageLoading());
    final String userId = await userRepositories.hasUserId();
    try {
      final response = await taskRepositories.fetchTaskFilterListApi(
          userId, fromDate, toDate, clientId, priorityId);
      emit(TaskFilterPageLoaded(response));
    } catch (e) {
      emit(const TaskFilterPageFailure(error: 'Api Interaction Failed'));
    }
  }
}
