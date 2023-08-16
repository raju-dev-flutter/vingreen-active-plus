import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../config/theme/app_assets.dart';
import '../../../config/theme/app_colors.dart';
import '../../../data/models/attendance_model.dart';
import '../../../data/services/url.dart';
import '../../../data/utils/convert_datetime.dart';
import '../../../logic/bloc/home/attendance/attendance_bloc.dart';
import '../../../logic/bloc/home/attendance_list/attendance_list_bloc.dart';
import '../../../logic/bloc/home/count/dashboard_count_bloc.dart';
import '../../../logic/bloc/home/dashboard/dashboard_bloc.dart';
import '../../components/show_bottom_sheet.dart';
import '../attendance/attendance_history_page.dart';
import '../invoice/invoice_page.dart';
import '../lead/lead_page.dart';
import '../petty_cash/petty_cash_page.dart';
import '../proforma_invoice/proforma_invoice_page.dart';
import '../quotation/quotation_page.dart';
import '../ticket/ticket_page.dart';
import 'attendance_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DashboardBloc dashboardBloc;
  late AttendanceBloc attendanceBloc;
  late DashboardCountBloc dashboardCountBloc;

  @override
  void initState() {
    super.initState();
    dashboardBloc = BlocProvider.of<DashboardBloc>(context);
    dashboardBloc.add(GetUserDetails());
    attendanceBloc = BlocProvider.of<AttendanceBloc>(context);
    attendanceBloc.add(AttendanceStatus());
    dashboardCountBloc = BlocProvider.of<DashboardCountBloc>(context);
    dashboardCountBloc.add(DashboardCount());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        if (state is GetUserDetailsLoaded) {
          // final imageFirstLatter = state.userDetails.firstName;
          return SingleChildScrollView(
            child: Stack(
              children: [
                SizedBox(width: width, height: height),
                gradientContainer(width),
                Positioned(
                  top: 0,
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          SizedBox(width: width, height: 320),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                              child: Container(
                                height: 250,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFFFFFF),
                                      Color(0x31FFFFFF)
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      width: 1, color: AppColor.secondaryColor),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x1188909F),
                                      offset: Offset(0, 6),
                                      blurRadius: 16,
                                    )
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      state.userDetails.userName ?? '',
                                      style: textTheme.titleMedium
                                          ?.copyWith(letterSpacing: .5),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      state.userDetails.email ?? '',
                                      style: textTheme.bodyMedium?.copyWith(
                                          letterSpacing: .4, fontSize: 13),
                                    ),
                                    const SizedBox(height: 20),
                                    const Divider(
                                      height: 0,
                                      thickness: 1,
                                      color: Color(0xFFFFE9AD),
                                    ),
                                    calenderContainer(context),
                                    const SizedBox(height: 20),
                                    attendanceSection(context: context),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          userProfileContainer(
                              context, state.userDetails.profileUpload!),
                        ],
                      ),
                      dashboardCardUI(context),
                      // attendanceHistoryUI(context),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  attendanceSection({required BuildContext context}) {
    final height = MediaQuery.of(context).size.height;
    final textTheme = Theme.of(context).textTheme;
    final attendanceBloc = context.watch<AttendanceBloc>();
    // attendanceBloc.add(AttendanceStatus());
    return BlocBuilder<AttendanceBloc, AttendanceState>(
        builder: (context, state) {
      if (state is AttendanceStatusLoaded) {
        final checkInTime =
            state.checkInTime != 'null' ? state.checkInTime : '-- : --';
        final checkOutTime =
            state.checkOutTime != 'null' ? state.checkOutTime : '-- : --';
        final itIsEqualPunchIn = state.status == "checkin"
            ? "Check In"
            : state.status == "checkout"
                ? "Check Out"
                : "null";

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Check In Time',
                        style:
                            textTheme.labelMedium?.copyWith(letterSpacing: .5)),
                    const SizedBox(height: 4),
                    Text(
                      checkInTime,
                      style: textTheme.bodyMedium?.copyWith(
                          letterSpacing: .5, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(width: 2),
                const VerticalDivider(thickness: 1, color: Color(0xFFD5D5D5)),
                const SizedBox(width: 2),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Check Out Time',
                        style:
                            textTheme.labelMedium?.copyWith(letterSpacing: .5)),
                    const SizedBox(height: 4),
                    Text(
                      checkOutTime,
                      style: textTheme.bodyMedium?.copyWith(
                          letterSpacing: .5, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Spacer(),
                itIsEqualPunchIn == 'Check In'
                    ? CheckOutButton(
                        onPressed: () {
                          showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext bc) {
                              return bottomContainer(height, 'Check Out');
                            },
                          ).whenComplete(() => refresh(context));
                        },
                      )
                    : itIsEqualPunchIn == 'Check Out'
                        ? UpdateButton(onPressed: () {})
                        : CheckInButton(
                            onPressed: () {
                              showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                isScrollControlled: true,
                                builder: (BuildContext bc) {
                                  return bottomContainer(height, 'Check In');
                                },
                              ).whenComplete(() => refresh(context));
                            },
                          ),
              ],
            ),
          ),
        );
      }
      return Container();
    });
  }

  Future<void> refresh(BuildContext context) async {
    BlocProvider.of<DashboardBloc>(context, listen: false)
        .add(GetUserDetails());
    BlocProvider.of<AttendanceBloc>(context, listen: false)
        .add(AttendanceStatus());
  }

  dashboardCardUI(BuildContext context) {
    final dashboardCountBloc = context.watch<DashboardCountBloc>();
    // dashboardCountBloc.add(DashboardCount());
    return BlocBuilder<DashboardCountBloc, DashboardCountState>(
      builder: (context, state) {
        if (state is DashboardCountLoaded) {
          return Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: cardBoxDecoration(),
                  child: Row(
                    children: [
                      Text(
                        'Categories',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(letterSpacing: .5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: (() =>
                            Navigator.of(context).pushNamed(LeadPage.id)),
                        child: Container(
                          height: 82,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                          decoration: cardBoxDecoration(),
                          child: cardBoxDetails(
                            context: context,
                            svgSrc: AppSvg.lead,
                            label: 'Leads',
                            value: state.leadCount ?? '',
                            color: const Color(0xFF8EA1FF),
                            shadow: const Color(0x17657FFF),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () =>
                            Navigator.of(context).pushNamed(TicketPage.id),
                        child: Container(
                          height: 82,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                          decoration: cardBoxDecoration(),
                          child: cardBoxDetails(
                            context: context,
                            svgSrc: AppSvg.ticket,
                            label: 'Tickets',
                            value: state.ticketCount ?? '',
                            color: const Color(0xFFFF9094),
                            shadow: const Color(0x17F06C71),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: (() =>
                            Navigator.of(context).pushNamed(PettyCashPage.id)),
                        child: Container(
                          height: 82,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                          decoration: cardBoxDecoration(),
                          child: cardBoxDetails(
                            context: context,
                            svgSrc: AppSvg.pettyCash,
                            label: 'Petty Cash',
                            value: state.pettyCashCount ?? '',
                            color: const Color(0xFFFF8EC7),
                            shadow: const Color(0x17FF65FF),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () =>
                            Navigator.of(context).pushNamed(QuotationPage.id),
                        child: Container(
                          height: 82,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                          decoration: cardBoxDecoration(),
                          child: cardBoxDetails(
                            context: context,
                            svgSrc: AppSvg.quotation,
                            label: 'Quotation',
                            value: state.quotationCount ?? '',
                            color: const Color(0xFFBF8EFF),
                            shadow: const Color(0x17BF8EFF),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: (() =>
                            Navigator.of(context).pushNamed(InvoicePage.id)),
                        child: Container(
                          height: 82,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                          decoration: cardBoxDecoration(),
                          child: cardBoxDetails(
                            context: context,
                            svgSrc: AppSvg.lead,
                            label: 'Invoice',
                            value: state.leadCount ?? '',
                            color: const Color(0xFFFFBB8E),
                            shadow: const Color(0x17FFBB8E),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () => Navigator.of(context)
                            .pushNamed(ProformaInvoicePage.id),
                        child: Container(
                          height: 82,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: cardBoxDecoration(),
                          child: cardBoxDetails(
                            context: context,
                            svgSrc: AppSvg.ticket,
                            label: 'Proforma \ninvoice',
                            value: state.ticketCount ?? '',
                            color: const Color(0xFFFF9094),
                            shadow: const Color(0x17F06C71),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  cardBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        width: 1,
        strokeAlign: BorderSide.strokeAlignOutside,
        color: AppColor.secondaryColor,
      ),
      gradient: const LinearGradient(
        colors: [Color(0xFFFFFFFF), Color(0x6AFFFFFF), Color(0x1EFFFFFF)],
        begin: Alignment.topLeft,
        end: Alignment.topRight,
        transform: GradientRotation(20),
      ),
      boxShadow: const [
        BoxShadow(
            color: Color(0x2888909F), offset: Offset(0, 6), blurRadius: 11),
      ],
    );
  }

  cardBoxDetails(
      {required BuildContext context,
      required String svgSrc,
      required String label,
      required String value,
      required Color color,
      required Color shadow}) {
    return Row(
      children: [
        Container(
          width: 55,
          height: 54,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                width: 1,
                strokeAlign: BorderSide.strokeAlignOutside,
                color: color),
            boxShadow: [
              BoxShadow(
                color: shadow,
                offset: const Offset(0, 6),
                blurRadius: 15,
              ),
            ],
          ),
          child: SvgPicture.asset(svgSrc, color: color),
        ),
        const SizedBox(width: 12),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: const Color(0xFF57585D), letterSpacing: .5),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(color: color, letterSpacing: .5),
            ),
          ],
        )
      ],
    );
  }

  attendanceHistoryUI(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return BlocBuilder<AttendanceListBloc, AttendanceListState>(
      builder: (context, state) {
        if (state is AttendanceListLoaded) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              width: width,
              height: 290,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: const Color(0xFFFFFFFF),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Attendance History',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: .5),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: (() => Navigator.of(context)
                              .pushNamed(AttendanceHistoryPage.id)),
                          child: Text(
                            'Go to Full Log History',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                    color: AppColor.grayColor,
                                    letterSpacing: .5),
                          ),
                        ),
                        const SizedBox(width: 4),
                        SvgPicture.asset(
                          AppSvg.arrowFrd,
                          width: 16,
                          color: AppColor.grayColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                      scrollDirection: Axis.vertical,
                      itemCount: state.attendanceList.length,
                      itemBuilder: (_, index) {
                        return attendanceListBox(
                            context, state.attendanceList[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }

  attendanceListBox(BuildContext context, AttendanceList attendance) {
    var isDateTime = attendance.attendanceAt.toString();
    final splitted = isDateTime.split(' ');
    final splittedDate = splitted[0].split('-');

    int year = int.parse(splittedDate[0]);
    int date = int.parse(splittedDate[1]);
    int month = int.parse(splittedDate[2]);

    DateTime now = DateTime(year, date, month);
    var dayMonth = '${splittedDate[2]}  ${Convert.month(now)}';
    var day = Convert.day(now);
    var time =
        DateFormat.jm().format(DateFormat("hh:mm:ss").parse(splitted[1]));
    final attendanceType =
        attendance.type == 'checkin' ? 'Check In' : 'Check Out';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: (() =>
            showBottomSheetModel(context: context, attendance: attendance)),
        // onTap: (() => ShowAttendanceDetails.showModel(
        //     context: _context, data: attendance, time: time)),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xFFFFFFFF),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FFE2),
                    borderRadius: BorderRadius.circular(4),
                    border:
                        Border.all(width: .5, color: const Color(0xFFCFE5BA)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dayMonth,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF3D5824),
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        day,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF3D5824),
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      attendanceType,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColor.grayColor,
                            fontWeight: FontWeight.w300,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      time,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColor.primaryColor),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  width: 24,
                  height: 24,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(width: 1, color: const Color(0xFF8399a2)),
                  ),
                  child: SvgPicture.asset(AppSvg.arrowFrd,
                      color: const Color(0xFF8399a2)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  gradientContainer(double width) {
    return Positioned(
      top: 0,
      child: Container(
        width: width,
        height: 277,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF52B45F), Color.fromARGB(255, 255, 255, 255)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(45),
            bottomRight: Radius.circular(45),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x31AEDCB4),
              offset: Offset(0, 3),
              blurRadius: 18,
            )
          ],
        ),
      ),
    );
  }

  bottomContainer(double height, String label) {
    return Container(
      height: height / 1.3,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: AttendanceFormModel(title: label),
    );
  }

  calenderContainer(BuildContext context) {
    return Container(
      width: 150,
      height: 36,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0xFFFFE9AD),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(AppSvg.calendar, width: 14),
          const SizedBox(width: 8),
          Text(
            DateFormat.yMMMd().format(DateTime.now()),
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }

  userProfileContainer(BuildContext context, String profileImage) {
    return Positioned(
      top: 0,
      child: Container(
        width: 105,
        height: 105,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: AppColor.secondaryColor,
          image: profileImage == null
              ? const DecorationImage(
                  image: AssetImage(AppImage.user),
                  fit: BoxFit.fill,
                )
              : DecorationImage(
                  image: NetworkImage(
                      "${AppUrl.baseUrl}public/profile_uploads/$profileImage"),
                  fit: BoxFit.fill,
                ),
          border: Border.all(
            width: 8,
            strokeAlign: BorderSide.strokeAlignOutside,
            color: AppColor.secondaryColor,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x2800366D),
              offset: Offset(0, 3),
              blurRadius: 6,
            ),
          ],
        ),
      ),
    );
  }
}
