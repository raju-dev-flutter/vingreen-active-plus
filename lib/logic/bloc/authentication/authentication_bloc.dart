import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../data/repositories/user_repositories.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepositories userRepositories;
  AuthenticationBloc({required this.userRepositories}) : super(initialState()) {
    on<AuthenticationEvent>(_authenticationEvent);
  }

  static initialState() => AuthenticationUninitialized();

  void _authenticationEvent(
      AuthenticationEvent event, Emitter<AuthenticationState> emit) async {
    if (event is AppStarted) {
      await Future.delayed(const Duration(seconds: 3));
      final bool hasPermissionToken =
          await userRepositories.hasPermissionToken();
      final bool hasToken = await userRepositories.hasToken();
      if (hasPermissionToken) {
        if (hasToken) {
          emit(AuthenticationAuthenticated());
        } else {
          emit(AuthenticationUnauthenticated());
        }
      } else {
        emit(AppPermissionNotGranded());
      }
    }
    if (event is AppPermission) {
      await userRepositories.persistePermissionToken(event.appPermission);
      final bool hasPermissionToken =
          await userRepositories.hasPermissionToken();
      final bool hasToken = await userRepositories.hasToken();
      if (hasPermissionToken) {
        if (hasToken) {
          emit(AuthenticationAuthenticated());
        } else {
          emit(AuthenticationUnauthenticated());
        }
      } else {
        emit(AppPermissionNotGranded());
      }
    }
    if (event is LoggedIn) {
      debugPrint('====== LoggedIn ==========');
      await userRepositories.persisteToken(event.token, event.userId);
      emit(AuthenticationAuthenticated());
    }
    if (event is LoggedOut) {
      // emit(AuthenticationLoading());
      await userRepositories.deleteToken();
      emit(AuthenticationUnauthenticated());
    }
  }
}
