import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../config/theme/app_assets.dart';
import '../../../../config/theme/app_colors.dart';

class ProfilePageAppBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function() onPressed;

  const ProfilePageAppBar(
      {Key? key, required this.scaffoldKey, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.appColor,
      elevation: 0,
      leading: appBarButton(
        svgSrc: AppSvg.menu,
        onPressed: (() => scaffoldKey.currentState!.openDrawer()),
      ),
      title: Text(
        'My Profile',
        style: Theme.of(context)
            .textTheme
            .headlineLarge
            ?.copyWith(color: AppColor.secondaryColor, letterSpacing: .6),
      ),
      centerTitle: true,
      actions: [
        appBarButton(svgSrc: AppSvg.edit, onPressed: onPressed),
      ],
    );
  }
}
 
appBarButton({required String svgSrc, required Function() onPressed}) {
  final isCheckMenu = svgSrc == AppSvg.menu || svgSrc == AppSvg.edit;
  return TextButton(
    onPressed: onPressed,
    child: Container(
      width: 40,
      height: 40,
      padding: EdgeInsets.all(isCheckMenu ? 12 : 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: const Color.fromARGB(50, 255, 255, 255),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1100366D),
            offset: Offset(0, 3),
            blurRadius: 6,
          )
        ],
      ),
      child: SvgPicture.asset(svgSrc, color: AppColor.secondaryColor),
    ),
  );
}
