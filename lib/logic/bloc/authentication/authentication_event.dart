part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {
  @override
  String toString() => 'AppStarted';
}

class AppPermission extends AuthenticationEvent {
  final String appPermission;
  const AppPermission({required this.appPermission});

  @override
  List<Object> get props => [appPermission];

  @override
  String toString() => 'App Permission {$appPermission}';
}

class LoggedIn extends AuthenticationEvent {
  final String token;
  final String userId;
  const LoggedIn({required this.token, required this.userId});

  @override
  List<Object> get props => [token];

  @override
  String toString() => 'LoggedIn {$token}';
}

class LoggedOut extends AuthenticationEvent {}
