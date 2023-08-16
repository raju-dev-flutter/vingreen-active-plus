import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../data/models/proforma_invoice_model.dart';
import '../../../data/repositories/proforma_invoice_repositories.dart';
import '../../../data/repositories/user_repositories.dart';
import '../../cubit/proforma_invoice/proforma_invoice_crud_cubit.dart';

class ProformaInvoiceAddBloc {
  final proformaInvoiceRepositories = ProformaInvoiceRepositories();
  final userRepositories = UserRepositories();

  final searchController = BehaviorSubject<String>();
  final _clientsList = BehaviorSubject<List<ClientsList>>();
  final _clientsListInit = BehaviorSubject<ClientsList>();
  final _productsList = BehaviorSubject<List<ProductsList>>();
  final _filterProduct = BehaviorSubject<List<ProductsList>>();

  final _dateIssue = BehaviorSubject<DateTime>();
  final _seletedDateIssue = BehaviorSubject<String>();

  final _dueDate = BehaviorSubject<DateTime>();
  final _seletedDueDate = BehaviorSubject<String>();

  final _gstCheckboxValue = BehaviorSubject<int>.seeded(1);

  Stream<List<ClientsList>> get clientsList => _clientsList.stream;

  Stream<List<ProductsList>> get productsList => _productsList.stream;

  Stream<List<ProductsList>> get filterProduct => _filterProduct.stream;

  ValueStream<ClientsList> get clientsListInit => _clientsListInit.stream;

  ValueStream<DateTime> get dateIssue => _dateIssue.stream;

  ValueStream<String> get seletedDateIssue => _seletedDateIssue.stream;

  ValueStream<DateTime> get dueDate => _dueDate.stream;

  ValueStream<String> get seletedDueDate => _seletedDueDate.stream;

  ValueStream<int> get gstCheckboxValue => _gstCheckboxValue.stream;

  Future<void> fetchProformaInvoiceDetailLoaded() async {
    final userId = await userRepositories.hasUserId();
    dynamic response =
        await proformaInvoiceRepositories.fetchProformaInvoiceAddApi(userId);
    final invoice = ProformaInvoiceModel.fromJson(response);
    debugPrint(invoice.clientsList?.first.clientName);

    _clientsList.sink.add(invoice.clientsList!);
    _clientsListInit.sink.add(invoice.clientsList!.first);

    _productsList.sink.add(invoice.productsList!);
    _filterProduct.sink.add(invoice.productsList!);
  }

  void invoiceClientsList(value) {
    _clientsListInit.value.clientId = value;
  }

  void selectIssueDate(DateTime date) {
    List<String> splitDateTime = date.toString().split(' ');
    _dateIssue.sink.add(date);
    _seletedDateIssue.sink.add(splitDateTime[0]);
  }

  void selectDueDate(DateTime date) {
    List<String> splitDateTime = date.toString().split(' ');
    _dueDate.sink.add(date);
    _seletedDueDate.sink.add(splitDateTime[0]);
  }

  void setGstCheckBoxValue(int i) {
    _gstCheckboxValue.sink.add(i);
  }

  void filterProductList(String searchKey) {
    _filterProduct.sink.add(_productsList.value
        .where((product) => product.productName!
            .toLowerCase()
            .contains(searchKey.toLowerCase()))
        .toList());
  }

