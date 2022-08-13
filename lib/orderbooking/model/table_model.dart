// To parse this JSON data, do
//
//     final tableModel = tableModelFromJson(jsonString);

import 'dart:convert';

TableModel tableModelFromJson(String str) => TableModel.fromJson(json.decode(str));

String tableModelToJson(TableModel data) => json.encode(data.toJson());

class TableModel {
  TableModel({
    this.message,
  });

  Message? message;

  factory TableModel.fromJson(Map<String, dynamic> json) => TableModel(
    message: Message.fromJson(json["message"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message!.toJson(),
  };
}

class Message {
  Message({
    this.salesOrder,
    this.salesPromosItems,
    this.boughtItem,
    this.salesPromosSameItem,
    this.salesPromoDiffItems,
    this.salesPromoDiscount,
    this.promosQty,
    this.salesPromoDiscountedAmount,
  });

  MessageSalesOrder? salesOrder;
  List<dynamic>? salesPromosItems;
  List<BoughtItem>? boughtItem;
  SalesPromo? salesPromosSameItem;
  SalesPromo? salesPromoDiffItems;
  SalesPromo? salesPromoDiscount;
  PromosQty? promosQty;
  List<dynamic>? salesPromoDiscountedAmount;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    salesOrder: MessageSalesOrder.fromJson(json["sales_order"]),
    salesPromosItems: List<dynamic>.from(json["sales_promos_items"].map((x) => x)),
    boughtItem: List<BoughtItem>.from(json["bought_item"].map((x) => BoughtItem.fromJson(x))),
    salesPromosSameItem: SalesPromo.fromJson(json["sales_promos_same_item"]),
    salesPromoDiffItems: SalesPromo.fromJson(json["sales_promo_diff_items"]),
    salesPromoDiscount: SalesPromo.fromJson(json["sales_promo_discount"]),
    promosQty: PromosQty.fromJson(json["promos_qty"]),
    salesPromoDiscountedAmount: List<dynamic>.from(json["sales_promo_discounted_amount"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "sales_order": salesOrder!.toJson(),
    "sales_promos_items": List<dynamic>.from(salesPromosItems!.map((x) => x)),
    "bought_item": List<dynamic>.from(boughtItem!.map((x) => x.toJson())),
    "sales_promos_same_item": salesPromosSameItem!.toJson(),
    "sales_promo_diff_items": salesPromoDiffItems!.toJson(),
    "sales_promo_discount": salesPromoDiscount!.toJson(),
    "promos_qty": promosQty!.toJson(),
    "sales_promo_discounted_amount": List<dynamic>.from(salesPromoDiscountedAmount!.map((x) => x)),
  };
}

class BoughtItem {
  BoughtItem({
    this.itemCode,
    this.quantityBooked,
    this.averagePrice,
    this.amount,
    this.quantityAvailable,
  });

  String? itemCode;
  int? quantityBooked;
  int? averagePrice;
  int? amount;
  int? quantityAvailable;

  factory BoughtItem.fromJson(Map<String, dynamic> json) => BoughtItem(
    itemCode: json["item_code"],
    quantityBooked: json["quantity_booked"],
    averagePrice: json["average_price"],
    amount: json["amount"],
    quantityAvailable: json["quantity_available"],
  );

  Map<String, dynamic> toJson() => {
    "item_code": itemCode,
    "quantity_booked": quantityBooked,
    "average_price": averagePrice,
    "amount": amount,
    "quantity_available": quantityAvailable,
  };
}

class PromosQty {
  PromosQty({
    this.itemA,
  });

  double? itemA;

  factory PromosQty.fromJson(Map<String, dynamic> json) => PromosQty(
    itemA: json["ItemA"],
  );

  Map<String, dynamic> toJson() => {
    "ItemA": itemA,
  };
}

class MessageSalesOrder {
  MessageSalesOrder({
    this.salesOrder,
  });

  List<SalesOrderElement>? salesOrder;

  factory MessageSalesOrder.fromJson(Map<String, dynamic> json) => MessageSalesOrder(
    salesOrder: List<SalesOrderElement>.from(json["sales_order"].map((x) => SalesOrderElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "sales_order": List<dynamic>.from(salesOrder!.map((x) => x.toJson())),
  };
}

class SalesOrderElement {
  SalesOrderElement({
    this.promoType,
    this.qty,
    this.itemCode,
    this.dic,
    this.averagePrice,
    this.warehouse,
    this.qtyAvailable,
  });

  String? promoType;
  int? qty;
  String? itemCode;
  String? dic;
  int? averagePrice;
  String? warehouse;
  int? qtyAvailable;

  factory SalesOrderElement.fromJson(Map<String, dynamic> json) => SalesOrderElement(
    promoType: json["promo_type"],
    qty: json["qty"],
    itemCode: json["item_code"],
    dic: json["dic"],
    averagePrice: json["average_price"],
    warehouse: json["warehouse"],
    qtyAvailable: json["qty_available"],
  );

  Map<String, dynamic> toJson() => {
    "promo_type": promoType,
    "qty": qty,
    "item_code": itemCode,
    "dic": dic,
    "average_price": averagePrice,
    "warehouse": warehouse,
    "qty_available": qtyAvailable,
  };
}

class SalesPromo {
  SalesPromo({
    this.promoSales,
    this.promos,
    this.salesData,
  });

  List<dynamic>? promoSales;
  List<dynamic>? promos;
  dynamic salesData;

  factory SalesPromo.fromJson(Map<String, dynamic> json) => SalesPromo(
    promoSales: List<dynamic>.from(json["Promo_sales"].map((x) => x)),
    promos: List<dynamic>.from(json["Promos"].map((x) => x)),
    salesData: json["sales_data"],
  );

  Map<String, dynamic> toJson() => {
    "Promo_sales": List<dynamic>.from(promoSales!.map((x) => x)),
    "Promos": List<dynamic>.from(promos!.map((x) => x)),
    "sales_data": salesData,
  };
}
