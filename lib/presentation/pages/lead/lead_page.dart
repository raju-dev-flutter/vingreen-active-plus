import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/theme/app_assets.dart';
import '../../../config/theme/app_colors.dart';
import '../../../data/models/lead_model.dart';
import '../../../logic/cubit/lead/call_again/call_again_lead_cubit.dart';
import '../../../logic/cubit/lead/converted/converted_lead_cubit.dart';
import '../../../logic/cubit/lead/fresh_lead/fresh_lead_cubit.dart';
import '../../../logic/cubit/lead/reconnect/reconnect_lead_cubit.dart';
import '../../components/app_loader.dart';
import 'create_timeline_page.dart';
import 'lead_detail_page.dart';
import 'lead_filter_page.dart';
import 'lead_update_page.dart';

class LeadPage extends StatefulWidget {
  static const String id = 'lead_page';

  const LeadPage({Key? key}) : super(key: key);

  @override
  State<LeadPage> createState() => _LeadPageState();
}

class _LeadPageState extends State<LeadPage> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<FreshLeadCubit>(context, listen: false).getFreshLead();
    BlocProvider.of<CallAgainLeadCubit>(context, listen: false)
        .getCallAgainLead();
    BlocProvider.of<ReconnectLeadCubit>(context, listen: false)
        .getReconnectLead();
    BlocProvider.of<ConvertedLeadCubit>(context, listen: false)
        .getConvertedLead();
  }

  Future<void> refresh() async {
    BlocProvider.of<FreshLeadCubit>(context, listen: false).getFreshLead();
    BlocProvider.of<CallAgainLeadCubit>(context, listen: false)
        .getCallAgainLead();
    BlocProvider.of<ReconnectLeadCubit>(context, listen: false)
        .getReconnectLead();
    BlocProvider.of<ConvertedLeadCubit>(context, listen: false)
        .getConvertedLead();
  }

  @override
  Widget build(BuildContext context) {
    final freshLeadCubit =
        BlocProvider.of<FreshLeadCubit>(context, listen: false);
    final callAgainLeadCubit =
        BlocProvider.of<CallAgainLeadCubit>(context, listen: false);
    final reconnectLeadCubit =
        BlocProvider.of<ReconnectLeadCubit>(context, listen: false);
    final convertedLeadCubit =
        BlocProvider.of<ConvertedLeadCubit>(context, listen: false);

    return Scaffold(
      body: DefaultTabController(
        length: 4,
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
                title: Text('Leads',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColor.secondaryColor)),
                centerTitle: true,
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, LeadFilterPage.id);
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
                    if (value == 0) freshLeadCubit.getFreshLead();
                    if (value == 1) callAgainLeadCubit.getCallAgainLead();
                    if (value == 2) reconnectLeadCubit.getReconnectLead();
                    if (value == 2) convertedLeadCubit.getConvertedLead();
                  },
                  tabs: const [
                    Tab(icon: Text('Fresh Lead')),
                    Tab(icon: Text('Call Again')),
                    Tab(icon: Text('Reconnect')),
                    Tab(icon: Text('Converted')),
                  ],
                ),
              )
            ];
          },
          body: TabBarView(
            children: [
              BlocBuilder<FreshLeadCubit, FreshLeadState>(
                builder: (context, state) {
                  if (state is FreshLeadLoading) {
                    return showCirclerLoading(context, 40);
                  }
                  if (state is FreshLeadDetailLoaded) {
                    return state.freshLead.isEmpty
                        ? Container() //getTaskEmpty(context)
                        : ListView.builder(
                            padding: const EdgeInsets.only(bottom: 16),
                            itemCount: state.freshLead.length,
                            itemBuilder: (_, index) =>
                                leadListUI(context, state.freshLead[index]),
                          );
                  }
                  return Container();
                },
              ),
              BlocBuilder<CallAgainLeadCubit, CallAgainLeadState>(
                builder: (context, state) {
                  if (state is CallAgainLeadLoading) {
                    return showCirclerLoading(context, 40);
                  }
                  if (state is CallAgainLeadDetailLoaded) {
                    return state.callAgainLead.isEmpty
                        ? Container() //getTaskEmpty(context)
                        : ListView.builder(
                            padding: const EdgeInsets.only(bottom: 16),
                            itemCount: state.callAgainLead.length,
                            itemBuilder: (_, index) =>
                                leadListUI(context, state.callAgainLead[index]),
                          );
                  }
                  return Container();
                },
              ),
              BlocBuilder<ReconnectLeadCubit, ReconnectLeadState>(
                builder: (context, state) {
                  if (state is ReconnectLeadLoading) {
                    return showCirclerLoading(context, 40);
                  }
                  if (state is ReconnectLeadDetailLoaded) {
                    return state.reconnectLead.isEmpty
                        ? Container() //getTaskEmpty(context)
                        : ListView.builder(
                            padding: const EdgeInsets.only(bottom: 16),
                            itemCount: state.reconnectLead.length,
                            itemBuilder: (_, index) =>
                                leadListUI(context, state.reconnectLead[index]),
                          );
                  }
                  return Container();
                },
              ),
              BlocBuilder<ConvertedLeadCubit, ConvertedLeadState>(
                builder: (context, state) {
                  if (state is ConvertedLeadLoading) {
                    return showCirclerLoading(context, 40);
                  }
                  if (state is ConvertedLeadDetailLoaded) {
                    return state.convertedLead.isEmpty
                        ? Container() //getTaskEmpty(context)
                        : ListView.builder(
                            padding: const EdgeInsets.only(bottom: 16),
                            itemCount: state.convertedLead.length,
                            itemBuilder: (_, index) =>
                                leadListUI(context, state.convertedLead[index]),
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

  leadListUI(BuildContext context, LeadList lead) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: InkWell(
        onTap: (() {
          Navigator.pushNamed(context, LeadDetailsPage.id,
                  arguments: LeadDetailsPage(leadId: lead.leadId!))
              .then((value) => refresh());
        }),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xFFFFFFFF),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0800366D),
                offset: Offset(0, 3),
                blurRadius: 6,
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lead.leadName ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            SvgPicture.asset(
                              AppSvg.location,
                              width: 12,
                              color: const Color(0xFF4AA1F7),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              lead.countryName ?? ' ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF4AA1F7),
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          lead.emailId ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppColor.grayColor),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: InkWell(
                        onTap: (() {
                          Navigator.pushNamed(context, LeadUpdatePage.id,
                                  arguments:
                                      LeadUpdatePage(leadId: lead.leadId!))
                              .then((value) => refresh());
                        }),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              // color: const ,
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(150, 136, 167, 233),
                                  width: 1),
                              borderRadius: BorderRadius.circular(4)),
                          child: const Icon(Icons.edit,
                              size: 16, color: Color(0xFF88A6E9)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 0, thickness: 1, color: Color(0xFFF0F0F0)),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
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
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mobile Number',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppColor.grayColor),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            lead.mobileNumber ?? '+91',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF024461),
                                ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    leadContactCard(
                        color: const Color(0xFF55D0A1),
                        svgSrc: AppSvg.whatsapp,
                        onTap: () => performAction(
                              leadId: lead.leadId.toString(),
                              communicationMedium: 'WhatsApp',
                              mobileNo: lead.mobileNumber!,
                            )),
                    const SizedBox(width: 10),
                    leadContactCard(
                        color: const Color(0xFF6889D5),
                        svgSrc: AppSvg.message,
                        onTap: () => performAction(
                              leadId: lead.leadId.toString(),
                              communicationMedium: 'SMS',
                              mobileNo: lead.mobileNumber!,
                            )),
                    const SizedBox(width: 10),
                    leadContactCard(
                        color: const Color(0xFF70DB70),
                        svgSrc: AppSvg.call,
                        onTap: () => performAction(
                              leadId: lead.leadId.toString(),
                              communicationMedium: 'Phone Call',
                              mobileNo: lead.mobileNumber!,
                            )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  leadContactCard(
      {required Color color,
      required String svgSrc,
      required Function() onTap}) {
    final isCheckWA = svgSrc == AppSvg.whatsapp;
    final isCheckMS = svgSrc == AppSvg.message;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        padding: EdgeInsets.all(isCheckWA ? 11 : 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: color,
          boxShadow: [
            BoxShadow(
              color: isCheckWA
                  ? const Color(0x3A55D0A1)
                  : isCheckMS
                      ? const Color(0x3A6889D5)
                      : const Color(0x3A70DB70),
              offset: const Offset(0, 3),
              blurRadius: 6,
            ),
          ],
        ),
        child: SvgPicture.asset(svgSrc, width: 14, color: AppColor.bgColor),
      ),
    );
  }

  performAction(
      {required String leadId,
      required String mobileNo,
      required String communicationMedium}) async {
    Navigator.pushNamed(context, CreateTimeLinePage.id,
            arguments: CreateTimeLinePage(
                leadId: leadId,
                mobileNo: mobileNo,
                communicationMedium: communicationMedium))
        .then((value) => refresh());
  }
}
