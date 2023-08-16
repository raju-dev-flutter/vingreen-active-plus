import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/theme/app_assets.dart';
import '../../../config/theme/app_colors.dart';
import '../../../data/models/lead_model.dart';
import '../../../logic/cubit/lead/lead_crud/lead_crud_cubit.dart';
import '../../components/app_loader.dart';
import '../../components/expandable_fab.dart';
import 'create_timeline_page.dart';

class LeadDetailsPage extends StatefulWidget {
  static const String id = 'lead_details_page';
  final int leadId;

  const LeadDetailsPage({Key? key, required this.leadId}) : super(key: key);

  @override
  State<LeadDetailsPage> createState() => _LeadDetailsPageState();
}

class _LeadDetailsPageState extends State<LeadDetailsPage> {
  late LeadCrudCubit leadCrudCubit;

  @override
  void initState() {
    super.initState();
    leadCrudCubit = BlocProvider.of<LeadCrudCubit>(context);
    leadCrudCubit.getLeadDetail(widget.leadId);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LeadCrudCubit, LeadCrudState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is LeadCrudLoading) {
          return Scaffold(body: showCirclerLoading(context, 40));
        }
        if (state is LeadCrudFailure) {
          return Scaffold(body: showCirclerLoading(context, 40));
        }
        if (state is LeadDetailLoaded) {
          final lead = state.leadDetails;
          return Scaffold(
            appBar: appBar(context),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  leadDetailsUI(lead),
                  addressUI(lead),
                  additionalInformationUI(lead),
                ],
              ),
            ),
            floatingActionButton: ExpandableFab(
              distance: 90.0,
              children: [
                ActionButton(
                  onPressed: () => performAction(
                    leadId: widget.leadId.toString(),
                    communicationMedium: 'WhatsApp',
                    mobileNo: lead.mobileNumber!,
                  ),
                  svgSrc: AppSvg.whatsapp,
                  color: const Color(0xFF55D0A1),
                ),
                ActionButton(
                  onPressed: () => performAction(
                    leadId: widget.leadId.toString(),
                    communicationMedium: 'SMS',
                    mobileNo: lead.mobileNumber!,
                  ),
                  svgSrc: AppSvg.message,
                  color: const Color(0xFF6889D5),
                ),
                ActionButton(
                  onPressed: () => performAction(
                    leadId: widget.leadId.toString(),
                    communicationMedium: 'Phone Call',
                    mobileNo: lead.mobileNumber!,
                  ),
                  svgSrc: AppSvg.call,
                  color: const Color(0xFF70DB70),
                ),
              ],
            ),
          );
        }
        return Scaffold(body: showCirclerLoading(context, 40));
      },
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
        'Lead Details',
        style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold, color: AppColor.secondaryColor),
      ),
      centerTitle: true,
    );
  }

  leadDetailsUI(LeadDetails leadDetails) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        decoration: boxDecoration(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80),
                    image: const DecorationImage(
                      image: AssetImage(AppIcon.leadProfileMale),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: 90,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD6FFDC),
                    border: Border.all(width: 1, color: AppColor.appColor),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Lead ID : ${leadDetails.leadId ?? ''}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  leadDetails.leadName ?? '',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(width: 16),
                pointBox(
                  gColorOne: const Color(0xFFFFBA5C),
                  gColorTwo: const Color(0xFFFFBA5C),
                  radius: 8,
                ),
                const SizedBox(width: 8),
                Text(
                  '${leadDetails.age ?? ''} Years ',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: AppColor.grayColor),
                ),
              ],
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
                  '${leadDetails.cityName ?? ' '}, ${leadDetails.countryName ?? ' '}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF4AA1F7)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              leadDetails.emailId ?? ' ',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColor.grayColor),
            ),
          ],
        ),
      ),
    );
  }

  addressUI(LeadDetails leadDetails) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
        decoration: boxDecoration(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Address',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
            detailLabelText(
              hintLabel: 'Address',
              label: leadDetails.address ?? ' ',
            ),
            horizontalDivider(),
            detailLabelText(
                hintLabel: 'City', label: leadDetails.cityName ?? ' '),
            horizontalDivider(),
            detailLabelText(
                hintLabel: 'State', label: leadDetails.stateName ?? ' '),
            horizontalDivider(),
            detailLabelText(
                hintLabel: 'country', label: leadDetails.countryName ?? ' '),
            horizontalDivider(),
            detailLabelText(
                hintLabel: 'Pin Code', label: leadDetails.pincode ?? ' '),
          ],
        ),
      ),
    );
  }

  additionalInformationUI(LeadDetails leadDetails) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
        decoration: boxDecoration(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Additional Information',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
            detailLabelText(
                hintLabel: 'Alter Email Id',
                label: leadDetails.alterEmailId ?? ' '),
            horizontalDivider(),
            detailLabelText(
                hintLabel: 'Lead Stage',
                label: leadDetails.leadStageName ?? ' '),
            horizontalDivider(),
            detailLabelText(
                hintLabel: 'Lead Sub Stage',
                label: leadDetails.leadSubStage ?? ' '),
            horizontalDivider(),
            detailLabelText(
                hintLabel: 'Lead Source',
                label: leadDetails.leadSourceName ?? ' '),
            horizontalDivider(),
            detailLabelText(
                hintLabel: 'Lead Sub Source',
                label: leadDetails.leadSubSourceName ?? ' '),
            horizontalDivider(),
            detailLabelText(
                hintLabel: 'Medium', label: leadDetails.mediumName ?? ' '),
            horizontalDivider(),
            detailLabelText(
                hintLabel: 'Campaign Name',
                label: leadDetails.campaignName ?? ' '),
            horizontalDivider(),
            detailLabelText(
                hintLabel: 'Lead Owner', label: leadDetails.leadOwner ?? ' '),
            horizontalDivider(),
            detailLabelText(
                hintLabel: 'Ad Name', label: leadDetails.adName ?? ' '),
            horizontalDivider(),
            detailLabelText(
                hintLabel: 'Product Category',
                label: leadDetails.productCategoryName ?? ' '),
            horizontalDivider(),
            detailLabelText(
                hintLabel: 'Product Name',
                label: leadDetails.productName ?? ' '),
            horizontalDivider(),
            detailLabelText(
                hintLabel: 'Communication Medium',
                label: leadDetails.communicationMedium ?? ' '),
            horizontalDivider(),
            detailLabelText(
                hintLabel: 'Communication Type',
                label: leadDetails.communicationType ?? ' '),
          ],
        ),
      ),
    );
  }

  horizontalDivider() =>
      const Divider(height: 0, thickness: 0.5, color: Color(0xFFF0F0F0));

  detailLabelText({required String hintLabel, required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          hintLabel,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColor.grayColor,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColor.grayColor,
              ),
        ),
        const SizedBox(height: 12),
      ],
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

  leadStatusUpdate(
      {required String taskStatus,
      required Color bgColor,
      required Color brColor}) {
    return Container(
      width: 90,
      height: 32,
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

  performAction(
      {required String leadId,
      required String mobileNo,
      required String communicationMedium}) {
    Navigator.pushNamed(context, CreateTimeLinePage.id,
        arguments: CreateTimeLinePage(
            leadId: leadId,
            mobileNo: mobileNo,
            communicationMedium: communicationMedium));
  }
}
