// To parse this JSON data, do
//
//     final transactionModel = transactionModelFromJson(jsonString);

import 'dart:convert';

TransactionModel transactionModelFromJson(String str) => TransactionModel.fromJson(json.decode(str));

String transactionModelToJson(TransactionModel data) => json.encode(data.toJson());

class TransactionModel {
  TransactionModel({
    this.message,
  });

  Message? message;

  factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
    message: Message.fromJson(json["message"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message!.toJson(),
  };
}

class Message {
  Message({
    this.keys,
    this.values,
  });

  List<String>? keys;
  List<List<dynamic>>? values;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    keys: List<String>.from(json["keys"].map((x) => x)),
    values: List<List<dynamic>>.from(json["values"].map((x) => List<dynamic>.from(x.map((x) => x)))),
  );

  Map<String, dynamic> toJson() => {
    "keys": List<dynamic>.from(keys!.map((x) => x)),
    "values": List<dynamic>.from(values!.map((x) => List<dynamic>.from(x.map((x) => x)))),
  };
}
