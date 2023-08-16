import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/models/lead_model.dart';
import '../../../../data/repositories/lead_repositories.dart';
import '../../../../data/repositories/user_repositories.dart';

part 'reconnect_lead_state.dart';

class ReconnectLeadCubit extends Cubit<ReconnectLeadState> {
  final UserRepositories userRepositories;
  final LeadRepositories leadRepositories;

  ReconnectLeadCubit(
      {required this.userRepositories, required this.leadRepositories})
      : super(ReconnectLeadLoading());

  Future<void> getReconnectLead() async {
    final String userId = await userRepositories.hasUserId();

    const int pageSize = 10;
    const int pageKey = 1;

    try {
      dynamic jsonResponse =
          await leadRepositories.fetchleadListApi(userId, pageKey, pageSize, 3);
      emit(ReconnectLeadDetailLoaded(jsonResponse));
    } catch (e) {
      emit(const ReconnectLeadFailure(error: 'Api Interaction Failed'));
    }
  }
}
