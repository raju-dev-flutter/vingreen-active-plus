part of 'profile_update_form_cubit.dart';

abstract class ProfileUpdateFormState extends Equatable {
  const ProfileUpdateFormState();

  @override
  List<Object> get props => [];
}

class UserDetailsLoading extends ProfileUpdateFormState {}

class UserDetailsLoaded extends ProfileUpdateFormState {}

class ProfileUpdateFormLoading extends ProfileUpdateFormState {}

class ProfileUpdateFormSuccess extends ProfileUpdateFormState {}

class ProfileUpdateFormFailure extends ProfileUpdateFormState {
  final String error;

  const ProfileUpdateFormFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'User Edit Failure: {$error}';
}
