import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/theme/app_assets.dart';
import '../../../config/theme/app_colors.dart';
import '../../../data/repositories/login_repositories.dart';
import '../../../data/repositories/user_repositories.dart';
import '../../../data/utils/utils.dart';
import '../../../data/validation/validations.dart';
import '../../../logic/bloc/authentication/authentication_bloc.dart';
import '../../../logic/bloc/login/login_bloc.dart';
import '../../components/app_loader.dart';

class LoginPage extends StatefulWidget {
  final UserRepositories userRepositories;

  const LoginPage({Key? key, required this.userRepositories}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState(userRepositories);
}

class _LoginPageState extends State<LoginPage> {
  final UserRepositories userRepositories;

  _LoginPageState(this.userRepositories);

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late FocusNode _emailFocusNode = FocusNode();
  late FocusNode _passwordFocusNode = FocusNode();

  bool isPasswordhidden = false;

  @override
  void setState(VoidCallback fn) {
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) {
        return LoginBloc(
            userRepositories: userRepositories,
            loginRepositories: LoginRepositories(),
            authenticationBloc:
                BlocProvider.of<AuthenticationBloc>(context, listen: false));
      },
      child: BlocConsumer<LoginBloc, LoginState>(listener: (context, state) {
        if (state is LoginSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Login Successfully'),
                backgroundColor: AppColor.successColor),
          );
          _emailController.clear();
          _passwordController.clear();
        }
        if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Login Fail'),
                backgroundColor: AppColor.warningColor),
          );
        }
      }, builder: (context, state) {
        return Scaffold(
          key: _scaffoldkey,
          body: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF038D16), Color(0x100DB323)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(top: 40),
                      child: const Image(
                          image: AssetImage(AppIcon.whiteLogo), width: 210),
                    ),
                  ),
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 1.35,
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1.1,
                          height: MediaQuery.of(context).size.height / 1.37,
                          decoration: BoxDecoration(
                            color: const Color(0x9AFFFFFF),
                            border: Border.all(
                                width: .8,
                                color: AppColor.secondaryColor.withOpacity(.5)),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(26),
                              topRight: Radius.circular(26),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 1.4,
                          padding: const EdgeInsets.only(top: 48),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                            border: Border.all(
                                width: 1.2, color: AppColor.secondaryColor),
                            gradient: const LinearGradient(
                                colors: [Color(0xFFFFFFFF), Color(0xFFFFFFFF)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter),
                          ),
                          child: Form(
                            key: _formkey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Welcome back',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: .8,
                                          color: AppColor.grayColor),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Please Login to Continue',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: .6,
                                          color: AppColor.grayColor),
                                ),
                                const SizedBox(height: 56),
                                emailTextFormField(context),
                                const SizedBox(height: 16),
                                passwordTextFormField(context),
                                const SizedBox(height: 30),
                                state is LoginLoading
                                    ? showCirclerLoading(context, 40)
                                    : logInButton(
                                        context: context,
                                        onTap: () {
                                          if (_formkey.currentState!
                                              .validate()) {
                                            BlocProvider.of<LoginBloc>(context,
                                                    listen: false)
                                                .add(LoginButtonPressed(
                                              email: _emailController.text,
                                              password:
                                                  _passwordController.text,
                                            ));
                                          }
                                        },
                                      ),
                                const SizedBox(height: 30),
                                Text('Forget Password ?',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            color: AppColor.warningColor)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  emailTextFormField(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        controller: _emailController,
        focusNode: _emailFocusNode,
        keyboardType: TextInputType.emailAddress,
        enableSuggestions: true,
        obscureText: false,
        enableInteractiveSelection: true,
        onFieldSubmitted: (value) => Utils.fieldFocusChange(
            context, _emailFocusNode, _passwordFocusNode),
        validator: (String? valid) {
          return Validations().validateEmail(_emailController.text);
        },
        decoration: textInputDecoration('User Name'),
      ),
    );
  }

  passwordTextFormField(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        controller: _passwordController,
        focusNode: _passwordFocusNode,
        keyboardType: TextInputType.emailAddress,
        enableSuggestions: true,
        obscureText: !isPasswordhidden,
        enableInteractiveSelection: true,
        validator: (String? value) {
          return Validations().validatePassword(_passwordController.text);
        },
        decoration: textInputDecoration('Password'),
      ),
    );
  }

  logInButton({required Function() onTap, required BuildContext context}) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: width,
          height: 58,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6EEE87), Color(0xFF5FC52E)],
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              transform: GradientRotation(45),
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Color(0x9D9BF5AD),
                offset: Offset(0, 3),
                blurRadius: 12,
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Log In',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: AppColor.secondaryColor,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  textInputDecoration(String label) {
    final isCheckPassword = label == "Password";
    return InputDecoration(
      suffixIcon: isCheckPassword
          ? IconButton(
              onPressed: () =>
                  setState(() => isPasswordhidden = !isPasswordhidden),
              icon: isPasswordhidden
                  ? SvgPicture.asset(
                      AppSvg.passwordVisible,
                      width: 22,
                      color: AppColor.focusColor,
                    )
                  : SvgPicture.asset(
                      AppSvg.passwordInvisible,
                      width: 22,
                      color: AppColor.lightgrey,
                    ),
            )
          : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColor.primaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColor.focusColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColor.warningColor),
      ),
      hintText: label,
      hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: AppColor.grayColor,
          letterSpacing: .6,
          fontWeight: FontWeight.w400),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
    );
  }
}

// mixin InputValidationMixin {
//   bool isPasswordValid(String password) => password.length == 8;
//
//   bool isEmailValid(String email) {
//     // Pattern pattern =r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$' ;
//     RegExp regex = RegExp(
//         r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
//     return regex.hasMatch(email);
//   }
// }
