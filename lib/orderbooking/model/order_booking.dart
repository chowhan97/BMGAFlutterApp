class OrderBooking {
  final String? name;
  final int? docstatus;
  final String? customer;
  final String? company;
  final String? customer_name;
  final String? modified;
  final List<OrderBookingItems>? orderBookingItems;
  // final List<OrderBookingSalesPromos>? orderBookingSalesPromos;
  

  OrderBooking(
      {this.docstatus,
      this.orderBookingItems,
      this.customer,
      this.company,
      this.name,
      this.customer_name,
      this.modified,
      // this.orderBookingSalesPromos
      });
  factory OrderBooking.fromJson(Map<String, dynamic> json) {
    return OrderBooking(
      company: json['company'] ?? '',
      customer: json['customer'] ?? '',
      name: json['name'] ?? '',
      orderBookingItems: json['items'] ?? null,
      customer_name: json['customer_name'] ?? "",
      modified: json['modified'] ?? ""
      // orderBookingSalesPromos: json['items'] ?? null,
    );
  }

  //For converting model to json format for storing it in quality inspection model
  Map toJson() {
    List<Map>? orderBookingItemsList = this.orderBookingItems != null
        ? this.orderBookingItems!.map((i) => i.toJson()).toList()
        : null;
    return {
      'docstatus': docstatus,
      'company': company,
      'customer': customer,
      'items': orderBookingItemsList,
      // 'items': orderBookingSalesPromos,

    };
  }
}

class OrderBookingItems {
  double? qty;
  String? itemcode;
  String? itemname;
  double? amount;
  double? rate;


  OrderBookingItems({
    this.qty,
    this.itemcode,
    this.itemname,
    this.amount,
    this.rate
  });

  factory OrderBookingItems.fromJson(Map<String, dynamic> json) {
    return OrderBookingItems(
      amount: json['amount'] ?? 0,
      itemcode: json['item_code'] ?? '',
      itemname: json['item_name'] ?? '',
      qty: json['qty'] ?? 0,
      rate: json['rate'] ?? 0,
    );
  }

  //For converting model to json format for storing it in quality inspection readings
  Map toJson() => {
        'item_code': itemcode,
        'qty': qty,
      };
     
}


//fecthing sales promo

class OrderBookingSalesPromos{
    String? customertype;
    String? orderlist;
    String? itemCode;
    String? customer;
    String? company;

  OrderBookingSalesPromos({
    this.customertype,
    this.orderlist,
    this.itemCode,
    this.customer,
    this.company,
  });

  factory OrderBookingSalesPromos.fromJson(Map<String, dynamic> json){
    return OrderBookingSalesPromos(
      customertype: json['customer_type'] ?? '',
      orderlist: json['order_list'] ?? '',
      itemCode: json['item_code'] ?? '',
      customer: json['customer'] ?? '',
      company: json['company'] ?? '',
    );
  }
  Map toJson() =>{
    'customer_type': customertype,
    'order_list': orderlist,
  };
}




// class OrderBookingSalesPromos {
//     OrderBookingSalesPromos({
//         this.customertype,
//         this.itemCode,
//         this.customer,
//         this.company,
//         this.orderList,
//     });

//     String? customertype;
//     String? itemCode;
//     String? customer;
//     String? company;
//     String? orderList;

//     factory OrderBookingSalesPromos.fromJson(Map<String, dynamic> json) => OrderBookingSalesPromos(
//         customertype: json["customertype"],
//         itemCode: json["item_code"],
//         customer: json["customer"],
//         company: json["company"],
//         orderList: json["order_list"],
//     );

//     Map<String, dynamic> toJson() => {
//         "customertype": customertype,
//         "item_code": itemCode,
//         "customer": customer,
//         "company": company,
//         "order_list": orderList,
//     };
// }

//OrderBookingDetails orderBookingDetailsFromJson(String str) => OrderBookingDetails.fromJson(json.decode(str));

//String orderBookingDetailsToJson(OrderBookingDetails data) => json.encode(data.toJson());

class OrderBookingDetails {
    OrderBookingDetails({
        this.message,
    });

    Message? message;

    factory OrderBookingDetails.fromJson(Map<String, dynamic> json) => OrderBookingDetails(
        message: Message.fromJson(json["message"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message?.toJson(),
    };
}

class Message {
    Message({
        this.availableQty,
        this.priceDetails,
        this.stockDetail,
        this.qtyDetail,
        this.brandName,
    });

    int? availableQty;
    PriceDetails? priceDetails;
    StockDetail? stockDetail;
    QtyDetail? qtyDetail;
    BrandName? brandName;

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        availableQty: json["available_qty"],
        priceDetails: PriceDetails.fromJson(json["price_details"]),
        stockDetail: StockDetail.fromJson(json["stock_detail"]),
        qtyDetail: QtyDetail.fromJson(json["qty_detail"]),
        brandName: BrandName.fromJson(json["brand_name"]),
    );

    Map<String, dynamic> toJson() => {
        "available_qty": availableQty,
        "price_details": priceDetails?.toJson(),
        "stock_detail": stockDetail?.toJson(),
        "qty_detail": qtyDetail?.toJson(),
        "brand_name": brandName?.toJson(),

    };
}
class BrandName {
    BrandName({
        this.brandName,
    });

    String? brandName;

    factory BrandName.fromJson(Map<String, dynamic> json) => BrandName(
        brandName: json["brand_name"],
    );

    Map<String, dynamic> toJson() => {
        "brand_name": brandName,
    };
}

class PriceDetails {
    PriceDetails({
        this.price,
        this.rateContractCheck,
        this.mrp,
    });

    int? price;
    int? rateContractCheck;
    int? mrp;

    factory PriceDetails.fromJson(Map<String, dynamic> json) => PriceDetails(
        price: json["price"],
        rateContractCheck: json["rate_contract_check"],
        mrp: json["mrp"],
    );

    Map<String, dynamic> toJson() => {
        "price": price,
        "rate_contract_check": rateContractCheck,
        "mrp": mrp,
    };
}

class QtyDetail {
    QtyDetail({
        this.availableQty,
        this.salesQty,
    });

    int? availableQty;
    int? salesQty;

    factory QtyDetail.fromJson(Map<String, dynamic> json) => QtyDetail(
        availableQty: json["available_qty"],
        salesQty: json["sales_qty"],
    );

    Map<String, dynamic> toJson() => {
        "available_qty": availableQty,
        "sales_qty": salesQty,
    };
}

class StockDetail {
    StockDetail({
        this.batchId,
        this.actualQty,
    });

    String? batchId;
    int? actualQty;

    factory StockDetail.fromJson(Map<String, dynamic> json) => StockDetail(
        batchId: json["batch_id"],
        actualQty: json["actual_qty"],
    );

    Map<String, dynamic> toJson() => {
        "batch_id": batchId,
        "actual_qty": actualQty,
    };
}
