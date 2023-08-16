import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/theme/app_colors.dart';
import '../../../data/models/lead_edit_model.dart';
import '../../../data/validation/validations.dart';
import '../../../logic/cubit/lead/lead_crud/lead_crud_cubit.dart';
import '../../../logic/rxdart/lead/leas_timeline.dart';
import '../../components/app_loader.dart';

class CreateTimeLinePage extends StatefulWidget {
  static const String id = 'create_time_line_page';
  final String leadId;
  final String mobileNo;
  final String communicationMedium;

  const CreateTimeLinePage({Key? key,
    required this.leadId,
    required this.mobileNo,
    required this.communicationMedium})
      : super(key: key);

  @override
  State<CreateTimeLinePage> createState() => _CreateTimeLinePageState();
}

class _CreateTimeLinePageState extends State<CreateTimeLinePage> {
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late LeadCrudCubit leadCrudCubit;

  final LeadTimelineBloc leadTimelineBloc = LeadTimelineBloc();

  @override
  void initState() {
    super.initState();
    leadCrudCubit = BlocProvider.of<LeadCrudCubit>(context);
    leadCrudCubit.getLeadEditDetail(widget.leadId);
    leadTimelineBloc.performAction(
        communicationMedium: widget.communicationMedium,
        mobileNo: widget.mobileNo);
    leadTimelineBloc.fetchLeadData(widget.leadId);
    leadTimelineBloc.fetchCommunicationMediumApi();
    leadTimelineBloc.fetchCommunicationmediumType();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LeadCrudCubit, LeadCrudState>(
      listener: (context, state) {
        if (state is LeadCrudFormSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "Lead Timeline Successfully Created",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ));

          Navigator.pop(context);
        }
        if (state is LeadCrudFormFailure) {
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
        if (state is LeadCrudLoading) {
          return Scaffold(body: showCirclerLoading(context, 40));
        }
        return Scaffold(
          key: scaffoldkey,
          appBar: appBar(context),
          body: Form(
            key: formKey,
            child: Column(
              children: [
                streamBuilderDropdown(
                    label: 'Lead Stage',
                    streamList: leadTimelineBloc.leadStageList),
                streamBuilderDropdown(
                    label: 'Lead Sub Stage',
                    streamList: leadTimelineBloc.leadSubStageList),
                streamBuilderDropdown(
                    label: 'Communication Medium',
                    streamList: leadTimelineBloc.leadCommunicationMediumList),
                streamBuilderDropdown(
                    label: 'Communication Medium Type',
                    streamList:
                    leadTimelineBloc.leadCommunicationMediumTypeList),
                editTextField(
                    label: 'Description',
                    controller: leadTimelineBloc.description),
                const SizedBox(height: 20),
                state is LeadCrudFormLoadinge
                    ? showCirclerLoading(context, 40)
                    : submitButton(
                  onTap: () =>
                      leadTimelineBloc.uploadLeadTimelineDetails(
                          context, widget.leadId),
                ),
              ],
            ),
          ),
        );
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
        'Create Time Line',
        style: Theme
            .of(context)
            .textTheme
            .displaySmall
            ?.copyWith(
            fontWeight: FontWeight.bold, color: AppColor.secondaryColor),
      ),
      centerTitle: true,
    );
  }

  getStreamInitValue(String label) {
    if (label == "Lead Stage") {
      return leadTimelineBloc.leadStageListInit.valueOrNull!.name;
    } else if (label == "Lead Sub Stage") {
      return leadTimelineBloc.leadSubStageListInit.valueOrNull!.name;
    } else if (label == "Communication Medium") {
      return leadTimelineBloc.leadCommunicationMediumListInit.valueOrNull!.name;
    } else if (label == "Communication Medium Type") {
      return leadTimelineBloc
          .leadCommunicationMediumTypeListInit.valueOrNull!.name;
    }
  }

  streamBuilderDropdown(
      {required String label, required Stream<List<CommonObj>> streamList}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label *",
            style: Theme
                .of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(letterSpacing: 1, color: AppColor.grayColor),
          ),
          const SizedBox(height: 8),
          StreamBuilder<List<CommonObj>>(
            stream: streamList,
            builder: (context, snapshot) {
              debugPrint(snapshot.data?.length.toString());
              if (snapshot.hasData) {
                final data = snapshot.data!;
                return DropDownTextField(
                  initialValue: getStreamInitValue(label),
                  clearOption: false,
                  enableSearch: true,
                  clearIconProperty: IconProperty(color: Colors.green),
                  searchDecoration: const InputDecoration(hintText: "Search "),
                  validator: (value) {
                    if (value == null) {
                      return "Required field";
                    } else {
                      return null;
                    }
                  },
                  dropDownItemCount: 4,
                  textFieldDecoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  dropDownList: data
                      .map((val) =>
                      DropDownValueModel(name: val.name!, value: val.id))
                      .toList(),
                  onChanged: (dynamic val) {
                    if (val != '') {
                      if (label == "Lead Stage") {
                        leadTimelineBloc.leadStage(val.value);
                      } else if (label == "Lead Sub Stage") {
                        leadTimelineBloc.leadSubStage(val.value);
                      } else if (label == "Communication Medium") {
                        leadTimelineBloc.leadCommunicationmedium(val.value);
                      } else if (label == "Communication Medium Type") {
                        leadTimelineBloc.leadCommunicationmedium(val.value);
                      }
                    }
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                );
              } else {
                return showDropdownLoaded();
              }
            },
          ),
        ],
      ),
    );
  }

  editTextField(
      {required String label, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label *",
            style: Theme
                .of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(letterSpacing: 1, color: AppColor.grayColor),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: label == "Mobile Number" ||
                label == "Phone Number" ||
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
            onChanged: (v) {
              leadTimelineBloc.onChangedValue();
            },
            validator: (String? valid) {
              return Validations().validateString(controller.text);
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
    );
  }

  submitButton({required Function() onTap}) {
    final width = MediaQuery
        .of(context)
        .size
        .width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: onTap,
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
                'Submit',
                style: Theme
                    .of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: AppColor.secondaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
