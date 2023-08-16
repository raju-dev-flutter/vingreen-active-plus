part of 'task_crud_cubit.dart';

abstract class TaskCrudState extends Equatable {
  const TaskCrudState();

  @override
  List<Object> get props => [];
}

class TaskCrudLoading extends TaskCrudState {}

class TaskFilterInitial extends TaskCrudState {}

class TaskFilterLoading extends TaskCrudState {}

class TaskFilterLoaded extends TaskCrudState {}

class TaskFilterFailure extends TaskCrudState {}

class TaskUpdateLoaded extends TaskCrudState {
  final String userId;
  final List<StatusList> statusList;
  final StatusList statusListInit;
  final TextEditingController description;

  const TaskUpdateLoaded(this.userId, this.statusList, this.statusListInit,
      this.description);

  @override
  List<Object> get props => [userId, statusList, statusListInit, description];
}

class CreateNewTaskLoaded extends TaskCrudState {
  final String userId;
  final TextEditingController taskName;
  final TextEditingController description;

  final List<CommonList> clientDetailsList;
  final List<CommonList> projectDetailsList;
  final List<CommonList> statusDetailsList;
  final List<CommonList> priorityDetailsList;
  final List<CommonList> userDetailsList;

  final CommonList clientDetailsListInit;
  final CommonList projectDetailsListInit;
  final CommonList statusDetailsListInit;
  final CommonList priorityDetailsListInit;
  final CommonList userDetailsListInit;

  const CreateNewTaskLoaded({
    required this.userId,
    required this.taskName,
    required this.description,
    required this.clientDetailsList,
    required this.projectDetailsList,
    required this.statusDetailsList,
    required this.priorityDetailsList,
    required this.userDetailsList,
    required this.clientDetailsListInit,
    required this.projectDetailsListInit,
    required this.statusDetailsListInit,
    required this.priorityDetailsListInit,
    required this.userDetailsListInit,
  });

  @override
  List<Object> get props =>
      [
        userId,
        taskName,
        description,
        clientDetailsList,
        projectDetailsList,
        statusDetailsList,
        priorityDetailsList,
        userDetailsList,
        clientDetailsListInit,
        projectDetailsListInit,
        statusDetailsListInit,
        priorityDetailsListInit,
        userDetailsListInit,
      ];
}

class TaskCrudFailure extends TaskCrudState {
  final String error;

  const TaskCrudFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'Task Crud Failure: {$error}';
}

class TaskCrudFormLoading extends TaskCrudState {}

class TaskCrudFormSuccess extends TaskCrudState {}

class TaskCrudFormFailure extends TaskCrudState {
  final String error;

  const TaskCrudFormFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'Task Crud Form Failure: {$error}';
}
