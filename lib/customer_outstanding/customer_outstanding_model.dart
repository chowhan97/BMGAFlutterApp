// // To parse this JSON data, do
// //
// //     final customerOutstandingModel = customerOutstandingModelFromJson(jsonString);
//
// import 'dart:convert';
//
// CustomerOutstandingModel customerOutstandingModelFromJson(String str) => CustomerOutstandingModel.fromJson(json.decode(str));
//
// String customerOutstandingModelToJson(CustomerOutstandingModel data) => json.encode(data.toJson());
//
// class CustomerOutstandingModel {
//   CustomerOutstandingModel({
//     this.message,
//   });
//
//   Message? message;
//
//   factory CustomerOutstandingModel.fromJson(Map<String, dynamic> json) => CustomerOutstandingModel(
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
//     this.result,
//     this.columns,
//     this.message,
//     this.chart,
//     this.reportSummary,
//     this.skipTotalRow,
//     this.status,
//     this.executionTime,
//     this.addTotalRow,
//   });
//
//   List<Result>? result;
//   List<Columnn>? columns;
//   dynamic message;
//   Chart? chart;
//   dynamic reportSummary;
//   int? skipTotalRow;
//   dynamic status;
//   double? executionTime;
//   bool? addTotalRow;
//
//   factory Message.fromJson(Map<String, dynamic> json) => Message(
//     result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
//     columns: List<Columnn>.from(json["columns"].map((x) => Columnn.fromJson(x))),
//     message: json["message"],
//     chart: Chart.fromJson(json["chart"]),
//     reportSummary: json["report_summary"],
//     skipTotalRow: json["skip_total_row"],
//     status: json["status"],
//     executionTime: json["execution_time"].toDouble(),
//     addTotalRow: json["add_total_row"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "result": List<dynamic>.from(result!.map((x) => x.toJson())),
//     "columns": List<dynamic>.from(columns!.map((x) => x.toJson())),
//     "message": message,
//     "chart": chart!.toJson(),
//     "report_summary": reportSummary,
//     "skip_total_row": skipTotalRow,
//     "status": status,
//     "execution_time": executionTime,
//     "add_total_row": addTotalRow,
//   };
// }
//
// class Chart {
//   Chart({
//     this.data,
//     this.type,
//   });
//
//   Data? data;
//   String? type;
//
//   factory Chart.fromJson(Map<String, dynamic> json) => Chart(
//     data: Data.fromJson(json["data"]),
//     type: json["type"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "data": data!.toJson(),
//     "type": type,
//   };
// }
//
// class Data {
//   Data({
//     this.labels,
//     this.datasets,
//   });
//
//   List<String>? labels;
//   List<Dataset>? datasets;
//
//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//     labels: List<String>.from(json["labels"].map((x) => x)),
//     datasets: List<Dataset>.from(json["datasets"].map((x) => Dataset.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "labels": List<dynamic>.from(labels!.map((x) => x)),
//     "datasets": List<dynamic>.from(datasets!.map((x) => x.toJson())),
//   };
// }
//
// class Dataset {
//   Dataset({
//     this.values,
//   });
//
//   List<int>? values;
//
//   factory Dataset.fromJson(Map<String, dynamic> json) => Dataset(
//     values: List<int>.from(json["values"].map((x) => x)),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "values": List<dynamic>.from(values!.map((x) => x)),
//   };
// }
//
// class Columnn {
//   Columnn({
//     this.label,
//     this.fieldname,
//     this.fieldtype,
//     this.options,
//     this.width,
//   });
//
//   String? label;
//   String? fieldname;
//   String? fieldtype;
//   String? options;
//   int? width;
//
//   factory Columnn.fromJson(Map<String, dynamic> json) => Columnn(
//     label: json["label"],
//     fieldname: json["fieldname"],
//     fieldtype: json["fieldtype"],
//     options: json["options"] == null ? null : json["options"],
//     width: json["width"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "label": label,
//     "fieldname": fieldname,
//     "fieldtype": fieldtype,
//     "options": options == null ? null : options,
//     "width": width,
//   };
// }
//
// class Result {
//   Result({
//     this.voucherType,
//     this.voucherNo,
//     this.party,
//     this.partyAccount,
//     this.postingDate,
//     this.accountCurrency,
//     this.remarks,
//     this.invoiced,
//     this.paid,
//     this.creditNote,
//     this.outstanding,
//     this.invoicedInAccountCurrency,
//     this.paidInAccountCurrency,
//     this.creditNoteInAccountCurrency,
//     this.outstandingInAccountCurrency,
//     this.invoiceGrandTotal,
//     this.name,
//     this.dueDate,
//     this.poNo,
//     this.customerName,
//     this.territory,
//     this.customerGroup,
//     this.customerPrimaryContact,
//     this.currency,
//     this.range1,
//     this.range2,
//     this.range3,
//     this.range4,
//     this.range5,
//     this.age,
//     this.totalDue,
//   });
//
//   String? voucherType;
//   String? voucherNo;
//   String? party;
//   String? partyAccount;
//   DateTime? postingDate;
//   String? accountCurrency;
//   dynamic remarks;
//   dynamic invoiced;
//   dynamic paid;
//   dynamic creditNote;
//   dynamic outstanding;
//   dynamic invoicedInAccountCurrency;
//   dynamic paidInAccountCurrency;
//   dynamic creditNoteInAccountCurrency;
//   dynamic outstandingInAccountCurrency;
//   dynamic invoiceGrandTotal;
//   String? name;
//   DateTime? dueDate;
//   String? poNo;
//   String? customerName;
//   String? territory;
//   String? customerGroup;
//   String? customerPrimaryContact;
//   String? currency;
//   dynamic range1;
//   dynamic range2;
//   dynamic range3;
//   dynamic range4;
//   dynamic range5;
//   dynamic age;
//   dynamic totalDue;
//
//   factory Result.fromJson(Map<String, dynamic> json) => Result(
//     voucherType: json["voucher_type"],
//     voucherNo: json["voucher_no"],
//     party: json["party"],
//     partyAccount: json["party_account"],
//     postingDate: DateTime.parse(json["posting_date"]),
//     accountCurrency: json["account_currency"],
//     remarks: json["remarks"],
//     invoiced: json["invoiced"],
//     paid: json["paid"],
//     creditNote: json["credit_note"],
//     outstanding: json["outstanding"],
//     invoicedInAccountCurrency: json["invoiced_in_account_currency"],
//     paidInAccountCurrency: json["paid_in_account_currency"],
//     creditNoteInAccountCurrency: json["credit_note_in_account_currency"],
//     outstandingInAccountCurrency: json["outstanding_in_account_currency"],
//     invoiceGrandTotal: json["invoice_grand_total"],
//     name: json["name"] == null ? null : json["name"],
//     dueDate: json["due_date"] == null ? null : DateTime.parse(json["due_date"]),
//     poNo: json["po_no"] == null ? null : json["po_no"],
//     customerName: json["customer_name"],
//     territory: json["territory"],
//     customerGroup: json["customer_group"],
//     customerPrimaryContact: json["customer_primary_contact"] == null ? null : json["customer_primary_contact"],
//     currency: json["currency"],
//     range1: json["range1"],
//     range2: json["range2"],
//     range3: json["range3"],
//     range4: json["range4"],
//     range5: json["range5"],
//     age: json["age"],
//     totalDue: json["total_due"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "voucher_type": voucherType,
//     "voucher_no": voucherNo,
//     "party": party,
//     "party_account": partyAccount,
//     "posting_date": "${postingDate!.year.toString().padLeft(4, '0')}-${postingDate!.month.toString().padLeft(2, '0')}-${postingDate!.day.toString().padLeft(2, '0')}",
//     "account_currency": accountCurrency,
//     "remarks": remarks,
//     "invoiced": invoiced,
//     "paid": paid,
//     "credit_note": creditNote,
//     "outstanding": outstanding,
//     "invoiced_in_account_currency": invoicedInAccountCurrency,
//     "paid_in_account_currency": paidInAccountCurrency,
//     "credit_note_in_account_currency": creditNoteInAccountCurrency,
//     "outstanding_in_account_currency": outstandingInAccountCurrency,
//     "invoice_grand_total": invoiceGrandTotal,
//     "name": name == null ? null : name,
//     "due_date": dueDate == null ? null : "${dueDate!.year.toString().padLeft(4, '0')}-${dueDate!.month.toString().padLeft(2, '0')}-${dueDate!.day.toString().padLeft(2, '0')}",
//     "po_no": poNo == null ? null : poNo,
//     "customer_name": customerName,
//     "territory": territory,
//     "customer_group": customerGroup,
//     "customer_primary_contact": customerPrimaryContact == null ? null : customerPrimaryContact,
//     "currency": currency,
//     "range1": range1,
//     "range2": range2,
//     "range3": range3,
//     "range4": range4,
//     "range5": range5,
//     "age": age,
//     "total_due": totalDue,
//   };
// }


