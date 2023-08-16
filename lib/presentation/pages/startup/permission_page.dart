import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/theme/app_assets.dart';
import '../../../config/theme/app_colors.dart';
import '../../../logic/bloc/authentication/authentication_bloc.dart';
import '../../../logic/cubit/permission/permission_cubit.dart';

class PermissionPage extends StatelessWidget {
  static const String id = 'permission_page';
  const PermissionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<PermissionCubit, PermissionState>(
        listener: (context, state) {
          if (state is AllPermissionsGranted) {
            BlocProvider.of<AuthenticationBloc>(context, listen: false)
                .add(const AppPermission(appPermission: 'true'));
          }
        },
        listenWhen: (previous, current) {
          return (current is AllPermissionsGranted);
        },
        builder: (context, state) {
          var authenticationBloc =
              BlocProvider.of<AuthenticationBloc>(context, listen: false);
          var permissionCubit = context.watch<PermissionCubit>();
          permissionCubit.checkIfPermissionNeeded();
          if (state is AllPermissionsGranted || state is WaitingForPermission) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'OK! ',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(color: const Color(0xFF32CD30)),
                      children: [
                        TextSpan(
                          text: 'we need some access!',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),
                  resourceConstants(
                    context: context,
                    svg: AppSvg.location,
                    title: "Location",
                    description:
                        "To display fun facts about the user's location",
                  ),
                  const SizedBox(height: 16),
                  resourceConstants(
                    context: context,
                    svg: AppSvg.folder,
                    title: "Storage",
                    description: "Don't worry your data is private",
                  ),
                  const SizedBox(height: 16),
                  resourceConstants(
                    context: context,
                    svg: AppSvg.call,
                    title: "Call",
                    description: "Because why not :)",
                  ),
                  const SizedBox(height: 60),
                  InkWell(
                    onTap: () async {
                      if (state.permissionRepository.isGranted == true) {
                        debugPrint(
                            "=============| Permission : ${state.permissionRepository.isGranted.toString()} |=============");
                      } else {
                        return await permissionCubit.onRequestAllPermission();
                      }
                    },
                    child: Container(
                      height: 58,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFF32CD30),
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: Text(
                        'Allow All Access',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                color: AppColor.secondaryColor,
                                fontFamily: 'Popp'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  resourceConstants(
      {required BuildContext context,
      required String svg,
      required String title,
      required String description}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(svg, width: 26, color: const Color(0xFF32CD30)),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColor.grayColor.withOpacity(.8),
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
