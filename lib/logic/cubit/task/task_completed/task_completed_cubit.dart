import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/models/task_model.dart';
import '../../../../data/repositories/task_repositories.dart';
import '../../../../data/repositories/user_repositories.dart';

part 'task_completed_state.dart';

class TaskCompletedCubit extends Cubit<TaskCompletedState> {
  final UserRepositories userRepositories;
  final TaskRepositories taskRepositories;

  TaskCompletedCubit(
      {required this.userRepositories, required this.taskRepositories})
      : super(TaskCompletedLoading());

  Future<void> getTaskCompletedDetails() async {
    final String userId = await userRepositories.hasUserId();

    try {
      dynamic jsonResponse = await taskRepositories.fetchTaskListApi(userId, 5);
      emit(TaskCompletedDetails(jsonResponse));
    } catch (e) {
      emit(const TaskCompletedFailure(error: 'Api Interaction Failed'));
    }
  }
}
