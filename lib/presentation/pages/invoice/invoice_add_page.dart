import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/theme/app_assets.dart';
import '../../../config/theme/app_colors.dart';
import '../../../data/models/invoice_model.dart';
import '../../../data/validation/validations.dart';
import '../../../logic/cubit/invoice/invoice_crud_cubit.dart';
import '../../../logic/rxdart/invoice/invoice_add_bloc.dart';
import '../../components/app_loader.dart';
import '../../components/app_toast.dart';

class InvoiceAddPage extends StatefulWidget {
  static const String id = "invoice_add_page";

  const InvoiceAddPage({Key? key}) : super(key: key);

  @override
  State<InvoiceAddPage> createState() => _InvoiceAddPageState();
}

class _InvoiceAddPageState extends State<InvoiceAddPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final invoiceAddBloc = InvoiceAddBloc();
  late InvoiceCrudCubit invoiceCrudCubit;

  List<Map<String, TextEditingController>> multiTextController = [];

  @override
  void initState() {
    super.initState();
    invoiceCrudCubit = BlocProvider.of<InvoiceCrudCubit>(context);
    invoiceCrudCubit.initialInvoiceAddCrud();
    invoiceAddBloc.fetchInvoiceDetailLoaded();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: BlocConsumer<InvoiceCrudCubit, InvoiceCrudState>(
        listener: (context, state) {
          if (state is InvoiceCrudFromSuccess) {
            showSuccessToast(context, "Quotation Successfully Added");
            Navigator.pop(context);
          }
          if (state is InvoiceCrudFromFailed) {
            showWarningToast(context, state.error);
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                streamBuilderDropdown(
                  label: 'Client Name',
                  streamList: invoiceAddBloc.clientsList,
                ),
                const SizedBox(height: 12),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    children: [
                      streamDataPicker(label: 'Issue Date'),
                      const SizedBox(width: 12),
                      streamDataPicker(label: 'Due Date'),
                    ],
                  ),
                ),
                checkBox(),
                Column(
                  children: [
                    SizedBox(
                      height: 540 * multiTextController.length.toDouble(),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(0),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: multiTextController.length,
                        itemBuilder: (_, position) {
                          return quotationProductList(position: position);
                        },
                      ),
                    ),
                    addQuotationButton(onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return selectProduct(
                                productLastId: multiTextController.length);
                          });
                    }),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<InvoiceCrudCubit, InvoiceCrudState>(
        builder: (context, state) {
          return BottomAppBar(
            child: Container(
              height: 90,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: state is InvoiceCrudFromLoading
                  ? showDropdownLoaded()
                  : submitButton(onTap: () {
                      invoiceAddBloc.uploadInvoiceProductUpdate(
                          context, multiTextController);
                    }),
            ),
          );
        },
      ),
    );
  }

  appBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.appColor,
      elevation: 0,
      leading: IconButton(
          onPressed: (() => Navigator.pop(context)),
          icon: const Icon(Icons.arrow_back_rounded)),
      title: Text('Create New Invoice',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold, color: AppColor.secondaryColor)),
      centerTitle: true,
    );
  }

  getStreamInitValue(String label) {
    if (label == "Client Name") {
      return invoiceAddBloc.clientsListInit.valueOrNull?.clientName;
    }
  }

  streamBuilderDropdown(
      {required String label, required Stream<List<ClientsList>> streamList}) {
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
          StreamBuilder<List<ClientsList>>(
            stream: streamList,
            builder: (context, snapshot) {
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
                      .map((val) => DropDownValueModel(
                          name: val.clientName!, value: val.clientId))
                      .toList(),
                  onChanged: (dynamic val) {
                    if (val != '') {
                      if (label == "Client Name") {
                        invoiceAddBloc.invoiceClientsList(val.value);
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
            stream: label == "Issue Date"
                ? invoiceAddBloc.dateIssue
                : invoiceAddBloc.dueDate,
            builder: (context, snapshot) {
              final selectedDate = snapshot.data ?? DateTime.now();
              final selectDate = label == "Issue Date"
                  ? invoiceAddBloc.seletedDateIssue
                  : invoiceAddBloc.seletedDueDate;
              return InkWell(
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    if (label == "Issue Date") {
                      invoiceAddBloc.selectIssueDate(pickedDate);
                    } else {
                      invoiceAddBloc.selectDueDate(pickedDate);
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
                            letterSpacing: 0.5, color: AppColor.grayColor),
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

  checkBox() {
    final isSelectGst = invoiceAddBloc.gstCheckboxValue.valueOrNull;
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Select GST Type :",
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(letterSpacing: .2, color: AppColor.grayColor),
          ),
          const SizedBox(width: 2),
          InkWell(
            onTap: () {
              setState(() => invoiceAddBloc.setGstCheckBoxValue(1));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isSelectGst == 1
                        ? AppColor.focusColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      width: isSelectGst == 1 ? 0 : 3,
                      color: isSelectGst == 1
                          ? Colors.transparent
                          : AppColor.focusColor,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  "IGST",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: AppColor.grayColor),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () {
              setState(() => invoiceAddBloc.setGstCheckBoxValue(2));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isSelectGst == 2
                        ? AppColor.focusColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      width: isSelectGst == 2 ? 0 : 3,
                      color: isSelectGst == 2
                          ? Colors.transparent
                          : AppColor.focusColor,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  "CGST & SGST",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: AppColor.grayColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  addQuotationButton({required Function() onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: InkWell(
        onTap: onTap,
        child: DottedBorder(
          color: AppColor.grayColor,
          borderType: BorderType.RRect,
          radius: const Radius.circular(8),
          strokeWidth: 1,
          dashPattern: const [3],
          child: Container(
            height: 54,
            alignment: Alignment.center,
            child: Text(
              'Add Product',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(letterSpacing: 1, color: AppColor.grayColor),
            ),
          ),
        ),
      ),
    );
  }

  quotationProductList({required int position}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
            child: DottedBorder(
              color: AppColor.grayColor,
              borderType: BorderType.RRect,
              radius: const Radius.circular(8),
              strokeWidth: 1,
              dashPattern: const [3],
              padding: const EdgeInsets.only(top: 12, bottom: 5),
              child: Column(
                children: [
                  editTextField(
                    label: 'Product Name',
                    controller: multiTextController[position]['name']!,
                  ),
                  editTextField(
                    label: 'Quantity',
                    controller: multiTextController[position]['quantity']!,
                  ),
                  editTextField(
                    label: 'Amount',
                    controller: multiTextController[position]['amount']!,
                  ),
                  editTextField(
                    label: 'GST',
                    controller: multiTextController[position]['gst']!,
                  ),
                  editTextField(
                    label: 'Product Description',
                    controller: multiTextController[position]['description']!,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              color: AppColor.bgColor,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Product ${position + 1}',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(letterSpacing: 1),
              ),
            ),
          ),
          Positioned(
            top: 5,
            right: 10,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                for (var i = 0; i < multiTextController.length; i++) {
                  if (position == i) {
                    setState(() => multiTextController.removeAt(i));
                    break;
                  }
                }
              },
              child: Container(
                width: 25,
                height: 25,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: AppColor.warningColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SvgPicture.asset(
                  AppSvg.clear,
                  color: AppColor.bgColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  editTextField(
      {required String label, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
            enabled: label == "Product Name" ? false : true,
            controller: controller,
            keyboardType: label == "Product Description"
                ? TextInputType.multiline
                : label == "Quantity" || label == "Amount" || label == "GST"
                    ? TextInputType.number
                    : TextInputType.none,
            maxLines: label == "Product Description" ? 3 : 1,
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
          'Submit',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(letterSpacing: 1, color: AppColor.bgColor),
        ),
      ),
    );
  }

  selectProduct({required int productLastId}) {
    return SimpleDialog(
      clipBehavior: Clip.hardEdge,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        SizedBox(
          width: 300,
          height: 450,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                onChanged: (value) => invoiceAddBloc.filterProductList(value),
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.search_rounded),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.focusColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.focusColor),
                  ),
                  hintText: 'Search',
                  hintStyle: TextStyle(
                      fontFamily: 'Roboto', fontSize: 14, letterSpacing: 1),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                ),
              ),
              Expanded(
                child: StreamBuilder<List<ProductsList>>(
                    stream: invoiceAddBloc.filterProduct,
                    builder: (_, snapshot) {
                      return ListView.builder(
                        padding: const EdgeInsets.all(0),
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, i) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  multiTextController.add({
                                    'id': TextEditingController(
                                        text: snapshot.data?[i].productId
                                            .toString()),
                                    'name': TextEditingController(
                                        text: snapshot.data?[i].productName),
                                    'quantity':
                                        TextEditingController(text: '1'),
                                    'amount': TextEditingController(
                                        text: snapshot.data?[i].sellingPrice
                                            .toString()),
                                    'gst': TextEditingController(
                                        text: snapshot.data?[i].gst.toString()),
                                    'description':
                                        TextEditingController(text: ''),
                                  });
                                });
                                invoiceAddBloc.filterProductList('');
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 4),
                                child: Text(
                                  snapshot.data?[i].productName ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                          letterSpacing: 1,
                                          color: AppColor.grayColor),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
