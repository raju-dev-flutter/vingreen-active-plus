import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/models/lead_model.dart';
import '../../../../data/repositories/lead_repositories.dart';
import '../../../../data/repositories/user_repositories.dart';

part 'call_again_lead_state.dart';

class CallAgainLeadCubit extends Cubit<CallAgainLeadState> {
  final UserRepositories userRepositories;
  final LeadRepositories leadRepositories;

  CallAgainLeadCubit(
      {required this.userRepositories, required this.leadRepositories})
      : super(CallAgainLeadLoading());

  Future<void> getCallAgainLead() async {
    final String userId = await userRepositories.hasUserId();

    const int pageSize = 10;
    const int pageKey = 1;

    try {
      dynamic jsonResponse =
          await leadRepositories.fetchleadListApi(userId, pageKey, pageSize, 2);
      emit(CallAgainLeadDetailLoaded(jsonResponse));
    } catch (e) {
      emit(const CallAgainLeadFailure(error: 'Api Interaction Failed'));
    }
  }
}
