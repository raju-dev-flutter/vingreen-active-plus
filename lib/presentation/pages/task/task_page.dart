import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:vingreen_active_plus/presentation/pages/task/task_add_page.dart';
import 'package:vingreen_active_plus/presentation/pages/task/task_detail_page.dart';

import '../../../config/theme/app_assets.dart';
import '../../../config/theme/app_colors.dart';
import '../../../data/models/task_model.dart';
import '../../../logic/cubit/task/task_completed/task_completed_cubit.dart';
import '../../../logic/cubit/task/task_progress/task_progress_cubit.dart';
import '../../../logic/cubit/task/task_start/task_start_cubit.dart';
import '../../components/app_loader.dart';
import 'task_filter_page.dart';
import 'task_update_page.dart';

class TaskPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldkey;

  const TaskPage({Key? key, required this.scaffoldkey}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late TaskStartCubit taskStartCubit;
  late TaskProgressCubit taskProgressCubit;
  late TaskCompletedCubit taskCompletedCubit;

  @override
  void initState() {
    super.initState();
    taskStartCubit = BlocProvider.of<TaskStartCubit>(context);
    taskStartCubit.getTaskStartDetails();
    taskProgressCubit = BlocProvider.of<TaskProgressCubit>(context);
    taskProgressCubit.getTaskProgressDetails();
    taskCompletedCubit = BlocProvider.of<TaskCompletedCubit>(context);
    taskCompletedCubit.getTaskCompletedDetails();
  }

  Future<void> refresh() async {
    taskStartCubit = BlocProvider.of<TaskStartCubit>(context);
    taskStartCubit.getTaskStartDetails();
    taskProgressCubit = BlocProvider.of<TaskProgressCubit>(context);
    taskProgressCubit.getTaskProgressDetails();
    taskCompletedCubit = BlocProvider.of<TaskCompletedCubit>(context);
    taskCompletedCubit.getTaskCompletedDetails();
  }

  @override
  Widget build(BuildContext context) {
    // final watchTaskStartCubit = context.watch<TaskStartCubit>();
    // watchTaskStartCubit.getTaskStartDetails();
    // final watchTaskProgressCubit = context.watch<TaskProgressCubit>();
    // watchTaskProgressCubit.getTaskProgressDetails();
    // final watchTaskCompleteCubit = context.watch<TaskCompletedCubit>();
    // watchTaskCompleteCubit.getTaskCompletedDetails();

    final taskStart = BlocProvider.of<TaskStartCubit>(context, listen: false);
    final taskProgress =
        BlocProvider.of<TaskProgressCubit>(context, listen: false);
    final taskCompleted =
        BlocProvider.of<TaskCompletedCubit>(context, listen: false);
    return DefaultTabController(
      length: 3,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              pinned: true,
              backgroundColor: AppColor.appColor,
              leading: appBarButton(
                svgSrc: AppSvg.menu,
                onPressed: (() =>
                    widget.scaffoldkey.currentState!.openDrawer()),
              ),
              title: Text('Task',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColor.secondaryColor)),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: (() {
                    Navigator.pushNamed(context, TaskAddPage.id)
                        .then((value) => refresh());
                  }),
                  icon: SvgPicture.asset(AppSvg.add,
                      width: 18, color: AppColor.secondaryColor),
                ),
                IconButton(
                  onPressed: () {
                    // _scaffoldkey.currentState!.openEndDrawer();
                    Navigator.pushNamed(context, TaskFilterPage.id);
                  },
                  icon: SvgPicture.asset(AppSvg.filter,
                      width: 18, color: AppColor.secondaryColor),
                ),
              ],
              bottom: TabBar(
                indicatorPadding: const EdgeInsets.all(0),
                indicatorColor: const Color(0xFFFFFFFF),
                labelPadding: const EdgeInsets.all(0),
                labelColor: const Color(0xFFFFFFFF),
                unselectedLabelColor: const Color(0xABFFFFFF),
                unselectedLabelStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                labelStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                isScrollable: false,
                onTap: (value) {
                  if (value == 0) taskStart.getTaskStartDetails();
                  if (value == 1) taskProgress.getTaskProgressDetails();
                  if (value == 2) taskCompleted.getTaskCompletedDetails();
                },
                tabs: const [
                  Tab(text: 'Yet to Start'),
                  Tab(text: 'In Progress'),
                  Tab(text: 'Completed'),
                ],
              ),
            )
          ];
        },
        body: TabBarView(
          children: [
            BlocBuilder<TaskStartCubit, TaskStartState>(
              builder: (context, state) {
                if (state is TaskStartLoading) {
                  return showCirclerLoading(context, 40);
                }
                if (state is TaskStartDetails) {
                  return state.taskList.isEmpty
                      ? Container() //getTaskEmpty(context)
                      : ListView.builder(
                          itemCount: state.taskList.length,
                          itemBuilder: (_, index) =>
                              taskListUI(context, state.taskList[index]),
                        );
                }
                return Container();
              },
            ),
            BlocBuilder<TaskProgressCubit, TaskProgressState>(
              builder: (context, state) {
                if (state is TaskProgressLoading) {
                  return showCirclerLoading(context, 40);
                }
                if (state is TaskProgressDetails) {
                  return state.taskList.isEmpty
                      ? Container() //getTaskEmpty(context)
                      : ListView.builder(
                          itemCount: state.taskList.length,
                          itemBuilder: (_, index) =>
                              taskListUI(context, state.taskList[index]),
                        );
                }
                return Container();
              },
            ),
            BlocBuilder<TaskCompletedCubit, TaskCompletedState>(
              builder: (context, state) {
                if (state is TaskCompletedLoading) {
                  return showCirclerLoading(context, 40);
                }
                if (state is TaskCompletedDetails) {
                  return state.taskList.isEmpty
                      ? Container() //getTaskEmpty(context)
                      : ListView.builder(
                          itemCount: state.taskList.length,
                          itemBuilder: (_, index) =>
                              taskListUI(context, state.taskList[index]),
                        );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
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

  taskListUI(BuildContext context, TaskList data) {
    final isCheckTaskStatusCompleted = data.taskStatus == '5';

    var isDateTime = data.createdAt.toString();
    final splitted = isDateTime.split(' ');
    final splittedDate = splitted[0].split('-');

    int year = int.parse(splittedDate[0]);
    int date = int.parse(splittedDate[1]);
    int month = int.parse(splittedDate[2]);

    var assignedDate = '$date.$month.$year';

    var assignedTime =
        DateFormat.jm().format(DateFormat("hh:mm:ss").parse(splitted[1]));

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
      child: InkWell(
        onTap: (() {
          Navigator.pushNamed(context, TaskDetailPage.id,
                  arguments: TaskDetailPage(taskId: data.taskId!))
              .then((value) => refresh());
        }),
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
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.taskName ?? ' ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  AppSvg.taskCalender,
                                  width: 14,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '$assignedDate | ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.grayColor,
                                      ),
                                ),
                                Text(
                                  assignedTime,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: AppColor.grayColor),
                                ),
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
                          child: Text('Task ID : ${data.taskId ?? ''}',
                              style: Theme.of(context).textTheme.bodySmall),
                        ),
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
                              colors: [Color(0xFFEBEBEB), Color(0xFF696969)],
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
                              colors: [Color(0xFFF1F1F1), Color(0x00FFFFFF)],
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
                                    .bodySmall
                                    ?.copyWith(color: AppColor.grayColor),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  infoPointBox(
                                    gColorOne: const Color(0xFFFFBA5C),
                                    gColorTwo: const Color(0xFFFFBA5C),
                                    radius: 8,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    data.statusName ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: AppColor.grayColor),
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
                                    .bodySmall
                                    ?.copyWith(color: AppColor.grayColor),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                data.projectName ?? 'VG Office Suite',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
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
              const Divider(
                  height: 0, thickness: 0.5, color: Color(0xFFF0F0F0)),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    taskUserProfileIcon(),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Assigned by',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.w300,
                                    color: AppColor.grayColor,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          data.assignTo ?? ' ',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColor.grayColor,
                                  ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    isCheckTaskStatusCompleted
                        ? completeTaskUpdate(context)
                        : taskUpdateButton(
                            context: context,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                TaskUpdatePage.id,
                                arguments: TaskUpdatePage(taskId: data.taskId!),
                              ).then((value) => refresh());
                            },
                          ),
                  ],
                ),
              ),
            ],
          ),
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

  infoContainer(BuildContext context) {
    return Container(
      color: AppColor.secondaryColor,
      padding: const EdgeInsets.fromLTRB(30, 8, 30, 8),
      child: Row(
        children: [
          infoPointBox(
            gColorOne: const Color(0xFFD8ED6F),
            gColorTwo: const Color(0xFF6ABB75),
          ),
          const SizedBox(width: 6),
          Text(
            'Assigned Date',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColor.grayColor),
          ),
          const SizedBox(width: 12),
          infoPointBox(
            gColorOne: const Color(0xFFFFD27E),
            gColorTwo: const Color(0xFFFF6969),
          ),
          const SizedBox(width: 6),
          Text(
            'Task Deadline',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColor.grayColor),
          ),
        ],
      ),
    );
  }

  infoPointBox(
      {required Color gColorOne, required Color gColorTwo, double? radius}) {
    return Container(
      width: radius ?? 10,
      height: radius ?? 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 1),
        gradient: LinearGradient(
            colors: [gColorOne, gColorTwo],
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

  taskUpdateButton({required BuildContext context, required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 130,
        height: 40,
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
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColor.secondaryColor),
            ),
            const SizedBox(width: 8),
            SvgPicture.asset(AppSvg.rightArrow,
                height: 13, color: AppColor.secondaryColor),
          ],
        ),
      ),
    );
  }

  completeTaskUpdate(BuildContext context) {
    return Container(
      width: 130,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFDCF7E0),
        border: Border.all(width: 1, color: const Color(0xFF3EB783)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'Completed',
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: AppColor.appColor),
      ),
    );
  }
}
