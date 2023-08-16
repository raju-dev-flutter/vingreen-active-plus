import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

import '../../../config/theme/app_assets.dart';
import '../../../config/theme/app_colors.dart';
import '../../../data/services/url.dart';
import '../../../data/validation/validations.dart';
import '../../../logic/cubit/profile_update_form/profile_update_form_cubit.dart';
import '../../../logic/rxdart/profile/profile_update.dart';
import '../../components/app_loader.dart';
import '../../components/app_toast.dart';

class ProfileUpdatePage extends StatefulWidget {
  static const String id = 'profile_update_page';

  const ProfileUpdatePage({Key? key}) : super(key: key);

  @override
  State<ProfileUpdatePage> createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final ProfileUpdateBloc profileUpdateBloc = ProfileUpdateBloc();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late ProfileUpdateFormCubit profileUpdateFormCubit;

  @override
  void initState() {
    super.initState();
    profileUpdateFormCubit = BlocProvider.of<ProfileUpdateFormCubit>(context);
    profileUpdateFormCubit.getUserDetails();
    profileUpdateBloc.getProfileDetails();
    _askCamaraPermission();
  }

  Future<void> _askCamaraPermission() async {
    if (await Permission.camera.request().isDenied) {
      await Permission.camera.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileUpdateFormCubit, ProfileUpdateFormState>(
      listener: (context, state) {
        if (state is ProfileUpdateFormSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "Profile Successfully Updated",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ));

          Navigator.pop(context);
        }
        if (state is ProfileUpdateFormFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.error,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.redAccent,
            ),
          );
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state is UserDetailsLoading) {
          return Scaffold(body: showCirclerLoading(context, 40));
        }
        return Scaffold(
          key: _scaffoldkey,
          appBar: appBar(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 8),
            child: StreamBuilder<ProfileUpdateBloc>(
              builder: (_, snapshot) {
                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      profileCardUI(),
                      editTextField(
                          label: 'First Name',
                          controller: profileUpdateBloc.firstName),
                      editTextField(
                          label: 'Last Name',
                          controller: profileUpdateBloc.lastName),
                      editTextField(
                          label: 'Mobile Number',
                          controller: profileUpdateBloc.mobileNumber),
                      editTextField(
                          label: 'Emergency Mobile Number',
                          controller: profileUpdateBloc.emgContectNumber),
                      editTextField(
                          label: 'Address',
                          controller: profileUpdateBloc.address),
                      editTextField(
                          label: 'Pin Code',
                          controller: profileUpdateBloc.pinCode),
                      const SizedBox(height: 40),
                      state is ProfileUpdateFormLoading
                          ? showCirclerLoading(context, 40)
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: InkWell(
                                onTap: () => profileUpdateBloc
                                    .uploadProfileDetails(context),
                                child: Container(
                                  height: 52,
                                  decoration: BoxDecoration(
                                    color: AppColor.appColor,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x3052B45F),
                                        offset: Offset(0, 3),
                                        blurRadius: 12,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Update',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                                color: AppColor.secondaryColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  appBar() {
    return AppBar(
      backgroundColor: AppColor.appColor,
      elevation: 0,
      leading: IconButton(
          onPressed: (() => Navigator.pop(context)),
          icon: const Icon(Icons.arrow_back_rounded)),
      title: Text(
        'Update Profile',
        style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold, color: AppColor.secondaryColor),
      ),
      centerTitle: true,
    );
  }

  profileCardUI() {
    final width = MediaQuery.of(context).size.width;

    return StreamBuilder(
      stream: profileUpdateBloc.profileImg,
      builder: (_, snapshot) {
        return SizedBox(
          width: width,
          height: 168,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 0,
                child: Container(
                    width: width, height: 90, color: AppColor.appColor),
              ),
              profileImageBox(
                image: snapshot.data.toString(),
                onTap: () => _settingModalBottomSheet(context),
              ),
              Positioned(
                bottom: 30,
                left: width / 1.76,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9BB953),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(Icons.edit_rounded,
                      size: 14, color: AppColor.secondaryColor),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Wrap(
            children: <Widget>[
              ListTile(
                  title: const Text('Gallery'),
                  onTap: () => {
                        profileUpdateBloc.openGallery(),
                        Navigator.pop(context),
                      }),
              ListTile(
                title: const Text('Camera'),
                onTap: () => {
                  profileUpdateBloc.openGamera(),
                  Navigator.pop(context),
                },
              ),
            ],
          );
        });
  }

  profileImageBox({required Function() onTap, required String image}) {
    return StreamBuilder(
        stream: profileUpdateBloc.pictedImage,
        builder: (_, snapshot) {
          return InkWell(
            onTap: onTap,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(120),
                color: AppColor.secondaryColor,
                image: snapshot.data != null
                    ? DecorationImage(
                        image: FileImage(File(snapshot.data!.path)),
                        fit: BoxFit.cover,
                      )
                    : image == 'null' || image == '' || image == 'Null'
                        ? const DecorationImage(
                            image: AssetImage(AppImage.user),
                            fit: BoxFit.cover,
                          )
                        : DecorationImage(
                            image: NetworkImage(
                                '${AppUrl.baseUrl}public/profile_uploads/$image'),
                            fit: BoxFit.cover,
                          ),
                border: Border.all(
                  width: 5,
                  strokeAlign: BorderSide.strokeAlignOutside,
                  color: const Color(0x7552B45F),
                ),
              ),
            ),
          );
        });
  }

  editTextField(
      {required String label, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(letterSpacing: 1, color: AppColor.grayColor),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: label == "Mobile Number" ||
                    label == "Emergency Mobile Number" ||
                    label == "Age" ||
                    label == "Pin Code"
                ? TextInputType.phone
                : label == "Email Id" || label == "Alternate Email Id"
                    ? TextInputType.emailAddress
                    : label == "Address"
                        ? TextInputType.multiline
                        : TextInputType.text,
            maxLines: label == "Address" ? 5 : 1,
            enableSuggestions: true,
            obscureText: false,
            enableInteractiveSelection: true,
            decoration: textInputDecoration(label),
            validator: (String? valid) {
              return Validations().validateString(controller.text);
            },
            onChanged: (v) {
              profileUpdateBloc.onChangedValue(label);
            },
          ),
        ],
      ),
    );
  }

  textInputDecoration(String? label) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColor.primaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColor.focusColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColor.errorColor),
      ),
      hintText: label,
      hintStyle:
          const TextStyle(fontFamily: 'Roboto', fontSize: 14, letterSpacing: 1),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    );
  }
}
