import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../data/models/user_detail_model.dart';
import '../../../data/repositories/profile_repositories.dart';
import '../../../data/repositories/user_repositories.dart';
import '../../rxdart/profile/profile_update.dart';

part 'profile_update_form_state.dart';

class ProfileUpdateFormCubit extends Cubit<ProfileUpdateFormState> {
  final UserRepositories userRepositories;
  final ProfileRepositories profileRepositories;

  ProfileUpdateFormCubit(
      {required this.userRepositories, required this.profileRepositories})
      : super(ProfileUpdateFormLoading());

  Future<void> getUserDetails() async {
    emit(UserDetailsLoading());
    final String userId = await userRepositories.hasUserId();

    emit(UserDetailsLoaded());
  }

  Future<void> uploadUserDetails(
      dynamic data, dynamic userId, dynamic attachment) async {
    emit(ProfileUpdateFormLoading());
    try {
      await profileRepositories.fatchUploadUserDetails(data);
      attachment != null
          ? await profileRepositories.fatchUploadUserImage(userId, attachment)
          : null;
      emit(ProfileUpdateFormSuccess());
    } catch (e) {
      emit(const ProfileUpdateFormFailure(error: 'Api Interaction Failed'));
    }
  }
}
