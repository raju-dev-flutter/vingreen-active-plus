class ProformaInvoiceEditModel {
  String? apiSuccess;
  GetProformaInvoice? getProformaInvoice;
  List<GetAttachments>? getAttachments;

  ProformaInvoiceEditModel(
      {this.apiSuccess, this.getProformaInvoice, this.getAttachments});

  ProformaInvoiceEditModel.fromJson(Map<String, dynamic> json) {
    apiSuccess = json['Api_success'];
    getProformaInvoice = json['get_proforma_invoice'] != null
        ? GetProformaInvoice.fromJson(json['get_proforma_invoice'])
        : null;
    if (json['get_attachments'] != null) {
      getAttachments = <GetAttachments>[];
      json['get_attachments'].forEach((v) {
        getAttachments!.add(GetAttachments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Api_success'] = apiSuccess;
    if (getProformaInvoice != null) {
      data['get_proforma_invoice'] = getProformaInvoice!.toJson();
    }
    if (getAttachments != null) {
      data['get_attachments'] = getAttachments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetProformaInvoice {
  int? proformaInvoiceId;
  String? clientName;
  String? dateIssue;
  String? dateDue;
  int? igstType;
  String? totalAmount;
  String? totalIgst;
  String? totalCgst;
  String? totalSgst;
  String? grandTotal;
  String? createdBy;
  String? createdAt;
  String? updatedBy;
  String? updatedAt;

  GetProformaInvoice(
      {this.proformaInvoiceId,
      this.clientName,
      this.dateIssue,
      this.dateDue,
      this.igstType,
      this.totalAmount,
      this.totalIgst,
      this.totalCgst,
      this.totalSgst,
      this.grandTotal,
      this.createdBy,
      this.createdAt,
      this.updatedBy,
      this.updatedAt});

  GetProformaInvoice.fromJson(Map<String, dynamic> json) {
    proformaInvoiceId = json['proforma_invoice_id'];
    clientName = json['client_name'];
    dateIssue = json['date_issue'];
    dateDue = json['date_due'];
    igstType = json['igst_type'];
    totalAmount = json['total_amount'];
    totalIgst = json['total_igst'];
    totalCgst = json['total_cgst'];
    totalSgst = json['total_sgst'];
    grandTotal = json['grand_total'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedBy = json['updated_by'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['proforma_invoice_id'] = proformaInvoiceId;
    data['client_name'] = clientName;
    data['date_issue'] = dateIssue;
    data['date_due'] = dateDue;
    data['igst_type'] = igstType;
    data['total_amount'] = totalAmount;
    data['total_igst'] = totalIgst;
    data['total_cgst'] = totalCgst;
    data['total_sgst'] = totalSgst;
    data['grand_total'] = grandTotal;
    data['created_by'] = createdBy;
    data['created_at'] = createdAt;
    data['updated_by'] = updatedBy;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class GetAttachments {
  int? product;
  String? service;
  int? quantity;
  String? cost;
  String? gST;
  String? iGST;
  String? cGST;
  String? sGST;
  String? amount;
  String? productDescription;
  String? serviceDescription;

  GetAttachments(
      {this.product,
      this.service,
      this.quantity,
      this.cost,
      this.gST,
      this.iGST,
      this.cGST,
      this.sGST,
      this.amount,
      this.productDescription,
      this.serviceDescription});

  GetAttachments.fromJson(Map<String, dynamic> json) {
    product = json['Product'];
    service = json['Service'];
    quantity = json['Quantity'];
    cost = json['Cost'];
    gST = json['GST'];
    iGST = json['IGST'];
    cGST = json['CGST'];
    sGST = json['SGST'];
    amount = json['Amount'];
    productDescription = json['ProductDescription'];
    serviceDescription = json['ServiceDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Product'] = product;
    data['Service'] = service;
    data['Quantity'] = quantity;
    data['Cost'] = cost;
    data['GST'] = gST;
    data['IGST'] = iGST;
    data['CGST'] = cGST;
    data['SGST'] = sGST;
    data['Amount'] = amount;
    data['ProductDescription'] = productDescription;
    data['ServiceDescription'] = serviceDescription;
    return data;
  }
}
