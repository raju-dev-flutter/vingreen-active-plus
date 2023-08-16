part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserDetails userDetails;

  const ProfileLoaded(this.userDetails);

  @override
  List<Object> get props => [userDetails];

  @override
  String toString() => 'User Details Loaded {$userDetails}';
}

class ProfileFailure extends ProfileState {
  final String error;

  const ProfileFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => ' Profile {$error}';
}
