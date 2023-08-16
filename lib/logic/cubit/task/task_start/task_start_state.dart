part of 'task_start_cubit.dart';

abstract class TaskStartState extends Equatable {
  const TaskStartState();

  @override
  List<Object> get props => [];
}

class TaskStartLoading extends TaskStartState {}

class TaskStartDetails extends TaskStartState {
  final List<TaskList> taskList;

  const TaskStartDetails(this.taskList);

  @override
  List<Object> get props => [taskList];
}

class TaskStartFailure extends TaskStartState {
  final String error;

  const TaskStartFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'Task Start Failure: {$error}';
}
