part of 'task_filter_cubit.dart';

abstract class TaskFilterState extends Equatable {
  const TaskFilterState();

  @override
  List<Object> get props => [];
}

class TaskFilterLoading extends TaskFilterState {}

class TaskFilterLoaded extends TaskFilterState {}

class TaskFilterFailure extends TaskFilterState {}

class TaskFilterPageLoading extends TaskFilterState {}

class TaskFilterPageLoaded extends TaskFilterState {
  final List<TaskList> taskList;

  const TaskFilterPageLoaded(this.taskList);

  @override
  List<Object> get props => [taskList];
}

class TaskFilterPageFailure extends TaskFilterState {
  final String error;

  const TaskFilterPageFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'Task Crud Form Failure: {$error}';
}

// class TaskFilterFormLoading extends TaskFilterState {}
//
// class TaskFilterFormSuccess extends TaskFilterState {}
//
// class TaskFilterFormFailure extends TaskFilterState {
//   final String error;
//
//   const TaskFilterFormFailure({required this.error});
//
//   @override
//   List<Object> get props => [error];
//
//   @override
//   String toString() => 'Task Crud Form Failure: {$error}';
// }
