import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/models/task_detail_model.dart';
import '../../../../data/repositories/task_repositories.dart';
import '../../../../data/repositories/user_repositories.dart';

part 'task_detail_state.dart';

class TaskDetailCubit extends Cubit<TaskDetailState> {
  final TaskRepositories taskRepositories;

  TaskDetailCubit({required this.taskRepositories})
      : super(TaskDetailLoading());

  Future<void> getTaskDetails(int taskId) async {
    try {
      dynamic jsonResponse = await taskRepositories.fetchTaskDetailApi(taskId);
      emit(TaskDetailLoaded(jsonResponse));
    } catch (e) {
      emit(const TaskDetailFailure(error: 'Api Interaction Failed'));
    }
  }
}
