import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ebuzz/common/colors.dart';
import 'package:ebuzz/common/custom_toast.dart';
import 'package:ebuzz/exception/custom_exception.dart';
import 'package:ebuzz/network/base_dio.dart';
import 'package:ebuzz/orderbooking/model/order_booking.dart';
import 'package:ebuzz/orderbooking/model/table_model.dart';
import 'package:ebuzz/util/apiurls.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;



class OrderBookingListService {

  // //for posting data to quality inpsection api
  Future post(OrderBooking orderBooking, BuildContext context) async {
    try {
      Dio _dio = await BaseDio().getBaseDio();
      final String url = orderBookingUrl();
      final response = await _dio.post(url, data: OrderBooking);
      if (response.statusCode == 200) {
        fluttertoast(whiteColor, blueAccent, 'Data posted successfully');
      }
    } catch (e) {
      exception(e,context);
    }
  }

  //for fetching order list
  Future<List<OrderBooking>> getOrderBookingList(BuildContext context) async {
    List list = [];
    List<OrderBooking> oblist = [];
    try {
      Dio _dio = await BaseDio().getBaseDio();
      final String ob = orderBookingListUrl();
      final response = await _dio.get(ob);
      var data = response.data;
      list = data['data'];
      for (var listJson in list) {
        oblist.add(OrderBooking.fromJson(listJson));
      }
      return oblist;
    } catch (e) {
      exception(e,context);
    }
    return oblist;
  }
}
  
//for fetching sales order item list
  Future<List<OrderBookingItems>> getOrderBookingItemList(String name, BuildContext context) async {
    List<OrderBookingItems> items = [];

    try {
      Dio _dio = await BaseDio().getBaseDio();

      final String itemList = orderBookingDetailUrl(name);
      var response = await _dio.get(
        itemList,
      );
      var data = response.data;
      List list = data['data']['items'];
      for (var listJson in list) {
        items.add(OrderBookingItems.fromJson(listJson));
      }
      // fluttertoast(whiteColor, redColor, data);
      return items;
    } catch (e) {
      exception(e,context);
    }
    return items;
  }


//for fetching sales promo
Future<List<OrderBookingSalesPromos>> getOrderBookingSalesPromo(String itemCode,String customertype,String company,String orderList,String customer,BuildContext context) async{
  List<OrderBookingSalesPromos> salesPromos = [];
  try{
    Dio _dio = await BaseDio().getBaseDio();
    final String salePromoList = salesPromoUrl(itemCode,customertype,company,orderList,customer);
    var response = await _dio.get(salePromoList);
    
    var data = response.data;
    List list = data['item_code']['customer_type']['company']["order_list"]['customer'];
    for (var listJson in list) {
      salesPromos.add(OrderBookingSalesPromos.fromJson(listJson));
      print(salesPromos);
      print(data);
      fluttertoast(whiteColor, redColor, data);
    // fluttertoast(whiteColor, redColor, salesPromos);
    return salesPromos;
    // print("Sales Promo", salesPromos);
  }
  } catch (e){
    exception(e,context);
    print(salesPromos);
  }
  print(salesPromos);
  return salesPromos;
}


// Future<List<OrderBookingSalesPromos>> getOrderBookingSalesPromo(String item_code, String customer_type, String company, String order_list, String customer, BuildContext context) async {
//     try {
//       Dio _dio = await BaseDio().getBaseDio();

//       final String url1 = salesPromoUrl(item_code, customer_type, company, order_list, customer);
//       final response = await _dio.get(
//         url1,
//       );
//       String data = response.body;
//       if (response.statusCode == 200) {
//         var item_code = jsonDecode(data)['item_code'];
//         var customer_type = jsonDecode(data)['customer_type'];
//         var company = jsonDecode(data)['company'];
//         var order_list = jsonDecode(data)['order_list'];
//         var customer = jsonDecode(data)['customer'];

