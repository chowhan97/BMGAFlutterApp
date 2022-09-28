import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:ebuzz/common/colors.dart';
import 'package:ebuzz/common/custom_appbar.dart';
import 'package:ebuzz/common/custom_toast.dart';
import 'package:ebuzz/common/navigations.dart';
import 'package:ebuzz/orderbooking/model/saveData_model.dart';
import 'package:ebuzz/orderbooking/model/table_model.dart';
import 'package:ebuzz/orderbooking/ui/orderbooking_ui.dart';
import 'package:ebuzz/util/apiurls.dart';
import 'package:ebuzz/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderBookingForm4 extends StatefulWidget {
  // var itemcode,orderlist,OrderBookingItemsV2,bookOrderList;
  final itemcode,orderlist,OrderBookingItemsV2,bookOrderList,unPaidAmount,creditLimit;
  OrderBookingForm4({this.itemcode, this.orderlist, this.OrderBookingItemsV2, this.bookOrderList, this.creditLimit,this.unPaidAmount});

  @override
  State<OrderBookingForm4> createState() => _OrderBookingForm4State();
}

class _OrderBookingForm4State extends State<OrderBookingForm4> {



  var finalTotal = 0;
  bool pending_status = false;

  @override
  void initState() {
    // var item_code = [{"item_code":"ItemA","quantity_booked":21,"average_price":41,"amount":861,"quantity_available":486}];
    // var order_list = [{"item_code":"IT002","quantity_booked":21,"average_price":41,"amount":861,"quantity_available":465,"rate_contract_check":0}];
    // String item_codeString = jsonEncode(item_code);
    // String order_listString = jsonEncode(order_list);
    // print(item_codeString.toString());
    // print(order_listString.toString());
    print("itemcode??=====>>>>${widget.creditLimit}");
    print("itemcode??=====>>>>${widget.unPaidAmount}");
    print("itemcode??=====>>>>${widget.itemcode}");
    print("orderlist??=====>>>>${widget.orderlist}");
    print("orderlist??=====>>>>${widget.OrderBookingItemsV2}");
    print("orderlist??=====>>>>${widget.bookOrderList}");

    getTableData(context, company: "Bharath Medical %26 General Agencies");
    // getTableData(context,itemcode: '[{"item_code":"ItemA","quantity_booked":21,"average_price":41,"amount":861,"quantity_available":486}]',customertype: "Retail",company: "Bharath Medical & General Agencies",order_list: '[{"item_code":"IT002","quantity_booked":21,"average_price":41,"amount":861,"quantity_available":465,"rate_contract_check":0}]',customer: "CUST-R-00010");
    super.initState();
  }
  SaveModel? saveModel;
  TableModel? tableModel;
  var decodedData;
  bool isTableLoad = false;
  var prefscompany;
  var prefscustomer;
  var prefscust_type;
  var prefsitem_code;
  var prefsorder_list;
  var owner;
  var order_booking_items_v2;
  List salesOrder = [];
  List freePromos = [];
  List promoDisc = [];
  var customerName;
  var creditLimit;
  var unpaidAmount;

