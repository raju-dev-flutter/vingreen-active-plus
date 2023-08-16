import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/models/lead_model.dart';
import '../../../../data/repositories/lead_repositories.dart';
import '../../../../data/repositories/user_repositories.dart';

part 'lead_filter_state.dart';

class LeadFilterCubit extends Cubit<LeadFilterState> {
  final UserRepositories userRepositories;
  final LeadRepositories leadRepositories;

  LeadFilterCubit(
      {required this.userRepositories, required this.leadRepositories})
      : super(LeadFilterLoading());

  Future<void> fetchLeadFilterInitial() async {
    emit(LeadFilterLoading());
    // await taskFilterBloc.fetchTaskList();
    emit(LeadFilterLoaded());
  }

  Future<void> submitLeadFilter(String fromDate, String toDate) async {
    emit(LeadFilterPageLoading());
    final String userId = await userRepositories.hasUserId();
    try {
      final response = await leadRepositories.fetchleadFilterListApi(
          userId, fromDate, toDate);
      emit(LeadFilterPageLoaded(response));
    } catch (e) {
      emit(const LeadFilterPageFailure(error: 'Api Interaction Failed'));
    }
  }
}