//         return <String>[item_code, customer_type, company, order_list, customer];
//       } else {
//         throw Exception('Failed to load data');
//       }
//     } catch (e) {
//       exception(e, context);
//     }
//     return <String>[item_code, customer_type, company, order_list, customer];
//   }

  // //for fetching sales order payment schedule list
  // Future<List<OrderBookingPaymentSchedule>> getOrderBookingPaymentScheduleList(
  //     String name, BuildContext context) async {
  //   List<OrderBookingPaymentSchedule> ps = [];

  //   try {
  //     Dio _dio = await BaseDio().getBaseDio();

  //     final String itemList = orderBookingDetailUrl(name);
  //     var response = await _dio.get(
  //       itemList,
  //     );
  //     var data = response.data;
  //     List list = data['data']['payment_schedule'];
  //     for (var listJson in list) {
  //       ps.add(OrderBookingPaymentSchedule.fromJson(listJson));
  //     }
  //     return ps;
  //   } catch (e) {
  //     exception(e,context);
  //   }
  //   return ps;
  // }


  // String url = salesPromoDetailUrl(item_code, customer_type, company, customer);

  Future<Map<String, dynamic>> getOrderBookingDetails(String itemCode, String customertype, String company, String customer, BuildContext context) async{
  // var orderDetails = "";
  Map<String, dynamic> orderBookingDetailsMap = Map();
  try{
    Dio _dio = await BaseDio().getBaseDio();
    final String orderDetailsList = orderDetailUrl(itemCode, customertype, company, customer);
    var response = await _dio.get(orderDetailsList);
    
    var data = response.data as Map<String, dynamic>;
    orderBookingDetailsMap = new Map.from(data);
    // print(response.data.message);
    // print(data["message"]["available_qty"]);
    return orderBookingDetailsMap;
  } catch (e) {
    exception(e,context);
    print(e);
  }
  return orderBookingDetailsMap;
}

// TableModel? tableModel;
// var decodedData;
// bool isTableLoad = false;
//
// Future getTableData(BuildContext context,{itemcode,customertype,company,order_list,customer}) async{
//   print("call");
//   isTableLoad = true;
//   var headers = {
//     'Cookie': 'full_name=Jeeva; sid=6a44549626720c83d2d37a33716891f32dc8bf7978dcdaabbcf9b7b6; system_user=yes; user_id=jeeva%40yuvabe.com; user_image='
//   };
//   var request = http.Request('POST', Uri.parse('https://erptest.bharathrajesh.co.in/api/method/bmga.bmga.doctype.order_booking_v2.api.sales_promos?item_code=$itemcode&customer_type=$customertype&company=$company&order_list=$order_list&customer=$customer'));
//
//   request.headers.addAll(headers);
//
//   // http.StreamedResponse response = await request.send();
//   var streamedResponse = await request.send();
//   var response = await http.Response.fromStream(streamedResponse);
//
//   if (response.statusCode == 200) {
//     // var data = await response.stream.bytesToString();
//     isTableLoad = false;
//     print(response.body);
//     String data = response.body;
//     decodedData = jsonDecode(data);
//     print(decodedData['message']['sales_order']['sales_order']);
//     // tableModel = TableModel.fromJson(json.decode(data));
//     // print("table data is===>>>$tableModel");
//   }
//   else {
//     print(response.reasonPhrase);
//   }
//
//   // var customerType;
//   // try {
//   //   Dio _dio = await BaseDio().getBaseDio();
//   //   final String so = tableData(itemcode: itemcode,customerType: customertype,company: company,order_list: order_list,customer: customer);
//   //   final response = await _dio.get(so);
//   //   var data = response.data;
//   //   print("table data is====>>>$data");
//   //   // customerType = data['message']['pch_customer_type'];
//   //   // return customerType;
//   // } catch (e) {
//   //   exception(e, context);
//   // }
//   // return customerType;
// }


