// To parse this JSON data, do
//
//     final offerModel = offerModelFromJson(jsonString);

import 'dart:convert';

OfferModel offerModelFromJson(String str) => OfferModel.fromJson(json.decode(str));

String offerModelToJson(OfferModel data) => json.encode(data.toJson());

class OfferModel {
  OfferModel({
    this.docs,
    this.docinfo,
  });

  List<Doc>? docs;
  Docinfo? docinfo;

  factory OfferModel.fromJson(Map<String, dynamic> json) => OfferModel(
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
    this.salesPromo,
    this.startDate,
    this.endDate,
    this.promoType,
    this.doctype,
    this.promoTableForQuantityamountBasedDiscount,
    this.promosTableOfSameItem,
    this.promosTableOfDifferentItems,
    this.freeItemForEligibleQuantity,
  });

  String? name;
  String? owner;
  DateTime? creation;
  DateTime? modified;
  String? modifiedBy;
  int? idx;
  int? docstatus;
  String? salesPromo;
  DateTime? startDate;
  DateTime? endDate;
  String? promoType;
  String? doctype;
  List<PromoTableForQuantityamountBasedDiscount>? promoTableForQuantityamountBasedDiscount;
  List<PromosTableOfSameItem>? promosTableOfSameItem;
  List<PromosTableOfDifferentItems>? promosTableOfDifferentItems;
  List<FreeItemForEligibleQuantity>? freeItemForEligibleQuantity;

  factory Doc.fromJson(Map<String, dynamic> json) => Doc(
    name: json["name"],
    owner: json["owner"],
    creation: DateTime.parse(json["creation"]),
    modified: DateTime.parse(json["modified"]),
    modifiedBy: json["modified_by"],
    idx: json["idx"],
    docstatus: json["docstatus"],
    salesPromo: json["sales_promo"],
    startDate: DateTime.parse(json["start_date"]),
    endDate: DateTime.parse(json["end_date"]),
    promoType: json["promo_type"],
    doctype: json["doctype"],
    promoTableForQuantityamountBasedDiscount: List<PromoTableForQuantityamountBasedDiscount>.from(json["promo_table_for_quantityamount_based_discount"].map((x) => PromoTableForQuantityamountBasedDiscount.fromJson(x))),
    promosTableOfSameItem: List<PromosTableOfSameItem>.from(json["promos_table_of_same_item"].map((x) => PromosTableOfSameItem.fromJson(x))),
    promosTableOfDifferentItems: List<PromosTableOfDifferentItems>.from(json["promos_table_of_different_items"].map((x) => PromosTableOfDifferentItems.fromJson(x))),
    freeItemForEligibleQuantity: List<FreeItemForEligibleQuantity>.from(json["free_item_for_eligible_quantity"].map((x) => FreeItemForEligibleQuantity.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "owner": owner,
    "creation": creation!.toIso8601String(),
    "modified": modified!.toIso8601String(),
    "modified_by": modifiedBy,
    "idx": idx,
    "docstatus": docstatus,
    "sales_promo": salesPromo,
    "start_date": "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
    "end_date": "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
    "promo_type": promoType,
    "doctype": doctype,
    "promo_table_for_quantityamount_based_discount": List<dynamic>.from(promoTableForQuantityamountBasedDiscount!.map((x) => x)),
    "promos_table_of_same_item": List<dynamic>.from(promosTableOfSameItem!.map((x) => x)),
    "promos_table_of_different_items": List<dynamic>.from(promosTableOfDifferentItems!.map((x) => x)),
    "free_item_for_eligible_quantity": List<dynamic>.from(freeItemForEligibleQuantity!.map((x) => x.toJson())),
  };
}

class FreeItemForEligibleQuantity {
  FreeItemForEligibleQuantity({
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
    this.promoBasedOn,
    this.boughtItem,
    this.forEveryQuantityThatIsBought,
    this.quantityOfFreeItemsThatsGiven,
    this.discount,
    this.type,
    this.quantity,
    this.doctype,
  });

  String? name;
  String? owner;
  DateTime? creation;
  DateTime? modified;
  String? modifiedBy;
  String? parent;
  String? parentfield;
  String? parenttype;
  int? idx;
  int? docstatus;
  String? promoBasedOn;
  String? boughtItem;
  int? forEveryQuantityThatIsBought;
  int? quantityOfFreeItemsThatsGiven;
  dynamic discount;
  String? type;
  int? quantity;
  String? doctype;

  factory FreeItemForEligibleQuantity.fromJson(Map<String, dynamic> json) => FreeItemForEligibleQuantity(
    name: json["name"],
    owner: json["owner"],
    creation: DateTime.parse(json["creation"]),
    modified: DateTime.parse(json["modified"]),
    modifiedBy: json["modified_by"],
    parent: json["parent"],
    parentfield: json["parentfield"],
    parenttype: json["parenttype"],
    idx: json["idx"],
    docstatus: json["docstatus"],
    promoBasedOn: json["promo_based_on"],
    boughtItem: json["bought_item"],
    forEveryQuantityThatIsBought: json["for_every_quantity_that_is_bought"],
    quantityOfFreeItemsThatsGiven: json["quantity_of_free_items_thats_given"],
    discount: json["discount"],
    type: json["type"],
    quantity: json["quantity"],
    doctype: json["doctype"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "owner": owner,
    "creation": creation!.toIso8601String(),
    "modified": modified!.toIso8601String(),
    "modified_by": modifiedBy,
    "parent": parent,
    "parentfield": parentfield,
    "parenttype": parenttype,
    "idx": idx,
    "docstatus": docstatus,
    "promo_based_on": promoBasedOn,
    "bought_item": boughtItem,
    "for_every_quantity_that_is_bought": forEveryQuantityThatIsBought,
    "quantity_of_free_items_thats_given": quantityOfFreeItemsThatsGiven,
    "discount": discount,
    "type": type,
    "quantity": quantity,
    "doctype": doctype,
  };
}

class PromosTableOfDifferentItems{
  PromosTableOfDifferentItems({
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
    this.promoBasedOn,
    this.boughtItem,
    this.forEveryQuantityThatIsBought,
    this.quantityOfFreeItemsThatsGiven,
    this.discount,
    this.type,
    this.quantity,
    this.doctype,
  });

  String? name;
  String? owner;
  DateTime? creation;
  DateTime? modified;
  String? modifiedBy;
  String? parent;
  String? parentfield;
  String? parenttype;
  int? idx;
  int? docstatus;
  String? promoBasedOn;
  String? boughtItem;
  int? forEveryQuantityThatIsBought;
  int? quantityOfFreeItemsThatsGiven;
  dynamic discount;
  String? type;
  int? quantity;
  String? doctype;

  factory PromosTableOfDifferentItems.fromJson(Map<String, dynamic> json) => PromosTableOfDifferentItems(
    name: json["name"],
    owner: json["owner"],
    creation: DateTime.parse(json["creation"]),
    modified: DateTime.parse(json["modified"]),
    modifiedBy: json["modified_by"],
    parent: json["parent"],
    parentfield: json["parentfield"],
    parenttype: json["parenttype"],
    idx: json["idx"],
    docstatus: json["docstatus"],
    promoBasedOn: json["promo_based_on"],
    boughtItem: json["bought_item"],
    forEveryQuantityThatIsBought: json["for_every_quantity_that_is_bought"],
    quantityOfFreeItemsThatsGiven: json["quantity_of_free_items_thats_given"],
    discount: json["discount"],
    type: json["type"],
    quantity: json["quantity"],
    doctype: json["doctype"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "owner": owner,
    "creation": creation!.toIso8601String(),
    "modified": modified!.toIso8601String(),
    "modified_by": modifiedBy,
    "parent": parent,
    "parentfield": parentfield,
    "parenttype": parenttype,
    "idx": idx,
    "docstatus": docstatus,
    "promo_based_on": promoBasedOn,
    "bought_item": boughtItem,
    "for_every_quantity_that_is_bought": forEveryQuantityThatIsBought,
    "quantity_of_free_items_thats_given": quantityOfFreeItemsThatsGiven,
    "discount": discount,
    "type": type,
    "quantity": quantity,
    "doctype": doctype,
  };
}

class PromosTableOfSameItem{
  PromosTableOfSameItem({
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
    this.promoBasedOn,
    this.boughtItem,
    this.forEveryQuantityThatIsBought,
    this.quantityOfFreeItemsThatsGiven,
    this.discount,
    this.type,
    this.quantity,
    this.doctype,
  });

  String? name;
  String? owner;
  DateTime? creation;
  DateTime? modified;
  String? modifiedBy;
  String? parent;
  String? parentfield;
  String? parenttype;
  int? idx;
  int? docstatus;
  String? promoBasedOn;
  String? boughtItem;
  int? forEveryQuantityThatIsBought;
  int? quantityOfFreeItemsThatsGiven;
  dynamic discount;
  String? type;
  int? quantity;
  String? doctype;

  factory PromosTableOfSameItem.fromJson(Map<String, dynamic> json) => PromosTableOfSameItem(
    name: json["name"],
    owner: json["owner"],
    creation: DateTime.parse(json["creation"]),
    modified: DateTime.parse(json["modified"]),
    modifiedBy: json["modified_by"],
    parent: json["parent"],
    parentfield: json["parentfield"],
    parenttype: json["parenttype"],
    idx: json["idx"],
    docstatus: json["docstatus"],
    promoBasedOn: json["promo_based_on"],
    boughtItem: json["bought_item"],
    forEveryQuantityThatIsBought: json["for_every_quantity_that_is_bought"],
    quantityOfFreeItemsThatsGiven: json["quantity_of_free_items_thats_given"],
    discount: json["discount"],
    type: json["type"],
    quantity: json["quantity"],
    doctype: json["doctype"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "owner": owner,
    "creation": creation!.toIso8601String(),
    "modified": modified!.toIso8601String(),
    "modified_by": modifiedBy,
    "parent": parent,
    "parentfield": parentfield,
    "parenttype": parenttype,
    "idx": idx,
    "docstatus": docstatus,
    "promo_based_on": promoBasedOn,
    "bought_item": boughtItem,
    "for_every_quantity_that_is_bought": forEveryQuantityThatIsBought,
    "quantity_of_free_items_thats_given": quantityOfFreeItemsThatsGiven,
    "discount": discount,
    "type": type,
    "quantity": quantity,
    "doctype": doctype,
  };
}

class PromoTableForQuantityamountBasedDiscount{
  PromoTableForQuantityamountBasedDiscount({
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
    this.promoBasedOn,
    this.boughtItem,
    this.forEveryQuantityThatIsBought,
    this.quantityOfFreeItemsThatsGiven,
    this.discount,
    this.type,
    this.quantity,
    this.doctype,
  });

  String? name;
  String? owner;
  DateTime? creation;
  DateTime? modified;
  String? modifiedBy;
  String? parent;
  String? parentfield;
  String? parenttype;
  int? idx;
  int? docstatus;
  String? promoBasedOn;
  String? boughtItem;
  int? forEveryQuantityThatIsBought;
  int? quantityOfFreeItemsThatsGiven;
  dynamic discount;
  String? type;
  int? quantity;
  String? doctype;

  factory PromoTableForQuantityamountBasedDiscount.fromJson(Map<String, dynamic> json) => PromoTableForQuantityamountBasedDiscount(
    name: json["name"],
    owner: json["owner"],
    creation: DateTime.parse(json["creation"]),
    modified: DateTime.parse(json["modified"]),
    modifiedBy: json["modified_by"],
    parent: json["parent"],
    parentfield: json["parentfield"],
    parenttype: json["parenttype"],
    idx: json["idx"],
    docstatus: json["docstatus"],
    promoBasedOn: json["promo_based_on"],
    boughtItem: json["bought_item"],
    forEveryQuantityThatIsBought: json["for_every_quantity_that_is_bought"],
    quantityOfFreeItemsThatsGiven: json["quantity_of_free_items_thats_given"],
    discount: json["discount"],
    type: json["type"],
    quantity: json["quantity"],
    doctype: json["doctype"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "owner": owner,
    "creation": creation!.toIso8601String(),
    "modified": modified!.toIso8601String(),
    "modified_by": modifiedBy,
    "parent": parent,
    "parentfield": parentfield,
    "parenttype": parenttype,
    "idx": idx,
    "docstatus": docstatus,
    "promo_based_on": promoBasedOn,
    "bought_item": boughtItem,
    "for_every_quantity_that_is_bought": forEveryQuantityThatIsBought,
    "quantity_of_free_items_thats_given": quantityOfFreeItemsThatsGiven,
    "discount": discount,
    "type": type,
    "quantity": quantity,
    "doctype": doctype,
  };
}


