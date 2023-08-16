import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/theme/app_colors.dart';
import '../../../data/models/lead_edit_model.dart';
import '../../../data/validation/validations.dart';
import '../../../logic/cubit/lead/lead_crud/lead_crud_cubit.dart';
import '../../../logic/rxdart/lead/lead_curd.dart';
import '../../components/app_loader.dart';

class LeadUpdatePage extends StatefulWidget {
  static const String id = 'lead_update_page';
  final int leadId;

  const LeadUpdatePage({Key? key, required this.leadId}) : super(key: key);

  @override
  State<LeadUpdatePage> createState() => _LeadUpdatePageState();
}

class _LeadUpdatePageState extends State<LeadUpdatePage> {
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late LeadCrudCubit leadCrudCubit;

  final LeadEditBloc leadEditBloc = LeadEditBloc();

  @override
  void initState() {
    super.initState();
    leadCrudCubit = BlocProvider.of<LeadCrudCubit>(context);
    leadCrudCubit.getLeadEditDetail(widget.leadId);
    leadEditBloc.fetchOptions(widget.leadId);
  }

  @override
  void dispose() {
    leadEditBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LeadCrudCubit, LeadCrudState>(
      listener: (context, state) {
        if (state is LeadCrudFormSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "Lead Edit Successfully Updated",
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
          appBar: appBar(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: StreamBuilder<LeadEditBloc>(
              builder: (_, snapshot) {
                return Form(
                  key: formKey,
                  child: Column(
                    children: [
                      editTextField(
                          label: 'Full Name',
                          controller: leadEditBloc.fullNameEditText),
                      editTextField(
                          label: 'Mobile Number',
                          controller: leadEditBloc.mobileNumberEditText),
                      editTextField(
                          label: 'Phone Number',
                          controller: leadEditBloc.phoneNumberEditText),
                      editTextField(
                          label: 'Email Id',
                          controller: leadEditBloc.emailIdEditText),
                      editTextField(
                          label: 'Alternate Email Id',
                          controller: leadEditBloc.alternateEmailIdEditText),
                      editTextField(
                          label: 'Age', controller: leadEditBloc.ageEditText),
                      //Start Dropdown
                      streamBuilderDropdown(
                          label: 'Lead Stage',
                          streamList: leadEditBloc.leadStageList),
                      streamBuilderDropdown(
                          label: 'Sub Stage',
                          streamList: leadEditBloc.leadSubStageList),
                      streamBuilderDropdown(
                          label: 'Lead Source',
                          streamList: leadEditBloc.leadSourceList),
                      streamBuilderDropdown(
                          label: 'Lead Sub Source',
                          streamList: leadEditBloc.leadSubSourceList),
                      streamBuilderDropdown(
                          label: 'Campaigns',
                          streamList: leadEditBloc.campaignsList),
                      streamBuilderDropdown(
                          label: 'Campaigns',
                          streamList: leadEditBloc.campaignsList),
                      streamBuilderDropdown(
                          label: 'Product Category',
                          streamList: leadEditBloc.productCategoryList),
                      streamBuilderDropdown(
                          label: 'Product',
                          streamList: leadEditBloc.productList),
                      streamBuilderDropdown(
                          label: 'Ad Name',
                          streamList: leadEditBloc.adNameList),
                      streamBuilderDropdown(
                          label: 'Medium', streamList: leadEditBloc.mediumList),
                      streamBuilderDropdown(
                          label: 'Country',
                          streamList: leadEditBloc.countryList),
                      streamBuilderDropdown(
                          label: 'State', streamList: leadEditBloc.stateList),
                      streamBuilderDropdown(
                          label: 'City', streamList: leadEditBloc.cityList),
                      //End Dropdown
                      editTextField(
                          label: 'Address',
                          controller: leadEditBloc.addressEditText),
                      editTextField(
                          label: 'Pin Code',
                          controller: leadEditBloc.pinCodeEditText),

                      const SizedBox(height: 20),
                      state is LeadCrudFormLoadinge
                          ? showCirclerLoading(context, 40)
                          : submitButton(
                              onTap: () => leadEditBloc.uploadLeadUpdateDetails(
                                  context, widget.leadId),
                            ),
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
        'Lead Edit',
        style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold, color: AppColor.secondaryColor),
      ),
      centerTitle: true,
    );
  }

  getStreamInitValue(String label) {
    if (label == "Lead Stage") {
      return leadEditBloc.leadStageListInit.valueOrNull!.name;
    } else if (label == "Sub Stage") {
      return leadEditBloc.leadSubStageListInit.valueOrNull!.name;
    } else if (label == "Lead Source") {
      return leadEditBloc.leadSourceListInit.valueOrNull!.name;
    } else if (label == "Lead Sub Source") {
      return leadEditBloc.leadSubSourceListInit.valueOrNull!.name;
    } else if (label == "Campaigns") {
      return leadEditBloc.campaignsListInit.valueOrNull!.name;
    } else if (label == "Campaigns") {
      return leadEditBloc.campaignsListInit.valueOrNull!.name;
    } else if (label == "Product Category") {
      return leadEditBloc.productCategoryListInit.valueOrNull!.name;
    } else if (label == "Product") {
      return leadEditBloc.productListInit.valueOrNull!.name;
    } else if (label == "Ad Name") {
      return leadEditBloc.adNameListInit.valueOrNull!.name;
    } else if (label == "Medium") {
      return leadEditBloc.mediumListInit.valueOrNull!.name;
    } else if (label == "Country") {
      return leadEditBloc.countryListInit.valueOrNull!.name;
    } else if (label == "State") {
      return leadEditBloc.stateListInit.valueOrNull!.name;
    } else if (label == "City") {
      return leadEditBloc.cityListInit.valueOrNull!.name;
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
            style: Theme.of(context)
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
                        leadEditBloc.leadStage(val.value);
                      } else if (label == "Sub Stage") {
                        leadEditBloc.leadSubStage(val.value);
                      } else if (label == "Lead Source") {
                        leadEditBloc.leadSource(val.value);
                      } else if (label == "Lead Sub Source") {
                        leadEditBloc.leadSubSource(val.value);
                      } else if (label == "Campaigns") {
                        leadEditBloc.leadCampaigns(val.value);
                      } else if (label == "Product Category") {
                        leadEditBloc.leadProductCategory(val.value);
                      } else if (label == "Product") {
                        leadEditBloc.leadProduct(val.value);
                      } else if (label == "Ad Name") {
                        leadEditBloc.leadAdName(val.value);
                      } else if (label == "Medium") {
                        leadEditBloc.leadMedium(val.value);
                      } else if (label == "Country") {
                        leadEditBloc.leadCountry(val.value);
                      } else if (label == "State") {
                        leadEditBloc.leadState(val.value);
                      } else if (label == "City") {
                        leadEditBloc.leadCity(val.value);
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
            style: Theme.of(context)
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
              leadEditBloc.onChangedValue(label);
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
    final width = MediaQuery.of(context).size.width;
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
                'Update',
                style: Theme.of(context)
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
