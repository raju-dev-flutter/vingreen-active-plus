import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../config/theme/app_assets.dart';
import '../../../config/theme/app_colors.dart';
import '../../../data/models/task_detail_model.dart';
import '../../../data/repositories/task_repositories.dart';
import '../../../logic/cubit/task/task_detail/task_detail_cubit.dart';
import '../../components/app_loader.dart';

class TaskDetailPage extends StatelessWidget {
  static const String id = 'task_detail_page';
  final int taskId;

  const TaskDetailPage({Key? key, required this.taskId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return TaskDetailCubit(
          taskRepositories: context.read<TaskRepositories>(),
        )..getTaskDetails(taskId);
      },
      child: Scaffold(
        appBar: appBar(context),
        body: BlocBuilder<TaskDetailCubit, TaskDetailState>(
          builder: (context, state) {
            if (state is TaskDetailLoading) {
              return showCirclerLoading(context, 40);
            }
            if (state is TaskDetailFailure) {}
            if (state is TaskDetailLoaded) {
              final isCheckTaskCompleted =
                  state.taskDetail.taskStatusName == 'Completed';
              debugPrint(state.taskDetail.taskStatusName);
              return Column(
                children: [
                  isCheckTaskCompleted ? completedStatus(context) : Container(),
                  ticketsDetailsUI(context, state.taskDetail),
                  attachmentUI(context, state.taskDetail),
                  lastTicketsUpdateUI(context, state.taskDetail),
                ],
              );
            }
            return Container();
          },
        ),
        // bottomNavigationBar: SizedBox(),
      ),
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
        'Task Details',
        style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold, color: AppColor.secondaryColor),
      ),
      centerTitle: true,
    );
  }

  completedStatus(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        decoration: boxDecoration(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(AppSvg.taskCompleted, width: 40),
            const SizedBox(width: 8),
            Text(
              'Great! You have Completed the Task',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  ticketsDetailsUI(BuildContext context, TaskDetailModel task) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Container(
        decoration: boxDecoration(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.taskName ?? '--',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(AppSvg.taskCalender, width: 10),
                              const SizedBox(width: 8),
                              Text(
                                '${task.createdDate} | ',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.grayColor,
                                    ),
                              ),
                              Text(
                                task.createdTime ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(color: AppColor.grayColor),
                              ),
                              // const SizedBox(width: 22),
                              // SvgIcon(svgSrc: AppSvg.TASKTIMER, width: AppSize.C1 + 1),
                              // const SizedBox(width: 6),
                              // CustomText(
                              //   text: '-- : -- : ----',
                              //   fontSize: AppSize.C2,
                              //   fontWeight: FontWeight.w500,
                              //   color: AppColor.GRAYCOLORPRIM,
                              // ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        width: 90,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD6FFDC),
                          border:
                              Border.all(width: 1, color: AppColor.appColor),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Task ID : ${task.taskId ?? ''}',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 3,
                        height: 30,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFD8ED6F), Color(0xFF6ABB75)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      Container(
                        width: 7,
                        height: 30,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFEEFFBF), Color(0x00FFFFFF)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Priority',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(color: AppColor.grayColor),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                pointBox(
                                  gradientColorOne: const Color(0xFFFFBA5C),
                                  gradientColorTwo: const Color(0xFFFFBA5C),
                                  radius: 8,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Medium',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColor.grayColor,
                                      ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Project Name',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(color: AppColor.grayColor),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              task.projectName ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.grayColor,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 0, thickness: 0.5, color: Color(0xFFF0F0F0)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Task Description',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColor.grayColor,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    task.description ?? '',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w300,
                          color: AppColor.grayColor,
                        ),
                  ),
                ],
              ),
            ),
            const Divider(height: 0, thickness: 0.5, color: Color(0xFFF0F0F0)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  taskUserProfileIcon(),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assigned by',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w300,
                              color: AppColor.grayColor,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        task.assignTo ?? '',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppColor.grayColor,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  attachmentUI(BuildContext context, TaskDetailModel task) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        decoration: boxDecoration(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Attachments',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            attachmenFileCardBox(
                context: context, attachementFile: task.attachment ?? ''),
            // const SizedBox(height: 16),
            // attachmenFileCardBox(attachementFile: 'Learning Material.pdf'),
          ],
        ),
      ),
    );
  }

  attachmenFileCardBox(
      {required BuildContext context, required String attachementFile}) {
    return Row(
      children: [
        Text(
          attachementFile,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w500, color: AppColor.grayColor),
        ),
        const Spacer(),
        Text(
          'Download',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w500, color: const Color(0xFF6E83EB)),
        ),
        const SizedBox(width: 6),
        SvgPicture.asset(AppSvg.download, width: 12)
      ],
    );
  }

  lastTicketsUpdateUI(BuildContext context, TaskDetailModel task) {
    final isCheckTaskStart = task.taskStatus == '1';
    final isCheckTaskCompleted = task.taskStatus == '5';
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        decoration: boxDecoration(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(AppSvg.flag, width: 16),
                const SizedBox(width: 6),
                Text(
                  'Last Update',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                // const Spacer(),
                // CustomText(
                //   text: 'View History',
                //   fontWeight: FontWeight.w500,
                //   fontSize: AppSize.C2,
                // ),
                // const SizedBox(width: 6),
                // SvgIcon(svgSrc: AppSvg.RIGHTARROW, width: 5),
              ],
            ),
            const SizedBox(height: 12),
            isCheckTaskStart
                ? Column(
                    children: [
                      const Image(
                        image: AssetImage(AppIcon.taskUpdateEmpty),
                        width: 100,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'This Task has no last update history. You can update the status now!',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w300,
                              color: AppColor.grayColor,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(AppSvg.taskCalender, width: 11),
                      const SizedBox(width: 8),
                      Text(
                        '${task.createdDate} | ',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColor.grayColor,
                            ),
                      ),
                      Text(
                        task.createdTime ?? '',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppColor.grayColor,
                            ),
                      ),
                      const Spacer(),
                      isCheckTaskCompleted
                          ? ticketStatusUpdate(
                              context: context,
                              taskStatus: task.taskStatusName ?? '',
                              bgColor: const Color(0xFFDCF7E0),
                              brColor: const Color(0xFF3EB783),
                            )
                          : ticketStatusUpdate(
                              context: context,
                              taskStatus: task.taskStatusName ?? '',
                              bgColor: const Color(0xFFFFF2D6),
                              brColor: const Color(0xFFFFCE60),
                            ),
                    ],
                  ),
            isCheckTaskStart ? Container() : const SizedBox(height: 12),
            isCheckTaskStart
                ? Container()
                : Text(
                    task.statusDescription ?? '',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w300,
                          color: AppColor.grayColor,
                        ),
                  ),
          ],
        ),
      ),
    );
  }

  boxDecoration(double borderRadius) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      color: const Color(0xFFFFFFFF),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0800366D),
          offset: Offset(0, 3),
          blurRadius: 6,
        ),
      ],
    );
  }

  taskUserProfileIcon() {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        image: const DecorationImage(
          image: AssetImage(AppIcon.leadProfileMale),
          fit: BoxFit.cover,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(40, 0, 54, 109),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
    );
  }

  ticketUpdateButton(
      {required BuildContext context,
      required Function() onTap,
      double? width}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        height: 50,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFFD8ED6F), Color(0xFF6ABB75)],
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              transform: GradientRotation(20)),
          borderRadius: BorderRadius.circular(4),
          boxShadow: const [
            BoxShadow(
              color: Color(0x4BA6D672),
              offset: Offset(0, 3),
              blurRadius: 6,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Update Status',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600, color: AppColor.secondaryColor),
            ),
            const SizedBox(width: 16),
            SvgPicture.asset(AppSvg.rightArrow,
                height: 11, color: AppColor.secondaryColor),
          ],
        ),
      ),
    );
  }

  ticketStatusUpdate(
      {required BuildContext context,
      required String taskStatus,
      required Color bgColor,
      required Color brColor}) {
    return Container(
      // width: 90,
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(width: 1, color: brColor),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        taskStatus,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: brColor),
      ),
    );
  }

  pointBox(
      {required Color gradientColorOne,
      required Color gradientColorTwo,
      double? radius}) {
    return Container(
      width: radius ?? 10,
      height: radius ?? 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 1),
        gradient: LinearGradient(
            colors: [gradientColorOne, gradientColorTwo],
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            transform: const GradientRotation(20)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0800366D),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
    );
  }
}