Future getOrderBooking() async{
  var headers = {
    'Cookie': 'full_name=Jeeva; sid=6a44549626720c83d2d37a33716891f32dc8bf7978dcdaabbcf9b7b6; system_user=yes; user_id=jeeva%40yuvabe.com; user_image='
  };
  var map = {
    'customer': 'CUST-R-00002',
    'order_list': '[{"docstatus":0,"doctype":"Order Booking Items V2","name":"new-order-booking-items-v2-7","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","quantity_available":52,"gst_rate":"12","rate_contract":"0","rate_contract_check":0,"parent":"new-order-booking-v2-1","parentfield":"order_booking_items_v2","parenttype":"Order Booking V2","idx":1,"__unedited":false,"stock_uom":"Unit","item_code":"Demo Item 4","average_price":170,"amount_after_gst":180,"brand_name":"Johnson & Johnson","__checked":0,"quantity_booked":22,"amount":3740}]',
    'company': 'Bharath Medical & General Agencies',
    'customer_type': 'Retail',
    'free_promos': '[{"docstatus":0,"doctype":"Order Booking V2 Sales Promo","name":"new-order-booking-v2-sales-promo-1","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","parent":"new-order-booking-v2-1","parentfield":"promos","parenttype":"Order Booking V2","idx":1,"bought_item":"Demo Item 4","free_items":"Demo Item 4","price":0,"quantity":4,"warehouse_quantity":20,"promo_type":"Buy x get same and discount for ineligible qty"}]',
    'promo_dis': '[{"docstatus":0,"doctype":"Order Booking V2 Sales Discount","name":"new-order-booking-v2-sales-discount-1","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","parent":"new-order-booking-v2-1","parentfield":"promos_discount","parenttype":"Order Booking V2","idx":1,"bought_item":"Demo Item 4","free_item":"Demo Item 4","quantity":2,"discount":136,"promo_type":"Buy x get same and discount for ineligible qty","amount":272}]',
    'sales_order': '[{"docstatus":0,"doctype":"Order booking V2 Sales Order Preview","name":"new-order-booking-v2-sales-order-preview-1","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","parent":"new-order-booking-v2-1","parentfield":"sales_order_preview","parenttype":"Order Booking V2","idx":1,"item_code":"Demo Item 4","quantity_available":52,"quantity":20,"average":170,"promo_type":"None","warehouse":"BMGA Test Warehouse - BMGA"},{"docstatus":0,"doctype":"Order booking V2 Sales Order Preview","name":"new-order-booking-v2-sales-order-preview-2","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","parent":"new-order-booking-v2-1","parentfield":"sales_order_preview","parenttype":"Order Booking V2","idx":2,"item_code":"Demo Item 4","quantity_available":20,"quantity":4,"average":0,"promo_type":"Buy x get same and discount for ineligible qty","warehouse":"Free Warehouse - BMGA"},{"docstatus":0,"doctype":"Order booking V2 Sales Order Preview","name":"new-order-booking-v2-sales-order-preview-3","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","parent":"new-order-booking-v2-1","parentfield":"sales_order_preview","parenttype":"Order Booking V2","idx":3,"item_code":"Demo Item 4","quantity_available":52,"quantity":2,"average":136,"promo_type":"Buy x get same and discount for ineligible qty","warehouse":"BMGA Test Warehouse - BMGA"}]'
  };
  var request = http.MultipartRequest('POST', Uri.parse('https://erptest.bharathrajesh.co.in${orderBooking()}'));
  request.fields.addAll(map);

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    fluttertoast(whiteColor, redColor, "Order book successful");
    print(await response.stream.bytesToString());
  }
  else {
    print(response.reasonPhrase);
  }
  [{"docstatus":0,"doctype":"Order Booking Items V2","name":"new-order-booking-items-v2-7","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","quantity_available":52,"gst_rate":"12","rate_contract":"0","rate_contract_check":0,"parent":"new-order-booking-v2-1","parentfield":"order_booking_items_v2","parenttype":"Order Booking V2","idx":1,"__unedited":false,"stock_uom":"Unit","item_code":"Demo Item 4","average_price":170,"amount_after_gst":180,"brand_name":"Johnson & Johnson","__checked":0,"quantity_booked":22,"amount":3740}];
  [{"docstatus":0,"doctype":"Order Booking V2 Sales Promo","name":"new-order-booking-v2-sales-promo-1","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","parent":"new-order-booking-v2-1","parentfield":"promos","parenttype":"Order Booking V2","idx":1,"bought_item":"Demo Item 4","free_items":"Demo Item 4","price":0,"quantity":4,"warehouse_quantity":20,"promo_type":"Buy x get same and discount for ineligible qty"}];
    [{"docstatus":0,"doctype":"Order Booking V2 Sales Discount","name":"new-order-booking-v2-sales-discount-1","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","parent":"new-order-booking-v2-1","parentfield":"promos_discount","parenttype":"Order Booking V2","idx":1,"bought_item":"Demo Item 4","free_item":"Demo Item 4","quantity":2,"discount":136,"promo_type":"Buy x get same and discount for ineligible qty","amount":272}];
  [{"docstatus":0,"doctype":"Order booking V2 Sales Order Preview","name":"new-order-booking-v2-sales-order-preview-1","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","parent":"new-order-booking-v2-1","parentfield":"sales_order_preview","parenttype":"Order Booking V2","idx":1,"item_code":"Demo Item 4","quantity_available":52,"quantity":20,"average":170,"promo_type":"None","warehouse":"BMGA Test Warehouse - BMGA"},{"docstatus":0,"doctype":"Order booking V2 Sales Order Preview","name":"new-order-booking-v2-sales-order-preview-2","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","parent":"new-order-booking-v2-1","parentfield":"sales_order_preview","parenttype":"Order Booking V2","idx":2,"item_code":"Demo Item 4","quantity_available":20,"quantity":4,"average":0,"promo_type":"Buy x get same and discount for ineligible qty","warehouse":"Free Warehouse - BMGA"},{"docstatus":0,"doctype":"Order booking V2 Sales Order Preview","name":"new-order-booking-v2-sales-order-preview-3","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","parent":"new-order-booking-v2-1","parentfield":"sales_order_preview","parenttype":"Order Booking V2","idx":3,"item_code":"Demo Item 4","quantity_available":52,"quantity":2,"average":136,"promo_type":"Buy x get same and discount for ineligible qty","warehouse":"BMGA Test Warehouse - BMGA"}];
}

