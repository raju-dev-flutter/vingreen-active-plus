import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/models/task_model.dart';
import '../../../../data/repositories/task_repositories.dart';
import '../../../../data/repositories/user_repositories.dart';

part 'task_progress_state.dart';

class TaskProgressCubit extends Cubit<TaskProgressState> {
  final UserRepositories userRepositories;
  final TaskRepositories taskRepositories;

  TaskProgressCubit(
      {required this.userRepositories, required this.taskRepositories})
      : super(TaskProgressLoading());

  Future<void> getTaskProgressDetails() async {
    final String userId = await userRepositories.hasUserId();

    try {
      dynamic jsonResponse = await taskRepositories.fetchTaskListApi(userId, 2);
      emit(TaskProgressDetails(jsonResponse));
    } catch (e) {
      emit(const TaskProgressFailure(error: 'Api Interaction Failed'));
    }
  }
}
