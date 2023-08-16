import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/theme/app_assets.dart';
import '../../../config/theme/app_colors.dart';
import '../../../data/models/user_detail_model.dart';
import '../../../data/services/url.dart';
import '../../../logic/bloc/profile/profile_bloc.dart';

class IdCardPage extends StatelessWidget {
  static const String id = 'idcard_page';

  const IdCardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      if (state is ProfileLoaded) {
        return Scaffold(
          body: Stack(
            children: [
              Container(height: double.infinity),
              Positioned(top: 0, child: logoShadowClipPath(context)),
              Positioned(top: 0, child: logoContainer(context)),
              appBar(context),
              Positioned(
                  top: 136,
                  child: informationContainer(context, state.userDetails)),
              Positioned(bottom: 0, child: footerContainer(context)),
            ],
          ),
        );
      }
      return Container();
    });
  }

  appBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 52, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 40, height: 40),
          const Image(image: AssetImage(AppIcon.idLogo), width: 200),
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color.fromARGB(69, 245, 245, 245),
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: const Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  logoContainer(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Stack(
        children: [
          ClipPath(
            clipper: LogoContainerClipper(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 250,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color(0xFF43d42a),
                  Color(0xFF57b846),
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
            ),
          ),
        ],
      ),
    );
  }

  logoShadowClipPath(BuildContext context) {
    return ClipPath(
      clipper: LogoShadowContainerClipper(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 260,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromARGB(200, 171, 243, 158),
            Color.fromARGB(200, 183, 247, 172)
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
      ),
    );
  }

  informationContainer(BuildContext context, UserDetails user) {
    // var userPic = user.profile;
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  const SizedBox(width: 180, height: 180),
                  Positioned(top: 0, right: 0, child: shapeContainer()),
                  Positioned(bottom: 0, left: 0, child: shapeContainer()),
                  Positioned(
                    left: 24,
                    top: 26,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(150, 67, 212, 42),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(30),
                          ),
                          image: user.profileUpload == null
                              ? const DecorationImage(
                                  image: AssetImage(AppImage.user),
                                  fit: BoxFit.fill,
                                )
                              : DecorationImage(
                                  image: NetworkImage(
                                      '${AppUrl.baseUrl}public/profile_uploads/${user.profileUpload}'),
                                  fit: BoxFit.fill,
                                ),
                          boxShadow: const [
                            BoxShadow(
                                offset: Offset(3, -3), color: Colors.white),
                            BoxShadow(
                                offset: Offset(-3, -3), color: Colors.white),
                          ],
                          border: Border.all(
                              width: 5,
                              color: const Color.fromARGB(150, 67, 212, 42)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 22),
          Column(
            children: [
              Text(
                user.userName == null ? '' : user.userName!.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: AppColor.primaryColor),
              ),
              const SizedBox(height: 8),
              Text(
                user.designationId ?? '',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColor.appColor),
              ),
            ],
          ),
          const SizedBox(height: 22 + 6),
          detailsCard(
              context: context,
              lebal: 'Employee Id',
              value: user.employeeCode ?? ''),
          const SizedBox(height: 16),
          detailsCard(
              context: context, lebal: 'D.O.J', value: user.dateOfBirth ?? ''),
          const SizedBox(height: 16),
          detailsCard(
              context: context, lebal: 'Email Id', value: user.email ?? ''),
          const SizedBox(height: 16),
          detailsCard(
              context: context, lebal: 'D.O.B', value: user.dateOfBirth ?? ''),
          const SizedBox(height: 16),
          detailsCard(
              context: context,
              lebal: 'Blood Group',
              value: user.bloodGroup ?? ''),
          const SizedBox(height: 16),
          detailsCard(
              context: context,
              lebal: 'Mobile No',
              value: user.personalMobileNumber ?? ' '),
          const SizedBox(height: 16),
          detailsCard(
              context: context,
              lebal: 'Emg No',
              value: user.personalMobileNumber ?? ' '),
          const SizedBox(height: 16),
          detailsCard(
              context: context, lebal: 'Address', value: user.address ?? ''),
        ],
      ),
    );
  }

  footerContainer(BuildContext context) {
    return SizedBox(
      height: 700,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipPath(
            clipper: FooterShadowClipper(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 700,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xC7ABF39E), Color(0xC7B7F7AC)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
              ),
            ),
          ),
          ClipPath(
            clipper: FooterClipper(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 700,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xFF43d42a), Color(0xFF57b846)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            child: Text(
              'VINGREEN TECHNOLOGIES LLP',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: AppColor.secondaryColor),
            ),
          )
        ],
      ),
    );
  }

  shapeContainer() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(5),
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(30),
        ),
        border:
            Border.all(width: 2, color: const Color.fromARGB(200, 67, 212, 42)),
      ),
    );
  }

  detailsCard(
      {required BuildContext context,
      required String lebal,
      required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            flex: 2,
            child: Text(
              lebal,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColor.grayColor),
            )),
        Text(
          ': ',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColor.grayColor),
        ),
        const SizedBox(width: 6),
        Expanded(
          flex: 5,
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
          ),
        ),
      ],
    );
  }
}

class LogoContainerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);

    path.quadraticBezierTo(size.width * .09, size.height * 0.855,
        size.width * 0.26, size.height * 0.899);

    path.quadraticBezierTo(size.width * .50, size.height * .99,
        size.width * .65, size.height * 0.755);

    path.quadraticBezierTo(
        size.width * .8, size.height * .500, size.width, size.height * .50);

    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class LogoShadowContainerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);

    path.quadraticBezierTo(size.width * .09, size.height * 0.855,
        size.width * 0.26, size.height * 0.899);

    path.quadraticBezierTo(size.width * .50, size.height * .99,
        size.width * .65, size.height * 0.755);

    path.quadraticBezierTo(
        size.width * .8, size.height * .550, size.width, size.height * .60);

    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class FooterClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * 0.940);

    path.quadraticBezierTo(size.width * 0.25, size.height * 0.902,
        size.width * 0.5, size.height * 0.9267);
    path.quadraticBezierTo(size.width * 0.855, size.height * 0.9484,
        size.width * 1.0, size.height * 0.900);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class FooterShadowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * 0.940);

    path.quadraticBezierTo(size.width * 0.25, size.height * 0.912,
        size.width * 0.49, size.height * 0.925);
    path.quadraticBezierTo(size.width * 0.855, size.height * 0.9484,
        size.width * 1.0, size.height * 0.860);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
