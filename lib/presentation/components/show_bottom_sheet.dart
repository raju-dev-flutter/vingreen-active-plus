import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../config/theme/app_assets.dart';
import '../../config/theme/app_colors.dart';
import '../../data/models/attendance_model.dart';

showBottomSheetModel(
    {required BuildContext context, required AttendanceList attendance}) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        final textTheme = Theme.of(context).textTheme;
        final attendanceType = attendance.type == 'checkin'
            ? 'Check In Details'
            : 'Check Out Details';

        var isDateTime = attendance.attendanceAt.toString();
        final splitted = isDateTime.split(' ');

        var time =
            DateFormat.jm().format(DateFormat("hh:mm:ss").parse(splitted[1]));

        final workHours =
            attendance.workHours == '' || attendance.workHours == null
                ? '-- : --'
                : attendance.workHours.toString();

        return Container(
          height: MediaQuery.of(context).size.height / 1.6,
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16),
              topLeft: Radius.circular(16),
            ),
            color: AppColor.secondaryColor,
          ),
          child: ListView(
            padding: const EdgeInsets.all(6),
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColor.grayColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                attendanceType,
                style: textTheme.headlineMedium?.copyWith(letterSpacing: .5),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  iconBox(
                    svgSrc: AppSvg.calendar,
                    color: AppColor.focusColor,
                    shadow: const Color(0x17F06C71),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date',
                        style: textTheme.bodyMedium?.copyWith(
                          letterSpacing: .5,
                          fontWeight: FontWeight.w500,
                          color: AppColor.grayColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        splitted[0],
                        style: textTheme.bodyMedium?.copyWith(
                          letterSpacing: .5,
                          color: AppColor.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Container(
                      width: 2, height: 34, color: const Color(0x52588EE5)),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Time',
                        style: textTheme.bodyMedium?.copyWith(
                          letterSpacing: .5,
                          fontWeight: FontWeight.w500,
                          color: AppColor.grayColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        time,
                        style: textTheme.bodyMedium?.copyWith(
                          letterSpacing: .5,
                          color: AppColor.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  iconBox(
                    svgSrc: AppSvg.taskTimer,
                    color: AppColor.focusColor,
                    shadow: const Color(0x17F06C71),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Working Hours',
                        style: textTheme.bodyMedium?.copyWith(
                          letterSpacing: .5,
                          fontWeight: FontWeight.w500,
                          color: AppColor.grayColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        workHours,
                        style: textTheme.bodyMedium?.copyWith(
                          letterSpacing: .5,
                          color: AppColor.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: textTheme.bodyLarge?.copyWith(
                      letterSpacing: .5,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    attendance.description ?? '--',
                    style: textTheme.bodyMedium?.copyWith(
                      letterSpacing: .5,
                      color: AppColor.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      });
}

iconBox({required String svgSrc, required Color color, required Color shadow}) {
  return Container(
    width: 34,
    height: 34,
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      border: Border.all(
        width: 1,
        color: color,
        strokeAlign: BorderSide.strokeAlignOutside,
      ),
      boxShadow: [
        BoxShadow(
          color: shadow,
          offset: const Offset(0, 6),
          blurRadius: 15,
        ),
      ],
    ),
    child: SvgPicture.asset(svgSrc, color: color),
  );
}
