import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../config/theme/app_assets.dart';
import '../../../config/theme/app_colors.dart';
import '../../../data/models/ticket_model.dart';
import '../../../logic/cubit/ticket/ticket_completed/ticket_completed_cubit.dart';
import '../../../logic/cubit/ticket/ticket_progress/ticket_progress_cubit.dart';
import '../../../logic/cubit/ticket/ticket_start/ticket_start_cubit.dart';
import '../../components/app_loader.dart';
import 'ticket_add_page.dart';
import 'ticket_detail_page.dart';
import 'ticket_filter_page.dart';
import 'ticket_update_page.dart';

class TicketPage extends StatefulWidget {
  static const String id = 'ticket_page';

  const TicketPage({Key? key}) : super(key: key);

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<TicketStartCubit>(context, listen: false)
        .getTicketStartDetails();
    BlocProvider.of<TicketProgressCubit>(context, listen: false)
        .getTicketProgressDetails();
    BlocProvider.of<TicketCompletedCubit>(context, listen: false)
        .getTicketCompletedDetails();
  }

  Future refresh(BuildContext context) async {
    BlocProvider.of<TicketStartCubit>(context, listen: false)
        .getTicketStartDetails();
    BlocProvider.of<TicketProgressCubit>(context, listen: false)
        .getTicketProgressDetails();
    BlocProvider.of<TicketCompletedCubit>(context, listen: false)
        .getTicketCompletedDetails();
  }

  @override
  Widget build(BuildContext context) {
    final ticketStart =
        BlocProvider.of<TicketStartCubit>(context, listen: false);
    final ticketProgress =
        BlocProvider.of<TicketProgressCubit>(context, listen: false);
    final ticketCompleted =
        BlocProvider.of<TicketCompletedCubit>(context, listen: false);

    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                floating: true,
                pinned: true,
                backgroundColor: AppColor.appColor,
                leading: IconButton(
                    onPressed: (() => Navigator.pop(context)),
                    icon: const Icon(Icons.arrow_back_rounded)),
                title: Text('Tickets',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColor.secondaryColor)),
                centerTitle: true,
                actions: [
                  IconButton(
                    onPressed: (() =>
                        Navigator.pushNamed(context, TicketAddPage.id)),
                    icon: SvgPicture.asset(AppSvg.add,
                        width: 18, color: AppColor.secondaryColor),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, TicketFilterPage.id)
                          .then((value) => refresh(context));
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
                  unselectedLabelStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  labelStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  isScrollable: false,
                  onTap: (value) {
                    if (value == 0) ticketStart.getTicketStartDetails();
                    if (value == 1) ticketProgress.getTicketProgressDetails();
                    if (value == 2) ticketCompleted.getTicketCompletedDetails();
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
              BlocBuilder<TicketStartCubit, TicketStartState>(
                builder: (context, state) {
                  if (state is TicketStartLoading) {
                    return showCirclerLoading(context, 40);
                  }
                  if (state is TicketStartDetails) {
                    return state.ticketList.isEmpty
                        ? Container() //getTaskEmpty(context)
                        : ListView.builder(
                            padding: const EdgeInsets.only(top: 10, bottom: 8),
                            itemCount: state.ticketList.length,
                            itemBuilder: (_, index) =>
                                ticketListUI(context, state.ticketList[index]),
                          );
                  }
                  return Container();
                },
              ),
              BlocBuilder<TicketProgressCubit, TicketProgressState>(
                builder: (context, state) {
                  if (state is TicketProgressLoading) {
                    return showCirclerLoading(context, 40);
                  }
                  if (state is TicketProgressDetails) {
                    return state.ticketList.isEmpty
                        ? Container() //getTaskEmpty(context)
                        : ListView.builder(
                            padding: const EdgeInsets.only(top: 10, bottom: 8),
                            itemCount: state.ticketList.length,
                            itemBuilder: (_, index) =>
                                ticketListUI(context, state.ticketList[index]),
                          );
                  }
                  return Container();
                },
              ),
              BlocBuilder<TicketCompletedCubit, TicketCompletedState>(
                builder: (context, state) {
                  if (state is TicketCompletedLoading) {
                    return showCirclerLoading(context, 40);
                  }
                  if (state is TicketCompletedDetails) {
                    return state.ticketList.isEmpty
                        ? Container() //getTaskEmpty(context)
                        : ListView.builder(
                            padding: const EdgeInsets.only(top: 10, bottom: 8),
                            itemCount: state.ticketList.length,
                            itemBuilder: (_, index) =>
                                ticketListUI(context, state.ticketList[index]),
                          );
                  }
                  return Container();
                },
              ),
            ],
          ),
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
                                          ticketId: data.ticketId!))
                                  .then((value) => refresh(context));
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
