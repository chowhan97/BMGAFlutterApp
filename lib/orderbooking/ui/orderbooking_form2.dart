import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:ebuzz/common/colors.dart';
import 'package:ebuzz/common/custom_appbar.dart';
import 'package:ebuzz/common/navigations.dart';
import 'package:ebuzz/common_models/product.dart';
import 'package:ebuzz/common_service/common_service.dart';
import 'package:ebuzz/config/color_palette.dart';
import 'package:ebuzz/exception/custom_exception.dart';
import 'package:ebuzz/network/base_dio.dart';
import 'package:ebuzz/orderbooking/model/order_booking.dart';
import 'package:ebuzz/orderbooking/service/orderbooking_api_service.dart';
import 'package:ebuzz/orderbooking/ui/orderbooking_form3.dart';
import 'package:ebuzz/orderbooking/ui/orderbooking_form4.dart';
import 'package:ebuzz/salesorder/ui/sales_order_form2.dart';
import 'package:ebuzz/util/apiurls.dart';
import 'package:ebuzz/widgets/custom_card.dart';
import 'package:ebuzz/widgets/custom_textformformfield.dart';
import 'package:ebuzz/widgets/custom_typeahead_formfield.dart';
import 'package:ebuzz/widgets/typeahead_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
// final ValueNotifier<String> _notify = ValueNotifier<String>("");
var item = [{"item_code":"ItemA","quantity_booked":21,"average_price":41,"amount":861,"quantity_available":486}].toString();
var customerType = "Retail";
var companies = "Bharath+Medical+%26+General+Agencies";
var customers = "CUST-R-00010";
var orderList = [{"item_code":"IT002","quantity_booked":21,"average_price":41,"amount":861,"quantity_available":465,"rate_contract_check":0}].toString();
List<OrderBookingItems> oblist = [];
List<String> itemCodeList = [];
List<TextEditingController> itemcodecontrollerlist = <TextEditingController>[];
List<TextEditingController> quantitycontrollerlist = <TextEditingController>[];
List<TextEditingController> quantityavailablecontrollerlist = <TextEditingController>[];
List<TextEditingController> lastbatchpricecontrollerlist = <TextEditingController>[];
List<TextEditingController> ratecontractcontrollerlist = <TextEditingController>[];
List<TextEditingController> mrpcontractcontrollerlist = <TextEditingController>[];
List<TextEditingController> brandcontractcontrollerlist = <TextEditingController>[];
List<TextEditingController> salespromocontrollerlist = <TextEditingController>[];
String customertype = "Retail";
String company = "Bharath+Medical+%26+General+Agencies";
String customer = "CUST-R-00010";
// List<TextEditingController> datecontrollerlist = <TextEditingController>[];

class OrderBookingForm2 extends StatefulWidget {
  final String? company;
  final String? customer;
  final String? customertype;
  final String? itemCode;
  OrderBookingForm2(
      {
      this.company,
      this.customer,
      this.customertype,
      this.itemCode,
      });
  @override
  _OrderBookingForm2State createState() => _OrderBookingForm2State();

}

class _OrderBookingForm2State extends State<OrderBookingForm2> {
  bool _postButtonDisabled = false;

  @override
  void initState() {
    super.initState();
    getItemList();
    print("1. ${widget.company}");
    print("2. ${widget.customer}");
    print("3. ${widget.customertype}");
    print("4. ${widget.itemCode}");
    saveData();
    // print(widget.customer);
    }

