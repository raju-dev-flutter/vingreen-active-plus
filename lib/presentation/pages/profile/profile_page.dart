import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/theme/app_assets.dart';
import '../../../config/theme/app_colors.dart';
import '../../../data/models/user_detail_model.dart';
import '../../../data/services/url.dart';
import '../../../logic/bloc/profile/profile_bloc.dart';
import 'idcard_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileBloc profileBloc;

  @override
  void initState() {
    super.initState();
    profileBloc = BlocProvider.of<ProfileBloc>(context);
    profileBloc.add(ProfileStatus());
  }

  Future<void> refresh(BuildContext context) async {
    BlocProvider.of<ProfileBloc>(context, listen: false).add(ProfileStatus());
  }

  @override
  Widget build(BuildContext context) {
    final dashboardCountBloc = context.watch<ProfileBloc>();
    // dashboardCountBloc.add(ProfileStatus());

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          return SingleChildScrollView(
            child: Column(
              children: [
                profileCardUI(context, state.userDetails),
                employeeInformationUI(context, state.userDetails),
                personalInformationUI(context, state.userDetails),
                addressUI(context, state.userDetails),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  profileCardUI(BuildContext context, UserDetails user) {
    final width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        SizedBox(width: width, height: 245),
        gradientContainer(context),
        Positioned(
          bottom: 0,
          child: SizedBox(
            width: width,
            child: Container(
              height: 150,
              padding: const EdgeInsets.fromLTRB(22, 22, 16, 22),
              decoration: BoxDecoration(
                color: AppColor.secondaryColor,
                border: Border.all(width: .5, color: AppColor.secondaryColor),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0788909F),
                    offset: Offset(0, 6),
                    blurRadius: 16,
                  )
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        user.userName ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user.designationId ?? '',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email ?? '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w300,
                            color: AppColor.grayColor),
                      ),
                    ],
                  ),
                  const Spacer(),
                  viewIdCardButton(
                    context: context,
                    onTap: () => Navigator.pushNamed(context, IdCardPage.id),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 38,
          left: 22,
          child: Container(
            width: 105,
            height: 105,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColor.secondaryColor,
              image: user.profileUpload == null
                  ? const DecorationImage(
                      image: AssetImage(AppImage.user),
                      fit: BoxFit.fill,
                    )
                  : DecorationImage(
                      image: NetworkImage(
                          '${AppUrl.baseUrl}public/profile_uploads/${user.profileUpload}'),
                      fit: BoxFit.fill,
                    ),
              border: Border.all(
                width: 8,
                strokeAlign: BorderSide.strokeAlignOutside,
                color: AppColor.secondaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  employeeInformationUI(BuildContext context, UserDetails user) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 6),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
        width: double.infinity,
        decoration: boxDecoration(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Professional Information',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            detailLabelText(
                context: context,
                hintLabel: 'Employee Code',
                label: user.employeeCode ?? ''),
            horizontalDivider(),
            detailLabelText(
                context: context,
                hintLabel: 'Date Of Joining',
                label: user.dateOfJoining ?? ''),
            horizontalDivider(),
            detailLabelText(
                context: context,
                hintLabel: 'Designation ',
                label: user.designationId ?? ''),
          ],
        ),
      ),
    );
  }

  personalInformationUI(BuildContext context, UserDetails user) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
        width: double.infinity,
        decoration: boxDecoration(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal  Information',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            detailLabelText(
                context: context,
                hintLabel: 'Gender',
                label: user.gender ?? ''),
            horizontalDivider(),
            detailLabelText(
                context: context,
                hintLabel: 'Date Of Birth',
                label: user.dateOfBirth ?? ''),
            horizontalDivider(),
            detailLabelText(
                context: context,
                hintLabel: 'Blood Group',
                label: user.bloodGroup ?? ''),
            horizontalDivider(),
            detailLabelText(
                context: context,
                hintLabel: 'Personal Mobile Number',
                label: user.personalMobileNumber ?? ''),
            horizontalDivider(),
            detailLabelText(
                context: context,
                hintLabel: 'Emergency Mobile Number',
                label: user.emergencyContactNumber ?? ''),
          ],
        ),
      ),
    );
  }

  addressUI(BuildContext context, UserDetails user) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
        width: double.infinity,
        decoration: boxDecoration(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Address',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            detailLabelText(
                context: context,
                hintLabel: 'Address',
                label: user.address ?? ''),
            horizontalDivider(),
            detailLabelText(
                context: context, hintLabel: 'City', label: user.cityId ?? ''),
            horizontalDivider(),
            detailLabelText(
                context: context,
                hintLabel: 'State',
                label: user.stateId ?? ''),
            horizontalDivider(),
            detailLabelText(
                context: context,
                hintLabel: 'country',
                label: user.countryId ?? ''),
            horizontalDivider(),
            detailLabelText(
                context: context,
                hintLabel: 'Pin Code',
                label: user.pinCode.toString()),
          ],
        ),
      ),
    );
  }

  viewIdCardButton({required BuildContext context, required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
              'View Id Card',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500, color: AppColor.secondaryColor),
            ),
          ],
        ),
      ),
    );
  }

  gradientContainer(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Positioned(
      top: 0,
      child: Container(
        width: width,
        height: 210,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF52B45F), Color.fromARGB(150, 255, 255, 255)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(45),
            bottomRight: Radius.circular(45),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x31AEDCB4),
              offset: Offset(0, 3),
              blurRadius: 18,
            )
          ],
        ),
      ),
    );
  }

  horizontalDivider() =>
      const Divider(height: 0, thickness: 0.5, color: Color(0xFFF0F0F0));

  detailLabelText(
      {required BuildContext context,
      required String hintLabel,
      required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          hintLabel,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColor.grayColor,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColor.grayColor,
              ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  boxDecoration(double borderRadius) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(0),
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
