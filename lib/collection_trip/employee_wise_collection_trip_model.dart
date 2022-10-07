// To parse this JSON data, do
//
//     final employeeWiseCollectionTripModel = employeeWiseCollectionTripModelFromJson(jsonString);

import 'dart:convert';

EmployeeWiseCollectionTripModel employeeWiseCollectionTripModelFromJson(String str) => EmployeeWiseCollectionTripModel.fromJson(json.decode(str));

String employeeWiseCollectionTripModelToJson(EmployeeWiseCollectionTripModel data) => json.encode(data.toJson());

class EmployeeWiseCollectionTripModel {
  EmployeeWiseCollectionTripModel({
    this.message,
  });

  List<Message>? message;

  factory EmployeeWiseCollectionTripModel.fromJson(Map<String, dynamic> json) => EmployeeWiseCollectionTripModel(
    message: List<Message>.from(json["message"].map((x) => Message.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": List<dynamic>.from(message!.map((x) => x.toJson())),
  };
}

class Message {
  Message({
    this.name,
    this.invoiceNo,
    this.pendingAmount,
    this.cashAmount,
    this.chequeAmount,
    this.wireAmount,
    this.totalAmount,
    this.chequeReference,
    this.chequeDate,
    this.wireReference,
    this.wireDate,
  });

  dynamic name;
  dynamic invoiceNo;
  dynamic pendingAmount;
  dynamic cashAmount;
  dynamic chequeAmount;
  dynamic wireAmount;
  dynamic totalAmount;
  dynamic chequeReference;
  dynamic chequeDate;
  dynamic wireReference;
  dynamic wireDate;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    name: json["name"],
    invoiceNo: json["invoice_no"],
    pendingAmount: json["pending_amount"],
    cashAmount: json["cash_amount"],
    chequeAmount: json["cheque_amount"],
    wireAmount: json["wire_amount"],
    totalAmount: json["total_amount"],
    chequeReference: json["cheque_reference"],
    chequeDate: json["cheque_date"],
    wireReference: json["wire_reference"],
    wireDate: json["wire_date"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "invoice_no": invoiceNo,
    "pending_amount": pendingAmount,
    "cash_amount": cashAmount,
    "cheque_amount": chequeAmount,
    "wire_amount": wireAmount,
    "total_amount": totalAmount,
    "cheque_reference": chequeReference,
    "cheque_date": chequeDate,
    "wire_reference": wireReference,
    "wire_date": wireDate
  };
}
