class InvoiceModel {
  String? apiSuccess;
  List<InvoiceList>? invoiceList;
  List<ClientsList>? clientsList;
  List<ProductsList>? productsList;
  List<ServicesList>? servicesList;

  InvoiceModel(
      {this.apiSuccess,
      this.invoiceList,
      this.clientsList,
      this.productsList,
      this.servicesList});

  InvoiceModel.fromJson(Map<String, dynamic> json) {
    apiSuccess = json['Api_success'];
    if (json['Invoice List'] != null) {
      invoiceList = <InvoiceList>[];
      json['Invoice List'].forEach((v) {
        invoiceList!.add(InvoiceList.fromJson(v));
      });
    }
    if (json['Clients List'] != null) {
      clientsList = <ClientsList>[];
      json['Clients List'].forEach((v) {
        clientsList!.add(ClientsList.fromJson(v));
      });
    }
    if (json['Products List'] != null) {
      productsList = <ProductsList>[];
      json['Products List'].forEach((v) {
        productsList!.add(ProductsList.fromJson(v));
      });
    }
    if (json['Services List'] != null) {
      servicesList = <ServicesList>[];
      json['Services List'].forEach((v) {
        servicesList!.add(ServicesList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Api_success'] = apiSuccess;
    if (invoiceList != null) {
      data['Invoice List'] = invoiceList!.map((v) => v.toJson()).toList();
    }
    if (clientsList != null) {
      data['Clients List'] = clientsList!.map((v) => v.toJson()).toList();
    }
    if (productsList != null) {
      data['Products List'] = productsList!.map((v) => v.toJson()).toList();
    }
    if (servicesList != null) {
      data['Services List'] = servicesList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InvoiceList {
  int? invoiceId;
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

  InvoiceList(
      {this.invoiceId,
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

  InvoiceList.fromJson(Map<String, dynamic> json) {
    invoiceId = json['invoice_id'];
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
    data['invoice_id'] = invoiceId;
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

class ClientsList {
  int? clientId;
  String? clientName;

  ClientsList({this.clientId, this.clientName});

  ClientsList.fromJson(Map<String, dynamic> json) {
    clientId = json['client_id'];
    clientName = json['client_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['client_id'] = clientId;
    data['client_name'] = clientName;
    return data;
  }
}

class ProductsList {
  int? productId;
  String? productName;
  int? gst;
  String? sellingPrice;

  ProductsList({this.productId, this.productName, this.gst, this.sellingPrice});

  ProductsList.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    gst = json['gst'];
    sellingPrice = json['selling_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['gst'] = this.gst;
    data['selling_price'] = this.sellingPrice;
    return data;
  }
}

class ServicesList {
  int? serviceId;
  String? serviceName;

  ServicesList({this.serviceId, this.serviceName});

  ServicesList.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'];
    serviceName = json['service_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['service_id'] = serviceId;
    data['service_name'] = serviceName;
    return data;
  }
}
