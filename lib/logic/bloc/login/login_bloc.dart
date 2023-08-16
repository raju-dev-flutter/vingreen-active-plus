import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../data/models/user.dart';
import '../../../data/repositories/login_repositories.dart';
import '../../../data/repositories/user_repositories.dart';
import '../authentication/authentication_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepositories userRepositories;
  final LoginRepositories loginRepositories;
  final AuthenticationBloc authenticationBloc;

  late MethodChannel methodChannel;
  String nameOfTheChannel = "flutter/call_recorder";

  LoginBloc(
      {required this.userRepositories,
      required this.loginRepositories,
      required this.authenticationBloc})
      : assert(userRepositories != null),
        assert(authenticationBloc != null),
        super(LoginInitial()) {
    on<LoginEvent>((event, emit) async {
      if (event is LoginButtonPressed) {
        emit(LoginLoading());
        try {
          debugPrint('====== Api Calling ==========');

          Map data = {'email': event.email, 'password': event.password};
          dynamic response = await loginRepositories.loginApi(data);

          var aPISuccess = response['api_success'].toString();

          // debugPrint('====== $aPISuccess $response==========');

          if (aPISuccess == 'true') {
            authenticationBloc.add(LoggedIn(
                token: response['token'].toString(),
                userId: response['user']['id'].toString()));

            userRepositories.persisteUserDetails(User(
              id: response['user']['id'],
              profileUpload: response['user']['profile_upload'],
              email: response['user']['email'],
              personalMobileNumber: response['user']['personal_mobile_number'],
              designationId: response['user']['designation_id'],
            ));
            emit(LoginSuccess());
            // serviceStart(
            //   response['user']['id'],
            //   response['user']['personal_mobile_number'],
            //   "${response['user']['first_name']} ${response['user']['last_name']}",
            //   response['user']['email'],
            // );
          } else {
            emit(const LoginFailure(error: 'Login Failed'));
          }
        } catch (e) {
          emit(const LoginFailure(error: 'Login Failed'));
        }
      }
    });
  }

  Future<void> serviceStart(
      String userId, String mobileNo, String name, String emailId) async {
    debugPrint('Service Calling');
    try {
      methodChannel = MethodChannel(nameOfTheChannel);
      var result = await methodChannel.invokeMethod("run", <String, dynamic>{
        'userId': userId,
        'mobileNo': mobileNo,
        'userName': name,
        'emailId': emailId,
      });
      if (result == "Success") {
        userRepositories.setmethodChannel(result);
      }
    } catch (e) {
      debugPrint("Error while accessing native call");
    }
  }
}
