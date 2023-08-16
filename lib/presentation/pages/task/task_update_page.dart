import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import '../../../config/theme/app_colors.dart';
import '../../../data/validation/validations.dart';
import '../../../logic/cubit/task/task_crud/task_crud_cubit.dart';
import '../../components/app_loader.dart';

class TaskUpdatePage extends StatefulWidget {
  static const String id = 'task_update_page';

  final int taskId;

  const TaskUpdatePage({Key? key, required this.taskId}) : super(key: key);

  @override
  State<TaskUpdatePage> createState() => _TaskUpdatePageState();
}

class _TaskUpdatePageState extends State<TaskUpdatePage> {
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TaskCrudCubit taskCrudCubit;

  @override
  void initState() {
    super.initState();
    taskCrudCubit = BlocProvider.of<TaskCrudCubit>(context);
    taskCrudCubit.getUpdateDetails(widget.taskId);
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
          if (state is TaskUpdateLoaded) {
            return SingleChildScrollView(
              child: Form(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Task Status',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    letterSpacing: 1,
                                    color: AppColor.grayColor),
                          ),
                          const SizedBox(height: 8),
                          DropDownTextField(
                            initialValue: state.statusListInit.name,
                            // controller: _controller,

                            clearOption: false,
                            enableSearch: true,
                            clearIconProperty:
                                IconProperty(color: Colors.green),
                            searchDecoration:
                                const InputDecoration(hintText: "Search "),
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
                            dropDownList: state.statusList
                                .map((data) => DropDownValueModel(
                                    name: data.name!, value: data.id))
                                .toList(),

                            onChanged: (dynamic val) {
                              if (val != '') {
                                var value = val.value;
                                setState(() {
                                  state.statusListInit.id = value;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Description',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    letterSpacing: 1,
                                    color: AppColor.grayColor),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: state.description,
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                            enableSuggestions: true,
                            obscureText: false,
                            enableInteractiveSelection: true,
                            decoration: textInputDecoration('Description'),
                            validator: (String? valid) {
                              return Validations()
                                  .validateString(state.description.text);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    updateTaskButton(
                      onTap: () {
                        Map data = {
                          'user_id': state.userId,
                          'task_id': widget.taskId,
                          'task_status': state.statusListInit.id,
                          'status_description': state.description.text,
                        };
                        debugPrint(data.toString());
                        BlocProvider.of<TaskCrudCubit>(context, listen: false)
                            .submitTaskUpdateDetails(data);
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
      title: Text('Task Update',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold, color: AppColor.secondaryColor)),
      centerTitle: true,
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

  updateTaskButton({required Function() onTap}) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: width,
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
