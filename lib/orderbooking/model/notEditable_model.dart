// To parse this JSON data, do
//
//     final notEditable = notEditableFromJson(jsonString);

import 'dart:convert';

NotEditable notEditableFromJson(String str) => NotEditable.fromJson(json.decode(str));

String notEditableToJson(NotEditable data) => json.encode(data.toJson());

class NotEditable {
  NotEditable({
    this.docs,
    this.docinfo,
  });

  List<Doc>? docs;
  Docinfo? docinfo;

  factory NotEditable.fromJson(Map<String, dynamic> json) => NotEditable(
    docs: List<Doc>.from(json["docs"].map((x) => Doc.fromJson(x))),
    docinfo: Docinfo.fromJson(json["docinfo"]),
  );

  Map<String, dynamic> toJson() => {
    "docs": List<dynamic>.from(docs!.map((x) => x.toJson())),
    "docinfo": docinfo!.toJson(),
  };
}

class Docinfo {
  Docinfo({
    this.attachments,
    this.attachmentLogs,
    this.communications,
    this.automatedMessages,
    this.comments,
    this.totalComments,
    this.versions,
    this.assignments,
    this.assignmentLogs,
    this.permissions,
    this.shared,
    this.infoLogs,
    this.shareLogs,
    this.likeLogs,
    this.workflowLogs,
    this.views,
    this.energyPointLogs,
    this.additionalTimelineContent,
    this.milestones,
    this.isDocumentFollowed,
    this.tags,
    this.documentEmail,
  });

  List<dynamic>? attachments;
  List<dynamic>? attachmentLogs;
  List<dynamic>? communications;
  List<dynamic>? automatedMessages;
  List<dynamic>? comments;
  int? totalComments;
  List<dynamic>? versions;
  List<dynamic>? assignments;
  List<dynamic>? assignmentLogs;
  Permissions? permissions;
  List<dynamic>? shared;
  List<dynamic>? infoLogs;
  List<dynamic>? shareLogs;
  List<dynamic>? likeLogs;
  List<dynamic>? workflowLogs;
  List<dynamic>? views;
  List<dynamic>? energyPointLogs;
  List<dynamic>? additionalTimelineContent;
  List<dynamic>? milestones;
  dynamic isDocumentFollowed;
  String? tags;
  dynamic documentEmail;

  factory Docinfo.fromJson(Map<String, dynamic> json) => Docinfo(
    attachments: List<dynamic>.from(json["attachments"].map((x) => x)),
    attachmentLogs: List<dynamic>.from(json["attachment_logs"].map((x) => x)),
    communications: List<dynamic>.from(json["communications"].map((x) => x)),
    automatedMessages: List<dynamic>.from(json["automated_messages"].map((x) => x)),
    comments: List<dynamic>.from(json["comments"].map((x) => x)),
    totalComments: json["total_comments"],
    versions: List<dynamic>.from(json["versions"].map((x) => x)),
    assignments: List<dynamic>.from(json["assignments"].map((x) => x)),
    assignmentLogs: List<dynamic>.from(json["assignment_logs"].map((x) => x)),
    permissions: Permissions.fromJson(json["permissions"]),
    shared: List<dynamic>.from(json["shared"].map((x) => x)),
    infoLogs: List<dynamic>.from(json["info_logs"].map((x) => x)),
    shareLogs: List<dynamic>.from(json["share_logs"].map((x) => x)),
    likeLogs: List<dynamic>.from(json["like_logs"].map((x) => x)),
    workflowLogs: List<dynamic>.from(json["workflow_logs"].map((x) => x)),
    views: List<dynamic>.from(json["views"].map((x) => x)),
    energyPointLogs: List<dynamic>.from(json["energy_point_logs"].map((x) => x)),
    additionalTimelineContent: List<dynamic>.from(json["additional_timeline_content"].map((x) => x)),
    milestones: List<dynamic>.from(json["milestones"].map((x) => x)),
    isDocumentFollowed: json["is_document_followed"],
    tags: json["tags"],
    documentEmail: json["document_email"],
  );

