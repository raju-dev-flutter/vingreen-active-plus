import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/theme/app_assets.dart';
import '../../../config/theme/app_colors.dart';
import '../../../data/models/lead_model.dart';
import '../../../logic/cubit/lead/lead_filter/lead_filter_cubit.dart';
import '../../../logic/rxdart/lead/lead_filter_bloc.dart';
import '../../components/app_loader.dart';
import 'create_timeline_page.dart';
import 'lead_detail_page.dart';
import 'lead_update_page.dart';

class LeadFilterPage extends StatefulWidget {
  static const String id = 'lead_filter_page';

  const LeadFilterPage({Key? key}) : super(key: key);

  @override
  State<LeadFilterPage> createState() => _LeadFilterPageState();
}

class _LeadFilterPageState extends State<LeadFilterPage> {
  final leadFilterBloc = LeadFilterBloc();
  late LeadFilterCubit leadFilterCubit;

  @override
  void initState() {
    super.initState();
    leadFilterCubit = BlocProvider.of<LeadFilterCubit>(context);
    leadFilterCubit.fetchLeadFilterInitial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: BlocConsumer<LeadFilterCubit, LeadFilterState>(
        listener: (_, state) {},
        builder: (_, state) {
          if (state is LeadFilterLoading) {
            return showCirclerLoading(context, 40);
          }
          if (state is LeadFilterPageLoading) {
            return showCirclerLoading(context, 40);
          }
          if (state is LeadFilterPageLoaded) {
            final leadList = state.leadList;
            return leadList.isEmpty
                ? Container()
                : ListView.builder(
                    itemCount: leadList.length,
                    itemBuilder: (_, index) =>
                        leadListUI(context, leadList[index]),
                  );
          }
          return _buildFilterFormUI();
        },
      ),
      bottomNavigationBar: BlocBuilder<LeadFilterCubit, LeadFilterState>(
        builder: (context, state) {
          if (state is LeadFilterPageLoading) {
            return const SizedBox();
          }
          if (state is LeadFilterPageLoaded) {
            return const SizedBox();
          }
          return BottomAppBar(
            child: Container(
              height: 90,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: submitButton(onTap: () {
                leadFilterBloc.fetchLeadFilterLoaded(context);
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
      title: Text('Lead Filter',
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
                ? leadFilterBloc.startDate
                : leadFilterBloc.endDate,
            builder: (context, snapshot) {
              final selectedDate = snapshot.data ?? DateTime.now();
              final selectDate = label == "Start Date"
                  ? leadFilterBloc.selectedStartDate
                  : leadFilterBloc.selectedEndDate;
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
                      leadFilterBloc.selectStartDate(pickedDate);
                    } else {
                      leadFilterBloc.selectEndDate(pickedDate);
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

  leadListUI(BuildContext context, LeadList lead) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: InkWell(
        onTap: (() {
          Navigator.pushNamed(context, LeadDetailsPage.id,
              arguments: LeadDetailsPage(leadId: lead.leadId!));
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
                              arguments: LeadUpdatePage(leadId: lead.leadId!));
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
            communicationMedium: communicationMedium));
  }
}
