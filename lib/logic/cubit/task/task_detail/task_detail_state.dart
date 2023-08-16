part of 'task_detail_cubit.dart';

abstract class TaskDetailState extends Equatable {
  const TaskDetailState();

  @override
  List<Object> get props => [];
}

class TaskDetailLoading extends TaskDetailState {}

class TaskDetailLoaded extends TaskDetailState {
  final TaskDetailModel taskDetail;

  const TaskDetailLoaded(this.taskDetail);

  @override
  List<Object> get props => [taskDetail];
}

class TaskDetailFailure extends TaskDetailState {
  final String error;

  const TaskDetailFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'Task Detail Failure: {$error}';
}
