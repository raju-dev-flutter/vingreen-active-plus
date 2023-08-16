part of 'task_progress_cubit.dart';

abstract class TaskProgressState extends Equatable {
  const TaskProgressState();

  @override
  List<Object> get props => [];
}

class TaskProgressLoading extends TaskProgressState {}

class TaskProgressDetails extends TaskProgressState {
  final List<TaskList> taskList;

  const TaskProgressDetails(this.taskList);

  @override
  List<Object> get props => [taskList];
}

class TaskProgressFailure extends TaskProgressState {
  final String error;

  const TaskProgressFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'Task Progress Failure: {$error}';
}
