part of 'task_completed_cubit.dart';

abstract class TaskCompletedState extends Equatable {
  const TaskCompletedState();

  @override
  List<Object> get props => [];
}

class TaskCompletedLoading extends TaskCompletedState {}

class TaskCompletedDetails extends TaskCompletedState {
  final List<TaskList> taskList;

  const TaskCompletedDetails(this.taskList);

  @override
  List<Object> get props => [taskList];
}

class TaskCompletedFailure extends TaskCompletedState {
  final String error;

  const TaskCompletedFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'Task Progress Failure: {$error}';
}
