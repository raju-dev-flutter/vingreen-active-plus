import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/models/user_detail_model.dart';
import '../../../../data/repositories/homepage_repositories.dart';
import '../../../../data/repositories/user_repositories.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final UserRepositories userRepositories;
  final HomepageRepositories homepageRepositories;
  DashboardBloc(
      {required this.userRepositories, required this.homepageRepositories})
      : assert(userRepositories != null),
        assert(homepageRepositories != null),
        super(DashboardLoading()) {
    on<DashboardEvent>((event, emit) async {
      if (event is GetUserDetails) {
        emit(DashboardLoading());
        final String userId = await userRepositories.hasUserId();

        try {
          dynamic jsonResponse = await homepageRepositories.userDetails(userId);
          emit(GetUserDetailsLoaded(jsonResponse));
        } catch (e) {
          emit(const DashboardFailure(error: 'Api Interaction Failed'));
        }
      } else if (event is LogoutButtonPressed) {
        await userRepositories.deleteToken();
        // emit(LogoutSuccess());
      }
    });
  }
}
