import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/theme/app_colors.dart';
import '../../../data/validation/validations.dart';
import '../../../logic/cubit/task/task_crud/task_crud_cubit.dart';
import '../../components/app_loader.dart';

class TaskAddPage extends StatefulWidget {
  static const String id = 'task_add_page';

  const TaskAddPage({Key? key}) : super(key: key);

  @override
  State<TaskAddPage> createState() => _TaskAddPageState();
}

class _TaskAddPageState extends State<TaskAddPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TaskCrudCubit taskCrudCubit;

  @override
  void initState() {
    super.initState();
    taskCrudCubit = BlocProvider.of<TaskCrudCubit>(context);
    taskCrudCubit.getCreateNewTaskDetails();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: BlocConsumer<TaskCrudCubit, TaskCrudState>(
        listener: (context, state) {
          if (state is TaskCrudFormSuccess) {
            Navigator.pop(context);
          }
          if (state is TaskCrudFormFailure) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is TaskCrudLoading) {
            return showCirclerLoading(context, 40);
          }
          if (state is TaskCrudFailure) {}
          if (state is CreateNewTaskLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Form(
                child: Column(
                  children: [
                    editTextField(
                        label: 'Task Name', controller: state.taskName),
                    buildSearchDropDown(
                        label: 'Client', data: state.clientDetailsList),
                    buildSearchDropDown(
                        label: 'Project', data: state.projectDetailsList),
                    buildSearchDropDown(
                        label: 'Task Status', data: state.statusDetailsList),
                    buildSearchDropDown(
                        label: 'Priority', data: state.priorityDetailsList),
                    buildSearchDropDown(
                        label: 'Assign', data: state.userDetailsList),
                    editTextField(
                        label: 'Description', controller: state.description),
                    taskButton(
                      onTap: () {
                        Map data = {
                          'user_id': state.userId,
                          'task_name': state.taskName.text,
                          'client_id': state.clientDetailsListInit.id ?? 1,
                          'project_id': state.projectDetailsListInit.id ?? 1,
                          'assign_to': state.userDetailsListInit.id ?? 1,
                          'status_id': state.statusDetailsListInit.id ?? 1,
                          'priority_id': state.priorityDetailsListInit.id ?? 1,
                          'description': state.description.text
                        };
                        debugPrint(data.toString());
                        BlocProvider.of<TaskCrudCubit>(context, listen: false)
                            .submitCreateNewTask(data);
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

  appBar() {
    return AppBar(
      backgroundColor: AppColor.appColor,
      elevation: 0,
      leading: IconButton(
          onPressed: (() => Navigator.pop(context)),
          icon: const Icon(Icons.arrow_back_rounded)),
      title: Text('Create New Task',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold, color: AppColor.secondaryColor)),
      centerTitle: true,
    );
  }

  getInitValue(String label) {
    final taskState = BlocProvider.of<TaskCrudCubit>(context).state;

    if (taskState is CreateNewTaskLoaded) {
      if (label == "Client") {
        return taskState.clientDetailsListInit.name;
      } else if (label == "Project") {
        return taskState.projectDetailsListInit.name;
      } else if (label == "Task Status") {
        return taskState.statusDetailsListInit.name;
      } else if (label == "Priority") {
        return taskState.priorityDetailsListInit.name;
      } else if (label == "Assign") {
        return taskState.userDetailsListInit.name;
      }
    }
  }

  /*
   if (label == "Lead Stage") {
        return leadState.leadStageListInit.name;
      } else if (label == "Sub Stage") {
        return leadState.leadSubStageListInit.name;
      } else if (label == "Lead Source") {
        return leadState.leadSourcesListInit.name;
      } else if (label == "Lead Sub Source") {
        return leadState.leadSubSourcesListInit.name;
      } else if (label == "Campaigns") {
        return leadState.campaignsListInit.name;
      } else if (label == "Product Category") {
        return leadState.productCategoryListInit.name;
      } else if (label == "Product") {
        return leadState.productListInit.name;
      } else if (label == "Ad Name") {
        return leadState.adNameListInit.name;
      } else if (label == "Medium") {
        return leadState.mediumListInit.name;
      } else if (label == "Country") {
        return leadState.countryListInit.name;
      } else if (label == "State") {
        return leadState.stateListInit.name;
      } else if (label == "City") {
        return leadState.cityListInit.name;
      }
  
  */

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
          FormField<TaskCrudCubit>(builder: (FormFieldState<dynamic> state) {
            final taskState = BlocProvider.of<TaskCrudCubit>(context).state;

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
              textFieldDecoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              dropDownList: data
                  .map((data) =>
                      DropDownValueModel(name: data.name ?? '', value: data.id))
                  .toList(),

              onChanged: (dynamic val) {
                if (val != '') {
                  setState(() {
                    if (taskState is CreateNewTaskLoaded) {
                      if (label == "Client") {
                        taskState.clientDetailsListInit.id = val.value;
                      } else if (label == "Project") {
                        taskState.projectDetailsListInit.id = val.value;
                      } else if (label == "Task Status") {
                        taskState.statusDetailsListInit.id = val.value;
                      } else if (label == "Priority") {
                        taskState.priorityDetailsListInit.id = val.value;
                      } else if (label == "Assign") {
                        taskState.userDetailsListInit.id = val.value;
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

/*

  List<CommonObj> updateSubStages(int stagesId) {
    try {
      dynamic jsonResponse = leadRepositories.fetchleadEditsApi(stagesId);
      LeadStageBasedLeadSubStage updateleadSubStage =
          LeadStageBasedLeadSubStage.fromJson(jsonResponse);
      List<CommonObj> leadSubStageList;
      late CommonObj leadSubStageListInit;
      // lead Stage List
      if (updateleadSubStage.leadSubStageList != null) {
        leadSubStageList = updateleadSubStage.leadSubStageList!;
        if (leadSubStageList != null) {
          leadSubStageListInit = leadSubStageList.first;
        } else {
          leadSubStageListInit = leadSubStageList.first;
        }
      } else {
        leadSubStageListInit = CommonObj();
      }
      return leadSubStageListInit;
    } catch (e) {}
  }

*/
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

  taskButton({required Function() onTap}) {
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
                'Add New Task',
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
