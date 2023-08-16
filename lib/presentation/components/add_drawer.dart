import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/theme/app_assets.dart';
import '../../config/theme/app_colors.dart';
import '../../data/repositories/user_repositories.dart';
import '../../logic/bloc/authentication/authentication_bloc.dart';
import '../pages/attendance/attendance_history_page.dart';
import '../pages/lead/lead_page.dart';
import '../pages/petty_cash/petty_cash_page.dart';
import '../pages/quotation/quotation_page.dart';
import '../pages/ticket/ticket_page.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {

  final UserRepositories userRepositories = UserRepositories();
  late MethodChannel methodChannel;
  String nameOfTheChannel = "flutter/call_recorder";

  Future<void> serviceStop() async {
    try {
      methodChannel = MethodChannel(nameOfTheChannel);
      var result =
      await methodChannel.invokeMethod("stop", <String, dynamic>{});
      showToast(e: 'MethodChannel result: $result');
      if (result == "Success") {
        // userRepositories.setmethodChannel(result);
        // SharedPreferenceHelper().setmethodChannel(result);
      }
    } catch (e) {
      showToast(e: 'Error while accessing native call');
    }
  }

  void showToast({required String e}) {
    debugPrint(" |====== $e ======|");
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColor.bgColor,
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                color: AppColor.appColor,
                padding: const EdgeInsets.fromLTRB(50, 62, 50, 28),
                child: const SizedBox(
                  width: 180,
                  child: Image(image: AssetImage(AppIcon.idLogo)),
                ),
              ),
              const SizedBox(height: 16),
              DrawerListTile(
                title: 'Lead',
                svgSrc: AppSvg.lead,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed(LeadPage.id);
                },
              ),
              DrawerListTile(
                title: 'Tickets',
                svgSrc: AppSvg.ticket,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed(TicketPage.id);
                },
              ),
              DrawerListTile(
                title: 'Petty Cash',
                svgSrc: AppSvg.pettyCash,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed(PettyCashPage.id);
                },
              ),
              DrawerListTile(
                title: 'Quotation',
                svgSrc: AppSvg.quotation,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed(QuotationPage.id);
                },
              ), 
              DrawerListTile(
                title: 'Attendance',
                svgSrc: AppSvg.attendanceHistory,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed(AttendanceHistoryPage.id);
                },
              ),
              DrawerListTile(
                  title: 'Log Out',
                  svgSrc: AppSvg.logOut,
                  onTap: () =>
                  {
                        BlocProvider.of<AuthenticationBloc>(context,
                                listen: false)
                            .add(LoggedOut()),
                    // serviceStop(),
                      } 
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  final String title, svgSrc;
  final VoidCallback onTap;

  const DrawerListTile({
    super.key,
    required this.title,
    required this.svgSrc,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      minVerticalPadding: 0,
      horizontalTitleGap: 0.0,
      leading:
          SvgPicture.asset(svgSrc, width: 18, color: const Color(0xFF606C7C)),
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .displayLarge
            ?.copyWith(fontSize: 18, color: const Color(0xFF606C7C)),
      ),
    );
  }
}