  Map<String, dynamic> toJson() => {
    "attachments": List<dynamic>.from(attachments!.map((x) => x)),
    "attachment_logs": List<dynamic>.from(attachmentLogs!.map((x) => x)),
    "communications": List<dynamic>.from(communications!.map((x) => x)),
    "automated_messages": List<dynamic>.from(automatedMessages!.map((x) => x)),
    "comments": List<dynamic>.from(comments!.map((x) => x)),
    "total_comments": totalComments,
    "versions": List<dynamic>.from(versions!.map((x) => x)),
    "assignments": List<dynamic>.from(assignments!.map((x) => x)),
    "assignment_logs": List<dynamic>.from(assignmentLogs!.map((x) => x)),
    "permissions": permissions!.toJson(),
    "shared": List<dynamic>.from(shared!.map((x) => x)),
    "info_logs": List<dynamic>.from(infoLogs!.map((x) => x)),
    "share_logs": List<dynamic>.from(shareLogs!.map((x) => x)),
    "like_logs": List<dynamic>.from(likeLogs!.map((x) => x)),
    "workflow_logs": List<dynamic>.from(workflowLogs!.map((x) => x)),
    "views": List<dynamic>.from(views!.map((x) => x)),
    "energy_point_logs": List<dynamic>.from(energyPointLogs!.map((x) => x)),
    "additional_timeline_content": List<dynamic>.from(additionalTimelineContent!.map((x) => x)),
    "milestones": List<dynamic>.from(milestones!.map((x) => x)),
    "is_document_followed": isDocumentFollowed,
    "tags": tags,
    "document_email": documentEmail,
  };
}

class Permissions {
  Permissions({
    this.ifOwner,
    this.hasIfOwnerEnabled,
    this.select,
    this.read,
    this.write,
    this.create,
    this.delete,
    this.submit,
    this.cancel,
    this.amend,
    this.print,
    this.email,
    this.report,
    this.permissionsImport,
    this.permissionsExport,
    this.setUserPermissions,
    this.share,
  });

  IfOwner? ifOwner;
  bool? hasIfOwnerEnabled;
  int? select;
  int? read;
  int? write;
  int? create;
  int? delete;
  int? submit;
  int? cancel;
  int? amend;
  int? print;
  int? email;
  int? report;
  int? permissionsImport;
  int? permissionsExport;
  int? setUserPermissions;
  int? share;

  factory Permissions.fromJson(Map<String, dynamic> json) => Permissions(
    ifOwner: IfOwner.fromJson(json["if_owner"]),
    hasIfOwnerEnabled: json["has_if_owner_enabled"],
    select: json["select"],
    read: json["read"],
    write: json["write"],
    create: json["create"],
    delete: json["delete"],
    submit: json["submit"],
    cancel: json["cancel"],
    amend: json["amend"],
    print: json["print"],
    email: json["email"],
    report: json["report"],
    permissionsImport: json["import"],
    permissionsExport: json["export"],
    setUserPermissions: json["set_user_permissions"],
    share: json["share"],
  );

  Map<String, dynamic> toJson() => {
    "if_owner": ifOwner!.toJson(),
    "has_if_owner_enabled": hasIfOwnerEnabled,
    "select": select,
    "read": read,
    "write": write,
    "create": create,
    "delete": delete,
    "submit": submit,
    "cancel": cancel,
    "amend": amend,
    "print": print,
    "email": email,
    "report": report,
    "import": permissionsImport,
    "export": permissionsExport,
    "set_user_permissions": setUserPermissions,
    "share": share,
  };
}

class IfOwner {
  IfOwner();

  factory IfOwner.fromJson(Map<String, dynamic> json) => IfOwner(
  );

  Map<String, dynamic> toJson() => {
  };
}

class Doc {
  Doc({
    this.name,
    this.owner,
    this.creation,
    this.modified,
    this.modifiedBy,
    this.idx,
    this.docstatus,
    this.company,
    this.customer,
    this.customerType,
    this.customerName,
    this.orderBookingSo,
    this.huntingQuotation,
    this.doctype,
    this.orderBookingItemsV2,
    this.salesOrderPreview,
    this.promos,
    this.promosDiscount,
  });

  String? name;
  String? owner;
  String? creation;
  String? modified;
  String? modifiedBy;
  int? idx;
  int? docstatus;
  String? company;
  String? customer;
  String? customerType;
  String? customerName;
  String? orderBookingSo;
  String? huntingQuotation;
  String? doctype;
  List<OrderBookingItemsV2>? orderBookingItemsV2;
  List<SalesOrderPreview>? salesOrderPreview;
  List<Promo>? promos;
  List<dynamic>? promosDiscount;

