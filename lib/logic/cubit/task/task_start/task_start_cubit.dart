import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/models/task_model.dart';
import '../../../../data/repositories/task_repositories.dart';
import '../../../../data/repositories/user_repositories.dart';

part 'task_start_state.dart';

class TaskStartCubit extends Cubit<TaskStartState> {
  final UserRepositories userRepositories;
  final TaskRepositories taskRepositories;

  TaskStartCubit(
      {required this.userRepositories, required this.taskRepositories})
      : super(TaskStartLoading());

  Future<void> getTaskStartDetails() async {
    final String userId = await userRepositories.hasUserId();

    try {
      dynamic jsonResponse = await taskRepositories.fetchTaskListApi(userId, 1);
      emit(TaskStartDetails(jsonResponse));
    } catch (e) {
      emit(const TaskStartFailure(error: 'Api Interaction Failed'));
    }
  }
}
