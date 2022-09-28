// To parse this JSON data, do
//
//     final collectionListWiseModel = collectionListWiseModelFromJson(jsonString);

import 'dart:convert';

CollectionListWiseModel collectionListWiseModelFromJson(String str) => CollectionListWiseModel.fromJson(json.decode(str));

String collectionListWiseModelToJson(CollectionListWiseModel data) => json.encode(data.toJson());

class CollectionListWiseModel {
  CollectionListWiseModel({
    this.docs,
    this.docinfo,
  });

  List<Doc>? docs;
  Docinfo? docinfo;

  factory CollectionListWiseModel.fromJson(Map<String, dynamic> json) => CollectionListWiseModel(
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
    this.deliveryTripNo,
    this.collectionPerson,
    this.doctype,
    this.details,
    this.paymentEntry,
  });

  String? name;
  String? owner;
  String? creation;
  String? modified;
  String? modifiedBy;
  int? idx;
  int? docstatus;
  String? deliveryTripNo;
  String? collectionPerson;
  String? doctype;
  List<Detail>? details;
  List<PaymentEntry>? paymentEntry;

  factory Doc.fromJson(Map<String, dynamic> json) => Doc(
    name: json["name"],
    owner: json["owner"],
    creation: json["creation"],
    modified: json["modified"],
    modifiedBy: json["modified_by"],
    idx: json["idx"],
    docstatus: json["docstatus"],
    deliveryTripNo: json["delivery_trip_no"],
    collectionPerson: json["collection_person"],
    doctype: json["doctype"],
    details: List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))),
    paymentEntry: List<PaymentEntry>.from(json["payment_entry"].map((x) => PaymentEntry.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "owner": owner,
    "creation": creation,
    "modified": modified,
    "modified_by": modifiedBy,
    "idx": idx,
    "docstatus": docstatus,
    "delivery_trip_no": deliveryTripNo,
    "collection_person": collectionPerson,
    "doctype": doctype,
    "details": List<dynamic>.from(details!.map((x) => x.toJson())),
    "payment_entry": List<dynamic>.from(paymentEntry!.map((x) => x.toJson())),
  };
}

class Detail {
  Detail({
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
    this.invoiceNo,
    this.customer,
    this.customerName,
    this.pendingAmount,
    this.cashAmount,
    this.chequeAmount,
    this.wireAmount,
    this.totalAmount,
    this.chequeReference,
    this.chequeDate,
    this.wireReference,
    this.wireDate,
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
  dynamic idx;
  dynamic docstatus;
  String? invoiceNo;
  String? customer;
  String? customerName;
  dynamic pendingAmount;
  dynamic cashAmount;
  dynamic chequeAmount;
  dynamic wireAmount;
  dynamic totalAmount;
  String? chequeReference;
  String? chequeDate;
  String? wireReference;
  String? wireDate;
  String? doctype;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
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
    invoiceNo: json["invoice_no"],
    customer: json["customer"],
    customerName: json["customer_name"],
    pendingAmount: json["pending_amount"],
    cashAmount: json["cash_amount"],
    chequeAmount: json["cheque_amount"],
    wireAmount: json["wire_amount"],
    totalAmount: json["total_amount"],
    chequeReference: json["cheque_reference"] == null ? null : json["cheque_reference"],
    chequeDate: json["cheque_date"] == null ? null : json["cheque_date"],
    wireReference: json["wire_reference"] == null ? null : json["wire_reference"],
    wireDate: json["wire_date"] == null ? null : json["wire_date"],
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
    "invoice_no": invoiceNo,
    "customer": customer,
    "customer_name": customerName,
    "pending_amount": pendingAmount,
    "cash_amount": cashAmount,
    "cheque_amount": chequeAmount,
    "wire_amount": wireAmount,
    "total_amount": totalAmount,
    "cheque_reference": chequeReference == null ? null : chequeReference,
    "cheque_date": chequeDate == null ? null : chequeDate,
    "wire_reference": wireReference == null ? null : wireReference,
    "wire_date": wireDate == null ? null : wireDate,
    "doctype": doctype,
  };
}

class PaymentEntry {
  PaymentEntry({
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
    this.paymentEntry,
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
  String? paymentEntry;
  String? doctype;

  factory PaymentEntry.fromJson(Map<String, dynamic> json) => PaymentEntry(
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
    paymentEntry: json["payment_entry"],
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
    "payment_entry": paymentEntry,
    "doctype": doctype,
  };
}