    saveData() async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("company", widget.company.toString());
      prefs.setString("customer", widget.customer.toString());
    }

  getItemList() async {
    try {
      List listData = await CommonService().getItemList(context);
      for (int i = 0; i < listData.length; i++) {
        itemCodeList.add(listData[i]['item_code']);
      }
      print("aaaaaaaaa===${itemCodeList.length}");
    } catch (e) {
      throw Exception(e.toString());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: CustomAppBar(
          title: Text('Order booking Form', style: TextStyle(color: whiteColor)),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: whiteColor,
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'Add Button',
            backgroundColor: blueAccent,
            onPressed: () {
              oblist.add(OrderBookingItems(
                  amount: 0,
                  itemcode: '',
                  itemname: '',
                  qty: 0,
                  rate: 0));
              itemcodecontrollerlist.add(TextEditingController());
              quantitycontrollerlist.add(TextEditingController());
              quantityavailablecontrollerlist.add(TextEditingController());
              lastbatchpricecontrollerlist.add(TextEditingController());
              ratecontractcontrollerlist.add(TextEditingController());
              mrpcontractcontrollerlist.add(TextEditingController());
              brandcontractcontrollerlist.add(TextEditingController());
              // salespromocontractcontrollerlist.add(TextEditingController()) == [itemcodecontrollerlist.add(TextEditingController()), quantitycontrollerlist.add(TextEditingController())];
              setState(() {});
            },
            child: Icon(
              Icons.add,
              color: whiteColor,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          FloatingActionButton(
          backgroundColor: blueAccent,
          onPressed:() async{
            // Create for loop of item list
            SharedPreferences prefs = await SharedPreferences.getInstance();
            var owner = prefs.getString("owner");
            List itemcode = [];
            List orderlist = [];
            List OrderBookingItemsV2 = [];
            List Bookorderlist = [];
            itemcode.clear();
            orderlist.clear();
            OrderBookingItemsV2.clear();
            Bookorderlist.clear();
            print("length is==>>${oblist.length}");
            for(var i=0; i< oblist.length; i++){
              itemcode.add(jsonEncode({"item_code":itemcodecontrollerlist[i].text,"quantity_booked": int.parse(quantitycontrollerlist[i].text),"average_price": int.parse(double.parse(lastbatchpricecontrollerlist[i].text).toStringAsFixed(0)),"amount": int.parse(quantitycontrollerlist[i].text) * int.parse(double.parse(lastbatchpricecontrollerlist[i].text).toStringAsFixed(0)),"quantity_available": int.parse(double.parse(quantityavailablecontrollerlist[i].text).toStringAsFixed(0))}));
              orderlist.add(jsonEncode({"item_code":itemcodecontrollerlist[i].text,"quantity_booked": int.parse(quantitycontrollerlist[i].text),"average_price": int.parse(double.parse(lastbatchpricecontrollerlist[i].text).toStringAsFixed(0)),"amount": int.parse(quantitycontrollerlist[i].text) * int.parse(double.parse(lastbatchpricecontrollerlist[i].text).toStringAsFixed(0)),"quantity_available": int.parse(double.parse(quantityavailablecontrollerlist[i].text).toStringAsFixed(0)), "rate_contract_check": int.parse(ratecontractcontrollerlist[i].text)}));
              print("item code====>>>>${itemcode}");
              print("orderlist====>>>>${orderlist}");
              OrderBookingItemsV2.add(jsonEncode({"docstatus":0,"doctype":"Order Booking Items V2","name":"new-order-booking-items-v2-2","__islocal":1,"__unsaved":1,"owner":owner,"quantity_available":int.parse(double.parse(quantityavailablecontrollerlist[i].text).toStringAsFixed(0)),"gst_rate":"12","rate_contract":"0","rate_contract_check":int.parse(ratecontractcontrollerlist[i].text),"parent":"new-order-booking-v2-2","parentfield":"order_booking_items_v2","parenttype":"Order Booking V2","idx":int.parse("${i+1}"),"__unedited":false,"stock_uom":"Unit","item_code":itemcodecontrollerlist[i].text,"average_price":int.parse(double.parse(lastbatchpricecontrollerlist[i].text).toStringAsFixed(0)),"amount_after_gst":int.parse(double.parse(mrpcontractcontrollerlist[i].text).toStringAsFixed(0)),"brand_name":brandcontractcontrollerlist[i].text,"quantity_booked":int.parse(quantitycontrollerlist[i].text),"amount":int.parse(quantitycontrollerlist[i].text) * int.parse(double.parse(lastbatchpricecontrollerlist[i].text).toStringAsFixed(0))}));
              print("OrderBookingItemsV2====>>>>${OrderBookingItemsV2}");
              Bookorderlist.add(jsonEncode({"docstatus":0,"doctype":"Order Booking Items V2","name":"new-order-booking-items-v2-7","__islocal":1,"__unsaved":1,"owner":owner,"quantity_available":int.parse(double.parse(quantityavailablecontrollerlist[i].text).toStringAsFixed(0)),"gst_rate":"12","rate_contract":"0","rate_contract_check":int.parse(ratecontractcontrollerlist[i].text),"parent":"new-order-booking-v2-1","parentfield":"order_booking_items_v2","parenttype":"Order Booking V2","idx":int.parse("${i+1}"),"__unedited":false,"stock_uom":"Unit","item_code":itemcodecontrollerlist[i].text,"average_price":int.parse(double.parse(lastbatchpricecontrollerlist[i].text).toStringAsFixed(0)),"amount_after_gst":int.parse(double.parse(mrpcontractcontrollerlist[i].text).toStringAsFixed(0)),"brand_name":brandcontractcontrollerlist[i].text,"__checked":0,"quantity_booked":quantitycontrollerlist[i].text,"amount":int.parse(quantitycontrollerlist[i].text) * int.parse(double.parse(lastbatchpricecontrollerlist[i].text).toStringAsFixed(0))}));
              print("Bookorderlist====>>>>${Bookorderlist}");
            }
            pushScreen(context,OrderBookingForm4(itemcode: itemcode,orderlist: orderlist,OrderBookingItemsV2: OrderBookingItemsV2,bookOrderList: Bookorderlist));
         },
         child: Icon(
          Icons.arrow_forward,
          color: whiteColor,
        ),
      ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Color(0xffcfd6e7),
        child: oblist.length == 0
            ? Center(child: Text(
                'List is empty',
                style: TextStyle(fontSize: 18, color: blackColor),
              ))
            : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: oblist.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final item = oblist[index];
                            int lastElement = oblist.length - 1;
                            return Column(
                              children: [
                                OBItemsForm(
                                  key: ObjectKey(item),
                                  obi: item,
                                  i: index,
                                  onDelete: () => onDelete(index, lastElement),
                                ),
                              ],
                            );
                          }),
                    ),
                  ],
                ),
            ),
      ),
    );
  }

  onSave() async {
    // total = 0.0;
    // totalQuantity = 0;
    // for (int i = 0; i < oblist.length; i++) {
    //   total += oblist[i].amount;
    //   totalQuantity += oblist[i].qty;
    // }
    // print(total);
    // print(totalQuantity);

    OrderBooking orderBookingModel = OrderBooking(
      docstatus: 0,
      company: widget.company,
      customer: widget.customer,
      orderBookingItems: oblist,
      //orderBookingSalesPromos: splist,
      // basegrandtotal: total,
      // totalqty: totalQuantity,
      // totalnetweight: totalQuantity,
    );
    print(orderBookingModel);
    if (!mounted) return;
    setState(() {
      _postButtonDisabled = true;
    });
    // await OrderBookingService().post(orderBookingModel, context);
    // if (!mounted) return;
    // setState(() {
    //   _postButtonDisabled = false;
    // });
  }

  void assignIndex(int index, int lastElement) {
    for (int i = index; i < lastElement; i++) {
      setState(() {
        oblist[i].itemcode = oblist[i + 1].itemcode;
        oblist[i].qty = oblist[i + 1].qty;
        itemcodecontrollerlist[i].text = oblist[i + 1].itemcode!;
        quantitycontrollerlist[i].text = oblist[i + 1].qty!.toString();
      });
    }
  }

  void onDelete(int index, int lastElement) {
    if (index != lastElement) {
      assignIndex(index, lastElement);
    }
    oblist.removeAt(index);
    itemcodecontrollerlist.removeAt(index);
    quantitycontrollerlist.removeAt(index);
    if (!mounted) return;
    setState(() {});
  }
}

