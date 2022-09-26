// To parse this JSON data, do
//
//     final collectionListModel = collectionListModelFromJson(jsonString);

import 'dart:convert';

CollectionListModel collectionListModelFromJson(String str) => CollectionListModel.fromJson(json.decode(str));

String collectionListModelToJson(CollectionListModel data) => json.encode(data.toJson());

class CollectionListModel {
  CollectionListModel({
    this.message,
  });

  Message? message;

  factory CollectionListModel.fromJson(Map<String, dynamic> json) => CollectionListModel(
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
