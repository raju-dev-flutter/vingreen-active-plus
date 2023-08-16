import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../../data/repositories/homepage_repositories.dart';
import '../../../../data/repositories/user_repositories.dart';

part 'dashboard_count_event.dart';

part 'dashboard_count_state.dart';

class DashboardCountBloc
    extends Bloc<DashboardCountEvent, DashboardCountState> {
  final UserRepositories userRepositories;
  final HomepageRepositories homepageRepositories;

  DashboardCountBloc(
      {required this.userRepositories, required this.homepageRepositories})
      : super(DashboardCountLoading()) {
    on<DashboardCountEvent>((event, emit) async {
      if (event is DashboardCount) {
        final String userId = await userRepositories.hasUserId();
        debugPrint("======$userId=========");
        try {
          dynamic response = await homepageRepositories.count(userId);
          debugPrint("=============== :$response");
          String leadCount = response['leads_count'].toString();
          String ticketCount = response['tickets_count'].toString();
          String pettyCashCount = response['pettycash_count'].toString();
          String quotationCount = response['quotation_count'].toString();

          emit(DashboardCountLoaded(
              leadCount, ticketCount, pettyCashCount, quotationCount));
        } catch (e) {
          emit(const DashboardCountFailure(error: 'Api Interaction Failed'));
        }
      }
    });
  }
}
