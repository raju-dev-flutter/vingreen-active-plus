class Pettycash {
  String? apiSuccess;
  List<ExpenseList>? expenseList;
  List<UsersList>? usersList;

  Pettycash({this.apiSuccess, this.expenseList, this.usersList});

  Pettycash.fromJson(Map<String, dynamic> json) {
    apiSuccess = json['Api_success'];
    if (json['Expense List'] != null) {
      expenseList = <ExpenseList>[];
      json['Expense List'].forEach((v) {
        expenseList!.add(ExpenseList.fromJson(v));
      });
    }
    if (json['Users List'] != null) {
      usersList = <UsersList>[];
      json['Users List'].forEach((v) {
        usersList!.add(UsersList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Api_success'] = apiSuccess;
    if (expenseList != null) {
      data['Expense List'] = expenseList!.map((v) => v.toJson()).toList();
    }
    if (usersList != null) {
      data['Users List'] = usersList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ExpenseList {
  int? pettycashId;
  String? pettycashDate;
  String? particulars;
  String? voucherNumber;
  String? billReceiptNumber;
  String? userId;
  int? amount;
  String? balanceHistory;
  String? createdBy;
  String? createdAt;
  String? updatedBy;
  String? updatedAt;

  ExpenseList(
      {this.pettycashId,
      this.pettycashDate,
      this.particulars,
      this.voucherNumber,
      this.billReceiptNumber,
      this.userId,
      this.amount,
      this.balanceHistory,
      this.createdBy,
      this.createdAt,
      this.updatedBy,
      this.updatedAt});

  ExpenseList.fromJson(Map<String, dynamic> json) {
    pettycashId = json['pettycash_id'];
    pettycashDate = json['pettycash_date'];
    particulars = json['particulars'];
    voucherNumber = json['voucher_number'];
    billReceiptNumber = json['bill_receipt_number'];
    userId = json['user_id'];
    amount = json['amount'];
    balanceHistory = json['balance_history'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedBy = json['updated_by'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pettycash_id'] = pettycashId;
    data['pettycash_date'] = pettycashDate;
    data['particulars'] = particulars;
    data['voucher_number'] = voucherNumber;
    data['bill_receipt_number'] = billReceiptNumber;
    data['user_id'] = userId;
    data['amount'] = amount;
    data['balance_history'] = balanceHistory;
    data['created_by'] = createdBy;
    data['created_at'] = createdAt;
    data['updated_by'] = updatedBy;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class UsersList {
  int? id;
  String? firstName;

  UsersList({this.id, this.firstName});

  UsersList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    return data;
  }
}