  Future<void> uploadProformaInvoiceProductUpdate(BuildContext _,
      List<Map<String, TextEditingController>> multiTextController) async {
    final userId = await userRepositories.hasUserId();
    final proformaInvoiceCrudCubit =
        BlocProvider.of<ProformaInvoiceCrudCubit>(_, listen: false);

    final clientsListInit = _clientsListInit.valueOrNull?.clientId.toString();
    final issueDate = _seletedDateIssue.valueOrNull;
    final dueDate = _seletedDueDate.valueOrNull;

    var totalAmount = 0;
    var totalIgst = 0;
    var totalCgst = 0;
    var totalSgst = 0;
    var grandTotalAmount = 0;

    List<int> amountList = [];
    List<int> igstList = [];
    List<int> cgstList = [];
    List<int> sgstList = [];

    List<int> grandTotalAmountList = [];
    List<Map<String, String>> productIgstList = [];
    List<Map<String, String>> productCgstList = [];
    debugPrint(multiTextController.length.toString());
    for (var i = 0; i < multiTextController.length; i++) {
      final id = multiTextController[i]['id']!.text;
      final amount = multiTextController[i]['amount']!.text.toString();
      final quantity = multiTextController[i]['quantity']!.text;
      final gst = multiTextController[i]['gst']!.text;
      final description = multiTextController[i]['description']!.text;

      var withoutGstAmount = int.parse(amount) * int.parse(quantity);
      final divitedAmount = withoutGstAmount / 100;
      final gstAmount = divitedAmount * int.parse(gst);
      final cgstAmount = gstAmount / 2;
      var singleProductTotalAmount = withoutGstAmount + gstAmount.toInt();

      igstList.add(gstAmount.toInt());
      amountList.add(withoutGstAmount);
      cgstList.add(cgstAmount.toInt());
      sgstList.add(cgstAmount.toInt());
      grandTotalAmountList.add(singleProductTotalAmount.toInt());

      debugPrint("====Without Gst Amount : $withoutGstAmount");
      Map<String, String> igstVal = {
        'Product': id.toString(),
        'Cost': amount.toString(),
        'Amount': withoutGstAmount.toString(),
        'Quantity': quantity.toString(),
        'GST': gst.toString(),
        'IGST': gstAmount.toString(),
        'ProductDescription': description.toString(),
      };
      productIgstList.add(igstVal);
      Map<String, String> cgstVal = {
        'Product': id.toString(),
        'Cost': amount.toString(),
        'Amount': withoutGstAmount.toString(),
        'Quantity': quantity.toString(),
        'GST': gst.toString(),
        "CGST": cgstAmount.toString(),
        "SGST": cgstAmount.toString(),
        'ProductDescription': description.toString(),
      };
      productCgstList.add(cgstVal);
    }

    for (var i = 0; i < amountList.length; i++) {
      totalAmount += amountList[i];
      debugPrint("\n ===Total Amount :==========: $totalAmount");
    }
    for (var i = 0; i < igstList.length; i++) {
      totalIgst += igstList[i];
      debugPrint("\n ===Total Igst :==========: $totalIgst");
    }
    for (var i = 0; i < cgstList.length; i++) {
      totalCgst += cgstList[i];
      debugPrint("\n ===Total Cgst :==========: $totalCgst");
    }
    for (var i = 0; i < sgstList.length; i++) {
      totalSgst += sgstList[i];
      debugPrint("\n ===Total Sgst :==========: $totalSgst");
    }
    for (var i = 0; i < grandTotalAmountList.length; i++) {
      grandTotalAmount += grandTotalAmountList[i];
      debugPrint(
          "\n ===Grand Total Amount List :==========: ${grandTotalAmountList[i]}");
    }
    Map igstMap = {
      "user_id": userId,
      'client_id': clientsListInit.toString(),
      'qualification_date': issueDate.toString(),
      'valid_date': dueDate.toString(),
      'GSTType': _gstCheckboxValue.valueOrNull,
      'TotalAmount': totalAmount.toString(),
      'TotalIGST': totalIgst.toString(),
      'GrandTotal': grandTotalAmount.toString(),
      'proformainvoiceItems': productIgstList,
    };

    Map cgstMap = {
      "user_id": userId,
      'client_id': clientsListInit.toString(),
      'qualification_date': issueDate.toString(),
      'valid_date': dueDate.toString(),
      'GSTType': _gstCheckboxValue.valueOrNull,
      'TotalAmount': totalAmount.toString(),
      'TotalCGST': totalCgst.toString(),
      'TotalSGST': totalSgst.toString(),
      'GrandTotal': grandTotalAmount.toString(),
      'proformainvoiceItems': productCgstList,
    };

    debugPrint(
        "\n ===============Product List===: ${_gstCheckboxValue.valueOrNull == 1 ? igstMap : cgstMap} \n");

    proformaInvoiceCrudCubit.uploadProformaInvoiceAddSubmit(
        _gstCheckboxValue.valueOrNull == 1 ? igstMap : cgstMap);
  }

  void dispose() {
    _clientsList.close();
    _clientsListInit.close();
    _dateIssue.close();
    _seletedDateIssue.close();
    _dueDate.close();
    _seletedDueDate.close();
    _gstCheckboxValue.close();
  }
}
