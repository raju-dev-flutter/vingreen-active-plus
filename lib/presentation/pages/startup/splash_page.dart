import 'package:flutter/material.dart';

import '../../../config/theme/app_assets.dart';
import '../../../config/theme/app_colors.dart';

class SplashPage extends StatelessWidget {
  static const String id = 'splash_page';
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        decoration: const BoxDecoration(color: AppColor.appColor),
        child: const Image(image: AssetImage(AppIcon.whiteLogo), width: 250),
      ),
    );
  }
}
