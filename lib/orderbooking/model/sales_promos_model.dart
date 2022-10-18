// To parse this JSON data, do
//
//     final salesPromosModel = salesPromosModelFromJson(jsonString);

import 'dart:convert';

SalesPromosModel salesPromosModelFromJson(String str) => SalesPromosModel.fromJson(json.decode(str));

String salesPromosModelToJson(SalesPromosModel data) => json.encode(data.toJson());

class SalesPromosModel {
  SalesPromosModel({
    this.message,
  });

  Message? message;

  factory SalesPromosModel.fromJson(Map<String, dynamic> json) => SalesPromosModel(
    message: Message.fromJson(json["message"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message!.toJson(),
  };
}

class Message {
  Message({
    this.salesPreview,
    this.discountPreview,
    this.freePreview,
    this.quotationPreview,
    this.totalAmount,
  });

  List<SalesPreview>? salesPreview;
  List<DiscountPreview>? discountPreview;
  List<FreePreview>? freePreview;
  List<QuotationPreview>? quotationPreview;
  int? totalAmount;


  factory Message.fromJson(Map<String, dynamic> json) => Message(
    salesPreview: List<SalesPreview>.from(json["sales_preview"].map((x) => SalesPreview.fromJson(x))),
    discountPreview: List<DiscountPreview>.from(json["discount_preview"].map((x) => DiscountPreview.fromJson(x))),
    freePreview: List<FreePreview>.from(json["free_preview"].map((x) => FreePreview.fromJson(x))),
    quotationPreview: List<QuotationPreview>.from(json["quotation_preview"].map((x) => QuotationPreview.fromJson(x))),
    totalAmount: json["total_amount"],
  );

  Map<String, dynamic> toJson() => {
    "sales_preview": List<dynamic>.from(salesPreview!.map((x) => x.toJson())),
    "discount_preview": List<dynamic>.from(discountPreview!.map((x) => x)),
    "free_preview": List<dynamic>.from(freePreview!.map((x) => x.toJson())),
    "quotation_preview": List<dynamic>.from(quotationPreview!.map((x) => x.toJson())),
    "total_amount": totalAmount,
  };
}

class FreePreview {
  FreePreview({
    this.boughtItem,
    this.freeItem,
    this.qty,
    this.price,
    this.warehouseQuantity,
    this.promoType,
  });

  dynamic boughtItem;
  dynamic freeItem;
  dynamic qty;
  dynamic price;
  dynamic warehouseQuantity;
  dynamic promoType;

  factory FreePreview.fromJson(Map<String, dynamic> json) => FreePreview(
    boughtItem: json["bought_item"],
    freeItem: json["free_item"],
    qty: json["qty"],
    price: json["price"],
    warehouseQuantity: json["warehouse_quantity"],
    promoType: json["promo_type"],
  );

  Map<String, dynamic> toJson() => {
    "bought_item": boughtItem,
    "free_item": freeItem,
    "qty": qty,
    "price": price,
    "warehouse_quantity": warehouseQuantity,
    "promo_type": promoType,
  };
}

class SalesPreview {
  SalesPreview({
    this.itemCode,
    this.qtyAvailable,
    this.qty,
    this.averagePrice,
    this.warehouse,
    this.promoType,
  });

  dynamic itemCode;
  dynamic qtyAvailable;
  dynamic qty;
  dynamic averagePrice;
  dynamic warehouse;
  dynamic promoType;

  factory SalesPreview.fromJson(Map<String, dynamic> json) => SalesPreview(
    itemCode: json["item_code"],
    qtyAvailable: json["qty_available"],
    qty: json["qty"],
    averagePrice: json["average_price"],
    warehouse: json["warehouse"],
    promoType: json["promo_type"],
  );

  Map<String, dynamic> toJson() => {
    "item_code": itemCode,
    "qty_available": qtyAvailable,
    "qty": qty,
    "average_price": averagePrice,
    "warehouse": warehouse,
    "promo_type": promoType,
  };
}

class DiscountPreview {
  DiscountPreview({
    this.boughtItem,
    this.freeItem,
    this.dicQty,
    this.dic,
    this.promoType,
    this.amount,
  });

  dynamic boughtItem;
  dynamic freeItem;
  dynamic dicQty;
  dynamic dic;
  dynamic promoType;
  dynamic amount;

  factory DiscountPreview.fromJson(Map<String, dynamic> json) => DiscountPreview(
    boughtItem: json["bought_item"],
    freeItem: json["free_item"],
    dicQty: json["dic_qty"],
    dic: json["dic"].toDouble(),
    promoType: json["promo_type"],
    amount: json["amount"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "bought_item": boughtItem,
    "free_item": freeItem,
    "dic_qty": dicQty,
    "dic": dic,
    "promo_type": promoType,
    "amount": amount,
  };
}

class QuotationPreview {
  QuotationPreview({
    this.itemCode,
    this.quantity,
    this.average,
  });

  dynamic itemCode;
  dynamic quantity;
  dynamic average;

  factory QuotationPreview.fromJson(Map<String, dynamic> json) => QuotationPreview(
    itemCode: json["item_code"],
    quantity: json["quantity"],
    average: json["average"],
  );

  Map<String, dynamic> toJson() => {
    "item_code": itemCode,
    "quantity": quantity,
    "average": average,
  };
}


