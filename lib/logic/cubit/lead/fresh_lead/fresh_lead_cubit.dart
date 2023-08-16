import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/models/lead_model.dart';
import '../../../../data/repositories/lead_repositories.dart';
import '../../../../data/repositories/user_repositories.dart';

part 'fresh_lead_state.dart';

class FreshLeadCubit extends Cubit<FreshLeadState> {
  final UserRepositories userRepositories;
  final LeadRepositories leadRepositories;

  FreshLeadCubit(
      {required this.userRepositories, required this.leadRepositories})
      : super(FreshLeadLoading());

  Future<void> getFreshLead() async {
    final String userId = await userRepositories.hasUserId();

    const int pageSize = 10;
    const int pageKey = 1;

    try {
      dynamic jsonResponse =
          await leadRepositories.fetchleadListApi(userId, pageKey, pageSize, 1);
      emit(FreshLeadDetailLoaded(jsonResponse));
    } catch (e) {
      emit(const FreshLeadFailure(error: 'Api Interaction Failed'));
    }
  }
}
