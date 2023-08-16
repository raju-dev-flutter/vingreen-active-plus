import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/constants/enum.dart';
import '../../../config/theme/app_assets.dart';
import '../../../config/theme/app_colors.dart';
import '../../../logic/bloc/profile/profile_bloc.dart';
import '../../../logic/cubit/navigation/navigation_cubit.dart';
import '../../components/add_drawer.dart';
import '../home/appbar/homepage_appbar.dart';
import '../home/home_page.dart';
import '../profile/appbar/profilepage_appbar.dart';
import '../profile/profile_page.dart';
import '../profile/profile_update_page.dart';
import '../task/task_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> refresh(BuildContext context) async {
    BlocProvider.of<ProfileBloc>(context, listen: false).add(ProfileStatus());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: BlocBuilder<NavigationCubit, NavigationState>(
            builder: (context, state) {
          if (state.navbarItem == NavbarItem.home) {
            return HomePageAppBar(scaffoldKey: _scaffoldKey);
          } else if (state.navbarItem == NavbarItem.task) {
            return Container(height: 34, color: AppColor.appColor);
          } else if (state.navbarItem == NavbarItem.profile) {
            return ProfilePageAppBar(
              scaffoldKey: _scaffoldKey,
              onPressed: () =>
                  Navigator.pushNamed(context, ProfileUpdatePage.id)
                      .whenComplete(() => refresh(context)),
            );
          }
          return Container();
        }),
      ),
      drawer: const AppDrawer(),
      body: BlocBuilder<NavigationCubit, NavigationState>(
          builder: (context, state) {
        if (state.navbarItem == NavbarItem.home) {
          return const HomePage();
        } else if (state.navbarItem == NavbarItem.task) {
          return TaskPage(scaffoldkey: _scaffoldKey);
        } else if (state.navbarItem == NavbarItem.profile) {
          return const ProfilePage();
        }
        return Container();
      }),
      bottomNavigationBar: BlocBuilder<NavigationCubit, NavigationState>(
          builder: (context, state) {
        var navigationCubit = BlocProvider.of<NavigationCubit>(context);
        return Container(
          height: 70,
          padding: const EdgeInsets.all(12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            border: Border.all(
              width: 1.8,
              strokeAlign: BorderSide.strokeAlignOutside,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              navigationGroupButton(
                context: context,
                onTap: () => navigationCubit.getNavBarItem(NavbarItem.home),
                label: 'Dashboard',
                svgSrc: state.index == 0 ? AppSvg.homeFill : AppSvg.home,
                color:
                    state.index == 0 ? AppColor.appColor : AppColor.grayColor,
                fontWeight:
                    state.index == 0 ? FontWeight.w500 : FontWeight.normal,
              ),
              navigationGroupButton(
                context: context,
                onTap: () => navigationCubit.getNavBarItem(NavbarItem.task),
                label: 'Task',
                svgSrc: state.index == 1 ? AppSvg.taskFill : AppSvg.task,
                color:
                    state.index == 1 ? AppColor.appColor : AppColor.grayColor,
                fontWeight:
                    state.index == 1 ? FontWeight.w500 : FontWeight.normal,
              ),
              navigationGroupButton(
                context: context,
                onTap: () => navigationCubit.getNavBarItem(NavbarItem.profile),
                label: 'Profile',
                svgSrc: state.index == 2 ? AppSvg.myProfile : AppSvg.myProfile,
                color:
                    state.index == 2 ? AppColor.appColor : AppColor.grayColor,
                fontWeight:
                    state.index == 2 ? FontWeight.w500 : FontWeight.normal,
              ),
            ],
          ),
        );
      }),
    );
  }

  navigationGroupButton({
    required BuildContext context,
    required Function() onTap,
    required String label,
    required String svgSrc,
    required Color color,
    required FontWeight fontWeight,
  }) {
    final isCheckSvg = svgSrc == AppSvg.myProfile;
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          SvgPicture.asset(svgSrc, width: isCheckSvg ? 19 : 20, color: color),
          SizedBox(height: isCheckSvg ? 4 : 6),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: color, fontWeight: fontWeight),
          )
        ],
      ),
    );
  }
}
