// To parse this JSON data, do
//
//     final transactionDetailModel = transactionDetailModelFromJson(jsonString);

import 'dart:convert';

TransactionDetailModel transactionDetailModelFromJson(String str) => TransactionDetailModel.fromJson(json.decode(str));

String transactionDetailModelToJson(TransactionDetailModel data) => json.encode(data.toJson());

class TransactionDetailModel {
  TransactionDetailModel({
    this.docs,
    this.docinfo,
  });

  List<Doc>? docs;
  Docinfo? docinfo;

  factory TransactionDetailModel.fromJson(Map<String, dynamic> json) => TransactionDetailModel(
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
    this.title,
    this.namingSeries,
    this.customer,
    this.irnCancelled,
    this.ewayBillCancelled,
    this.customerName,
    this.isPos,
    this.isConsolidated,
    this.isReturn,
    this.isDebitNote,
    this.updateBilledAmountInSalesOrder,
    this.company,
    this.companyTaxId,
    this.postingDate,
    this.postingTime,
    this.setPostingTime,
    this.dueDate,
    this.poNo,
    this.customerAddress,
    this.billingAddressGstin,
    this.addressDisplay,
    this.contactPerson,
    this.contactDisplay,
    this.contactMobile,
    this.contactEmail,
    this.territory,
    this.shippingAddressName,
    this.placeOfSupply,
    this.companyAddress,
    this.companyGstin,
    this.companyAddressDisplay,
    this.currency,
    this.conversionRate,
    this.sellingPriceList,
    this.priceListCurrency,
    this.plcConversionRate,
    this.ignorePricingRule,
    this.updateStock,
    this.totalBillingAmount,
    this.totalBillingHours,
    this.totalQty,
    this.baseTotal,
    this.baseNetTotal,
    this.totalNetWeight,
    this.total,
    this.netTotal,
    this.taxesAndCharges,
    this.taxCategory,
    this.otherChargesCalculation,
    this.baseTotalTaxesAndCharges,
    this.totalTaxesAndCharges,
    this.loyaltyPoints,
    this.loyaltyAmount,
    this.redeemLoyaltyPoints,
    this.applyDiscountOn,
    this.baseDiscountAmount,
    this.additionalDiscountPercentage,
    this.discountAmount,
    this.baseGrandTotal,
    this.baseRoundingAdjustment,
    this.baseRoundedTotal,
    this.baseInWords,
    this.grandTotal,
    this.roundingAdjustment,
    this.roundedTotal,
    this.inWords,
    this.totalAdvance,
    this.outstandingAmount,
    this.disableRoundedTotal,
    this.writeOffAmount,
    this.baseWriteOffAmount,
    this.writeOffOutstandingAmountAutomatically,
    this.allocateAdvancesAutomatically,
    this.ignoreDefaultPaymentTermsTemplate,
    this.paymentTermsTemplate,
    this.basePaidAmount,
    this.paidAmount,
    this.baseChangeAmount,
    this.changeAmount,
    this.letterHead,
    this.groupSameItems,
    this.language,
    this.gstCategory,
    this.status,
    this.customerGroup,
    this.isInternalCustomer,
    this.isDiscounted,
    this.debitTo,
    this.partyAccountCurrency,
    this.isOpening,
    this.cFormApplicable,
    this.remarks,
    this.amountEligibleForCommission,
    this.commissionRate,
    this.totalCommission,
    this.againstIncomeAccount,
    this.distance,
    this.einvoiceStatus,
    this.exportType,
    this.gstVehicleType,
    this.invoiceCopy,
    this.lrDate,
    this.modeOfTransport,
    this.reasonForIssuingDocument,
    this.reverseCharge,
    this.doctype,
    this.items,
    this.pricingRules,
    this.packedItems,
    this.timesheets,
    this.taxes,
    this.advances,
    this.paymentSchedule,
    this.payments,
    this.salesTeam,
    this.onload,
  });

  String? name;
  String? owner;
  String? creation;
  String? modified;
  String? modifiedBy;
  int? idx;
  int? docstatus;
  String? title;
  String? namingSeries;
  String? customer;
  int? irnCancelled;
  int? ewayBillCancelled;
  String? customerName;
  int? isPos;
  int? isConsolidated;
  int? isReturn;
  int? isDebitNote;
  int? updateBilledAmountInSalesOrder;
  String? company;
  String? companyTaxId;
  DateTime? postingDate;
  String? postingTime;
  int? setPostingTime;
  String? dueDate;
  String? poNo;
  String? customerAddress;
  String? billingAddressGstin;
  String? addressDisplay;
  String? contactPerson;
  String? contactDisplay;
  String? contactMobile;
  String? contactEmail;
  String? territory;
  String? shippingAddressName;
  String? placeOfSupply;
  String? companyAddress;
  String? companyGstin;
  String? companyAddressDisplay;
  String? currency;
  dynamic conversionRate;
  String? sellingPriceList;
  String? priceListCurrency;
  dynamic plcConversionRate;
  int? ignorePricingRule;
  int? updateStock;
  dynamic totalBillingAmount;
  dynamic totalBillingHours;
  dynamic totalQty;
  dynamic baseTotal;
  dynamic baseNetTotal;
  dynamic totalNetWeight;
  dynamic total;
  dynamic netTotal;
  String? taxesAndCharges;
  String? taxCategory;
  String? otherChargesCalculation;
  dynamic baseTotalTaxesAndCharges;
  dynamic totalTaxesAndCharges;
  int? loyaltyPoints;
  dynamic loyaltyAmount;
  int? redeemLoyaltyPoints;
  String? applyDiscountOn;
  dynamic baseDiscountAmount;
  dynamic additionalDiscountPercentage;
  dynamic discountAmount;
  dynamic baseGrandTotal;
  dynamic baseRoundingAdjustment;
  dynamic baseRoundedTotal;
  String? baseInWords;
  dynamic grandTotal;
  dynamic roundingAdjustment;
  dynamic roundedTotal;
  String? inWords;
  dynamic totalAdvance;
  dynamic outstandingAmount;
  dynamic disableRoundedTotal;
  dynamic writeOffAmount;
  dynamic baseWriteOffAmount;
  int? writeOffOutstandingAmountAutomatically;
  int? allocateAdvancesAutomatically;
  int? ignoreDefaultPaymentTermsTemplate;
  String? paymentTermsTemplate;
  dynamic basePaidAmount;
  dynamic paidAmount;
  dynamic baseChangeAmount;
  dynamic changeAmount;
  String? letterHead;
  int? groupSameItems;
  String? language;
  String? gstCategory;
  String? status;
  String? customerGroup;
  int? isInternalCustomer;
  int? isDiscounted;
  String? debitTo;
  String? partyAccountCurrency;
  String? isOpening;
  String? cFormApplicable;
  String? remarks;
  dynamic amountEligibleForCommission;
  dynamic commissionRate;
  dynamic totalCommission;
  String? againstIncomeAccount;
  dynamic distance;
  String? einvoiceStatus;
  String? exportType;
  String? gstVehicleType;
  String? invoiceCopy;
  DateTime? lrDate;
  String? modeOfTransport;
  String? reasonForIssuingDocument;
  String? reverseCharge;
  String? doctype;
  List<Item>? items;
  List<dynamic>? pricingRules;
  List<dynamic>? packedItems;
  List<dynamic>? timesheets;
  List<Tax>? taxes;
  List<dynamic>? advances;
  List<PaymentSchedule>? paymentSchedule;
  List<dynamic>? payments;
  List<dynamic>? salesTeam;
  Onload? onload;

  factory Doc.fromJson(Map<String, dynamic> json) => Doc(
    name: json["name"],
    owner: json["owner"],
    creation: json["creation"],
    modified: json["modified"],
    modifiedBy: json["modified_by"],
    idx: json["idx"],
    docstatus: json["docstatus"],
    title: json["title"],
    namingSeries: json["naming_series"],
    customer: json["customer"],
    irnCancelled: json["irn_cancelled"],
    ewayBillCancelled: json["eway_bill_cancelled"],
    customerName: json["customer_name"],
    isPos: json["is_pos"],
    isConsolidated: json["is_consolidated"],
    isReturn: json["is_return"],
    isDebitNote: json["is_debit_note"],
    updateBilledAmountInSalesOrder: json["update_billed_amount_in_sales_order"],
    company: json["company"],
    companyTaxId: json["company_tax_id"],
    postingDate: DateTime.parse(json["posting_date"]),
    postingTime: json["posting_time"],
    setPostingTime: json["set_posting_time"],
    dueDate: json["due_date"],
    poNo: json["po_no"],
    customerAddress: json["customer_address"],
    billingAddressGstin: json["billing_address_gstin"],
    addressDisplay: json["address_display"],
    contactPerson: json["contact_person"],
    contactDisplay: json["contact_display"],
    contactMobile: json["contact_mobile"],
    contactEmail: json["contact_email"],
    territory: json["territory"],
    shippingAddressName: json["shipping_address_name"],
    placeOfSupply: json["place_of_supply"],
    companyAddress: json["company_address"],
    companyGstin: json["company_gstin"],
    companyAddressDisplay: json["company_address_display"],
    currency: json["currency"],
    conversionRate: json["conversion_rate"],
    sellingPriceList: json["selling_price_list"],
    priceListCurrency: json["price_list_currency"],
    plcConversionRate: json["plc_conversion_rate"],
    ignorePricingRule: json["ignore_pricing_rule"],
    updateStock: json["update_stock"],
    totalBillingAmount: json["total_billing_amount"],
    totalBillingHours: json["total_billing_hours"],
    totalQty: json["total_qty"],
    baseTotal: json["base_total"],
    baseNetTotal: json["base_net_total"],
    totalNetWeight: json["total_net_weight"],
    total: json["total"],
    netTotal: json["net_total"],
    taxesAndCharges: json["taxes_and_charges"],
    taxCategory: json["tax_category"],
    otherChargesCalculation: json["other_charges_calculation"],
    baseTotalTaxesAndCharges: json["base_total_taxes_and_charges"],
    totalTaxesAndCharges: json["total_taxes_and_charges"],
    loyaltyPoints: json["loyalty_points"],
    loyaltyAmount: json["loyalty_amount"],
    redeemLoyaltyPoints: json["redeem_loyalty_points"],
    applyDiscountOn: json["apply_discount_on"],
    baseDiscountAmount: json["base_discount_amount"],
    additionalDiscountPercentage: json["additional_discount_percentage"],
    discountAmount: json["discount_amount"],
    baseGrandTotal: json["base_grand_total"],
    baseRoundingAdjustment: json["base_rounding_adjustment"],
    baseRoundedTotal: json["base_rounded_total"],
    baseInWords: json["base_in_words"],
    grandTotal: json["grand_total"],
    roundingAdjustment: json["rounding_adjustment"],
    roundedTotal: json["rounded_total"],
    inWords: json["in_words"],
    totalAdvance: json["total_advance"],
    outstandingAmount: json["outstanding_amount"],
    disableRoundedTotal: json["disable_rounded_total"],
    writeOffAmount: json["write_off_amount"],
    baseWriteOffAmount: json["base_write_off_amount"],
    writeOffOutstandingAmountAutomatically: json["write_off_outstanding_amount_automatically"],
    allocateAdvancesAutomatically: json["allocate_advances_automatically"],
    ignoreDefaultPaymentTermsTemplate: json["ignore_default_payment_terms_template"],
    paymentTermsTemplate: json["payment_terms_template"],
    basePaidAmount: json["base_paid_amount"],
    paidAmount: json["paid_amount"],
    baseChangeAmount: json["base_change_amount"],
    changeAmount: json["change_amount"],
    letterHead: json["letter_head"],
    groupSameItems: json["group_same_items"],
    language: json["language"],
    gstCategory: json["gst_category"],
    status: json["status"],
    customerGroup: json["customer_group"],
    isInternalCustomer: json["is_internal_customer"],
    isDiscounted: json["is_discounted"],
    debitTo: json["debit_to"],
    partyAccountCurrency: json["party_account_currency"],
    isOpening: json["is_opening"],
    cFormApplicable: json["c_form_applicable"],
    remarks: json["remarks"],
    amountEligibleForCommission: json["amount_eligible_for_commission"],
    commissionRate: json["commission_rate"],
    totalCommission: json["total_commission"],
    againstIncomeAccount: json["against_income_account"],
    distance: json["distance"],
    einvoiceStatus: json["einvoice_status"],
    exportType: json["export_type"],
    gstVehicleType: json["gst_vehicle_type"],
    invoiceCopy: json["invoice_copy"],
    lrDate: DateTime.parse(json["lr_date"]),
    modeOfTransport: json["mode_of_transport"],
    reasonForIssuingDocument: json["reason_for_issuing_document"],
    reverseCharge: json["reverse_charge"],
    doctype: json["doctype"],
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    pricingRules: List<dynamic>.from(json["pricing_rules"].map((x) => x)),
    packedItems: List<dynamic>.from(json["packed_items"].map((x) => x)),
    timesheets: List<dynamic>.from(json["timesheets"].map((x) => x)),
    taxes: List<Tax>.from(json["taxes"].map((x) => Tax.fromJson(x))),
    advances: List<dynamic>.from(json["advances"].map((x) => x)),
    paymentSchedule: List<PaymentSchedule>.from(json["payment_schedule"].map((x) => PaymentSchedule.fromJson(x))),
    payments: List<dynamic>.from(json["payments"].map((x) => x)),
    salesTeam: List<dynamic>.from(json["sales_team"].map((x) => x)),
    onload: Onload.fromJson(json["__onload"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "owner": owner,
    "creation": creation,
    "modified": modified,
    "modified_by": modifiedBy,
    "idx": idx,
    "docstatus": docstatus,
    "title": title,
    "naming_series": namingSeries,
    "customer": customer,
    "irn_cancelled": irnCancelled,
    "eway_bill_cancelled": ewayBillCancelled,
    "customer_name": customerName,
    "is_pos": isPos,
    "is_consolidated": isConsolidated,
    "is_return": isReturn,
    "is_debit_note": isDebitNote,
    "update_billed_amount_in_sales_order": updateBilledAmountInSalesOrder,
    "company": company,
    "company_tax_id": companyTaxId,
    "posting_date": "${postingDate!.year.toString().padLeft(4, '0')}-${postingDate!.month.toString().padLeft(2, '0')}-${postingDate!.day.toString().padLeft(2, '0')}",
    "posting_time": postingTime,
    "set_posting_time": setPostingTime,
    "due_date": dueDate,
    "po_no": poNo,
    "customer_address": customerAddress,
    "billing_address_gstin": billingAddressGstin,
    "address_display": addressDisplay,
    "contact_person": contactPerson,
    "contact_display": contactDisplay,
    "contact_mobile": contactMobile,
    "contact_email": contactEmail,
    "territory": territory,
    "shipping_address_name": shippingAddressName,
    "place_of_supply": placeOfSupply,
    "company_address": companyAddress,
    "company_gstin": companyGstin,
    "company_address_display": companyAddressDisplay,
    "currency": currency,
    "conversion_rate": conversionRate,
    "selling_price_list": sellingPriceList,
    "price_list_currency": priceListCurrency,
    "plc_conversion_rate": plcConversionRate,
    "ignore_pricing_rule": ignorePricingRule,
    "update_stock": updateStock,
    "total_billing_amount": totalBillingAmount,
    "total_billing_hours": totalBillingHours,
    "total_qty": totalQty,
    "base_total": baseTotal,
    "base_net_total": baseNetTotal,
    "total_net_weight": totalNetWeight,
    "total": total,
    "net_total": netTotal,
    "taxes_and_charges": taxesAndCharges,
    "tax_category": taxCategory,
    "other_charges_calculation": otherChargesCalculation,
    "base_total_taxes_and_charges": baseTotalTaxesAndCharges,
    "total_taxes_and_charges": totalTaxesAndCharges,
    "loyalty_points": loyaltyPoints,
    "loyalty_amount": loyaltyAmount,
    "redeem_loyalty_points": redeemLoyaltyPoints,
    "apply_discount_on": applyDiscountOn,
    "base_discount_amount": baseDiscountAmount,
    "additional_discount_percentage": additionalDiscountPercentage,
    "discount_amount": discountAmount,
    "base_grand_total": baseGrandTotal,
    "base_rounding_adjustment": baseRoundingAdjustment,
    "base_rounded_total": baseRoundedTotal,
    "base_in_words": baseInWords,
    "grand_total": grandTotal,
    "rounding_adjustment": roundingAdjustment,
    "rounded_total": roundedTotal,
    "in_words": inWords,
    "total_advance": totalAdvance,
    "outstanding_amount": outstandingAmount,
    "disable_rounded_total": disableRoundedTotal,
    "write_off_amount": writeOffAmount,
    "base_write_off_amount": baseWriteOffAmount,
    "write_off_outstanding_amount_automatically": writeOffOutstandingAmountAutomatically,
    "allocate_advances_automatically": allocateAdvancesAutomatically,
    "ignore_default_payment_terms_template": ignoreDefaultPaymentTermsTemplate,
    "payment_terms_template": paymentTermsTemplate,
    "base_paid_amount": basePaidAmount,
    "paid_amount": paidAmount,
    "base_change_amount": baseChangeAmount,
    "change_amount": changeAmount,
    "letter_head": letterHead,
    "group_same_items": groupSameItems,
    "language": language,
    "gst_category": gstCategory,
    "status": status,
    "customer_group": customerGroup,
    "is_internal_customer": isInternalCustomer,
    "is_discounted": isDiscounted,
    "debit_to": debitTo,
    "party_account_currency": partyAccountCurrency,
    "is_opening": isOpening,
    "c_form_applicable": cFormApplicable,
    "remarks": remarks,
    "amount_eligible_for_commission": amountEligibleForCommission,
    "commission_rate": commissionRate,
    "total_commission": totalCommission,
    "against_income_account": againstIncomeAccount,
    "distance": distance,
    "einvoice_status": einvoiceStatus,
    "export_type": exportType,
    "gst_vehicle_type": gstVehicleType,
    "invoice_copy": invoiceCopy,
    "lr_date": "${lrDate!.year.toString().padLeft(4, '0')}-${lrDate!.month.toString().padLeft(2, '0')}-${lrDate!.day.toString().padLeft(2, '0')}",
    "mode_of_transport": modeOfTransport,
    "reason_for_issuing_document": reasonForIssuingDocument,
    "reverse_charge": reverseCharge,
    "doctype": doctype,
    "items": List<dynamic>.from(items!.map((x) => x.toJson())),
    "pricing_rules": List<dynamic>.from(pricingRules!.map((x) => x)),
    "packed_items": List<dynamic>.from(packedItems!.map((x) => x)),
    "timesheets": List<dynamic>.from(timesheets!.map((x) => x)),
    "taxes": List<dynamic>.from(taxes!.map((x) => x.toJson())),
    "advances": List<dynamic>.from(advances!.map((x) => x)),
    "payment_schedule": List<dynamic>.from(paymentSchedule!.map((x) => x.toJson())),
    "payments": List<dynamic>.from(payments!.map((x) => x)),
    "sales_team": List<dynamic>.from(salesTeam!.map((x) => x)),
    "__onload": onload!.toJson(),
  };
}

class Item {
  Item({
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
    this.itemName,
    this.description,
    this.isNilExempt,
    this.isNonGst,
    this.itemGroup,
    this.brand,
    this.image,
    this.qty,
    this.stockUom,
    this.uom,
    this.conversionFactor,
    this.stockQty,
    this.priceListRate,
    this.basePriceListRate,
    this.marginType,
    this.marginRateOrAmount,
    this.rateWithMargin,
    this.discountPercentage,
    this.discountAmount,
    this.baseRateWithMargin,
    this.rate,
    this.amount,
    this.baseRate,
    this.baseAmount,
    this.stockUomRate,
    this.isFreeItem,
    this.grantCommission,
    this.netRate,
    this.netAmount,
    this.baseNetRate,
    this.baseNetAmount,
    this.taxableValue,
    this.deliveredBySupplier,
    this.incomeAccount,
    this.isFixedAsset,
    this.expenseAccount,
    this.enableDeferredRevenue,
    this.weightPerUnit,
    this.totalWeight,
    this.warehouse,
    this.batchNo,
    this.incomingRate,
    this.allowZeroValuationRate,
    this.itemTaxRate,
    this.actualBatchQty,
    this.actualQty,
    this.salesOrder,
    this.soDetail,
    this.deliveredQty,
    this.costCenter,
    this.pageBreak,
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
  String? itemName;
  String? description;
  int? isNilExempt;
  int? isNonGst;
  String? itemGroup;
  String? brand;
  String? image;
  dynamic qty;
  String? stockUom;
  String? uom;
  dynamic conversionFactor;
  dynamic stockQty;
  dynamic priceListRate;
  dynamic basePriceListRate;
  String? marginType;
  dynamic marginRateOrAmount;
  dynamic rateWithMargin;
  dynamic discountPercentage;
  dynamic discountAmount;
  dynamic baseRateWithMargin;
  dynamic rate;
  dynamic amount;
  dynamic baseRate;
  dynamic baseAmount;
  dynamic stockUomRate;
  int? isFreeItem;
  int? grantCommission;
  dynamic netRate;
  dynamic netAmount;
  dynamic baseNetRate;
  dynamic baseNetAmount;
  dynamic taxableValue;
  int? deliveredBySupplier;
  String? incomeAccount;
  int? isFixedAsset;
  String? expenseAccount;
  int? enableDeferredRevenue;
  dynamic weightPerUnit;
  dynamic totalWeight;
  String? warehouse;
  String? batchNo;
  dynamic incomingRate;
  int? allowZeroValuationRate;
  String? itemTaxRate;
  dynamic actualBatchQty;
  dynamic actualQty;
  String? salesOrder;
  String? soDetail;
  dynamic deliveredQty;
  String? costCenter;
  int? pageBreak;
  String? doctype;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
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
    itemName: json["item_name"],
    description: json["description"],
    isNilExempt: json["is_nil_exempt"],
    isNonGst: json["is_non_gst"],
    itemGroup: json["item_group"],
    brand: json["brand"],
    image: json["image"],
    qty: json["qty"],
    stockUom: json["stock_uom"],
    uom: json["uom"],
    conversionFactor: json["conversion_factor"],
    stockQty: json["stock_qty"],
    priceListRate: json["price_list_rate"],
    basePriceListRate: json["base_price_list_rate"],
    marginType: json["margin_type"],
    marginRateOrAmount: json["margin_rate_or_amount"],
    rateWithMargin: json["rate_with_margin"],
    discountPercentage: json["discount_percentage"],
    discountAmount: json["discount_amount"],
    baseRateWithMargin: json["base_rate_with_margin"],
    rate: json["rate"],
    amount: json["amount"],
    baseRate: json["base_rate"],
    baseAmount: json["base_amount"],
    stockUomRate: json["stock_uom_rate"],
    isFreeItem: json["is_free_item"],
    grantCommission: json["grant_commission"],
    netRate: json["net_rate"],
    netAmount: json["net_amount"],
    baseNetRate: json["base_net_rate"],
    baseNetAmount: json["base_net_amount"],
    taxableValue: json["taxable_value"],
    deliveredBySupplier: json["delivered_by_supplier"],
    incomeAccount: json["income_account"],
    isFixedAsset: json["is_fixed_asset"],
    expenseAccount: json["expense_account"],
    enableDeferredRevenue: json["enable_deferred_revenue"],
    weightPerUnit: json["weight_per_unit"],
    totalWeight: json["total_weight"],
    warehouse: json["warehouse"],
    batchNo: json["batch_no"],
    incomingRate: json["incoming_rate"],
    allowZeroValuationRate: json["allow_zero_valuation_rate"],
    itemTaxRate: json["item_tax_rate"],
    actualBatchQty: json["actual_batch_qty"],
    actualQty: json["actual_qty"],
    salesOrder: json["sales_order"],
    soDetail: json["so_detail"],
    deliveredQty: json["delivered_qty"],
    costCenter: json["cost_center"],
    pageBreak: json["page_break"],
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
    "item_name": itemName,
    "description": description,
    "is_nil_exempt": isNilExempt,
    "is_non_gst": isNonGst,
    "item_group": itemGroup,
    "brand": brand,
    "image": image,
    "qty": qty,
    "stock_uom": stockUom,
    "uom": uom,
    "conversion_factor": conversionFactor,
    "stock_qty": stockQty,
    "price_list_rate": priceListRate,
    "base_price_list_rate": basePriceListRate,
    "margin_type": marginType,
    "margin_rate_or_amount": marginRateOrAmount,
    "rate_with_margin": rateWithMargin,
    "discount_percentage": discountPercentage,
    "discount_amount": discountAmount,
    "base_rate_with_margin": baseRateWithMargin,
    "rate": rate,
    "amount": amount,
    "base_rate": baseRate,
    "base_amount": baseAmount,
    "stock_uom_rate": stockUomRate,
    "is_free_item": isFreeItem,
    "grant_commission": grantCommission,
    "net_rate": netRate,
    "net_amount": netAmount,
    "base_net_rate": baseNetRate,
    "base_net_amount": baseNetAmount,
    "taxable_value": taxableValue,
    "delivered_by_supplier": deliveredBySupplier,
    "income_account": incomeAccount,
    "is_fixed_asset": isFixedAsset,
    "expense_account": expenseAccount,
    "enable_deferred_revenue": enableDeferredRevenue,
    "weight_per_unit": weightPerUnit,
    "total_weight": totalWeight,
    "warehouse": warehouse,
    "batch_no": batchNo,
    "incoming_rate": incomingRate,
    "allow_zero_valuation_rate": allowZeroValuationRate,
    "item_tax_rate": itemTaxRate,
    "actual_batch_qty": actualBatchQty,
    "actual_qty": actualQty,
    "sales_order": salesOrder,
    "so_detail": soDetail,
    "delivered_qty": deliveredQty,
    "cost_center": costCenter,
    "page_break": pageBreak,
    "doctype": doctype,
  };
}

class Onload {
  Onload({
    this.makePaymentViaJournalEntry,
  });

  int? makePaymentViaJournalEntry;

  factory Onload.fromJson(Map<String, dynamic> json) => Onload(
    makePaymentViaJournalEntry: json["make_payment_via_journal_entry"],
  );

  Map<String, dynamic> toJson() => {
    "make_payment_via_journal_entry": makePaymentViaJournalEntry,
  };
}

class PaymentSchedule {
  PaymentSchedule({
    this.name,
    this.creation,
    this.modified,
    this.modifiedBy,
    this.parent,
    this.parentfield,
    this.parenttype,
    this.idx,
    this.docstatus,
    this.paymentTerm,
    this.dueDate,
    this.invoicePortion,
    this.discountType,
    this.discountDate,
    this.discount,
    this.paymentAmount,
    this.outstanding,
    this.paidAmount,
    this.discountedAmount,
    this.basePaymentAmount,
    this.doctype,
  });

  String? name;
  String? creation;
  String? modified;
  String? modifiedBy;
  String? parent;
  String? parentfield;
  String? parenttype;
  int? idx;
  int? docstatus;
  String? paymentTerm;
  DateTime? dueDate;
  dynamic invoicePortion;
  String? discountType;
  DateTime? discountDate;
  dynamic discount;
  dynamic paymentAmount;
  dynamic outstanding;
  dynamic paidAmount;
  dynamic discountedAmount;
  dynamic basePaymentAmount;
  String? doctype;

  factory PaymentSchedule.fromJson(Map<String, dynamic> json) => PaymentSchedule(
    name: json["name"],
    creation: json["creation"],
    modified: json["modified"],
    modifiedBy: json["modified_by"],
    parent: json["parent"],
    parentfield: json["parentfield"],
    parenttype: json["parenttype"],
    idx: json["idx"],
    docstatus: json["docstatus"],
    paymentTerm: json["payment_term"],
    dueDate: DateTime.parse(json["due_date"]),
    invoicePortion: json["invoice_portion"],
    discountType: json["discount_type"],
    discountDate: DateTime.parse(json["discount_date"]),
    discount: json["discount"],
    paymentAmount: json["payment_amount"],
    outstanding: json["outstanding"],
    paidAmount: json["paid_amount"],
    discountedAmount: json["discounted_amount"],
    basePaymentAmount: json["base_payment_amount"],
    doctype: json["doctype"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "creation": creation,
    "modified": modified,
    "modified_by": modifiedBy,
    "parent": parent,
    "parentfield": parentfield,
    "parenttype": parenttype,
    "idx": idx,
    "docstatus": docstatus,
    "payment_term": paymentTerm,
    "due_date": "${dueDate!.year.toString().padLeft(4, '0')}-${dueDate!.month.toString().padLeft(2, '0')}-${dueDate!.day.toString().padLeft(2, '0')}",
    "invoice_portion": invoicePortion,
    "discount_type": discountType,
    "discount_date": "${discountDate!.year.toString().padLeft(4, '0')}-${discountDate!.month.toString().padLeft(2, '0')}-${discountDate!.day.toString().padLeft(2, '0')}",
    "discount": discount,
    "payment_amount": paymentAmount,
    "outstanding": outstanding,
    "paid_amount": paidAmount,
    "discounted_amount": discountedAmount,
    "base_payment_amount": basePaymentAmount,
    "doctype": doctype,
  };
}

class Tax {
  Tax({
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
    this.chargeType,
    this.accountHead,
    this.description,
    this.includedInPrintRate,
    this.includedInPaidAmount,
    this.costCenter,
    this.rate,
    this.accountCurrency,
    this.taxAmount,
    this.total,
    this.taxAmountAfterDiscountAmount,
    this.baseTaxAmount,
    this.baseTotal,
    this.baseTaxAmountAfterDiscountAmount,
    this.itemWiseTaxDetail,
    this.dontRecomputeTax,
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
  String? chargeType;
  String? accountHead;
  String? description;
  int? includedInPrintRate;
  int? includedInPaidAmount;
  String? costCenter;
  dynamic rate;
  String? accountCurrency;
  dynamic taxAmount;
  dynamic total;
  dynamic taxAmountAfterDiscountAmount;
  dynamic baseTaxAmount;
  dynamic baseTotal;
  dynamic baseTaxAmountAfterDiscountAmount;
  String? itemWiseTaxDetail;
  int? dontRecomputeTax;
  String? doctype;

  factory Tax.fromJson(Map<String, dynamic> json) => Tax(
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
    chargeType: json["charge_type"],
    accountHead: json["account_head"],
    description: json["description"],
    includedInPrintRate: json["included_in_print_rate"],
    includedInPaidAmount: json["included_in_paid_amount"],
    costCenter: json["cost_center"],
    rate: json["rate"],
    accountCurrency: json["account_currency"],
    taxAmount: json["tax_amount"],
    total: json["total"],
    taxAmountAfterDiscountAmount: json["tax_amount_after_discount_amount"],
    baseTaxAmount: json["base_tax_amount"],
    baseTotal: json["base_total"],
    baseTaxAmountAfterDiscountAmount: json["base_tax_amount_after_discount_amount"],
    itemWiseTaxDetail: json["item_wise_tax_detail"],
    dontRecomputeTax: json["dont_recompute_tax"],
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
    "charge_type": chargeType,
    "account_head": accountHead,
    "description": description,
    "included_in_print_rate": includedInPrintRate,
    "included_in_paid_amount": includedInPaidAmount,
    "cost_center": costCenter,
    "rate": rate,
    "account_currency": accountCurrency,
    "tax_amount": taxAmount,
    "total": total,
    "tax_amount_after_discount_amount": taxAmountAfterDiscountAmount,
    "base_tax_amount": baseTaxAmount,
    "base_total": baseTotal,
    "base_tax_amount_after_discount_amount": baseTaxAmountAfterDiscountAmount,
    "item_wise_tax_detail": itemWiseTaxDetail,
    "dont_recompute_tax": dontRecomputeTax,
    "doctype": doctype,
  };
}
