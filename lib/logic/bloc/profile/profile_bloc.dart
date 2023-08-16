import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/user_detail_model.dart';
import '../../../data/repositories/profile_repositories.dart';
import '../../../data/repositories/user_repositories.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepositories userRepositories;
  final ProfileRepositories profileRepositories;

  ProfileBloc(
      {required this.userRepositories, required this.profileRepositories})
      : super(ProfileLoading()) {
    on<ProfileEvent>((event, emit) async {
      if (event is ProfileStatus) {
        // emit(ProfileLoading());
        final String userId = await userRepositories.hasUserId();

        try {
          dynamic jsonResponse =
              await profileRepositories.fetchUserDetailsApi(userId);
          emit(ProfileLoaded(jsonResponse));
        } catch (e) {
          emit(const ProfileFailure(error: 'Api Interaction Failed'));
        }
      }
    });
  }
}
