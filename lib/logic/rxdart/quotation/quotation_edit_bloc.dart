import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../data/models/quotation_edit_model.dart';
import '../../../data/models/quotation_model.dart';
import '../../../data/repositories/quotation_repositories.dart';
import '../../../data/repositories/user_repositories.dart';
import '../../cubit/quotation/quotation_crud_cubit.dart';

class QuotationEditBloc {
  final quotationRepositories = QuotationRepositories();
  final userRepositories = UserRepositories();

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

  Future<void> fetchQuotationEditDetailsLoaded(dynamic quotationId) async {
    final userId = await userRepositories.hasUserId();
    dynamic response1 =
        await quotationRepositories.fetchQuotationAddApi(userId);
    dynamic response2 = await quotationRepositories.fetchQuotationEditDetailApi(
        userId, quotationId);
    final quotation = QuotationModel.fromJson(response1);
    final quotationEdit = QuotationEditModel.fromJson(response2);

    debugPrint(quotation.clientsList?.first.clientName);

    final quotetionDetail = quotationEdit.getQuote;
    // Clients List
    _clientsList.sink.add(quotation.clientsList!);
    debugPrint('Clients List : ${quotetionDetail!.clientName}');
    for (int i = 0; i < _clientsList.value.length; i++) {
      if (_clientsList.value[i].clientName == quotetionDetail.clientName) {
        _clientsListInit.sink.add(_clientsList.value[i]);
        break;
      } else {
        _clientsListInit.sink.add(_clientsList.value.first);
      }
    }

    debugPrint(quotetionDetail.dateIssue!);
    List<String> splitIssueDateTime =
        quotetionDetail.dateIssue.toString().split('-');
    _seletedDateIssue.sink.add(quotetionDetail.dateIssue!);
    _dateIssue.sink.add(DateTime(int.parse(splitIssueDateTime[0]),
        int.parse(splitIssueDateTime[1]), int.parse(splitIssueDateTime[2])));

    debugPrint(quotetionDetail.dateDue!);
    List<String> splitDueDateTime =
        quotetionDetail.dateDue.toString().split('-');
    _seletedDueDate.sink.add(quotetionDetail.dateDue!);
    _dueDate.sink.add(DateTime(int.parse(splitDueDateTime[0]),
        int.parse(splitDueDateTime[1]), int.parse(splitDueDateTime[2])));

    _gstCheckboxValue.sink.add(quotetionDetail.igstType!);

    _productsList.sink.add(quotation.productsList!);
    _filterProduct.sink.add(quotation.productsList!);
  }

  void quotationClientsList(value) {
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

  Future<void> uploadQuotationProductUpdate(BuildContext _, dynamic quotationId,
      List<Map<String, TextEditingController>> multiTextController) async {
    final userId = await userRepositories.hasUserId();
    final quotationCrudCubit =
        BlocProvider.of<QuotationCrudCubit>(_, listen: false);

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
      'quotation_id': quotationId,
      'qualification_date': issueDate.toString(),
      'valid_date': dueDate.toString(),
      'GSTType': _gstCheckboxValue.valueOrNull,
      'TotalAmount': totalAmount.toString(),
      'TotalIGST': totalIgst.toString(),
      'GrandTotal': grandTotalAmount.toString(),
      'quotationItems': productIgstList,
    };

    Map cgstMap = {
      "user_id": userId,
      'client_id': clientsListInit.toString(),
      'quotation_id': quotationId,
      'qualification_date': issueDate.toString(),
      'valid_date': dueDate.toString(),
      'GSTType': _gstCheckboxValue.valueOrNull,
      'TotalAmount': totalAmount.toString(),
      'TotalCGST': totalCgst.toString(),
      'TotalSGST': totalSgst.toString(),
      'GrandTotal': grandTotalAmount.toString(),
      'quotationItems': productCgstList,
    };

    debugPrint(
        "\n ===============Product List===: ${_gstCheckboxValue.valueOrNull == 1 ? igstMap : cgstMap} \n");

    quotationCrudCubit.uploadQuotationEditSubmit(
        _gstCheckboxValue.valueOrNull == 1 ? igstMap : cgstMap);
  }

  void dispose() {
    _clientsList.close();
    _clientsListInit.close();
    _productsList.close();
    _dateIssue.close();
    _seletedDateIssue.close();
    _dueDate.close();
    _seletedDueDate.close();
    _gstCheckboxValue.close();
    _gstCheckboxValue.close();
  }
}
