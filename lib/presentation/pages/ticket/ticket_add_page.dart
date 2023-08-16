import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/theme/app_colors.dart';
import '../../../data/validation/validations.dart';
import '../../../logic/cubit/ticket/ticket_crud/ticket_crud_cubit.dart';
import '../../components/app_loader.dart';

class TicketAddPage extends StatefulWidget {
  static const String id = 'Ticket_add_page';

  const TicketAddPage({Key? key}) : super(key: key);

  @override
  State<TicketAddPage> createState() => _TicketAddPageState();
}

class _TicketAddPageState extends State<TicketAddPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TicketCrudCubit ticketCrudCubit;

  @override
  void initState() {
    super.initState();
    ticketCrudCubit = BlocProvider.of<TicketCrudCubit>(context);
    ticketCrudCubit.getCreateNewTicketDetails();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: BlocConsumer<TicketCrudCubit, TicketCrudState>(
        listener: (context, state) {
          if (state is TicketCrudFormSuccess) {
            Navigator.pop(context);
          }
          if (state is TicketCrudFormFailure) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is TicketCrudLoading) {
            return showCirclerLoading(context, 40);
          }
          if (state is TicketCrudFailure) {
            return showCirclerLoading(context, 40);
          }
          if (state is CreateNewTicketLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    editTextField(label: 'Subject', controller: state.subject),
                    buildSearchDropDown(
                        label: 'Client', data: state.clientDetailsList),
                    buildSearchDropDown(
                        label: 'Customers Contact',
                        data: state.customersContactLists),
                    buildSearchDropDown(
                        label: 'Ticket Type',
                        data: state.ticketTypeDetailsList),
                    buildSearchDropDown(
                        label: 'Ticket Priority',
                        data: state.ticketPriorityDetailsList),
                    buildSearchDropDown(
                        label: 'Ticket Source',
                        data: state.ticketSourceDetailsList),
                    buildSearchDropDown(
                        label: 'User Details', data: state.userDetailsListList),
                    buildSearchDropDown(
                        label: 'Ticket Status',
                        data: state.ticketStatusDetailsList),
                    buildSearchDropDown(
                        label: 'Ticket Created Type',
                        data: state.ticketCreatedTypeList),
                    editTextField(
                        label: 'Description', controller: state.description),
                    ticketButton(
                      onTap: () {
                        Map data = {
                          'user_id': state.userId,
                          'subject': state.subject.text,
                          'client_id': state.clientDetailsListInit.id ?? 1,
                          'project_id': state.clientDetailsListInit.id ?? 1,
                          'customer_contact_id':
                              state.customersContactListsInit.id ?? 1,
                          'ticket_type_id':
                              state.ticketTypeDetailsListInit.id ?? 1,
                          'ticket_priority_id':
                              state.ticketPriorityDetailsListInit.id ?? 1,
                          'ticket_source_id':
                              state.ticketSourceDetailsListInit.id ?? 1,
                          'ticket_assign_id':
                              state.userDetailsListListInit.id ?? 1,
                          'status_id':
                              state.ticketStatusDetailsListInit.id ?? 1,
                          'ticket_created_type_id':
                              state.ticketCreatedTypeListInit.id ?? 1,
                          'description': state.description.text
                        };
                        debugPrint(data.toString());
                        BlocProvider.of<TicketCrudCubit>(context, listen: false)
                            .submitAddNewTask(data);
                      },
                    ),
                  ],
                ),
              ),
            );
          }
          return Container();
        },
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
            keyboardType: label == "Description"
                ? TextInputType.multiline
                : TextInputType.text,
            maxLines: label == "Description" ? 5 : 1,
            enableSuggestions: true,
            obscureText: false,
            enableInteractiveSelection: true,
            decoration: textInputDecoration(label),
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    );
  }

  getInitValue(String label) {
    final ticketState = BlocProvider.of<TicketCrudCubit>(context).state;

    if (ticketState is CreateNewTicketLoaded) {
      if (label == "Client") {
        return ticketState.clientDetailsListInit.name;
      } else if (label == "Customers Contact") {
        return ticketState.customersContactListsInit.name;
      } else if (label == "Ticket Type") {
        return ticketState.ticketTypeDetailsListInit.name;
      } else if (label == "Ticket Priority") {
        return ticketState.ticketPriorityDetailsListInit.name;
      } else if (label == "Ticket Source") {
        return ticketState.ticketSourceDetailsListInit.name;
      } else if (label == "User Details") {
        return ticketState.userDetailsListListInit.name;
      } else if (label == "Ticket Status") {
        return ticketState.ticketStatusDetailsListInit.name;
      } else if (label == "Ticket Created Type") {
        return ticketState.ticketCreatedTypeListInit.name;
      }
    }
  }

  buildSearchDropDown({required String label, required List<dynamic> data}) {
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
          FormField<TicketCrudCubit>(builder: (FormFieldState<dynamic> state) {
            final ticketState = BlocProvider.of<TicketCrudCubit>(context).state;

            return DropDownTextField(
              initialValue: getInitValue(label),
              // controller: _controller,
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
              textFieldDecoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              dropDownList: data
                  .map((data) =>
                      DropDownValueModel(name: data.name ?? '', value: data.id))
                  .toList(),

              onChanged: (dynamic val) {
                if (val != '') {
                  setState(() {
                    if (ticketState is CreateNewTicketLoaded) {
                      if (label == "Client") {
                        ticketState.clientDetailsListInit.id = val.value;
                      } else if (label == "Customers Contact") {
                        ticketState.customersContactListsInit.id = val.value;
                      } else if (label == "Ticket Type") {
                        ticketState.ticketTypeDetailsListInit.id = val.value;
                      } else if (label == "Ticket Priority") {
                        ticketState.ticketPriorityDetailsListInit.id =
                            val.value;
                      } else if (label == "Ticket Source") {
                        ticketState.ticketSourceDetailsListInit.id = val.value;
                      } else if (label == "User Details") {
                        ticketState.userDetailsListListInit.id = val.value;
                      } else if (label == "Ticket Status") {
                        ticketState.ticketStatusDetailsListInit.id = val.value;
                      } else if (label == "Ticket Created Type") {
                        ticketState.ticketCreatedTypeListInit.id = val.value;
                      }
                    }
                  });
                }

                FocusScope.of(context).requestFocus(FocusNode());
              },
            );
          }),
        ],
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
      title: Text('Create New Tickets',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold, color: AppColor.secondaryColor)),
      centerTitle: true,
    );
  }

  ticketButton({required Function() onTap}) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: width,
          height: 56,
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
                'Add New Tickets',
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
