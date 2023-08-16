import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../config/theme/app_assets.dart';
import '../../../config/theme/app_colors.dart';
import '../../../data/models/attendance_model.dart';
import '../../../data/utils/convert_datetime.dart';
import '../../../logic/bloc/home/attendance_list/attendance_list_bloc.dart';
import '../../components/show_bottom_sheet.dart';

class AttendanceHistoryPage extends StatelessWidget {
  static const String id = 'attendance_history_page';

  const AttendanceHistoryPage({Key? key}) : super(key: key);

  Future<void> refresh() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: BlocBuilder<AttendanceListBloc, AttendanceListState>(
          builder: (context, state) {
        if (state is AttendanceListLoaded) {
          return RefreshIndicator(
            onRefresh: refresh,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
              scrollDirection: Axis.vertical,
              itemCount: state.attendanceList.length,
              itemBuilder: (_, index) {
                return attendanceListBox(context, state.attendanceList[index]);
              },
            ),
          );
        }
        return Container();
      }),
    );
  }

  appBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.appColor,
      elevation: 0,
      leading: IconButton(
          onPressed: (() => Navigator.pop(context)),
          icon: const Icon(Icons.arrow_back_rounded)),
      title: Text(
        'Attendances',
        style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold, color: AppColor.secondaryColor),
      ),
      centerTitle: true,
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
}
