import 'dart:io';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../config/theme/app_assets.dart';
import '../../../config/theme/app_colors.dart';
import '../../../data/validation/validations.dart';
import '../../../logic/cubit/petty_cash/petty_cash_crud_cubit.dart';
import '../../components/app_loader.dart';
import '../../components/app_toast.dart';

class PettyCashAddPage extends StatefulWidget {
  static const String id = 'petty_cash_add_page';

  const PettyCashAddPage({Key? key}) : super(key: key);

  @override
  State<PettyCashAddPage> createState() => _PettyCashAddPageState();
}

class _PettyCashAddPageState extends State<PettyCashAddPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController amount = TextEditingController();
  TextEditingController voucher = TextEditingController();
  TextEditingController billReceipt = TextEditingController();
  TextEditingController description = TextEditingController();

  late PettyCashCrudCubit pettyCashCrudCubit;

  final ImagePicker imagePicker = ImagePicker();
  List<XFile> pickedImage = [];
  var selectedDate;
  List<String> formattedDate =
      DateFormat('dd-MM-yyyy').format(DateTime.now()).split('-');

  @override
  void initState() {
    super.initState();
    pettyCashCrudCubit = BlocProvider.of<PettyCashCrudCubit>(context);
    pettyCashCrudCubit.getUserDetails();
    selectedDate =
        '${formattedDate[2]}-${formattedDate[1]}-${formattedDate[0]}';
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: BlocConsumer<PettyCashCrudCubit, PettyCashCrudState>(
        listener: (context, state) {
          if (state is PettyCashFormSuccess) {
            showSuccessToast(context, 'Petty Cash Successfully Added');
            Navigator.pop(context);
          }
          if (state is PettyCashFormFailure) {
            showWarningToast(context, 'Profile Petty Cash Added Failed');
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is PettyCashCrudLoading) {
            return showCirclerLoading(context, 40);
          }
          if (state is PettyCashCrudFailure) {}
          if (state is PettyCashCrudLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Form(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'User Name',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    letterSpacing: 1,
                                    color: AppColor.grayColor),
                          ),
                          const SizedBox(height: 8),
                          DropDownTextField(
                            initialValue: state.usersListInit.firstName,
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
                            dropDownList: state.usersList
                                .map((data) => DropDownValueModel(
                                    name: data.firstName!, value: data.id))
                                .toList(),
                            onChanged: (dynamic val) {
                              if (val != '') {
                                var value = val.value;
                                setState(() {
                                  state.usersListInit.id = value;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    editTextField(label: 'Amount', controller: amount),
                    buildDateField(label: 'Date'),
                    // editTextField(label: 'Date', controller: amount),
                    editTextField(label: 'Voucher Number', controller: voucher),
                    editTextField(
                        label: 'Bill Receipt Number', controller: billReceipt),
                    buildImageList(label: 'Attachment'),
                    editTextField(
                        label: 'Description', controller: description),
                    state is PettyCashFormLoading
                        ? showCirclerLoading(context, 40)
                        : submitButton(onTap: () {
                            Map<String, String> data = {
                              'id': state.userId,
                              'pettycash_date': selectedDate,
                              'particulars': description.text,
                              'voucher_number': voucher.text,
                              'bill_receipt_number': billReceipt.text,
                              'user_id': state.usersListInit.id.toString(),
                              'amount': amount.text,
                            };
                            // debugPrint("========= : ${data['image']}");
                            BlocProvider.of<PettyCashCrudCubit>(context,
                                    listen: false)
                                .submitPettyCashDetails(data, pickedImage);
                          })
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
      title: Text('Create New Petty Cash',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold, color: AppColor.secondaryColor)),
      centerTitle: true,
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

  buildDateField({required String label}) {
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
          InkWell(
            onTap: (() async {
              DateTime? newTime = await showDatePicker(
                context: context,
                initialDate: DateTime(2000),
                firstDate: DateTime(2000, 1, 1),
                lastDate: DateTime(int.parse(formattedDate[2]),
                    int.parse(formattedDate[1]), int.parse(formattedDate[0])),
              );

              if (newTime != null) {
                List<String> splitDateTime = newTime.toString().split(' ');
                List<String> splitDate = splitDateTime[0].split('-');

                setState(() {
                  selectedDate =
                      "${splitDate[0]}-${splitDate[1]}-${splitDate[2]}";
                });
              }
            }),
            child: Container(
              height: 50,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  width: 1,
                  color: AppColor.grayColor.withOpacity(.6),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    selectedDate ??
                        "${formattedDate[0]}-${formattedDate[1]}-${formattedDate[2]}",
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 20,
                    child: SvgPicture.asset(
                      AppSvg.calendar,
                      color: const Color(0xFF5B8DB9),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildImageList({required String label}) {
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
          SizedBox(
            height: 80,
            child: Row(
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: IconButton(
                      icon: const Icon(Icons.add_a_photo, color: Colors.grey),
                      onPressed: () => _showPicker(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                pickedImage.isEmpty
                    ? const SizedBox()
                    : SizedBox(
                        height: 100,
                        child: ListView.builder(
                          itemCount: pickedImage.length,
                          itemBuilder: (_, index) {
                            return Stack(
                              children: [
                                InkWell(
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    margin: const EdgeInsets.only(left: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.black),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Hero(
                                        tag: "image_tag",
                                        child: Image(
                                          image: FileImage(
                                              File(pickedImage[index].path)),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () => _viewImageDialog(index),
                                ),
                                Positioned(
                                  top: 10,
                                  left: 10,
                                  child: InkWell(
                                    child: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onTap: () => setState(
                                        () => pickedImage.removeAt(index)),
                                  ),
                                )
                              ],
                            );
                          },
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _viewImageDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) => ViewImage(
        file: pickedImage[index],
      ),
    );
  }

  void _showPicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  Future _imgFromCamera() async {
    final pickedFile = await imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 90);

    setState(() {
      if (pickedFile != null) {
        try {
          if (pickedImage.length < 3) {
            pickedImage.add(pickedFile);
          } else {
            showWarningToast(
                context, "Maximum you can add one attachment here!");
          }
        } catch (e) {
          showWarningToast(
              context, "Something went wrong. Please try again later.");
        }
      } else {
        showWarningToast(context, "No image selected.");
      }
    });
  }

  Future _imgFromGallery() async {
    final pickedFile = await imagePicker.pickMultiImage(
        requestFullMetadata: true, imageQuality: 20);

    setState(() {
      if (pickedFile.isNotEmpty) {
        if (pickedFile.length <= 3) {
          try {
            if (pickedImage.length < 3) {
              for (var i = 0; i < pickedFile.length; i++) {
                pickedImage.add(pickedFile[i]);
              }
            } else {
              showWarningToast(
                  context, "Maximum you can add one attachment here!");
            }
          } catch (e) {
            showWarningToast(
                context, "Something went wrong. Please try again later.");
          }
        } else {
          showWarningToast(context,
              "Something went wrong. Please select only three attachment.");
        }
      } else {
        showWarningToast(context, "No image selected.");
      }
    });
  }

  submitButton({required Function() onTap}) {
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
                'Add New Petty Cash',
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

class ViewImage extends StatelessWidget {
  XFile file;

  ViewImage({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        alignment: Alignment.center,
        child: Container(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Hero(
              tag: "image_tag",
              child: Image(
                image: FileImage(File(file.path)),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
