import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../config/theme/app_assets.dart';
import '../../../config/theme/app_colors.dart';
import '../../../data/models/ticket_details_model.dart';
import '../../../logic/cubit/ticket/ticket_crud/ticket_crud_cubit.dart';
import '../../components/app_loader.dart';
import 'ticket_update_page.dart';

class TicketDetailPage extends StatefulWidget {
  static const String id = 'ticket_detail_page';

  final int ticketId;
  final String statusName;

  const TicketDetailPage(
      {Key? key, required this.ticketId, required this.statusName})
      : super(key: key);

  @override
  State<TicketDetailPage> createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketDetailPage> {
  late TicketCrudCubit ticketCrudCubit;

  @override
  void initState() {
    super.initState();
    ticketCrudCubit = BlocProvider.of<TicketCrudCubit>(context);
    ticketCrudCubit.getTicketDetails(widget.ticketId);
  }

  @override
  void dispose() {
    super.dispose();
    ticketCrudCubit.isClosed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: BlocBuilder<TicketCrudCubit, TicketCrudState>(
        builder: (context, state) {
          if (state is TicketCrudLoading) {
            return showCirclerLoading(context, 40);
          }
          if (state is TicketCrudFailure) {
            if (state is TicketCrudLoading) {
              return showCirclerLoading(context, 40);
            }
          }
          if (state is TicketCrudDetailLoaded) {
            final isCheckTaskCompleted = widget.statusName == 'Closed';
            return SingleChildScrollView(
              child: Column(
                children: [
                  isCheckTaskCompleted
                      ? completedStatus(state.ticketDetails)
                      : Container(),
                  ticketListDetailsUI(state.ticketDetails),
                  attachmentUI(state.ticketDetails),
                ],
              ),
            );
          }
          return Container();
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: widget.statusName == 'Closed' ? 0 : 80,
          padding: EdgeInsets.all(widget.statusName == 'Closed' ? 0 : 16),
          child: widget.statusName == 'Closed'
              ? Container()
              : ticketUpdateButton(onTap: () {
                  Navigator.pushNamed(context, TicketUpdatePage.id,
                          arguments:
                              TicketUpdatePage(ticketId: widget.ticketId))
                      .then((value) => BlocProvider.of<TicketCrudCubit>(context)
                        ..getTicketDetails(widget.ticketId));
                }),
        ),
      ),
    );
  }

  appBar() {
    return AppBar(
      backgroundColor: AppColor.appColor,
      elevation: 0,
      leading: IconButton(
          onPressed: (() => Navigator.pop(context)),
          icon: const Icon(Icons.arrow_back_rounded)),
      title: Text('Ticket Details',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold, color: AppColor.secondaryColor)),
      centerTitle: true,
    );
  }

  completedStatus(TicketDetailsModel ticket) {
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
              'Great! You have Completed the Tickets',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  ticketListDetailsUI(TicketDetailsModel ticket) {
    var isDateTime = ticket.createdAt.toString();
    final splitted = isDateTime.split(' ');
    var time =
        DateFormat.jm().format(DateFormat("hh:mm:ss").parse(splitted[1]));
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
                            ticket.subject ?? '--',
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
                                '${splitted[0]} | ',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.grayColor,
                                    ),
                              ),
                              Text(
                                time,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
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
                        child: Text(
                          'Ticket ID : ${ticket.ticketId ?? ''}',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        'Priority',
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(color: AppColor.grayColor),
                      ),
                      const SizedBox(width: 16),
                      pointBox(
                        gradientColorOne: const Color(0xFFFFBA5C),
                        gradientColorTwo: const Color(0xFFFFBA5C),
                        radius: 8,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        ticket.priorityId ?? 'Medium',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColor.grayColor,
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
                    ticket.description ?? '',
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
                  ticketsUserProfileIcon(),
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
                        ticket.assignTo ?? '',
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

  attachmentUI(TicketDetailsModel data) {
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
                context: context, attachementFile: data.ticketAttachments!),
          ],
        ),
      ),
    );
  }

  attachmenFileCardBox(
      {required BuildContext context,
      required List<TicketAttachments> attachementFile}) {
    return attachementFile.isEmpty
        ? Container(
            alignment: Alignment.center,
            child: Text(
              'No Attachment File',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w500, color: AppColor.grayColor),
            ))
        : Column(
            children: [
              for (var i = 1; i <= attachementFile.length; i++)
                Row(
                  children: [
                    Text(
                      attachementFile[i].attachment!,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColor.grayColor),
                    ),
                    const Spacer(),
                    Text(
                      'Download',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF6E83EB)),
                    ),
                    const SizedBox(width: 6),
                    SvgPicture.asset(AppSvg.download, width: 12)
                  ],
                ),
            ],
          );
  }

  ticketUpdateButton({required Function() onTap, double? width}) {
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
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColor.secondaryColor),
            ),
            const SizedBox(width: 16),
            SvgPicture.asset(AppSvg.rightArrow,
                height: 13, color: AppColor.secondaryColor),
          ],
        ),
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
}
