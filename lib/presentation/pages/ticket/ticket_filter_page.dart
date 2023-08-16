import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../config/theme/app_assets.dart';
import '../../../config/theme/app_colors.dart';
import '../../../data/models/create_new_ticket_model.dart';
import '../../../data/models/ticket_model.dart';
import '../../../logic/cubit/ticket/ticket_filter/ticket_filter_cubit.dart';
import '../../../logic/rxdart/ticket/ticket_filter_bloc.dart';
import '../../components/app_loader.dart';
import 'ticket_detail_page.dart';
import 'ticket_update_page.dart';

class TicketFilterPage extends StatefulWidget {
  static const String id = 'ticket_filter_page';

  const TicketFilterPage({Key? key}) : super(key: key);

  @override
  State<TicketFilterPage> createState() => _TicketFilterPageState();
}

class _TicketFilterPageState extends State<TicketFilterPage> {
  final ticketFilterBloc = TicketFilterBloc();
  late TicketFilterCubit ticketFilterCubit;

  @override
  void initState() {
    super.initState();
    ticketFilterCubit = BlocProvider.of<TicketFilterCubit>(context);
    ticketFilterCubit.fetchTicketFilterInitial();
    ticketFilterBloc.fetchTicketList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: BlocConsumer<TicketFilterCubit, TicketFilterState>(
        listener: (_, state) {},
        builder: (_, state) {
          if (state is TicketFilterLoading) {
            return showCirclerLoading(context, 40);
          }
          if (state is TicketFilterPageLoading) {
            return showCirclerLoading(context, 40);
          }
          if (state is TicketFilterPageLoaded) {
            final ticketList = state.ticketList;
            return ticketList.isEmpty
                ? Container() //getTaskEmpty(context)
                : ListView.builder(
                    itemCount: ticketList.length,
                    itemBuilder: (_, index) =>
                        ticketListUI(context, ticketList[index]),
                  );
          }
          return _buildFilterFormUI();
        },
      ),
      bottomNavigationBar: BlocBuilder<TicketFilterCubit, TicketFilterState>(
        builder: (context, state) {
          if (state is TicketFilterLoading) {
            return const SizedBox();
          }
          if (state is TicketFilterPageLoaded) {
            return const SizedBox();
          }
          return BottomAppBar(
            child: Container(
              height: 90,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: submitButton(onTap: () {
                ticketFilterBloc.fetchTicketFilterLoaded(context);
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
      title: Text('Ticket Filter',
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
          StreamBuilder<List<CommonTicketObj>>(
              stream: ticketFilterBloc.selectClientListFilter,
              builder: (context, snapshot) {
                // final clientList = snapshot.data;
                final clientList = ticketFilterBloc.client;
                List<CommonTicketObj> selectedFilters = snapshot.data ?? [];
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
                              ticketFilterBloc
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
          StreamBuilder<List<CommonTicketObj>>(
              stream: ticketFilterBloc.selectProjectListFilter,
              builder: (context, snapshot) {
                final priorityList = ticketFilterBloc.priority;
                List<CommonTicketObj> selectedFilters = snapshot.data ?? [];
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                return Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: priorityList.isEmpty
                      ? []
                      : List<Widget>.generate(priorityList.length, (index) {
                          final filter = priorityList[index];
                          bool isSelected = selectedFilters.contains(filter);
                          return FilterChip(
                            label: Text(filter.name!),
                            selected: isSelected,
                            onSelected: (bool value) {
                              ticketFilterBloc
                                  .updatePriorityListSelectedFilters(filter);
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
                ? ticketFilterBloc.startDate
                : ticketFilterBloc.endDate,
            builder: (context, snapshot) {
              final selectedDate = snapshot.data ?? DateTime.now();
              final selectDate = label == "Start Date"
                  ? ticketFilterBloc.selectedStartDate
                  : ticketFilterBloc.selectedEndDate;
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
                      ticketFilterBloc.selectStartDate(pickedDate);
                    } else {
                      ticketFilterBloc.selectEndDate(pickedDate);
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

  ticketListUI(BuildContext context, Tickets data) {
    final isCheckTicketsStatusCompleted = data.ticketStatusName == 'Closed';

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
          Navigator.pushNamed(context, TicketDetailPage.id,
              arguments: TicketDetailPage(
                ticketId: data.ticketId!,
                statusName: data.ticketStatusName!,
              ));
        }),
        child: Container(
          decoration: boxDecoration(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.subject ?? '',
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
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Priority',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppColor.grayColor),
                            ),
                            const SizedBox(width: 12),
                            infoPointBox(
                              gColorOne: const Color(0xFFFFBA5C),
                              gColorTwo: const Color(0xFFFFBA5C),
                              radius: 8,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              data.priorityName ?? 'Medium',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.grayColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      width: 90,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD6FFDC),
                        border: Border.all(width: 1, color: AppColor.appColor),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text('Ticket ID : ${data.ticketId ?? ''}',
                          style: Theme.of(context).textTheme.bodySmall),
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
                    ticketsUserProfileIcon(),
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
                    isCheckTicketsStatusCompleted
                        ? completeTicketsUpdate(context)
                        : ticketsUpdateButton(
                            context: context,
                            onTap: () {
                              Navigator.pushNamed(context, TicketUpdatePage.id,
                                  arguments: TicketUpdatePage(
                                      ticketId: data.ticketId!));
                            }),
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

  ticketsUserProfileIcon() {
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

  ticketsUpdateButton(
      {required BuildContext context, required Function() onTap}) {
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

  completeTicketsUpdate(BuildContext context) {
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