class CustomerOutstandingModel {
  Message? message;

  CustomerOutstandingModel({this.message});

  CustomerOutstandingModel.fromJson(Map<String, dynamic> json) {
    message =
    json['message'] != null ? new Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    return data;
  }
}

class Message {
  List<Result>? result;
  List<Columns>? columns;
  Null? message;
  Chart? chart;
  Null? reportSummary;
  int? skipTotalRow;
  Null? status;
  double? executionTime;
  bool? addTotalRow;

  Message(
      {this.result,
        this.columns,
        this.message,
        this.chart,
        this.reportSummary,
        this.skipTotalRow,
        this.status,
        this.executionTime,
        this.addTotalRow});

  Message.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
    if (json['columns'] != null) {
      columns = <Columns>[];
      json['columns'].forEach((v) {
        columns!.add(new Columns.fromJson(v));
      });
    }
    message = json['message'];
    chart = json['chart'] != null ? new Chart.fromJson(json['chart']) : null;
    reportSummary = json['report_summary'];
    skipTotalRow = json['skip_total_row'];
    status = json['status'];
    executionTime = json['execution_time'];
    addTotalRow = json['add_total_row'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    if (this.columns != null) {
      data['columns'] = this.columns!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    if (this.chart != null) {
      data['chart'] = this.chart!.toJson();
    }
    data['report_summary'] = this.reportSummary;
    data['skip_total_row'] = this.skipTotalRow;
    data['status'] = this.status;
    data['execution_time'] = this.executionTime;
    data['add_total_row'] = this.addTotalRow;
    return data;
  }
}

class Result {
  String? voucherType;
  String? voucherNo;
  String? party;
  String? partyAccount;
  String? postingDate;
  String? accountCurrency;
  Null? remarks;
  double? invoiced;
  double? paid;
  double? creditNote;
  double? outstanding;
  double? invoicedInAccountCurrency;
  double? paidInAccountCurrency;
  double? creditNoteInAccountCurrency;
  double? outstandingInAccountCurrency;
  double? invoiceGrandTotal;
  String? name;
  String? dueDate;
  String? poNo;
  String? customerName;
  String? territory;
  String? customerGroup;
  String? customerPrimaryContact;
  String? currency;
  double? range1;
  double? range2;
  double? range3;
  double? range4;
  double? range5;
  dynamic age;
  double? totalDue;

