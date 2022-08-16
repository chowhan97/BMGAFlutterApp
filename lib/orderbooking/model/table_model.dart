// // // To parse this JSON data, do
// // //
// // //     final tableModel = tableModelFromJson(jsonString);
// //
// // import 'dart:convert';
// //
// // TableModel tableModelFromJson(String str) => TableModel.fromJson(json.decode(str));
// //
// // String tableModelToJson(TableModel data) => json.encode(data.toJson());
// //
// // class TableModel {
// //   TableModel({
// //     this.message,
// //   });
// //
// //   Message? message;
// //
// //   factory TableModel.fromJson(Map<String, dynamic> json) => TableModel(
// //     message: Message.fromJson(json["message"]),
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     "message": message!.toJson(),
// //   };
// // }
// //
// // class Message {
// //   Message({
// //     this.salesOrder,
// //     this.salesPromosItems,
// //     this.boughtItem,
// //     this.salesPromosSameItem,
// //     this.salesPromoDiffItems,
// //     this.salesPromoDiscount,
// //     this.promosQty,
// //     this.salesPromoDiscountedAmount,
// //   });
// //
// //   MessageSalesOrder? salesOrder;
// //   List<dynamic>? salesPromosItems;
// //   List<BoughtItem>? boughtItem;
// //   SalesPromosSameItem? salesPromosSameItem;
// //   SalesPromoDi? salesPromoDiffItems;
// //   SalesPromoDi? salesPromoDiscount;
// //   PromosQty? promosQty;
// //   List<dynamic>? salesPromoDiscountedAmount;
// //
// //   factory Message.fromJson(Map<String, dynamic> json) => Message(
// //     salesOrder: MessageSalesOrder.fromJson(json["sales_order"]),
// //     salesPromosItems: List<dynamic>.from(json["sales_promos_items"].map((x) => x)),
// //     boughtItem: List<BoughtItem>.from(json["bought_item"].map((x) => BoughtItem.fromJson(x))),
// //     salesPromosSameItem: SalesPromosSameItem.fromJson(json["sales_promos_same_item"]),
// //     salesPromoDiffItems: SalesPromoDi.fromJson(json["sales_promo_diff_items"]),
// //     salesPromoDiscount: SalesPromoDi.fromJson(json["sales_promo_discount"]),
// //     promosQty: PromosQty.fromJson(json["promos_qty"]),
// //     salesPromoDiscountedAmount: List<dynamic>.from(json["sales_promo_discounted_amount"].map((x) => x)),
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     "sales_order": salesOrder!.toJson(),
// //     "sales_promos_items": List<dynamic>.from(salesPromosItems!.map((x) => x)),
// //     "bought_item": List<dynamic>.from(boughtItem!.map((x) => x.toJson())),
// //     "sales_promos_same_item": salesPromosSameItem!.toJson(),
// //     "sales_promo_diff_items": salesPromoDiffItems!.toJson(),
// //     "sales_promo_discount": salesPromoDiscount!.toJson(),
// //     "promos_qty": promosQty!.toJson(),
// //     "sales_promo_discounted_amount": List<dynamic>.from(salesPromoDiscountedAmount!.map((x) => x)),
// //   };
// // }
// //
// // class BoughtItem {
// //   BoughtItem({
// //     this.itemCode,
// //     this.quantityBooked,
// //     this.averagePrice,
// //     this.amount,
// //     this.quantityAvailable,
// //   });
// //
// //   String? itemCode;
// //   int? quantityBooked;
// //   int? averagePrice;
// //   int? amount;
// //   int? quantityAvailable;
// //
// //   factory BoughtItem.fromJson(Map<String, dynamic> json) => BoughtItem(
// //     itemCode: json["item_code"],
// //     quantityBooked: json["quantity_booked"],
// //     averagePrice: json["average_price"],
// //     amount: json["amount"],
// //     quantityAvailable: json["quantity_available"],
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     "item_code": itemCode,
// //     "quantity_booked": quantityBooked,
// //     "average_price": averagePrice,
// //     "amount": amount,
// //     "quantity_available": quantityAvailable,
// //   };
// // }
// //
// // class PromosQty {
// //   PromosQty({
// //     this.demoItem2,
// //   });
// //
// //   int? demoItem2;
// //
// //   factory PromosQty.fromJson(Map<String, dynamic> json) => PromosQty(
// //     demoItem2: json["Demo Item 2"],
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     "Demo Item 2": demoItem2,
// //   };
// // }
// //
// // class MessageSalesOrder {
// //   MessageSalesOrder({
// //     this.salesOrder,
// //   });
// //
// //   List<SalesOrderElement>? salesOrder;
// //
// //   factory MessageSalesOrder.fromJson(Map<String, dynamic> json) => MessageSalesOrder(
// //     salesOrder: List<SalesOrderElement>.from(json["sales_order"].map((x) => SalesOrderElement.fromJson(x))),
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     "sales_order": List<dynamic>.from(salesOrder!.map((x) => x.toJson())),
// //   };
// // }
// //
// // class SalesOrderElement {
// //   SalesOrderElement({
// //     this.promoType,
// //     this.qty,
// //     this.itemCode,
// //     this.dic,
// //     this.averagePrice,
// //     this.warehouse,
// //     this.qtyAvailable,
// //   });
// //
// //   String? promoType;
// //   int? qty;
// //   String? itemCode;
// //   String? dic;
// //   int? averagePrice;
// //   String? warehouse;
// //   int? qtyAvailable;
// //
// //   factory SalesOrderElement.fromJson(Map<String, dynamic> json) => SalesOrderElement(
// //     promoType: json["promo_type"],
// //     qty: json["qty"],
// //     itemCode: json["item_code"],
// //     dic: json["dic"],
// //     averagePrice: json["average_price"] ?? "",
// //     warehouse: json["warehouse"],
// //     qtyAvailable: json["qty_available"],
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     "promo_type": promoType,
// //     "qty": qty,
// //     "item_code": itemCode,
// //     "dic": dic,
// //     "average_price": averagePrice,
// //     "warehouse": warehouse,
// //     "qty_available": qtyAvailable,
// //   };
// // }
// //
// // class SalesPromoDi {
// //   SalesPromoDi({
// //     this.promoSales,
// //     this.promos,
// //     this.salesData,
// //   });
// //
// //   List<dynamic>? promoSales;
// //   List<dynamic>? promos;
// //   dynamic? salesData;
// //
// //   factory SalesPromoDi.fromJson(Map<String, dynamic> json) => SalesPromoDi(
// //     promoSales: List<dynamic>.from(json["Promo_sales"].map((x) => x)),
// //     promos: List<dynamic>.from(json["Promos"].map((x) => x)),
// //     salesData: json["sales_data"],
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     "Promo_sales": List<dynamic>.from(promoSales!.map((x) => x)),
// //     "Promos": List<dynamic>.from(promos!.map((x) => x)),
// //     "sales_data": salesData,
// //   };
// // }
// //
// // class SalesPromosSameItem {
// //   SalesPromosSameItem({
// //     this.promoSales,
// //     this.promos,
// //     this.salesData,
// //   });
// //
// //   List<dynamic>? promoSales;
// //   List<Promo>? promos;
// //   List<SalesDatum>? salesData;
// //
// //   factory SalesPromosSameItem.fromJson(Map<String, dynamic> json) => SalesPromosSameItem(
// //     promoSales: List<dynamic>.from(json["Promo_sales"].map((x) => x)),
// //     promos: List<Promo>.from(json["Promos"].map((x) => Promo.fromJson(x))),
// //     salesData: List<SalesDatum>.from(json["sales_data"].map((x) => SalesDatum.fromJson(x))),
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     "Promo_sales": List<dynamic>.from(promoSales!.map((x) => x)),
// //     "Promos": List<dynamic>.from(promos!.map((x) => x.toJson())),
// //     "sales_data": List<dynamic>.from(salesData!.map((x) => x.toJson())),
// //   };
// // }
// //
// // class Promo {
// //   Promo({
// //     this.startDate,
// //     this.endDate,
// //     this.forEveryQuantityThatIsBought,
// //     this.quantityOfFreeItemsThatsGiven,
// //     this.boughtItem,
// //   });
// //
// //   DateTime? startDate;
// //   DateTime? endDate;
// //   int? forEveryQuantityThatIsBought;
// //   int? quantityOfFreeItemsThatsGiven;
// //   String? boughtItem;
// //
// //   factory Promo.fromJson(Map<String, dynamic> json) => Promo(
// //     startDate: DateTime.parse(json["start_date"]),
// //     endDate: DateTime.parse(json["end_date"]),
// //     forEveryQuantityThatIsBought: json["for_every_quantity_that_is_bought"],
// //     quantityOfFreeItemsThatsGiven: json["quantity_of_free_items_thats_given"],
// //     boughtItem: json["bought_item"],
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     "start_date": "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
// //     "end_date": "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
// //     "for_every_quantity_that_is_bought": forEveryQuantityThatIsBought,
// //     "quantity_of_free_items_thats_given": quantityOfFreeItemsThatsGiven,
// //     "bought_item": boughtItem,
// //   };
// // }
// //
// // class SalesDatum {
// //   SalesDatum({
// //     this.pendingQty,
// //   });
// //
// //   dynamic pendingQty;
// //
// //   factory SalesDatum.fromJson(Map<String, dynamic> json) => SalesDatum(
// //     pendingQty: json["pending_qty"],
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     "pending_qty": pendingQty,
// //   };
// // }
// // To parse this JSON data, do
// //
// //     final tableModel = tableModelFromJson(jsonString);
//
// // To parse this JSON data, do
// //
// //     final tableModel = tableModelFromJson(jsonString);
//
// import 'dart:convert';
//
// TableModel tableModelFromJson(String str) => TableModel.fromJson(json.decode(str));
//
// String tableModelToJson(TableModel data) => json.encode(data.toJson());
//
// class TableModel {
//   TableModel({
//     this.message,
//   });
//
//   Message? message;
//
//   factory TableModel.fromJson(Map<String, dynamic> json) => TableModel(
//     message: Message.fromJson(json["message"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "message": message!.toJson(),
//   };
// }
//
// class Message {
//   Message({
//     this.salesOrder,
//     this.salesPromosItems,
//     this.boughtItem,
//     this.salesPromosSameItem,
//     this.salesPromoDiffItems,
//     this.salesPromoDiscount,
//     this.promosQty,
//     this.salesPromoDiscountedAmount,
//   });
//
//   MessageSalesOrder? salesOrder;
//   List<dynamic>? salesPromosItems;
//   List<BoughtItem>? boughtItem;
//   SalesPromo? salesPromosSameItem;
//   SalesPromo? salesPromoDiffItems;
//   SalesPromoDiscount? salesPromoDiscount;
//   PromosQty? promosQty;
//   List<dynamic>? salesPromoDiscountedAmount;
//
//   factory Message.fromJson(Map<String, dynamic> json) => Message(
//     salesOrder: MessageSalesOrder.fromJson(json["sales_order"]),
//     salesPromosItems: List<dynamic>.from(json["sales_promos_items"].map((x) => x)),
//     boughtItem: List<BoughtItem>.from(json["bought_item"].map((x) => BoughtItem.fromJson(x))),
//     salesPromosSameItem: SalesPromo.fromJson(json["sales_promos_same_item"]),
//     salesPromoDiffItems: SalesPromo.fromJson(json["sales_promo_diff_items"]),
//     salesPromoDiscount: SalesPromoDiscount.fromJson(json["sales_promo_discount"]),
//     promosQty: PromosQty.fromJson(json["promos_qty"]),
//     salesPromoDiscountedAmount: List<dynamic>.from(json["sales_promo_discounted_amount"].map((x) => x)),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "sales_order": salesOrder!.toJson(),
//     "sales_promos_items": List<dynamic>.from(salesPromosItems!.map((x) => x)),
//     "bought_item": List<dynamic>.from(boughtItem!.map((x) => x.toJson())),
//     "sales_promos_same_item": salesPromosSameItem!.toJson(),
//     "sales_promo_diff_items": salesPromoDiffItems!.toJson(),
//     "sales_promo_discount": salesPromoDiscount!.toJson(),
//     "promos_qty": promosQty!.toJson(),
//     "sales_promo_discounted_amount": List<dynamic>.from(salesPromoDiscountedAmount!.map((x) => x)),
//   };
// }
//
// class BoughtItem {
//   BoughtItem({
//     this.itemCode,
//     this.quantityBooked,
//     this.averagePrice,
//     this.amount,
//     this.quantityAvailable,
//   });
//
//   String? itemCode;
//   int? quantityBooked;
//   int? averagePrice;
//   int? amount;
//   int? quantityAvailable;
//
//   factory BoughtItem.fromJson(Map<String, dynamic> json) => BoughtItem(
//     itemCode: json["item_code"],
//     quantityBooked: json["quantity_booked"],
//     averagePrice: json["average_price"],
//     amount: json["amount"],
//     quantityAvailable: json["quantity_available"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "item_code": itemCode,
//     "quantity_booked": quantityBooked,
//     "average_price": averagePrice,
//     "amount": amount,
//     "quantity_available": quantityAvailable,
//   };
// }
//
// class PromosQty {
//   PromosQty({
//     this.demoItem4,
//   });
//
//   double? demoItem4;
//
//   factory PromosQty.fromJson(Map<String, dynamic> json) => PromosQty(
//     demoItem4: json["Demo Item 4"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "Demo Item 4": demoItem4,
//   };
// }
//
// class MessageSalesOrder {
//   MessageSalesOrder({
//     this.salesOrder,
//   });
//
//   List<SalesOrderElement>? salesOrder;
//
//   factory MessageSalesOrder.fromJson(Map<String, dynamic> json) => MessageSalesOrder(
//     salesOrder: List<SalesOrderElement>.from(json["sales_order"].map((x) => SalesOrderElement.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "sales_order": List<dynamic>.from(salesOrder!.map((x) => x.toJson())),
//   };
// }
//
// class SalesOrderElement {
//   SalesOrderElement({
//     this.promoType,
//     this.qty,
//     this.itemCode,
//     this.dic,
//     this.averagePrice,
//     this.warehouse,
//     this.qtyAvailable,
//   });
//
//   String? promoType;
//   int? qty;
//   String? itemCode;
//   String? dic;
//   dynamic averagePrice;
//   String? warehouse;
//   dynamic qtyAvailable;
//
//   factory SalesOrderElement.fromJson(Map<String, dynamic> json) => SalesOrderElement(
//     promoType: json["promo_type"],
//     qty: json["qty"],
//     itemCode: json["item_code"],
//     dic: json["dic"],
//     averagePrice: json["average_price"] ?? 136,
//     warehouse: json["warehouse"],
//     qtyAvailable: json["qty_available"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "promo_type": promoType,
//     "qty": qty,
//     "item_code": itemCode,
//     "dic": dic,
//     "average_price": averagePrice,
//     "warehouse": warehouse,
//     "qty_available": qtyAvailable,
//   };
// }
//
// class SalesPromo {
//   SalesPromo({
//     this.promoSales,
//     this.promos,
//     this.salesData,
//   });
//
//   List<dynamic>? promoSales;
//   List<dynamic>? promos;
//   dynamic salesData;
//
//   factory SalesPromo.fromJson(Map<String, dynamic> json) => SalesPromo(
//     promoSales: List<dynamic>.from(json["Promo_sales"].map((x) => x)),
//     promos: List<dynamic>.from(json["Promos"].map((x) => x)),
//     salesData: json["sales_data"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "Promo_sales": List<dynamic>.from(promoSales!.map((x) => x)),
//     "Promos": List<dynamic>.from(promos!.map((x) => x)),
//     "sales_data": salesData,
//   };
// }
//
// class SalesPromoDiscount {
//   SalesPromoDiscount({
//     this.promoSales,
//     this.promos,
//     this.salesData,
//   });
//
//   List<dynamic>? promoSales;
//   List<Promo>? promos;
//   List<SalesDatum>? salesData;
//
//   factory SalesPromoDiscount.fromJson(Map<String, dynamic> json) => SalesPromoDiscount(
//     promoSales: List<dynamic>.from(json["Promo_sales"].map((x) => x)),
//     promos: List<Promo>.from(json["Promos"].map((x) => Promo.fromJson(x))),
//     salesData: List<SalesDatum>.from(json["sales_data"].map((x) => SalesDatum.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "Promo_sales": List<dynamic>.from(promoSales!.map((x) => x)),
//     "Promos": List<dynamic>.from(promos!.map((x) => x.toJson())),
//     "sales_data": List<dynamic>.from(salesData!.map((x) => x.toJson())),
//   };
// }
//
// class Promo {
//   Promo({
//     this.startDate,
//     this.endDate,
//     this.forEveryQuantityThatIsBought,
//     this.quantityOfFreeItemsThatsGiven,
//     this.boughtItem,
//     this.discount,
//   });
//
//   DateTime? startDate;
//   DateTime? endDate;
//   int? forEveryQuantityThatIsBought;
//   int? quantityOfFreeItemsThatsGiven;
//   String? boughtItem;
//   double? discount;
//
//   factory Promo.fromJson(Map<String, dynamic> json) => Promo(
//     startDate: DateTime.parse(json["start_date"]),
//     endDate: DateTime.parse(json["end_date"]),
//     forEveryQuantityThatIsBought: json["for_every_quantity_that_is_bought"],
//     quantityOfFreeItemsThatsGiven: json["quantity_of_free_items_thats_given"],
//     boughtItem: json["bought_item"],
//     discount: json["discount"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "start_date": "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
//     "end_date": "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
//     "for_every_quantity_that_is_bought": forEveryQuantityThatIsBought,
//     "quantity_of_free_items_thats_given": quantityOfFreeItemsThatsGiven,
//     "bought_item": boughtItem,
//     "discount": discount,
//   };
// }
//
// class SalesDatum {
//   SalesDatum({
//     this.pendingQty,
//   });
//
//   double? pendingQty;
//
//   factory SalesDatum.fromJson(Map<String, dynamic> json) => SalesDatum(
//     pendingQty: json["pending_qty"] != null ? json["pending_qty"] : 0.0,
//   );
//
//   Map<String, dynamic> toJson() => {
//     "pending_qty": pendingQty,
//   };
// }

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
  SalesPromoDiscount? salesPromoDiscount;
  PromosQty? promosQty;
  List<dynamic>? salesPromoDiscountedAmount;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    salesOrder: MessageSalesOrder.fromJson(json["sales_order"]),
    salesPromosItems: List<dynamic>.from(json["sales_promos_items"].map((x) => x)),
    boughtItem: List<BoughtItem>.from(json["bought_item"].map((x) => BoughtItem.fromJson(x))),
    salesPromosSameItem: SalesPromo.fromJson(json["sales_promos_same_item"]),
    salesPromoDiffItems: SalesPromo.fromJson(json["sales_promo_diff_items"]),
    salesPromoDiscount: SalesPromoDiscount.fromJson(json["sales_promo_discount"]),
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
    this.demoItem4,
  });

  double? demoItem4;

  factory PromosQty.fromJson(Map<String, dynamic> json) => PromosQty(
    demoItem4: json["Demo Item 4"],
  );

  Map<String, dynamic> toJson() => {
    "Demo Item 4": demoItem4,
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
  dynamic qty;
  String? itemCode;
  String? dic;
  dynamic averagePrice;
  String? warehouse;
  dynamic qtyAvailable;

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
  dynamic? salesData;

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

class SalesPromoDiscount {
  SalesPromoDiscount({
    this.promoSales,
    this.promos,
    // this.salesData,
  });

  List<dynamic>? promoSales;
  List<Promo>? promos;
  // List<SalesDatum>? salesData;

  factory SalesPromoDiscount.fromJson(Map<String, dynamic> json) => SalesPromoDiscount(
    promoSales: List<dynamic>.from(json["Promo_sales"].map((x) => x)),
    promos: List<Promo>.from(json["Promos"].map((x) => Promo.fromJson(x))),
    // salesData: List<SalesDatum>.from(json["sales_data"].map((x) => SalesDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Promo_sales": List<dynamic>.from(promoSales!.map((x) => x)),
    "Promos": List<dynamic>.from(promos!.map((x) => x.toJson())),
    // "sales_data": List<dynamic>.from(salesData!.map((x) => x.toJson())),
  };
}

class Promo {
  Promo({
    this.startDate,
    this.endDate,
    this.forEveryQuantityThatIsBought,
    this.quantityOfFreeItemsThatsGiven,
    this.boughtItem,
    this.discount,
  });

  DateTime? startDate;
  DateTime? endDate;
  int? forEveryQuantityThatIsBought;
  int? quantityOfFreeItemsThatsGiven;
  String? boughtItem;
  double? discount;

  factory Promo.fromJson(Map<String, dynamic> json) => Promo(
    startDate: DateTime.parse(json["start_date"]),
    endDate: DateTime.parse(json["end_date"]),
    forEveryQuantityThatIsBought: json["for_every_quantity_that_is_bought"],
    quantityOfFreeItemsThatsGiven: json["quantity_of_free_items_thats_given"],
    boughtItem: json["bought_item"],
    discount: json["discount"],
  );

  Map<String, dynamic> toJson() => {
    "start_date": "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
    "end_date": "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
    "for_every_quantity_that_is_bought": forEveryQuantityThatIsBought,
    "quantity_of_free_items_thats_given": quantityOfFreeItemsThatsGiven,
    "bought_item": boughtItem,
    "discount": discount,
  };
}

class SalesDatum {
  SalesDatum({
    this.pendingQty,
  });

  double? pendingQty;

  factory SalesDatum.fromJson(Map<String, dynamic> json) => SalesDatum(
    pendingQty: json["pending_qty"],
  );

  Map<String, dynamic> toJson() => {
    "pending_qty": pendingQty,
  };
}