  factory Doc.fromJson(Map<String, dynamic> json) => Doc(
    name: json["name"],
    owner: json["owner"],
    creation: json["creation"],
    modified: json["modified"],
    modifiedBy: json["modified_by"],
    idx: json["idx"],
    docstatus: json["docstatus"],
    company: json["company"],
    customer: json["customer"],
    customerType: json["customer_type"],
    customerName: json["customer_name"],
    orderBookingSo: json["order_booking_so"],
    huntingQuotation: json["hunting_quotation"],
    doctype: json["doctype"],
    orderBookingItemsV2: List<OrderBookingItemsV2>.from(json["order_booking_items_v2"].map((x) => OrderBookingItemsV2.fromJson(x))),
    salesOrderPreview: List<SalesOrderPreview>.from(json["sales_order_preview"].map((x) => SalesOrderPreview.fromJson(x))),
    promos: List<Promo>.from(json["promos"].map((x) => Promo.fromJson(x))),
    promosDiscount: List<dynamic>.from(json["promos_discount"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "owner": owner,
    "creation": creation,
    "modified": modified,
    "modified_by": modifiedBy,
    "idx": idx,
    "docstatus": docstatus,
    "company": company,
    "customer": customer,
    "customer_type": customerType,
    "customer_name": customerName,
    "order_booking_so": orderBookingSo,
    "hunting_quotation": huntingQuotation,
    "doctype": doctype,
    "order_booking_items_v2": List<dynamic>.from(orderBookingItemsV2!.map((x) => x.toJson())),
    "sales_order_preview": List<dynamic>.from(salesOrderPreview!.map((x) => x.toJson())),
    "promos": List<dynamic>.from(promos!.map((x) => x.toJson())),
    "promos_discount": List<dynamic>.from(promosDiscount!.map((x) => x)),
  };
}

class OrderBookingItemsV2 {
  OrderBookingItemsV2({
    this.name,
    this.owner,
    this.creation,
    this.modified,
    this.modifiedBy,
    this.parent,
    this.parentfield,
    this.parenttype,
    this.idx,
    this.docstatus,
    this.itemCode,
    this.freeItems,
    this.stockUom,
    this.quantityAvailable,
    this.quantityBooked,
    this.averagePrice,
    this.amount,
    this.gstRate,
    this.amountAfterGst,
    this.rateContract,
    this.rateContractCheck,
    this.brandName,
    this.doctype,
  });

  String? name;
  String? owner;
  String? creation;
  String? modified;
  String? modifiedBy;
  String? parent;
  String? parentfield;
  String? parenttype;
  int? idx;
  int? docstatus;
  String? itemCode;
  int? freeItems;
  String? stockUom;
  int? quantityAvailable;
  int? quantityBooked;
  double? averagePrice;
  double? amount;
  double? gstRate;
  double? amountAfterGst;
  String? rateContract;
  int? rateContractCheck;
  String? brandName;
  String? doctype;

  factory OrderBookingItemsV2.fromJson(Map<String, dynamic> json) => OrderBookingItemsV2(
    name: json["name"],
    owner: json["owner"],
    creation: json["creation"],
    modified: json["modified"],
    modifiedBy: json["modified_by"],
    parent: json["parent"],
    parentfield: json["parentfield"],
    parenttype: json["parenttype"],
    idx: json["idx"],
    docstatus: json["docstatus"],
    itemCode: json["item_code"],
    freeItems: json["free_items"],
    stockUom: json["stock_uom"],
    quantityAvailable: json["quantity_available"],
    quantityBooked: json["quantity_booked"],
    averagePrice: json["average_price"],
    amount: json["amount"],
    gstRate: json["gst_rate"],
    amountAfterGst: json["amount_after_gst"],
    rateContract: json["rate_contract"],
    rateContractCheck: json["rate_contract_check"],
    brandName: json["brand_name"],
    doctype: json["doctype"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "owner": owner,
    "creation": creation,
    "modified": modified,
    "modified_by": modifiedBy,
    "parent": parent,
    "parentfield": parentfield,
    "parenttype": parenttype,
    "idx": idx,
    "docstatus": docstatus,
    "item_code": itemCode,
    "free_items": freeItems,
    "stock_uom": stockUom,
    "quantity_available": quantityAvailable,
    "quantity_booked": quantityBooked,
    "average_price": averagePrice,
    "amount": amount,
    "gst_rate": gstRate,
    "amount_after_gst": amountAfterGst,
    "rate_contract": rateContract,
    "rate_contract_check": rateContractCheck,
    "brand_name": brandName,
    "doctype": doctype,
  };
}

class Promo {
  Promo({
    this.name,
    this.owner,
    this.creation,
    this.modified,
    this.modifiedBy,
    this.parent,
    this.parentfield,
    this.parenttype,
    this.idx,
    this.docstatus,
    this.boughtItem,
    this.freeItems,
    this.quantity,
    this.price,
    this.warehouseQuantity,
    this.promoType,
    this.doctype,
  });

  String? name;
  String? owner;
  String? creation;
  String? modified;
  String? modifiedBy;
  String? parent;
  String? parentfield;
  String? parenttype;
  int? idx;
  int? docstatus;
  String? boughtItem;
  String? freeItems;
  String? quantity;
  double? price;
  String? warehouseQuantity;
  String? promoType;
  String? doctype;

  factory Promo.fromJson(Map<String, dynamic> json) => Promo(
    name: json["name"],
    owner: json["owner"],
    creation: json["creation"],
    modified: json["modified"],
    modifiedBy: json["modified_by"],
    parent: json["parent"],
    parentfield: json["parentfield"],
    parenttype: json["parenttype"],
    idx: json["idx"],
    docstatus: json["docstatus"],
    boughtItem: json["bought_item"],
    freeItems: json["free_items"],
    quantity: json["quantity"],
    price: json["price"],
    warehouseQuantity: json["warehouse_quantity"],
    promoType: json["promo_type"],
    doctype: json["doctype"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "owner": owner,
    "creation": creation,
    "modified": modified,
    "modified_by": modifiedBy,
    "parent": parent,
    "parentfield": parentfield,
    "parenttype": parenttype,
    "idx": idx,
    "docstatus": docstatus,
    "bought_item": boughtItem,
    "free_items": freeItems,
    "quantity": quantity,
    "price": price,
    "warehouse_quantity": warehouseQuantity,
    "promo_type": promoType,
    "doctype": doctype,
  };
}

class SalesOrderPreview {
  SalesOrderPreview({
    this.name,
    this.owner,
    this.creation,
    this.modified,
    this.modifiedBy,
    this.parent,
    this.parentfield,
    this.parenttype,
    this.idx,
    this.docstatus,
    this.itemCode,
    this.quantityAvailable,
    this.quantity,
    this.average,
    this.warehouse,
    this.promoType,
    this.doctype,
  });

  String? name;
  String? owner;
  String? creation;
  String? modified;
  String? modifiedBy;
  String? parent;
  String? parentfield;
  String? parenttype;
  int? idx;
  int? docstatus;
  String? itemCode;
  String? quantityAvailable;
  String? quantity;
  double? average;
  String? warehouse;
  String? promoType;
  String? doctype;

  factory SalesOrderPreview.fromJson(Map<String, dynamic> json) => SalesOrderPreview(
    name: json["name"],
    owner: json["owner"],
    creation: json["creation"],
    modified: json["modified"],
    modifiedBy: json["modified_by"],
    parent: json["parent"],
    parentfield: json["parentfield"],
    parenttype: json["parenttype"],
    idx: json["idx"],
    docstatus: json["docstatus"],
    itemCode: json["item_code"],
    quantityAvailable: json["quantity_available"],
    quantity: json["quantity"],
    average: json["average"],
    warehouse: json["warehouse"],
    promoType: json["promo_type"],
    doctype: json["doctype"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "owner": owner,
    "creation": creation,
    "modified": modified,
    "modified_by": modifiedBy,
    "parent": parent,
    "parentfield": parentfield,
    "parenttype": parenttype,
    "idx": idx,
    "docstatus": docstatus,
    "item_code": itemCode,
    "quantity_available": quantityAvailable,
    "quantity": quantity,
    "average": average,
    "warehouse": warehouse,
    "promo_type": promoType,
    "doctype": doctype,
  };
}