typedef OnDelete();

class OBItemsForm extends StatefulWidget {
  final OrderBookingItems obi;
  final OnDelete onDelete;
  final int i;

  OBItemsForm(
      {required Key key,
      required this.obi,
      required this.onDelete,
      required this.i})
      : super(key: key);
  @override
  _OBItemsFormState createState() => _OBItemsFormState();
}

class _OBItemsFormState extends State<OBItemsForm>
    with AutomaticKeepAliveClientMixin {
  int count = 0;
  Product product = Product();
  DateTime selectedDate = DateTime.now();
  var orderDetails;
  List item = [];
  String txt = " ";
  var prefscompany;
  var prefscustomer;
  var prefscust_type;
  @override
  void initState() {
    super.initState();
  }


  setItemData(String itemCode, int index) async {
    product = await getData(itemCode);
    // print(product);
    print(itemCode);
    oblist[index].rate = double.parse(product.valuationRate.toString());
    oblist[index].qty = 1.0;
    oblist[index].amount = oblist[index].rate! * oblist[index].qty!;
    quantitycontrollerlist[index].text = 1.toString();
    itemcodecontrollerlist[index].text = itemCode;
    // orderDetails = await getOrderBookingDetails(itemCode,customertype,company,customer, context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefscompany    = prefs.getString("company");
      print("prefscompany??????$prefscompany");
      prefscustomer   = prefs.getString("customer");
      print("prefscustomer??????????$prefscustomer");
      prefscust_type  = prefs.getString("cust_type");
      print("prefscust_type????????$prefscust_type");
    });
    print("itemCode==>>${itemCode + prefscust_type + company + prefscustomer}");
    orderDetails = await getOrderBookingDetails(itemCode,prefscust_type,company,prefscustomer, context);
    quantityavailablecontrollerlist[index].text = orderDetails["message"]["available_qty"].toString();
    lastbatchpricecontrollerlist[index].text = orderDetails["message"]["price_details"]["price"].toString();
    ratecontractcontrollerlist[index].text = orderDetails["message"]["price_details"]["rate_contract_check"].toString();
    mrpcontractcontrollerlist[index].text = orderDetails["message"]["price_details"]["mrp"].toString();
    brandcontractcontrollerlist[index].text = orderDetails["message"]["brand_name"]["brand_name"].toString();
    //=============
    var owner = prefs.getString("owner");
    var Bookorderlist = [{"docstatus":0,"doctype":"Order Booking Items V2","name":"new-order-booking-items-v2-7","__islocal":1,"__unsaved":1,"owner":owner,"quantity_available":int.parse(double.parse(quantityavailablecontrollerlist[index].text).toStringAsFixed(0)),"gst_rate":"12","rate_contract":"0","rate_contract_check":int.parse(ratecontractcontrollerlist[index].text),"parent":"new-order-booking-v2-1","parentfield":"order_booking_items_v2","parenttype":"Order Booking V2","idx":1,"__unedited":false,"stock_uom":"Unit","item_code":itemcodecontrollerlist[index].text,"average_price":int.parse(double.parse(lastbatchpricecontrollerlist[index].text).toStringAsFixed(0)),"amount_after_gst":int.parse(double.parse(mrpcontractcontrollerlist[index].text).toStringAsFixed(0)),"brand_name":brandcontractcontrollerlist[index].text,"__checked":0,"quantity_booked":quantitycontrollerlist[index].text,"amount":int.parse(quantitycontrollerlist[index].text) * int.parse(double.parse(lastbatchpricecontrollerlist[index].text).toStringAsFixed(0))}];
    String book_orderlist = jsonEncode(Bookorderlist);
    print("========?????=========$book_orderlist");
    prefs.setString("book_orderlist", book_orderlist);
    // List item = [
    //   for (var i in itemCode)
      
    // ]
      for (int i in item){
       item[i].add(itemCode); 
       print(item);
      }
      // item[i].add(orderDetails["message"]["available_qty"]),
    // print("quantity_booked======>>>>${quantitycontrollerlist[widget.i].text}");
    // print("average_price======>>>>${int.parse(double.parse(lastbatchpricecontrollerlist[widget.i].text).toStringAsFixed(0))}");
    // print("quantity_available======>>>>${int.parse(double.parse(quantityavailablecontrollerlist[widget.i].text).toStringAsFixed(0))}");
    // print("amount======>>>>${int.parse(quantitycontrollerlist[widget.i].text) * int.parse(double.parse(lastbatchpricecontrollerlist[widget.i].text).toStringAsFixed(0))}");
    // print("rate_contract_check======>>>>${int.parse(ratecontractcontrollerlist[widget.i].text)}");
    // var item_code = [{"item_code":itemcodecontrollerlist[widget.i].text,"quantity_booked": int.parse(quantitycontrollerlist[widget.i].text),"average_price": int.parse(double.parse(lastbatchpricecontrollerlist[widget.i].text).toStringAsFixed(0)),"amount": int.parse(quantitycontrollerlist[widget.i].text) * int.parse(double.parse(lastbatchpricecontrollerlist[widget.i].text).toStringAsFixed(0)),"quantity_available": int.parse(double.parse(quantityavailablecontrollerlist[widget.i].text).toStringAsFixed(0))}];
    // var order_list = [{"item_code":itemcodecontrollerlist[widget.i].text,"quantity_booked": int.parse(quantitycontrollerlist[widget.i].text),"average_price": int.parse(double.parse(lastbatchpricecontrollerlist[widget.i].text).toStringAsFixed(0)),"amount": int.parse(quantitycontrollerlist[widget.i].text) * int.parse(double.parse(lastbatchpricecontrollerlist[widget.i].text).toStringAsFixed(0)),"quantity_available": int.parse(double.parse(quantityavailablecontrollerlist[widget.i].text).toStringAsFixed(0)), "rate_contract_check": int.parse(ratecontractcontrollerlist[widget.i].text)}];
    // String item_codeString = jsonEncode(item_code);
    // String order_listString = jsonEncode(order_list);
    // print("========?????=========$item_codeString");
    // print("========?????=========$order_listString");
    // // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString("item_code", item_codeString);
    // prefs.setString("order_list", order_listString);
    // var getitem_code = prefs.getString("item_code");
    // var getorder_list = prefs.getString("order_list");
    // print("========get?????=========$getitem_code");
    // print("========get?????=========$getorder_list");
    //==========================================================================================
    print("quantity_booked======>>>>${quantitycontrollerlist[widget.i].text}");
    print("average_price======>>>>${int.parse(double.parse(lastbatchpricecontrollerlist[widget.i].text).toStringAsFixed(0))}");
    print("quantity_available======>>>>${int.parse(double.parse(quantityavailablecontrollerlist[widget.i].text).toStringAsFixed(0))}");
    print("amount======>>>>${int.parse(quantitycontrollerlist[widget.i].text) * int.parse(double.parse(lastbatchpricecontrollerlist[widget.i].text).toStringAsFixed(0))}");
    print("rate_contract_check======>>>>${int.parse(ratecontractcontrollerlist[widget.i].text)}");
    var item_code = [{"item_code":itemcodecontrollerlist[widget.i].text,"quantity_booked": int.parse(quantitycontrollerlist[widget.i].text),"average_price": int.parse(double.parse(lastbatchpricecontrollerlist[widget.i].text).toStringAsFixed(0)),"amount": int.parse(quantitycontrollerlist[widget.i].text) * int.parse(double.parse(lastbatchpricecontrollerlist[widget.i].text).toStringAsFixed(0)),"quantity_available": int.parse(double.parse(quantityavailablecontrollerlist[widget.i].text).toStringAsFixed(0))}];
    var order_list = [{"item_code":itemcodecontrollerlist[widget.i].text,"quantity_booked": int.parse(quantitycontrollerlist[widget.i].text),"average_price": int.parse(double.parse(lastbatchpricecontrollerlist[widget.i].text).toStringAsFixed(0)),"amount": int.parse(quantitycontrollerlist[widget.i].text) * int.parse(double.parse(lastbatchpricecontrollerlist[widget.i].text).toStringAsFixed(0)),"quantity_available": int.parse(double.parse(quantityavailablecontrollerlist[widget.i].text).toStringAsFixed(0)), "rate_contract_check": int.parse(ratecontractcontrollerlist[widget.i].text)}];
    var order_booking_items_v2 = [{"docstatus":0,"doctype":"Order Booking Items V2","name":"new-order-booking-items-v2-2","__islocal":1,"__unsaved":1,"owner":owner,"quantity_available":int.parse(double.parse(quantityavailablecontrollerlist[widget.i].text).toStringAsFixed(0)),"gst_rate":"12","rate_contract":"0","rate_contract_check":int.parse(ratecontractcontrollerlist[widget.i].text),"parent":"new-order-booking-v2-2","parentfield":"order_booking_items_v2","parenttype":"Order Booking V2","idx":1,"__unedited":false,"stock_uom":"Unit","item_code":itemcodecontrollerlist[widget.i].text,"average_price":int.parse(double.parse(lastbatchpricecontrollerlist[widget.i].text).toStringAsFixed(0)),"amount_after_gst":int.parse(double.parse(mrpcontractcontrollerlist[widget.i].text).toStringAsFixed(0)),"brand_name":brandcontractcontrollerlist[widget.i].text,"quantity_booked":int.parse(quantitycontrollerlist[widget.i].text),"amount":int.parse(quantitycontrollerlist[widget.i].text) * int.parse(double.parse(lastbatchpricecontrollerlist[widget.i].text).toStringAsFixed(0))}];
    String item_codeString = jsonEncode(item_code);
    String order_listString = jsonEncode(order_list);
    String order_booking_items_String = jsonEncode(order_booking_items_v2);
    print("========?????=========$item_codeString");
    print("========?????=========$order_listString");
    print("========?????=========$order_booking_items_String");
    prefs.setString("item_code", item_codeString);
    prefs.setString("order_list", order_listString);
    prefs.setString("order_booking_items_v2", order_booking_items_String);
    var getitem_code = prefs.getString("item_code");
    var getorder_list = prefs.getString("order_list");
    var getorder_booking_items_v2 = prefs.getString("order_booking_items_v2");
    print("========get?????=========$getitem_code");
    print("========get?????=========$getorder_list");
    print("========get?????=========$getorder_booking_items_v2");
    setState(() {});
  }



  //For fetching data from item api in product model
  Future<Product> getData(String text) async {
    try {
      Dio _dio = await BaseDio().getBaseDio();

      final String url = itemDataUrl(text);
      final response = await _dio.get(
        url,
      );
      if (response.statusCode == 200) {
        return Product.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      exception(e, context);
    }
    return Product();
  }

  @override
  Widget build(BuildContext context){
    // result = await getOrderBookingDetails(itemCode,customertype,company,customer, context);
    // print(result["message"]["available_qty"]); 
    super.build(context);
    return Padding(
      padding: EdgeInsets.only(left: 6, top: 4, right: 6, bottom: 4),
      child: CustomCard(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: deleteWidget(),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10, left: 8, right: 8, top: 25),
              child: Column(
                children: [
                  itemCodeField(),
                  SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Brand Name : ",style: TextStyle(fontWeight: FontWeight.bold,)),
                      Expanded(
                        child: Text(
                          "${brandcontractcontrollerlist[widget.i].text}",style: TextStyle(color: Colors.grey),
                          maxLines: 1,overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Quantity Available : ",style: TextStyle(fontWeight: FontWeight.bold,)),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: Text(
                          "${quantityavailablecontrollerlist[widget.i].text}",style: TextStyle(color: Colors.grey),
                          // maxLines: 2,overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Last Batch Price : ",style: TextStyle(fontWeight: FontWeight.bold,)),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: Text(
                          "${lastbatchpricecontrollerlist[widget.i].text}",style: TextStyle(color: Colors.grey),
                          // maxLines: 2,overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("MRP : ",style: TextStyle(fontWeight: FontWeight.bold)),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: Text(
                          "${mrpcontractcontrollerlist[widget.i].text}",style: TextStyle(color: Colors.grey),
                          // maxLines: 2,overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  quantityField()
                  // Row(
                  //   children: [
                  //     SizedBox(width: 5),
                  //     Expanded(child: quantityField()),
                      
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget deleteWidget() {
    return IconButton(
        icon: Icon(Icons.cancel_sharp, color: ColorPalette.red),
        onPressed: widget.onDelete);
  }

  Widget itemCodeField() {
    return CustomTypeAheadFormField(
      controller: itemcodecontrollerlist[widget.i],
      decoration: InputDecoration(
          fillColor: greyColor,
          filled: true,
          isDense: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(5),
          ),
        hintText: 'Select Item Code',
      ),
      label: 'Item Code',
      labelStyle: TextStyle(color: blackColor,fontWeight: FontWeight.bold),
      required: true,
      style: TextStyle(fontSize: 14, color: blackColor),
      itemBuilder: (context, item) {
        return TypeAheadWidgets.itemUi(item);
      },
      onSuggestionSelected: (suggestion) async {
        setItemData(suggestion, widget.i);
        if (!mounted) return;
        setState(() {
          oblist[widget.i].itemcode = suggestion;
        });
        // var result = await getOrderBookingDetails(itemCode,customertype,company,customer, context);
        // print(result["message"]["available_qty"]);
      },
      suggestionsCallback: (pattern) {
        return TypeAheadWidgets.getSuggestions(pattern, itemCodeList);
      },
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      validator: (val) =>
          val == '' || val == null ? 'Item Code should not be empty' : null,

      
    );
  }

  Widget quantityField() {
    return CustomTextFormField(
      controller: quantitycontrollerlist[widget.i],
      onChanged: (value) async{
        if (value != '') {
          oblist[widget.i].qty = double.parse(value);
          if (!mounted) return;
          setState(() {}); // print("quantity_booked======>>>>${quantitycontrollerlist[widget.i].text}");
          // print("average_price======>>>>${int.parse(double.parse(lastbatchpricecontrollerlist[widget.i].text).toStringAsFixed(0))}");
          // print("quantity_available======>>>>${int.parse(double.parse(quantityavailablecontrollerlist[widget.i].text).toStringAsFixed(0))}");
          // print("amount======>>>>${int.parse(quantitycontrollerlist[widget.i].text) * int.parse(double.parse(lastbatchpricecontrollerlist[widget.i].text).toStringAsFixed(0))}");
          // print("rate_contract_check======>>>>${int.parse(ratecontractcontrollerlist[widget.i].text)}");
          var item_code = [{"item_code":itemcodecontrollerlist[widget.i].text,"quantity_booked": int.parse(quantitycontrollerlist[widget.i].text),"average_price": int.parse(double.parse(lastbatchpricecontrollerlist[widget.i].text).toStringAsFixed(0)),"amount": int.parse(quantitycontrollerlist[widget.i].text) * int.parse(double.parse(lastbatchpricecontrollerlist[widget.i].text).toStringAsFixed(0)),"quantity_available": int.parse(double.parse(quantityavailablecontrollerlist[widget.i].text).toStringAsFixed(0))}];
          var order_list = [{"item_code":itemcodecontrollerlist[widget.i].text,"quantity_booked": int.parse(quantitycontrollerlist[widget.i].text),"average_price": int.parse(double.parse(lastbatchpricecontrollerlist[widget.i].text).toStringAsFixed(0)),"amount": int.parse(quantitycontrollerlist[widget.i].text) * int.parse(double.parse(lastbatchpricecontrollerlist[widget.i].text).toStringAsFixed(0)),"quantity_available": int.parse(double.parse(quantityavailablecontrollerlist[widget.i].text).toStringAsFixed(0)), "rate_contract_check": int.parse(ratecontractcontrollerlist[widget.i].text)}];
          print("item_code============${item_code}");
          print("order_list============${order_list}");
          var order_booking_items_v2 = [{"docstatus":0,"doctype":"Order Booking Items V2","name":"new-order-booking-items-v2-2","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","quantity_available":int.parse(double.parse(quantityavailablecontrollerlist[widget.i].text).toStringAsFixed(0)),"gst_rate":"12","rate_contract":"0","rate_contract_check":int.parse(ratecontractcontrollerlist[widget.i].text),"parent":"new-order-booking-v2-2","parentfield":"order_booking_items_v2","parenttype":"Order Booking V2","idx":1,"__unedited":false,"stock_uom":"Unit","item_code":itemcodecontrollerlist[widget.i].text,"average_price":int.parse(double.parse(lastbatchpricecontrollerlist[widget.i].text).toStringAsFixed(0)),"amount_after_gst":int.parse(double.parse(mrpcontractcontrollerlist[widget.i].text).toStringAsFixed(0)),"brand_name":brandcontractcontrollerlist[widget.i].text,"quantity_booked":int.parse(quantitycontrollerlist[widget.i].text),"amount":int.parse(quantitycontrollerlist[widget.i].text) * int.parse(double.parse(lastbatchpricecontrollerlist[widget.i].text).toStringAsFixed(0))}];
          String item_codeString = jsonEncode(item_code);
          String order_listString = jsonEncode(order_list);
          String order_booking_items_String = jsonEncode(order_booking_items_v2);
          // print("========?????=========$item_codeString");
          // print("========?????=========$order_listString");
          // print("========?????=========$order_booking_items_String");
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("item_code", item_codeString);
          prefs.setString("order_list", order_listString);
          prefs.setString("order_booking_items_v2", order_booking_items_String);
          var getitem_code = prefs.getString("item_code");
          var getorder_list = prefs.getString("order_list");
          var getorder_booking_items_v2 = prefs.getString("order_booking_items_v2");
          // print("========get?????=========$getitem_code");
          // print("========get?????=========$getorder_list");
          // print("========get?????=========$getorder_booking_items_v2");
        }

      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          fillColor: greyColor,
          filled: true,
          isDense: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(5),
          )),
      label: 'Quantity',
      labelStyle: TextStyle(color: blackColor,fontWeight: FontWeight.bold),
      style: TextStyle(fontSize: 14, color: blackColor),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

