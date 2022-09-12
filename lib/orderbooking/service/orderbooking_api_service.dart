import 'package:dio/dio.dart';
import 'package:ebuzz/common/colors.dart';
import 'package:ebuzz/common/custom_toast.dart';
import 'package:ebuzz/exception/custom_exception.dart';
import 'package:ebuzz/network/base_dio.dart';
import 'package:ebuzz/orderbooking/model/order_booking.dart';
import 'package:ebuzz/orderbooking/model/table_model.dart';
import 'package:ebuzz/util/apiurls.dart';
import 'package:flutter/cupertino.dart';



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
      print("Order List $ob");
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

TableModel? tableModel;
var decodedData;
bool isTableLoad = false;