  Result(
      {this.voucherType,
        this.voucherNo,
        this.party,
        this.partyAccount,
        this.postingDate,
        this.accountCurrency,
        this.remarks,
        this.invoiced,
        this.paid,
        this.creditNote,
        this.outstanding,
        this.invoicedInAccountCurrency,
        this.paidInAccountCurrency,
        this.creditNoteInAccountCurrency,
        this.outstandingInAccountCurrency,
        this.invoiceGrandTotal,
        this.name,
        this.dueDate,
        this.poNo,
        this.customerName,
        this.territory,
        this.customerGroup,
        this.customerPrimaryContact,
        this.currency,
        this.range1,
        this.range2,
        this.range3,
        this.range4,
        this.range5,
        this.age,
        this.totalDue});

  Result.fromJson(Map<String, dynamic> json) {
    voucherType = json['voucher_type'];
    voucherNo = json['voucher_no'];
    party = json['party'];
    partyAccount = json['party_account'];
    postingDate = json['posting_date'];
    accountCurrency = json['account_currency'];
    remarks = json['remarks'];
    invoiced = json['invoiced'];
    paid = json['paid'];
    creditNote = json['credit_note'];
    outstanding = json['outstanding'];
    invoicedInAccountCurrency = json['invoiced_in_account_currency'];
    paidInAccountCurrency = json['paid_in_account_currency'];
    creditNoteInAccountCurrency = json['credit_note_in_account_currency'];
    outstandingInAccountCurrency = json['outstanding_in_account_currency'];
    invoiceGrandTotal = json['invoice_grand_total'];
    name = json['name'];
    dueDate = json['due_date'];
    poNo = json['po_no'];
    customerName = json['customer_name'];
    territory = json['territory'];
    customerGroup = json['customer_group'];
    customerPrimaryContact = json['customer_primary_contact'];
    currency = json['currency'];
    range1 = json['range1'];
    range2 = json['range2'];
    range3 = json['range3'];
    range4 = json['range4'];
    range5 = json['range5'];
    age = json['age'];
    totalDue = json['total_due'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['voucher_type'] = this.voucherType;
    data['voucher_no'] = this.voucherNo;
    data['party'] = this.party;
    data['party_account'] = this.partyAccount;
    data['posting_date'] = this.postingDate;
    data['account_currency'] = this.accountCurrency;
    data['remarks'] = this.remarks;
    data['invoiced'] = this.invoiced;
    data['paid'] = this.paid;
    data['credit_note'] = this.creditNote;
    data['outstanding'] = this.outstanding;
    data['invoiced_in_account_currency'] = this.invoicedInAccountCurrency;
    data['paid_in_account_currency'] = this.paidInAccountCurrency;
    data['credit_note_in_account_currency'] = this.creditNoteInAccountCurrency;
    data['outstanding_in_account_currency'] = this.outstandingInAccountCurrency;
    data['invoice_grand_total'] = this.invoiceGrandTotal;
    data['name'] = this.name;
    data['due_date'] = this.dueDate;
    data['po_no'] = this.poNo;
    data['customer_name'] = this.customerName;
    data['territory'] = this.territory;
    data['customer_group'] = this.customerGroup;
    data['customer_primary_contact'] = this.customerPrimaryContact;
    data['currency'] = this.currency;
    data['range1'] = this.range1;
    data['range2'] = this.range2;
    data['range3'] = this.range3;
    data['range4'] = this.range4;
    data['range5'] = this.range5;
    data['age'] = this.age;
    data['total_due'] = this.totalDue;
    return data;
  }
}

class Columns {
  String? label;
  String? fieldname;
  String? fieldtype;
  String? options;
  int? width;

  Columns(
      {this.label, this.fieldname, this.fieldtype, this.options, this.width});

  Columns.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    fieldname = json['fieldname'];
    fieldtype = json['fieldtype'];
    options = json['options'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['fieldname'] = this.fieldname;
    data['fieldtype'] = this.fieldtype;
    data['options'] = this.options;
    data['width'] = this.width;
    return data;
  }
}

class Chart {
  Data? data;
  String? type;

  Chart({this.data, this.type});

  Chart.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['type'] = this.type;
    return data;
  }
}

class Data {
  List<String>? labels;
  List<Datasets>? datasets;

  Data({this.labels, this.datasets});

  Data.fromJson(Map<String, dynamic> json) {
    labels = json['labels'].cast<String>();
    if (json['datasets'] != null) {
      datasets = <Datasets>[];
      json['datasets'].forEach((v) {
        datasets!.add(new Datasets.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['labels'] = this.labels;
    if (this.datasets != null) {
      data['datasets'] = this.datasets!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Datasets {
  List<int>? values;

  Datasets({this.values});

  Datasets.fromJson(Map<String, dynamic> json) {
    values = json['values'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['values'] = this.values;
    return data;
  }
}