  Future getTableData(BuildContext context, {company}) async {
    print("call");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefscompany = prefs.getString("company");
      print("prefscompany??????$prefscompany");
      prefscustomer = prefs.getString("customer");
      print("prefscustomer??????????$prefscustomer");
      prefscust_type = prefs.getString("cust_type");
      print("prefscust_type????????$prefscust_type");
      customerName = prefs.getString("customerName");
      print("prefscust_name????????$customerName");
      // prefsitem_code = prefs.getString("item_code");
      // print("prefsitem_code????????$prefsitem_code");
      // prefsorder_list = prefs.getString("order_list");
      // print("prefsorder_list????????$prefsorder_list");
      owner = prefs.getString("owner");
      print("owner????????$owner");
      creditLimit = prefs.getString("creditlimit");
      print("creditLimit????????$creditLimit");
      unpaidAmount = prefs.getString("unpaid");
      print("unpaidAmount????????$unpaidAmount");
    });
    isTableLoad = true;
    // var headers = {
    //   'Cookie': 'full_name=Jeeva; sid=6a44549626720c83d2d37a33716891f32dc8bf7978dcdaabbcf9b7b6; system_user=yes; user_id=jeeva%40yuvabe.com; user_image='
    // };
    // var request = http.Request('POST', Uri.parse('https://erptest.bharathrajesh.co.in/api/method/bmga.bmga.doctype.order_booking_v2.api.sales_promos?item_code=${widget.itemcode.toString()}&customer_type=$prefscust_type&company=${company}&order_list=${widget.orderlist.toString()}&customer=$prefscustomer'));
    var request = http.Request('POST', Uri.parse(getTableApi(itemcode: widget.itemcode.toString(),customer_type: prefscust_type,company: company,order_list: widget.orderlist.toString(),customer: prefscustomer)));

    request.headers.addAll(commonHeaders);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      setState(() {
        print(response.body);
        String data = response.body;
        decodedData = jsonDecode(data);
        isTableLoad = false;
        print("table call");
        tableModel = TableModel.fromJson(json.decode(data));
        var owner = prefs.getString("owner");
        salesOrder.clear();
        freePromos.clear();
        promoDisc.clear();
        for(var i=0; i<tableModel!.message!.salesOrder!.salesOrder!.length; i++){
          salesOrder.add(jsonEncode({"docstatus":0,"doctype":"Order booking V2 Sales Order Preview","name":"new-order-booking-v2-sales-order-preview-1","__islocal":1,"__unsaved":1,"owner":owner,"parent":"new-order-booking-v2-1","parentfield":"sales_order_preview","parenttype":"Order Booking V2","idx":int.parse("${i+1}"),"item_code": tableModel!.message!.salesOrder!.salesOrder![i].itemCode,"quantity_available":tableModel!.message!.salesOrder!.salesOrder![i].qtyAvailable,"quantity":tableModel!.message!.salesOrder!.salesOrder![i].qty,"average": tableModel!.message!.salesOrder!.salesOrder![i].averagePrice,"promo_type":tableModel!.message!.salesOrder!.salesOrder![i].promoType,"warehouse":tableModel!.message!.salesOrder!.salesOrder![i].warehouse}));
        }
        print("salesOrder ${salesOrder}");
        for(var i=0; i<tableModel!.message!.boughtItem!.length; i++){
          freePromos.add(jsonEncode({"docstatus":0,"doctype":"Order Booking V2 Sales Promo","name":"new-order-booking-v2-sales-promo-1","__islocal":1,"__unsaved":1,"owner":owner,"parent":"new-order-booking-v2-1","parentfield":"promos","parenttype":"Order Booking V2","idx":int.parse("${i+1}"),"bought_item": tableModel!.message!.boughtItem![i].itemCode,"free_items":tableModel!.message!.boughtItem![i].itemCode,"price":tableModel!.message!.boughtItem![i].amount,"quantity":tableModel!.message!.boughtItem![i].quantityBooked,"warehouse_quantity":tableModel!.message!.boughtItem![i].quantityAvailable,"promo_type":"Buy x get same and discount for ineligible qty"}));
        }

        print("freePromos ${freePromos}");

        for(var i=0; i<tableModel!.message!.boughtItem!.length; i++){
          promoDisc.add(jsonEncode({"docstatus":0,"doctype":"Order Booking V2 Sales Discount","name":"new-order-booking-v2-sales-discount-1","__islocal":1,"__unsaved":1,"owner":owner,"parent":"new-order-booking-v2-1","parentfield":"promos_discount","parenttype":"Order Booking V2","idx":int.parse("${i+1}"),"bought_item":tableModel!.message!.boughtItem![i].itemCode,"free_item":tableModel!.message!.boughtItem![i].itemCode,"quantity":tableModel!.message!.boughtItem![i].quantityBooked,"discount":136,"promo_type":"Buy x get same and discount for ineligible qty","amount":tableModel!.message!.boughtItem![i].amount}));
        }
        print("promoDisc ${promoDisc}");

        // var salesorder = [{"docstatus":0,"doctype":"Order booking V2 Sales Order Preview","name":"new-order-booking-v2-sales-order-preview-1","__islocal":1,"__unsaved":1,"owner":owner,"parent":"new-order-booking-v2-1","parentfield":"sales_order_preview","parenttype":"Order Booking V2","idx":1,"item_code": tableModel!.message!.salesOrder!.salesOrder![0].itemCode,"quantity_available":tableModel!.message!.salesOrder!.salesOrder![0].qtyAvailable,"quantity":tableModel!.message!.salesOrder!.salesOrder![0].qty,"average": tableModel!.message!.salesOrder!.salesOrder![0].averagePrice,"promo_type":tableModel!.message!.salesOrder!.salesOrder![0].promoType,"warehouse":tableModel!.message!.salesOrder!.salesOrder![0].warehouse},{"docstatus":0,"doctype":"Order booking V2 Sales Order Preview","name":"new-order-booking-v2-sales-order-preview-2","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","parent":"new-order-booking-v2-1","parentfield":"sales_order_preview","parenttype":"Order Booking V2","idx":2,"item_code": tableModel!.message!.salesOrder!.salesOrder![00].itemCode ?? "IT002","quantity_available":tableModel!.message!.salesOrder!.salesOrder![0].qtyAvailable ?? 465,"quantity":tableModel!.message!.salesOrder!.salesOrder![0].qty ?? 21,"average":tableModel!.message!.salesOrder!.salesOrder![0].averagePrice ?? 41,"promo_type":tableModel!.message!.salesOrder!.salesOrder![0].promoType ?? "None","warehouse":tableModel!.message!.salesOrder!.salesOrder![0].warehouse ?? "BMGA Test Warehouse - BMGA"},{"docstatus":0,"doctype":"Order booking V2 Sales Order Preview","name":"new-order-booking-v2-sales-order-preview-3","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","parent":"new-order-booking-v2-1","parentfield":"sales_order_preview","parenttype":"Order Booking V2","idx":3,"item_code":tableModel!.message!.salesOrder!.salesOrder![0].itemCode ?? "IT002","quantity_available":tableModel!.message!.salesOrder!.salesOrder![0].qtyAvailable ?? 465,"quantity":tableModel!.message!.salesOrder!.salesOrder![0].qty ?? 21,"average":tableModel!.message!.salesOrder!.salesOrder![0].averagePrice ?? 41,"promo_type":tableModel!.message!.salesOrder!.salesOrder![0].promoType ?? "None","warehouse":tableModel!.message!.salesOrder!.salesOrder![0].warehouse ?? "BMGA Test Warehouse - BMGA"}];
        // var freepromos =  [{"docstatus":0,"doctype":"Order Booking V2 Sales Promo","name":"new-order-booking-v2-sales-promo-1","__islocal":1,"__unsaved":1,"owner":owner,"parent":"new-order-booking-v2-1","parentfield":"promos","parenttype":"Order Booking V2","idx":1,"bought_item": tableModel!.message!.boughtItem![0].itemCode,"free_items":tableModel!.message!.boughtItem![0].itemCode,"price":tableModel!.message!.boughtItem![0].amount,"quantity":tableModel!.message!.boughtItem![0].quantityBooked,"warehouse_quantity":tableModel!.message!.boughtItem![0].quantityAvailable,"promo_type":"Buy x get same and discount for ineligible qty"}];
        // var promodis = [{"docstatus":0,"doctype":"Order Booking V2 Sales Discount","name":"new-order-booking-v2-sales-discount-1","__islocal":1,"__unsaved":1,"owner":owner,"parent":"new-order-booking-v2-1","parentfield":"promos_discount","parenttype":"Order Booking V2","idx":1,"bought_item":tableModel!.message!.boughtItem![0].itemCode,"free_item":tableModel!.message!.boughtItem![0].itemCode,"quantity":tableModel!.message!.boughtItem![0].quantityBooked,"discount":136,"promo_type":"Buy x get same and discount for ineligible qty","amount":tableModel!.message!.boughtItem![0].amount}];
        // String sales_order = jsonEncode(salesorder);
        // String free_promos = jsonEncode(freepromos);
        // String promo_dis = jsonEncode(promodis);
        // print("========?????=========$sales_order");
        // print("========?????=========$free_promos");
        // print("========?????=========$promo_dis");
        // prefs.setString("sales_order", sales_order);
        // prefs.setString("free_promos", free_promos);
        // prefs.setString("promo_dis", promo_dis);
      });
      // var data = await response.stream.bytesToString();
      // tableModel = TableModel.fromJson(json.decode(data));
      // print("table data is===>>>$tableModel");
    } else {
      print(response.reasonPhrase);
      isTableLoad = false;
    }
  }
  bool isSaved = false;
  bool isSaveload = false;

  Future SaveData(BuildContext context) async {
    print("call");
    isSaveload = true;
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // setState(() {
      //   order_booking_items_v2 = prefs.getString("order_booking_items_v2");
      //   print("prefsorder_list????????$order_booking_items_v2");
      // });
      String Owner = jsonEncode(owner);
      String Creditlimit = jsonEncode(creditLimit);
      String Unpaidamount = jsonEncode(unpaidAmount);
      List promolist = [];
      List salesOrderPreviewList = [];
      List promoDiscount = [];
      promolist.clear();
      salesOrderPreviewList.clear();
      promoDiscount.clear();
      String pendingReason = pending_status == true ? "Credit limit exceeded" : "";
      print("order booking Items V2=====>>>>>${widget.OrderBookingItemsV2}");
      // for(var i=0; i<tableModel!.message!.boughtItem!.length; i++){
      //   promolist.add(jsonEncode({"docstatus":0,"doctype":"Order Booking V2 Sales Promo","name":"new-order-booking-v2-sales-promo-1","__islocal":1,"__unsaved":1,"owner":Owner,"parent":"new-order-booking-v2-2","parentfield":"promos","parenttype":"Order Booking V2","idx":int.parse("${i + 1}"),"bought_item":tableModel!.message!.boughtItem![i].itemCode,"free_items":tableModel!.message!.boughtItem![i].itemCode,"price":tableModel!.message!.boughtItem![i].averagePrice,"quantity":tableModel!.message!.boughtItem![i].quantityBooked,"warehouse_quantity":tableModel!.message!.boughtItem![i].quantityAvailable,"promo_type":"Buy x get same x"}));
      //   print("promolist======>>>$promolist");
      // }
      for(var i=0; i<tableModel!.message!.salesPromosItems!.length; i++){
        promolist.add(jsonEncode({"docstatus":0,"doctype":"Order Booking V2 Sales Promo","name":"new-order-booking-v2-sales-promo-1","__islocal":1,"__unsaved":1,"owner":Owner,"parent":"new-order-booking-v2-2","parentfield":"promos","parenttype":"Order Booking V2","idx":int.parse("${i + 1}"),"bought_item":tableModel!.message!.salesPromosItems![i].boughtItem,"free_items":tableModel!.message!.salesPromosItems![i].promoItem,"price":tableModel!.message!.salesPromosItems![i].dic,"quantity":tableModel!.message!.salesPromosItems![i].dicQty,"warehouse_quantity":tableModel!.message!.salesPromosItems![i].wQty,"promo_type":tableModel!.message!.salesPromosItems![i].promoType}));
        print("promolist======>>>$promolist");
      }
      for(var i=0; i<tableModel!.message!.salesOrder!.salesOrder!.length; i++){
        salesOrderPreviewList.add(jsonEncode({"docstatus":0,"doctype":"Order booking V2 Sales Order Preview","name":"new-order-booking-v2-sales-order-preview-2","__islocal":1,"__unsaved":1,"owner":Owner,"parent":"new-order-booking-v2-2","parentfield":"sales_order_preview","parenttype":"Order Booking V2","idx":int.parse("${i+1}"),"item_code": tableModel!.message!.salesOrder!.salesOrder![i].itemCode,"quantity_available":tableModel!.message!.salesOrder!.salesOrder![i].qtyAvailable,"quantity":tableModel!.message!.salesOrder!.salesOrder![i].qty,"average":tableModel!.message!.salesOrder!.salesOrder![i].averagePrice,"promo_type":tableModel!.message!.salesOrder!.salesOrder![i].promoType,"warehouse":tableModel!.message!.salesOrder!.salesOrder![i].warehouse}));
        print("salesOrderPreviewList======>>>$salesOrderPreviewList");
      }
      for(var i=0; i<tableModel!.message!.salesPromoDiscountedAmount!.length; i++){
        promoDiscount.add(jsonEncode({"docstatus":0,"doctype":"Order Booking V2 Sales Promo Discount","name":"new-order-booking-v2-sales-promo-discount-1","__islocal":1,"__unsaved":1,"owner":Owner,"parent":"new-order-booking-v2-2","parentfield":"promos_discount","parenttype":"Order Booking V2","idx":int.parse("${i + 1}"),"promo_type": tableModel!.message!.salesPromoDiscountedAmount![i].promoType,"qty": tableModel!.message!.salesPromoDiscountedAmount![i].qty,"dic": tableModel!.message!.salesPromoDiscountedAmount![i].dic,"dic_qty": tableModel!.message!.salesPromoDiscountedAmount![i].dicQty,"rate": tableModel!.message!.salesPromoDiscountedAmount![i].rate,"bought_item": tableModel!.message!.salesPromoDiscountedAmount![i].boughtItem,"free_item": tableModel!.message!.salesPromoDiscountedAmount![i].promoItem,"quantity": tableModel!.message!.salesPromoDiscountedAmount![i].dicQty,"discount": tableModel!.message!.salesPromoDiscountedAmount![i].dic,"promo_item": tableModel!.message!.salesPromoDiscountedAmount![i].promoItem,"w_qty": tableModel!.message!.salesPromoDiscountedAmount![i].wQty}));
        print("promoDiscountlist======>>>$promoDiscount");
      }
      String customer = jsonEncode(prefscustomer);
      String customerType = jsonEncode(prefscust_type);
      String company = jsonEncode(prefscompany);
      String customer_name = jsonEncode(customerName);
      print("doc===>>>${'{"docstatus":0,"doctype":"Order Booking V2","name":"new-order-booking-v2-2","__islocal":1,"pending_reason":"$pendingReason","__unsaved":1,"owner":$Owner,"company":$company,"customer_type":$customerType,"customer_name":$customer_name,"customer":$customer,"credit_limit": $Creditlimit,"unpaid_amount": $Unpaidamount,"order_booking_items_v2":${widget.OrderBookingItemsV2},"order_booking_so":null,"hunting_quotation":null}'}");
      print("doc2===>>>${'"promos":${promolist},"promos_discount": ${promoDiscount}'},");
      print("doc3===>>>${'"sales_order_preview":$salesOrderPreviewList'}}");
    var request = http.MultipartRequest('POST', Uri.parse(saveOrder()));
    print("Uri.parse(saveOrder()) ${Uri.parse(saveOrder())}");
    request.fields.addAll({
      // 'doc': '{"docstatus":0,"doctype":"Order Booking V2","name":"new-order-booking-v2-2","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","company":"Bharath Medical & General Agencies","customer_type":"Retail,"customer_name":"Banashankari Medicals","customer":"CUST-R-00002","order_booking_items_v2":[{"docstatus":0,"doctype":"Order Booking Items V2","name":"new-order-booking-items-v2-2","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","quantity_available":${tableModel!.message!.salesOrder!.salesOrder![0].qtyAvailable.toString()},"gst_rate":"12","rate_contract":"0","rate_contract_check":0,"parent":"new-order-booking-v2-2","parentfield":"order_booking_items_v2","parenttype":"Order Booking V2","idx":1,"__unedited":false,"stock_uom":"Unit","item_code":${tableModel!.message!.salesOrder!.salesOrder![0].itemCode.toString()},"average_price":${tableModel!.message!.salesOrder!.salesOrder![0].averagePrice.toString()},"amount_after_gst":140,"brand_name":"Sanofi","quantity_booked":${tableModel!.message!.salesOrder!.salesOrder![0].qty.toString()},"amount":${tableModel!.message!.salesOrder!.salesOrder![0].averagePrice.toString()}}],"order_booking_so":null,"hunting_quotation":null,"promos":[{"docstatus":0,"doctype":"Order Booking V2 Sales Promo","name":"new-order-booking-v2-sales-promo-1","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","parent":"new-order-booking-v2-2","parentfield":"promos","parenttype":"Order Booking V2","idx":1,"bought_item":${tableModel!.message!.boughtItem![0].itemCode.toString()},"free_items":${tableModel!.message!.boughtItem![0].itemCode.toString()},"price":${tableModel!.message!.boughtItem![0].amount.toString()},"quantity":${tableModel!.message!.boughtItem![0].quantityBooked.toString()},"warehouse_quantity":${tableModel!.message!.boughtItem![0].quantityAvailable.toString()},"promo_type":"Buy x get same x"}],"promos_discount":[],"sales_order_preview":[{"docstatus":0,"doctype":"Order booking V2 Sales Order Preview","name":"new-order-booking-v2-sales-order-preview-2","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","parent":"new-order-booking-v2-2","parentfield":"sales_order_preview","parenttype":"Order Booking V2","idx":1,"item_code":${tableModel!.message!.salesOrder!.salesOrder![0].itemCode.toString()},"quantity_available":${tableModel!.message!.salesOrder!.salesOrder![0].qtyAvailable.toString()},"quantity":${tableModel!.message!.salesOrder!.salesOrder![0].qty.toString()},"average":${tableModel!.message!.salesOrder!.salesOrder![0].averagePrice.toString()},"promo_type":${tableModel!.message!.salesOrder!.salesOrder![0].promoType.toString()},"warehouse":${tableModel!.message!.salesOrder!.salesOrder![0].warehouse.toString()}},{"docstatus":0,"doctype":"Order booking V2 Sales Order Preview","name":"new-order-booking-v2-sales-order-preview-3","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","parent":"new-order-booking-v2-2","parentfield":"sales_order_preview","parenttype":"Order Booking V2","idx":2,"item_code":${tableModel!.message!.salesOrder!.salesOrder![0].itemCode.toString()},"quantity_available":${tableModel!.message!.salesOrder!.salesOrder![0].qtyAvailable.toString()},"quantity":${tableModel!.message!.salesOrder!.salesOrder![0].qty.toString()},"average":${tableModel!.message!.salesOrder!.salesOrder![0].averagePrice.toString()},"promo_type":${tableModel!.message!.salesOrder!.salesOrder![0].promoType.toString()},"warehouse":${tableModel!.message!.salesOrder!.salesOrder![0].warehouse.toString()}}]}',
      'doc': '{"docstatus":0,"doctype":"Order Booking V2","name":"new-order-booking-v2-2","__islocal":1,"pending_reason":"$pendingReason","__unsaved":1,"owner":$Owner,"company":$company,"customer_type":$customerType,"customer_name":$customer_name,"customer":$customer,"credit_limit": $Creditlimit,"unpaid_amount": $Unpaidamount,"order_booking_items_v2":${widget.OrderBookingItemsV2},"order_booking_so":null,"hunting_quotation":null,"promos":${promolist},"promos_discount": ${promoDiscount},"sales_order_preview":$salesOrderPreviewList}',
      'action': 'Save'
    });
    request.headers.addAll(commonHeaders);
    print("widget.OrderBookingItemsV2===>>>${widget.OrderBookingItemsV2}");
    print("promos===>>>${promolist}");
    print("promos discount===>>>${promoDiscount}");
    print("sales order===>>>${salesOrderPreviewList}");
    // abc(status: "pending_save",jeson: '{"docstatus":0,"doctype":"Order Booking V2","name":"new-order-booking-v2-2","__islocal":1,"pending_reason":"$pendingReason","__unsaved":1,"owner":$Owner,"company":$company,"customer_type":$customerType,"customer_name":$customer_name,"customer":$customer,"order_booking_items_v2":${widget.OrderBookingItemsV2},"order_booking_so":null,"hunting_quotation":null,"promos":${promolist},"promos_discount": ${promoDiscount},"sales_order_preview":$salesOrderPreviewList}');
    // http.StreamedResponse response = await request.send();
    var streamedResponse = await request.send();
    print("streamedResponse===${streamedResponse.request}");
    var response = await http.Response.fromStream(streamedResponse);
    print("response.statusCode ${response.statusCode}");
    if (response.statusCode == 200) {
      setState(() {
        print(response.body);
        String data = response.body;
        // isNotEditableLoad = false;
        print("table call");
        saveModel = SaveModel.fromJson(json.decode(data));
        print("this is promos discount${saveModel!.docs![0]}");
        print("this is promos discount${saveModel!.docs![0].promosDiscount}");
        isSaveload = false;
        isSaved = true;
        fluttertoast(whiteColor, greyLightColor, "Save Successful");
      });
    } else {
      setState(() {
        isSaveload = false;
      });
      print(response.reasonPhrase);
    }
  }

  bool isLoadbook = false;
  Future getOrderBooking({customer,order_list,company,customer_type,free_promos,promo_dis,sales_order}) async{
    print("get Order booking call");
    isLoadbook = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var prefscompany = prefs.getString("company");
    print("prefscompany??????$prefscompany");
    var prefscustomer   = prefs.getString("customer");
    print("prefscustomer??????????$prefscustomer");
    var prefscust_type  = prefs.getString("cust_type");
    print("prefscust_type????????$prefscust_type");

    // var book_orderlist = prefs.getString("book_orderlist");
    // print("book_orderlist????????$book_orderlist");
    // var sales_order = prefs.getString("sales_order");
    // print("sales_order????????$sales_order");
    // var free_promos = prefs.getString("free_promos");
    // print("free_promos????????$free_promos");
    // var promo_dis = prefs.getString("promo_dis");
    // print("promo_dis????????$promo_dis");
    // var map = {
    //   'customer': prefscustomer.toString(),
    //   'order_list': book_orderlist.toString(),
    //   'company': prefscompany.toString(),
    //   'customer_type': prefscust_type.toString(),
    //   'free_promos': free_promos.toString(),
    //   'promo_dis': promo_dis.toString(),
    //   'sales_order': sales_order.toString()
    // };
    print("customer ${prefscustomer}");
    print("order_list ${widget.bookOrderList}");
    print("company ${prefscompany}");
    print("customer_type ${prefscust_type}");
    print("freePromos ${freePromos}");
    print("promoDisc ${promoDisc}");
    print("salesOrder ${salesOrder}");
    print(Uri.parse('https://erptest.bharathrajesh.co.in${orderBooking()}'));
    var map = {
      'customer': prefscustomer.toString(),
      'order_list': widget.bookOrderList.toString(),
      'company': prefscompany.toString(),
      'customer_type': prefscust_type.toString(),
      'free_promos': freePromos.toString(),
      'promo_dis': promoDisc.toString(),
      'sales_order': salesOrder.toString(),
      // 'customer': jsonEncode(prefscustomer),
      // 'order_list': jsonEncode(widget.bookOrderList),
      // 'company': jsonEncode(prefscompany),
      // 'customer_type': jsonEncode(prefscust_type),
      // 'free_promos': jsonEncode(freePromos),
      // 'promo_dis': jsonEncode(promoDisc),
      // 'sales_order': jsonEncode(salesOrder),
    };
    // print("map ${map}");

    var request = http.MultipartRequest('POST', Uri.parse('https://erptest.bharathrajesh.co.in${orderBooking()}'));
    request.fields.addAll(map);
    print("request.fields ${request.fields}");
    request.headers.addAll(commonHeaders);

    // http.StreamedResponse response = await request.send();
    // print("response.statusCode ${response.statusCode}");
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    print("response ${response.body}");
    if (response.statusCode == 200) {
      setState(() {
        print(response.body);
        var res = json.decode(response.body);
        print("so_name is===>>${res['message']['so_name']}");
        print("qo_name is===>>${res['message']['qo_name']}");
        submit("Approved","",order_booking_so: res['message']['so_name'],hunting_quotation: res['message']['qo_name']);
      });
    }
    else {
      print("orderBooking Else");
      print(response.reasonPhrase);
      print(response.statusCode);
      setState(() {
        isLoadbook = false;
      });
    }
    [{"docstatus":0,"doctype":"Order Booking Items V2","name":"new-order-booking-items-v2-7","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","quantity_available":52,"gst_rate":"12","rate_contract":"0","rate_contract_check":0,"parent":"new-order-booking-v2-1","parentfield":"order_booking_items_v2","parenttype":"Order Booking V2","idx":1,"__unedited":false,"stock_uom":"Unit","item_code":"Demo Item 4","average_price":170,"amount_after_gst":180,"brand_name":"Johnson & Johnson","__checked":0,"quantity_booked":22,"amount":3740}];
    [{"docstatus":0,"doctype":"Order Booking V2 Sales Promo","name":"new-order-booking-v2-sales-promo-1","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","parent":"new-order-booking-v2-1","parentfield":"promos","parenttype":"Order Booking V2","idx":1,"bought_item":"Demo Item 4","free_items":"Demo Item 4","price":0,"quantity":4,"warehouse_quantity":20,"promo_type":"Buy x get same and discount for ineligible qty"}];
    [{"docstatus":0,"doctype":"Order Booking V2 Sales Discount","name":"new-order-booking-v2-sales-discount-1","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","parent":"new-order-booking-v2-1","parentfield":"promos_discount","parenttype":"Order Booking V2","idx":1,"bought_item":"Demo Item 4","free_item":"Demo Item 4","quantity":2,"discount":136,"promo_type":"Buy x get same and discount for ineligible qty","amount":272}];
    [{"docstatus":0,"doctype":"Order booking V2 Sales Order Preview","name":"new-order-booking-v2-sales-order-preview-1","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","parent":"new-order-booking-v2-1","parentfield":"sales_order_preview","parenttype":"Order Booking V2","idx":1,"item_code":"Demo Item 4","quantity_available":52,"quantity":20,"average":170,"promo_type":"None","warehouse":"BMGA Test Warehouse - BMGA"},{"docstatus":0,"doctype":"Order booking V2 Sales Order Preview","name":"new-order-booking-v2-sales-order-preview-2","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","parent":"new-order-booking-v2-1","parentfield":"sales_order_preview","parenttype":"Order Booking V2","idx":2,"item_code":"Demo Item 4","quantity_available":20,"quantity":4,"average":0,"promo_type":"Buy x get same and discount for ineligible qty","warehouse":"Free Warehouse - BMGA"},{"docstatus":0,"doctype":"Order booking V2 Sales Order Preview","name":"new-order-booking-v2-sales-order-preview-3","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","parent":"new-order-booking-v2-1","parentfield":"sales_order_preview","parenttype":"Order Booking V2","idx":3,"item_code":"Demo Item 4","quantity_available":52,"quantity":2,"average":136,"promo_type":"Buy x get same and discount for ineligible qty","warehouse":"BMGA Test Warehouse - BMGA"}];
  }

  bool isSubmitLoad = false;
  bool isSubmitSuccess = false;
  Future submit(String status,String pendingReason,{order_booking_so,hunting_quotation}) async{
    // print(saveModel!.docs![0].totalAmount);
    // print(saveModel!.docinfo);
    print("status $status");
    String Orderbookingitemsv2 = jsonEncode(saveModel!.docs![0].orderBookingItemsV2);
    String SalesOrderPreview = jsonEncode(saveModel!.docs![0].salesOrderPreview);
    String Promos = jsonEncode(saveModel!.docs![0].promos);
    String Promosdiscount = jsonEncode(saveModel!.docs![0].promosDiscount);
    // List promolist = [];
    // List salesOrderPreviewList = [];
    // List promoDiscount = [];
    String Owner = jsonEncode(owner);
    String customer = jsonEncode(prefscustomer);
    String customerType = jsonEncode(prefscust_type);
    String company = jsonEncode(prefscompany);


    // isSubmitLoad = true;
    print(Owner);
    print(company);
    print(customerType);
    print(customer);
    print({widget.OrderBookingItemsV2});
    // print(jsonEncode(saveModel!.docs![0].customerType));
    // print(jsonEncode(saveModel!.docs![0].customerName));
    // print(jsonEncode(saveModel!.docs![0].unpaidAmount));
    // // print(jsonEncode(saveModel!.docs![0].creditLimit));
    // print(jsonEncode(saveModel!.docs![0].totalAmount));
    // print(jsonEncode(saveModel!.docs![0].doctype));
    // print(jsonEncode(saveModel!.docs![0].orderBookingItemsV2));
    // print(jsonEncode(saveModel!.docs![0].salesOrderPreview));
    // print(jsonEncode(saveModel!.docs![0].promos));
    // print(jsonEncode(saveModel!.docs![0].promosDiscount));
    print(status);
    // var request = http.MultipartRequest('GET', Uri.parse('https://erptest.bharathrajesh.co.in/api/method/frappe.model.workflow.apply_workflow'));
    print("Submit ${Uri.parse(saveOrder())}");
    var request = http.MultipartRequest('Post', Uri.parse(saveOrder()));
      request.fields.addAll({
        // 'doc': '{"docstatus":0,"doctype":"Order Booking V2","name":"new-order-booking-v2-2","__islocal":1,"__unsaved":1,"owner":$Owner,"company":$company,"customer_type":$customerType,"customer_name":"Banashankari Medicals","customer":$customer,"order_booking_items_v2":${widget.OrderBookingItemsV2},"order_booking_so":null,"hunting_quotation":null,"promos":${promolist},"promos_discount": ${promoDiscount},"sales_order_preview":$salesOrderPreviewList}',
          'doc': '{"docstatus":${jsonEncode(saveModel!.docs![0].docstatus)},"doctype":${jsonEncode(saveModel!.docs![0].doctype)},"name":${jsonEncode(saveModel!.docs![0].name)},"creation":${jsonEncode(saveModel!.docs![0].creation)},"modified":${jsonEncode(saveModel!.docs![0].modified)},"modified_by":${jsonEncode(saveModel!.docs![0].modifiedBy)},"idx": ${jsonEncode(saveModel!.docs![0].idx)},"pch_status": "${status}","__unsaved":1,"owner":${jsonEncode(saveModel!.docs![0].owner)},"company":${jsonEncode(saveModel!.docs![0].company)},"customer_type":$customerType,"customer_name":${jsonEncode(saveModel!.docs![0].customerName)},"customer":${jsonEncode(saveModel!.docs![0].customer)},"pending_reason": "${pendingReason}","unpaid_amount": ${jsonEncode(saveModel!.docs![0].unpaidAmount)},"credit_limit": ${jsonEncode(saveModel!.docs![0].creditLimit)},"total_amount": ${jsonEncode(saveModel!.docs![0].totalAmount)},"order_booking_items_v2":${jsonEncode(saveModel!.docs![0].orderBookingItemsV2)},"order_booking_so": ${jsonEncode(order_booking_so)},"hunting_quotation": ${jsonEncode(hunting_quotation)},"promos":${Promos},"promos_discount": ${Promosdiscount},"sales_order_preview":$SalesOrderPreview}',
        // 'doc': '{"name":${jsonEncode(saveModel!.docs![0].name)},"owner":${jsonEncode(saveModel!.docs![0].owner)},"creation":${jsonEncode(saveModel!.docs![0].creation)},"modified":${jsonEncode(saveModel!.docs![0].modified)},"modified_by":${jsonEncode(saveModel!.docs![0].modifiedBy)},"idx":${jsonEncode(saveModel!.docs![0].idx)},"docstatus":${jsonEncode(saveModel!.docs![0].docstatus)},"workflow_state":${jsonEncode(saveModel!.docs![0].workflowState)},"company":"Bharath Medical %26 General Agencies","customer":${jsonEncode(saveModel!.docs![0].customer)},"customer_type":${jsonEncode(saveModel!.docs![0].customerType)},"customer_name":${jsonEncode(saveModel!.docs![0].customerName)},"unpaid_amount":${jsonEncode(saveModel!.docs![0].unpaidAmount)},"credit_limit":${jsonEncode(saveModel!.docs![0].creditLimit)},"total_amount":${jsonEncode(saveModel!.docs![0].totalAmount)},"doctype":${jsonEncode(saveModel!.docs![0].doctype)},"order_booking_items_v2": $Orderbookingitemsv2,"sales_order_preview":$SalesOrderPreview,"promos":$Promos,"promos_discount":$Promosdiscount}',
        // 'doc': '{"name":${jsonEncode(saveModel!.docs![0].name)},"owner":${jsonEncode(saveModel!.docs![0].owner)},"creation":${jsonEncode(saveModel!.docs![0].creation)},"modified":${jsonEncode(saveModel!.docs![0].modified)},"modified_by":${jsonEncode(saveModel!.docs![0].modifiedBy)},"idx":${jsonEncode(saveModel!.docs![0].idx)},"docstatus":${jsonEncode(saveModel!.docs![0].docstatus)},"company":"Bharath Medical %26 General Agencies","customer":${jsonEncode(saveModel!.docs![0].customer)},"customer_type":${jsonEncode(saveModel!.docs![0].customerType)},"customer_name":${jsonEncode(saveModel!.docs![0].customerName)},"unpaid_amount":${jsonEncode(saveModel!.docs![0].unpaidAmount)},"credit_limit":${jsonEncode(saveModel!.docs![0].creditLimit)},"total_amount":${jsonEncode(saveModel!.docs![0].totalAmount)},"doctype":${jsonEncode(saveModel!.docs![0].doctype)},"order_booking_items_v2": $Orderbookingitemsv2,"sales_order_preview":$SalesOrderPreview,"promos":$Promos,"promos_discount":$Promosdiscount,"__unsaved":1,"pending_reason": ""}',
        // 'doc': '{"name":"ORDRV20260","owner":"jeeva@yuvabe.com","creation":"2022-09-10 17:09:23.478118","modified":"2022-09-10 17:09:23.478118","modified_by":"dummy@gmail.com","idx":0,"docstatus":0,"pch_status":"Pending","company":"Bharath Medical & General Agencies","customer":"CUST-R-00002","customer_type":"Retail","pending_reason":"null","customer_name":"Banashankari Medicals","unpaid_amount":0,"credit_limit":0,"total_amount":0,"doctype":"Order Booking v2","order_booking_items_v2":[{"name":"f2fd235ad9","owner":"dummy@gmail.com","creation":"2022-09-10 17:09:23.478118","modified":"2022-09-10 17:09:23.478118","modified_by":"dummy@gmail.com","parent":"ORDRV20254","parentfield":"order_booking_items_v2","parenttype":"Order Booking V2","idx":1,"docstatus":0,"item_code":"Demo Item 4","free_items":0,"stock_uom":"Unit","quantity_available":1138,"quantity_booked":50,"average_price":170,"amount":8500,"gst_rate":12,"amount_after_gst":140,"rate_contract":"0","rate_contract_check":0,"sales_promo":0,"brand_name":"Johnson & Johnson","doctype":"Order Booking Items V2"}],"sales_order_preview":[{"docstatus":0,"doctype":"Order booking V2 Sales Order preview","name":"b270212263","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","parent":"ORDRV20254","parentfield":"sales_order_preview","parenttype":"Order Booking V2","idx":1,"item_code":"Demo Item 4","quantity_available":1138,"quantity":50,"average":170,"promo_type":"None","warehouse":"BMGA Test Warehouse - BMGA"},{"docstatus":0,"doctype":"Order booking V2 Sales Order preview","name":"cbfcf30562","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","parent":"ORDRV20254","parentfield":"sales_order_preview","parenttype":"Order Booking V2","idx":2,"item_code":"Demo Item 4","quantity_available":430,"quantity":10,"average":0,"promo_type":"Buy x get same and discount for ineligible qty","warehouse":"Free Warehouse - BMGA"}],"promos":[{"docstatus":0,"doctype":"Order Booking V2 Sales promo","name":"743db9cbe6","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","parent":"ORDRV20254","parentfield":"promos","parenttype":"Order Booking V2","idx":1,"bought_item":"Demo Item 4","free_items":"Demo Item 4","price":0,"quantity":10,"warehouse_quantity":430,"promo_type":"Buy x get same and discount for ineligible qty"}],"promos_discount":[],"__unsaved":1}',
        'action': 'Submit'
      });
      //print("submit==>>>>??????>>>>>${'{"docstatus":${jsonEncode(saveModel!.docs![0].docstatus)},"doctype":${jsonEncode(saveModel!.docs![0].doctype)},"name":${jsonEncode(saveModel!.docs![0].name)},"creation":${jsonEncode(saveModel!.docs![0].creation)},"modified":${jsonEncode(saveModel!.docs![0].modified)},"modified_by":${jsonEncode(saveModel!.docs![0].modifiedBy)},"idx": ${jsonEncode(saveModel!.docs![0].idx)},"pch_status": "${status}","__unsaved":1,"owner":${jsonEncode(saveModel!.docs![0].owner)},"company":${jsonEncode(saveModel!.docs![0].company)},"customer_type":$customerType,"customer_name":${jsonEncode(saveModel!.docs![0].customerName)},"customer":${jsonEncode(saveModel!.docs![0].customer)},"pending_reason": "${pendingReason}","unpaid_amount": ${jsonEncode(saveModel!.docs![0].unpaidAmount)},"credit_limit": ${jsonEncode(saveModel!.docs![0].creditLimit)},"total_amount": ${jsonEncode(saveModel!.docs![0].totalAmount)},"order_booking_items_v2":${jsonEncode(saveModel!.docs![0].orderBookingItemsV2)},"order_booking_so":null,"hunting_quotation":null,"promos":${Promos},"promos_discount": ${Promosdiscount},"sales_order_preview":$SalesOrderPreview}'}");
      // abc(status: "pending_submit",jeson: '{"docstatus":${jsonEncode(saveModel!.docs![0].docstatus)},"doctype":${jsonEncode(saveModel!.docs![0].doctype)},"name":${jsonEncode(saveModel!.docs![0].name)},"creation":${jsonEncode(saveModel!.docs![0].creation)},"modified":${jsonEncode(saveModel!.docs![0].modified)},"modified_by":${jsonEncode(saveModel!.docs![0].modifiedBy)},"idx": ${jsonEncode(saveModel!.docs![0].idx)},"pch_status": "${status}","__unsaved":1,"owner":${jsonEncode(saveModel!.docs![0].owner)},"company":${jsonEncode(saveModel!.docs![0].company)},"customer_type":$customerType,"customer_name":${jsonEncode(saveModel!.docs![0].customerName)},"customer":${jsonEncode(saveModel!.docs![0].customer)},"pending_reason": "${pendingReason}","unpaid_amount": ${jsonEncode(saveModel!.docs![0].unpaidAmount)},"credit_limit": ${jsonEncode(saveModel!.docs![0].creditLimit)},"total_amount": ${jsonEncode(saveModel!.docs![0].totalAmount)},"order_booking_items_v2":${jsonEncode(saveModel!.docs![0].orderBookingItemsV2)},"order_booking_so":null,"hunting_quotation":null,"promos":${Promos},"promos_discount": ${Promosdiscount},"sales_order_preview":$SalesOrderPreview}');
      print("here is fields===>>>${request.fields}");
      request.headers.addAll(commonHeaders);
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      print("response.statusCode ${response.statusCode}");
      print("response.body ${response.body}");
      if (response.statusCode == 200) {
        setState(() {
          print(response.body);
          var d = json.decode(response.body);
          print("wdjui====${d['_server_messages']}");
          // String data = response.body;
          // isNotEditableLoad = false;
          print("submit table call");
          // saveModel = SaveModel.fromJson(json.decode(data));
          // print("${saveModel!.docs}");
          isSubmitLoad = false;
          isSubmitSuccess = true;
          fluttertoast(whiteColor, greyLightColor, "Submit Successful");
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          pushScreen(context, OrderBookingUi());
        });
      } else {
        setState(() {
          isSubmitLoad = false;
        });
        print(response.reasonPhrase);
      }

    // var headers = {
    //   'Cookie': 'full_name=Prithvi%20Chowhan; sid=8bdd72c36fae79af4d380084ce31b0f040ceaead1bcc7541f0603d74; system_user=yes; user_id=dummy%40gmail.com; user_image='
    // };
    // var request = http.Request('GET', Uri.parse('https://erptest.bharathrajesh.co.in/api/method/frappe.model.workflow.apply_workflow?doc={"name":${jsonEncode(saveModel!.docs![0].name)},"owner":${jsonEncode(saveModel!.docs![0].owner)},"creation":${jsonEncode(saveModel!.docs![0].creation)},"modified":${jsonEncode(saveModel!.docs![0].modified)},"modified_by":${jsonEncode(saveModel!.docs![0].modifiedBy)},"idx":${jsonEncode(saveModel!.docs![0].idx)},"docstatus":${jsonEncode(saveModel!.docs![0].docstatus)},"workflow_state":${jsonEncode(saveModel!.docs![0].workflowState)},"company":"Bharath Medical %26 General Agencies","customer":${jsonEncode(saveModel!.docs![0].customer)},"customer_type":${jsonEncode(saveModel!.docs![0].customerType)},"customer_name":${jsonEncode(saveModel!.docs![0].customerName)},"unpaid_amount":${jsonEncode(saveModel!.docs![0].unpaidAmount)},"credit_limit":${jsonEncode(saveModel!.docs![0].creditLimit)},"total_amount":${jsonEncode(saveModel!.docs![0].totalAmount)},"doctype":${jsonEncode(saveModel!.docs![0].doctype)},"order_booking_items_v2": $Orderbookingitemsv2,"sales_order_preview":$SalesOrderPreview,"promos":$Promos,"promos_discount":$Promosdiscount}&action=Submit'));

  }

  bool deleteLoading = false;
  var deleteRes;

  Future DeleteOrder({id}) async {
    Navigator.pop(context);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row (children: [
            CircularProgressIndicator(
              valueColor:AlwaysStoppedAnimation<Color>(textcolor),
            ),
            Container(margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
          ]),
        );
      },
    );
    print("call");
    deleteLoading = true;
    var request = http.MultipartRequest('POST', Uri.parse(deleteOrder()));

    request.fields.addAll({
      'doctype': 'Order Booking V2',
      'name': id
    });

    request.headers.addAll(commonHeaders);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      setState(() {
        isSaved = false;
        fluttertoast(whiteColor, greyLightColor, "Order Discarded Successful");
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        pushScreen(context, OrderBookingUi());
        print(response.body);
        String data = response.body;
        deleteRes = json.decode(data);
        deleteLoading = false;
        print("delete success");
        print("delete res====>>>$deleteRes");
      });
    } else {
      print("error cause===>>${response.reasonPhrase}");
      setState(() {
        deleteLoading = false;
      });
    }
  }

  Future<bool> _onWillPop() async {
    return isSaved == true && isSubmitSuccess == false ? (await  showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AlertDialog(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Discard changes?'),
                  SizedBox(height: 10),
                  Text('Going back will discard all your changes.',style: TextStyle(color: greyLightColor,fontSize: 15)),
                ],
              ),
              actions: [
                MaterialButton(onPressed: (){DeleteOrder(id: saveModel!.docs![0].name);},child: Text("Yes",style: TextStyle(color: whiteColor)),color: textcolor,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                MaterialButton(onPressed: (){Navigator.pop(context);},child: Text("No",style: TextStyle(color: whiteColor)),color: textcolor,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
              ],
            )
         )) : true;
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(55),
          child: CustomAppBar(
            title: Text('Order Booking', style: TextStyle(color: textcolor)),
            leading: IconButton(
              onPressed: () async{
                isSaved == true && isSubmitSuccess == false ? (await  showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => AlertDialog(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Discard changes?'),
                      SizedBox(height: 10),
                      Text('Going back will discard all your changes.',style: TextStyle(color: greyLightColor,fontSize: 15)),
                    ],
                  ),
                  actions: [
                    MaterialButton(onPressed: (){DeleteOrder(id: saveModel!.docs![0].name);},child: Text("Yes",style: TextStyle(color: whiteColor)),color: textcolor,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                    MaterialButton(onPressed: (){Navigator.pop(context);},child: Text("No",style: TextStyle(color: whiteColor)),color: textcolor,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                  ],
                )
                )) : Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: textcolor,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(child:  isTableLoad == true
                ? Container(height: MediaQuery.of(context).size.height,child: Center(child: CircularProgressIndicator()))
                : Container(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      tableModel!.message!.salesOrder!.salesOrder!.isEmpty
                          ? Container()
                          : header("Sales Order Preview"),
                      // SizedBox(height: 8),
                      tableModel!.message!.salesOrder!.salesOrder!.isEmpty
                          ? Container()
                          : listSalesOrderPreview(tableModel!.message!.salesOrder!.salesOrder!),
                      tableModel!.message!.salesPromosItems!.isEmpty
                          ? Container()
                          : header("Promos"),
                      tableModel!.message!.salesPromosItems!.isEmpty
                          ? Container()
                          : listPromosView(tableModel!.message!.salesPromosItems!),
                      tableModel!.message!.salesPromoDiscountedAmount!.isEmpty
                          ? Container()
                          : header("Promos Discount"),
                      tableModel!.message!.salesPromoDiscountedAmount!.isEmpty
                          ? Container()
                      // : listPromosDiscountView(tableModel!.message!.salesPromoDiscount!.promos!),
                          : listPromosDiscountView(tableModel!.message!.salesPromoDiscountedAmount!),
                    ],
                  ),
                ),
              ),
            ),),
            if(isSaved == false)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(onPressed: (){
                SaveData(context);
              },height: 50,minWidth: double.infinity,color: textcolor,child: isSaveload == true? Container(height: 20,width: 20,child: CircularProgressIndicator(color: Colors.white)) : Text("Save",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold)),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
            ),
            if(isSaved == true)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(onPressed: (){
                setState(() {
                  if(pending_status == true){
                    print("if");
                    if(isSaved == true){
                      submit("Pending","Credit limit exceeded");
                    }
                    else{
                      fluttertoast(whiteColor, redColor, 'Please Save Order First Then Submit Order');
                    }
                  }else{
                    print("else");
                    //not pending
                    if(isSaved == true){
                      getOrderBooking();
                    }
                    else{
                      fluttertoast(whiteColor, redColor, 'Please Save Order First Then Submit Order');
                    }
                  }
                });
              },height: 50,minWidth: double.infinity,color: textcolor,child: isSubmitLoad == true? Container(height: 20,width: 20,child: CircularProgressIndicator(color: Colors.white)) : Text("Submit",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold)),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
            ),
            SizedBox(height: 5)
          ],
        )
      ),
    );
  }

  header(String s) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(s,style: TextStyle(fontSize: 18)),
    );
  }

  listSalesOrderPreview(List<SalesOrderElement> list) {
    // var formatter = NumberFormat('#,##,000');
    NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        child:  ListView.builder(
          itemCount: list.length,
          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context,index){
            var t;
            t = list.map((item) => item.qty * item.averagePrice)
                .reduce((ele1, ele2) => ele1 + ele2);
            print("t $t");
            print("widget.creditLimit ${widget.creditLimit}");
            if((t + double.parse(widget.unPaidAmount)) >= double.parse(widget.creditLimit)) {
                pending_status = true;
                print("pending_reason = Credit limit exceeded");
            }
            else{
              pending_status = false;
              print("pch_status = Pending");
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(list[index].itemCode.toString(),style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 2),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("PromoType : ",style: TextStyle(fontWeight: FontWeight.bold)),
                            Container(
                              width: MediaQuery.of(context).size.width / 2.5,
                              child: Text(
                                "${list[index].promoType}",style: TextStyle(color: Colors.grey),
                                // maxLines: 2,overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Text("PromoType : ",style: TextStyle(fontWeight: FontWeight.bold,)),
                            // Container(
                            //   width: MediaQuery.of(context).size.width / 1.7,
                            //   child: Text(
                            //     "PromoType : ${list[index].promoType}",style: TextStyle(fontWeight: FontWeight.bold,),
                            //       // maxLines: 2,overflow: TextOverflow.ellipsis,
                            //   ),
                            // ),
                          ],
                        ),
                        // Text("PromoType : ${list[index].promoType}",style: TextStyle(color: Colors.grey),maxLines: 2,overflow: TextOverflow.ellipsis),
                        SizedBox(height: 2),
                        Text(
                          "₹${list[index].qty} x ₹${list[index].averagePrice}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                  list[index].qty * list[index].averagePrice == 0 ? "₹0" : "₹" + myFormat.format(list[index].qty * list[index].averagePrice).toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  listPromosView(List<SalesPromoDiscountedAmount> list) {
    // var formatter = NumberFormat('#,##,000');
    NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
        elevation: 5,
        child: ListView.builder(
          itemCount: list.length,
          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context,index){
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(list[index].boughtItem.toString(),style: TextStyle(fontWeight: FontWeight.bold,),),
                      SizedBox(height: 2,),
                      Row(
                        children: [
                          Text("Free Item : ",style: TextStyle(fontWeight: FontWeight.bold,),),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Text(
                              "${list[index].promoItem}",
                              style: TextStyle(color: Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2,),
                      Text(
                        "${list[index].qty} Quantity",
                        style: TextStyle(fontWeight: FontWeight.bold,),
                        maxLines: 1,overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("PromoType : ",style: TextStyle(fontWeight: FontWeight.bold,)),
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Text(
                              "${list[index].promoType}",style: TextStyle(color: Colors.grey),
                              // maxLines: 2,overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Container(
                          //   width: MediaQuery.of(context).size.width / 1.7,
                          //   child: Text(
                          //     "PromoType : ${list[index].promoType}",style: TextStyle(fontWeight: FontWeight.bold,),
                          //     // maxLines: 2,overflow: TextOverflow.ellipsis,
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(width: 10,),
                  Text(
                      list[index].qty * list[index].amount == 0 ? "₹0" :  "₹" + myFormat.format(list[index].qty * list[index].amount).toString(),
                    style: TextStyle(fontWeight: FontWeight.bold,),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  listPromosDiscountView(List<SalesPromoDiscountedAmount> list) {
    // var formatter = NumberFormat('#,##,000');
    NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
        elevation: 5,
        child:  ListView.builder(
          itemCount: list.length,
          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context,index){
            print("disc is===>>${list[index].promoType}");
            print("dic is===>>${list[index].dic}");
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(list[index].boughtItem.toString(),style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 2,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("PromoItem : ",style: TextStyle(fontWeight: FontWeight.bold)),
                            Container(
                              width: MediaQuery.of(context).size.width / 2.5,
                              child: Text(
                                "${list[index].promoItem}",style: TextStyle(color: Colors.grey),
                                // maxLines: 2,overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("PromoType : ",style: TextStyle(fontWeight: FontWeight.bold)),
                            Container(
                              width: MediaQuery.of(context).size.width / 2.5,
                              child: Text(
                                "${list[index].promoType}",style: TextStyle(color: Colors.grey),
                                // maxLines: 2,overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        // Text("PromoType : "+list[index].promoType.toString(), style: TextStyle(color: Colors.grey),maxLines: 1,overflow: TextOverflow.ellipsis,),
                        SizedBox(height: 2),
                        Text(
                          "₹${list[index].dicQty == null ? "0.0" : list[index].dicQty} x ₹${list[index].dic == null ? "0.0" : list[index].dic}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                  (list[index].dicQty == null ? 0.0 : list[index].dicQty)! * (list[index].dic == null || list[index].dic == "0" ? 0.0 : list[index].dic) == 0 ? "₹0" :  "₹" + myFormat.format((list[index].dicQty == null ? 0.0 : list[index].dicQty)! * (list[index].dic == null ? 0.0 : list[index].dic)).toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // DataTable _createDataTable() {
  //   return DataTable(
  //       columns: _createColumns(),
  //       rows: _createRows(),
  //       border: TableBorder.all(color: Colors.black));
  // }
  //
  // DataTable _createPromosDataTable() {
  //   return DataTable(
  //       columns: _createpromosColumns(),
  //       rows: _createPromosRows(),
  //       border: TableBorder.all(color: Colors.black));
  // }
  //
  // DataTable _createPromosDiscountDataTable() {
  //   return DataTable(
  //       columns: _createpromosDiscountColumns(),
  //       rows: _createPromosDiscountRows(),
  //       border: TableBorder.all(color: Colors.black));
  // }

  // List<DataColumn> _createColumns() {
  //   return [
  //     DataColumn(label: Expanded(child: Text('Item Code'))),
  //     DataColumn(label: Expanded(child: Text('Quantity Available'))),
  //     DataColumn(label: Expanded(child: Text('Quantity'))),
  //     DataColumn(label: Expanded(child: Text('Latest Batch Price'))),
  //     DataColumn(label: Expanded(child: Text('Promo Type')))
  //   ];
  // }
  //
  // List<DataRow> _createRows() {
  //   return tableModel!.message!.salesOrder!.salesOrder!
  //       .map(
  //         (book) => DataRow(
  //           cells: [
  //             DataCell(Expanded(child: Text(book.itemCode.toString()))),
  //             DataCell(Expanded(child: Text(book.qtyAvailable.toString()))),
  //             DataCell(Expanded(child: Text(book.qty.toString()))),
  //             DataCell(Expanded(child: Text(book.averagePrice.toString()))),
  //             DataCell(Expanded(child: Text(book.promoType.toString()))),
  //           ],
  //         ),
  //       )
  //       .toList();
  // }
  //
  // List<DataColumn> _createpromosColumns() {
  //   return [
  //     DataColumn(label: Expanded(child: Text('Bought Item'))),
  //     DataColumn(label: Expanded(child: Text('Warehouse Quantity'))),
  //     DataColumn(label: Expanded(child: Text('Free items'))),
  //     DataColumn(label: Expanded(child: Text('Quantity'))),
  //   ];
  // }
  //
  // List<DataRow> _createPromosRows() {
  //   return tableModel!.message!.salesPromosItems!
  //       .map((book) => DataRow(cells: [
  //             DataCell(Expanded(child: Text(book.boughtItem.toString()))),
  //             DataCell(Expanded(child: Text(book.wQty.toString()))),
  //             DataCell(Expanded(child: Text(book.promoItem.toString()))),
  //             DataCell(Expanded(child: Text(book.qty.toString()))),
  //           ]))
  //       .toList();
  // }
  //
  // List<DataColumn> _createpromosDiscountColumns() {
  //   return [
  //     DataColumn(label: Expanded(child: Text('Bought Item'))),
  //     DataColumn(label: Expanded(child: Text('Free item'))),
  //     DataColumn(label: Expanded(child: Text('Discounted Price'))),
  //     DataColumn(label: Expanded(child: Text('Quantity'))),
  //   ];
  // }
  //
  // List<DataRow> _createPromosDiscountRows() {
  //   return tableModel!.message!.salesPromoDiscount!.promos!
  //       .map((book) => DataRow(cells: [
  //             DataCell(Expanded(child: Text(book.boughtItem.toString()))),
  //             DataCell(Expanded(child: Text(book.boughtItem.toString()))),
  //             DataCell(
  //                 Expanded(child: Text(book.discount.toString()))),
  //             DataCell(Expanded(child: Text(book.forEveryQuantityThatIsBought.toString()))),
  //           ]))
  //       .toList();
  // }
}
