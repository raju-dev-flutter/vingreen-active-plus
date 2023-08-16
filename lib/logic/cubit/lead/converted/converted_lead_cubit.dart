import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/models/lead_model.dart';
import '../../../../data/repositories/lead_repositories.dart';
import '../../../../data/repositories/user_repositories.dart';

part 'converted_lead_state.dart';

class ConvertedLeadCubit extends Cubit<ConvertedLeadState> {
  final UserRepositories userRepositories;
  final LeadRepositories leadRepositories;

  ConvertedLeadCubit(
      {required this.userRepositories, required this.leadRepositories})
      : super(ConvertedLeadLoading());

  Future<void> getConvertedLead() async {
    final String userId = await userRepositories.hasUserId();

    const int pageSize = 10;
    const int pageKey = 1;

    try {
      dynamic jsonResponse =
          await leadRepositories.fetchleadListApi(userId, pageKey, pageSize, 4);
      emit(ConvertedLeadDetailLoaded(jsonResponse));
    } catch (e) {
      emit(const ConvertedLeadFailure(error: 'Api Interaction Failed'));
    }
  }
}
