class Product {
  int? id;
  String? product;
  String? productId;
  String? cost;
  String? quantity;
  String? gST;
  String? amount;
  String? productDescription;

  Product(
      {this.id,
      this.product,
      this.productId,
      this.cost,
      this.quantity,
      this.gST,
      this.amount,
      this.productDescription});

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'Product': product,
      'ProductId': productId,
      'Cost': cost,
      'Quantity': quantity,
      'GST': gST,
      'Amount': amount,
      'ProductDescription': productDescription,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['Id'],
      product: map['Product'],
      productId: map['ProductId'],
      cost: map['Cost'],
      quantity: map['Quantity'],
      gST: map['GST'],
      amount: map['Amount'],
      productDescription: map['ProductDescription'],
    );
  }
}

class ProductIgstList {
  int? product;
  String? quantity;
  String? cost;
  String? gST;
  String? iGST;
  String? amount;
  String? productDescription;
  String? totalAmount;

  ProductIgstList({
    this.product,
    this.cost,
    this.quantity,
    this.gST,
    this.iGST,
    this.amount,
    this.productDescription,
    this.totalAmount,
  });
}

class ProductCgstList {
  String? product;
  String? quantity;
  String? gST;
  String? sGST;
  String? cGST;
  String? amount;
  String? productDescription;
  String? totalAmount;

  ProductCgstList({
    this.product,
    this.quantity,
    this.gST,
    this.sGST,
    this.cGST,
    this.amount,
    this.productDescription,
    this.totalAmount,
  });
}

//
// class ProductIgstList {
//   int? id;
//   String? product;
//   String? cost;
//   String? quantity;
//   String? gST;
//   String? iGST;
//   String? amount;
//   String? productDescription;
//
//   ProductIgstList(
//       {this.id,
//       this.product,
//       this.cost,
//       this.quantity,
//       this.gST,
//       this.iGST,
//       this.amount,
//       this.productDescription});
//
//   // ProductIgstList.fromJson(Map<String, dynamic> json) {
//   //   product = json['Product'];
//   //   cost = json['Cost'];
//   //   quantity = json['Quantity'];
//   //   gST = json['GST'];
//   //   iGST = json['IGST'];
//   //   amount = json['Amount'];
//   //   productDescription = json['ProductDescription'];
//   // }
//   //
//   // Map<String, dynamic> toJson() {
//   //   final Map<String, dynamic> data = <String, dynamic>{};
//   //   data['Product'] = product;
//   //   data['Cost'] = cost;
//   //   data['Quantity'] = quantity;
//   //   data['GST'] = gST;
//   //   data['IGST'] = iGST;
//   //   data['Amount'] = amount;
//   //   data['ProductDescription'] = productDescription;
//   //   return data;
//   // }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'Id': id,
//       'Product': product,
//       'Cost': cost,
//       'Quantity': quantity,
//       'GST': gST,
//       'IGST': iGST,
//       'Amount': amount,
//       'ProductDescription': productDescription,
//     };
//   }
//
//   factory ProductIgstList.fromMap(Map<String, dynamic> map) {
//     return ProductIgstList(
//       id: map['Id'],
//       product: map['Product'],
//       cost: map['Cost'],
//       quantity: map['Quantity'],
//       gST: map['GST'],
//       iGST: map['IGST'],
//       amount: map['Amount'],
//       productDescription: map['ProductDescription'],
//     );
//   }
// }
