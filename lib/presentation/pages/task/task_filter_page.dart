import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../config/theme/app_assets.dart';
import '../../../config/theme/app_colors.dart';
import '../../../data/models/create_new_task_modelo.dart';
import '../../../data/models/task_model.dart';
import '../../../logic/cubit/task/task_filter/task_filter_cubit.dart';
import '../../../logic/rxdart/task/task_filter_bloc.dart';
import '../../components/app_loader.dart';
import 'task_detail_page.dart';
import 'task_update_page.dart';

class TaskFilterPage extends StatefulWidget {
  static const String id = 'task_filter_page';

  const TaskFilterPage({Key? key}) : super(key: key);

  @override
  State<TaskFilterPage> createState() => _TaskFilterPageState();
}

class _TaskFilterPageState extends State<TaskFilterPage> {
  final taskFilterBloc = TaskFilterBloc();
  late TaskFilterCubit taskFilterCubit;

  @override
  void initState() {
    super.initState();
    taskFilterCubit = BlocProvider.of<TaskFilterCubit>(context);
    taskFilterCubit.fetchTaskFilterInitial();
    taskFilterBloc.fetchTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: BlocConsumer<TaskFilterCubit, TaskFilterState>(
        listener: (_, state) {},
        builder: (_, state) {
          if (state is TaskFilterLoading) {
            return showCirclerLoading(context, 40);
          }
          if (state is TaskFilterPageLoading) {
            return showCirclerLoading(context, 40);
          }
          if (state is TaskFilterPageLoaded) {
            final taskList = state.taskList;
            return taskList.isEmpty
                ? Container() //getTaskEmpty(context)
                : ListView.builder(
                    itemCount: taskList.length,
                    itemBuilder: (_, index) =>
                        taskListUI(context, taskList[index]),
                  );
          }
          return _buildFilterFormUI();
        },
      ),
      bottomNavigationBar: BlocBuilder<TaskFilterCubit, TaskFilterState>(
        builder: (context, state) {
          if (state is TaskFilterPageLoading) {
            return const SizedBox();
          }
          if (state is TaskFilterPageLoaded) {
            return const SizedBox();
          }
          return BottomAppBar(
            child: Container(
              height: 90,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: submitButton(onTap: () {
                taskFilterBloc.fetchTaskFilterLoaded(context);
              }),
            ),
          );
        },
      ),
    );
  }

  _appBar() {
    return AppBar(
      backgroundColor: AppColor.appColor,
      elevation: 0,
      leading: IconButton(
          onPressed: (() => Navigator.pop(context)),
          icon: const Icon(Icons.close)),
      title: Text('Task Filter',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold, color: AppColor.secondaryColor)),
      centerTitle: true,
    );
  }

  _buildFilterFormUI() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              streamDataPicker(label: 'Start Date'),
              const SizedBox(width: 12),
              streamDataPicker(label: 'End Date'),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "Client List *",
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(letterSpacing: 1, color: AppColor.grayColor),
          ),
          const SizedBox(height: 4),
          StreamBuilder<List<CommonList>>(
              stream: taskFilterBloc.selectClientListFilter,
              builder: (context, snapshot) {
                // final clientList = snapshot.data;
                final clientList = taskFilterBloc.client;
                List<CommonList> selectedFilters = snapshot.data ?? [];
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                return Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: clientList.isEmpty
                      ? []
                      : List<Widget>.generate(clientList.length, (index) {
                          final filter = clientList[index];
                          bool isSelected = selectedFilters.contains(filter);
                          return FilterChip(
                            label: Text(filter.name!),
                            selected: isSelected,
                            onSelected: (bool value) {
                              taskFilterBloc
                                  .updateClientListSelectedFilters(filter);
                            },
                          );
                        }),
                );
              }),
          const SizedBox(height: 16),
          Text(
            "Project List *",
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(letterSpacing: 1, color: AppColor.grayColor),
          ),
          const SizedBox(height: 4),
          StreamBuilder<List<CommonList>>(
              stream: taskFilterBloc.selectProjectListFilter,
              builder: (context, snapshot) {
                final projectList = taskFilterBloc.project;
                List<CommonList> selectedFilters = snapshot.data ?? [];
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                return Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: projectList.isEmpty
                      ? []
                      : List<Widget>.generate(projectList.length, (index) {
                          final filter = projectList[index];
                          bool isSelected = selectedFilters.contains(filter);
                          return FilterChip(
                            label: Text(filter.name!),
                            selected: isSelected,
                            onSelected: (bool value) {
                              taskFilterBloc
                                  .updateProjectListSelectedFilters(filter);
                            },
                          );
                        }),
                );
              }),
        ],
      ),
    );
  }

  streamDataPicker({required String label}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label *",
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(letterSpacing: 1, color: AppColor.grayColor),
          ),
          const SizedBox(height: 8),
          StreamBuilder<DateTime>(
            stream: label == "Start Date"
                ? taskFilterBloc.startDate
                : taskFilterBloc.endDate,
            builder: (context, snapshot) {
              final selectedDate = snapshot.data ?? DateTime.now();
              final selectDate = label == "Start Date"
                  ? taskFilterBloc.selectedStartDate
                  : taskFilterBloc.selectedEndDate;
              return InkWell(
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    if (label == "Start Date") {
                      taskFilterBloc.selectStartDate(pickedDate);
                    } else {
                      taskFilterBloc.selectEndDate(pickedDate);
                    }
                  }
                },
                child: Container(
                  height: 58,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(width: .8, color: AppColor.grayColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(
                        selectDate.valueOrNull ?? 'Select a date',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            letterSpacing: 0.5,
                            color: selectDate.valueOrNull != null
                                ? AppColor.primaryColor
                                : AppColor.grayColor),
                      ),
                      const Spacer(),
                      SvgPicture.asset(
                        AppSvg.calendar,
                        color: const Color(0xFF5B8DB9),
                        width: 24,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  submitButton({required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 54,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColor.appColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'Apply',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(letterSpacing: 1, color: AppColor.bgColor),
        ),
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
              arguments: TaskDetailPage(taskId: data.taskId!));
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
                              );
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
