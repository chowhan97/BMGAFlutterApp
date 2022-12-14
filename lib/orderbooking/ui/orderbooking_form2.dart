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
import 'package:ebuzz/orderbooking/ui/offer_model.dart';
import 'package:ebuzz/orderbooking/ui/orderbooking_form4.dart';
import 'package:ebuzz/util/apiurls.dart';
import 'package:ebuzz/util/constants.dart';
import 'package:ebuzz/widgets/custom_card.dart';
import 'package:ebuzz/widgets/custom_textformformfield.dart';
import 'package:ebuzz/widgets/custom_typeahead_formfield.dart';
import 'package:ebuzz/widgets/typeahead_widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final String? unPaidAmount;
  final String? creditLimit;
  OrderBookingForm2(
      {
      this.company,
      this.customer,
      this.customertype,
      this.itemCode,
        this.creditLimit,
        this.unPaidAmount,
      });
  @override
  _OrderBookingForm2State createState() => _OrderBookingForm2State();

}

class _OrderBookingForm2State extends State<OrderBookingForm2> {
  // bool _postButtonDisabled = false;

  @override
  void initState() {
    super.initState();
    getItemList();
    print("1. ${widget.company}");
    print("2. ${widget.customer}");
    print("3. ${widget.customertype}");
    print("4. ${widget.itemCode}");
    print("5. ${widget.unPaidAmount}");
    print("6. ${widget.creditLimit}");
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
    return WillPopScope(
      onWillPop: ()async{
        setState(() {
          itemCodeList.clear();
        });
        return true;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(55),
          child: CustomAppBar(
            title: Text('Order Booking', style: TextStyle(color: textcolor)),
            leading: IconButton(
              onPressed: () {
                itemCodeList.clear();
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: textcolor,
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
              backgroundColor: Constants.buttonColor,
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
            backgroundColor: Constants.buttonColor,
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
              for(var i=0; i < oblist.length; i++){
                itemcode.add(jsonEncode({"item_code":itemcodecontrollerlist[i].text,"quantity_booked": int.parse(quantitycontrollerlist[i].text),"average_price": int.parse(lastbatchpricecontrollerlist[i].text.replaceAll("???", "").replaceAll(",", "")),"amount": int.parse(quantitycontrollerlist[i].text) * int.parse(lastbatchpricecontrollerlist[i].text.replaceAll("???", "").replaceAll(",", "")),"quantity_available": int.parse(quantityavailablecontrollerlist[i].text.replaceAll("???", "").replaceAll(",", ""))}));
                orderlist.add(jsonEncode({"item_code":itemcodecontrollerlist[i].text,"quantity_booked": int.parse(quantitycontrollerlist[i].text),"average_price": int.parse(lastbatchpricecontrollerlist[i].text.replaceAll("???", "").replaceAll(",", "")),"amount": int.parse(quantitycontrollerlist[i].text) * int.parse(lastbatchpricecontrollerlist[i].text.replaceAll("???", "").replaceAll(",", "")),"quantity_available": int.parse(quantityavailablecontrollerlist[i].text.replaceAll("???", "").replaceAll(",", "")), "rate_contract_check": int.parse(ratecontractcontrollerlist[i].text)}));
                print("item code====>>>>${itemcode}");
                print("orderlist====>>>>${orderlist}");
                OrderBookingItemsV2.add(jsonEncode({"docstatus":0,"doctype":"Order Booking Items V2","name":"new-order-booking-items-v2-2","__islocal":1,"__unsaved":1,"owner":owner,"quantity_available":int.parse(quantityavailablecontrollerlist[i].text.replaceAll("???", "").replaceAll(",", "")),"gst_rate":"12","rate_contract":"0","rate_contract_check":int.parse(ratecontractcontrollerlist[i].text),"parent":"new-order-booking-v2-2","parentfield":"order_booking_items_v2","parenttype":"Order Booking V2","idx":int.parse("${i+1}"),"__unedited":false,"stock_uom":"Unit","item_code":itemcodecontrollerlist[i].text,"average_price":int.parse(lastbatchpricecontrollerlist[i].text.replaceAll("???", "").replaceAll(",", "")),"amount_after_gst":int.parse(mrpcontractcontrollerlist[i].text.replaceAll("???", "").replaceAll(",", "")),"brand_name":brandcontractcontrollerlist[i].text,"quantity_booked":int.parse(quantitycontrollerlist[i].text),"amount":int.parse(quantitycontrollerlist[i].text.replaceAll("???", "")) * int.parse(lastbatchpricecontrollerlist[i].text.replaceAll("???","").replaceAll(",", ""))}));
                print("OrderBookingItemsV2====>>>>${OrderBookingItemsV2}");
                Bookorderlist.add(jsonEncode({"docstatus":0,"doctype":"Order Booking Items V2","name":"new-order-booking-items-v2-7","__islocal":1,"__unsaved":1,"owner":owner,"quantity_available":int.parse(quantityavailablecontrollerlist[i].text.replaceAll("???", "").replaceAll(",", "")),"gst_rate":"12","rate_contract":"0","rate_contract_check":int.parse(ratecontractcontrollerlist[i].text),"parent":"new-order-booking-v2-1","parentfield":"order_booking_items_v2","parenttype":"Order Booking V2","idx":int.parse("${i+1}"),"__unedited":false,"stock_uom":"Unit","item_code":itemcodecontrollerlist[i].text,"average_price":int.parse(lastbatchpricecontrollerlist[i].text.replaceAll("???", "").replaceAll(",", "")),"amount_after_gst":int.parse(mrpcontractcontrollerlist[i].text.replaceAll("???", "").replaceAll(",", "")),"brand_name":brandcontractcontrollerlist[i].text,"__checked":0,"quantity_booked":quantitycontrollerlist[i].text,"amount":int.parse(quantitycontrollerlist[i].text.replaceAll("???", "")) * int.parse(lastbatchpricecontrollerlist[i].text.replaceAll("???", "").replaceAll(",", ""))}));
                print("Bookorderlist====>>>>${Bookorderlist}");
              }
              pushScreen(context,OrderBookingForm4(itemcode: itemcode,orderlist: orderlist,OrderBookingItemsV2: OrderBookingItemsV2,bookOrderList: Bookorderlist,creditLimit: widget.creditLimit,unPaidAmount: widget.unPaidAmount,));
              // oblist.clear();
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
    // setState(() {
    //     //   _postButtonDisabled = true;
    //     // });
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
  bool isOfferAvaibale = false;
  @override
  void initState() {
    itemcodecontrollerlist[widget.i].text = '';
    quantityavailablecontrollerlist[widget.i].text = '';
    lastbatchpricecontrollerlist[widget.i].text = '';
    ratecontractcontrollerlist[widget.i].text = '';
    mrpcontractcontrollerlist[widget.i].text = '';
    brandcontractcontrollerlist[widget.i].text = '';
    quantitycontrollerlist[widget.i].text = '';
    super.initState();
  }

  setItemData(String itemCode, int index) async {
    NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
    print("ggggg==>>${myFormat.format(5000.00)}");
    // var formatter = NumberFormat('#,##,000');
    // var formatter2 = NumberFormat('#,##,0');
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
      prefscompany = prefs.getString("company");
      print("prefscompany??????$prefscompany");
      prefscustomer   = prefs.getString("customer");
      print("prefscustomer??????????$prefscustomer");
      prefscust_type  = prefs.getString("cust_type");
      print("prefscust_type????????$prefscust_type");
    });
    print("itemCode==>>${itemCode + prefscust_type + company + prefscustomer}");
    orderDetails = await getOrderBookingDetails(itemCode,prefscust_type,company,prefscustomer, context);
    orderDetails = await getOrderBookingDetails(itemCode,prefscust_type,company,prefscustomer, context);
    print("orderDetails is=====>>>>>${orderDetails}");
    // quantityavailablecontrollerlist[index].text =  orderDetails["message"]["available_qty"] == 0.0 ? formatter2.format(orderDetails["message"]["available_qty"]):  formatter.format(orderDetails["message"]["available_qty"]);
    quantityavailablecontrollerlist[index].text =  myFormat.format(orderDetails["message"]["available_qty"]);
    // lastbatchpricecontrollerlist[index].text = '???${formatter.format(orderDetails["message"]["price_details"]["price"])}';
    lastbatchpricecontrollerlist[index].text = '???${myFormat.format(orderDetails["message"]["price_details"]["price"])}';
    ratecontractcontrollerlist[index].text = orderDetails["message"]["price_details"]["rate_contract_check"].toString();
    // mrpcontractcontrollerlist[index].text = "???${formatter.format(orderDetails["message"]["price_details"]["mrp"])}";
    mrpcontractcontrollerlist[index].text = "???${myFormat.format(orderDetails["message"]["price_details"]["mrp"])}";
    brandcontractcontrollerlist[index].text = orderDetails["message"]["brand_name"]["brand_name"].toString();
    print("is offer???????${orderDetails['message']['promo_check']}");
    setState(() {
      orderDetails['message']['promo_check'] == 1 ? isOfferAvaibale = true : isOfferAvaibale = false;
    });
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
  bool fetchPromo1 = false;
  bool fetchPromo2 = false;
  bool fetchPromo3 = false;
  bool fetchPromo5 = false;
  var promo1Res;
  var promo2Res;
  var promo3Res;
  var promo5Res;
  List ids = [];
  // var idx = 1;

  Future promoType1({itemCode,promoType,idx}) async {
    print("call");
    // var P1 = jsonEncode(itemCode);
    // print("P1 is===>>>$P1");
    // String pType = jsonEncode(promoType);
    // print("pType is===>>>$pType");
    if(idx == 1)
    fetchPromo1 = true;
    if(idx == 2)
      fetchPromo2 = true;
    if(idx == 3)
      fetchPromo3 = true;
    if(idx == 5)
      fetchPromo5 = true;
    // var headers = {
    //   'Cookie': 'full_name=Vishal%20Patel; sid=a8dd85da2f5ea05156bb1e1a1a83c0b22965ec46a959d0d242d6b46b; system_user=yes; user_id=prithvichowhan97%40gmail.com; user_image=https%3A//secure.gravatar.com/avatar/f8e2205f18d8e3e18fe031120b5aa50b%3Fd%3D404%26s%3D200'
    // };
    var request = http.MultipartRequest('GET', Uri.parse('https://erptest.bharathrajesh.co.in/api/method/frappe.desk.reportview.get'));

    request.fields.addAll({
      'doctype': 'Sales Promos',
      'fields': '["`tabSales Promos`.`name`","`tabSales Promos`.`owner`","`tabSales Promos`.`creation`","`tabSales Promos`.`modified`","`tabSales Promos`.`modified_by`","`tabSales Promos`.`_user_tags`","`tabSales Promos`.`_comments`","`tabSales Promos`.`_assign`","`tabSales Promos`.`_liked_by`","`tabSales Promos`.`docstatus`","`tabSales Promos`.`parent`","`tabSales Promos`.`parenttype`","`tabSales Promos`.`parentfield`","`tabSales Promos`.`idx`","`tabSales Promos`.`start_date`"]',
      'filters': '[[${jsonEncode(promoType)},"bought_item","=",${jsonEncode(itemCode)}]]',
      'order_by': '`tabSales Promos`.`modified` desc',
      'start': '0',
      'page_length': '20',
      'view': 'List',
      'group_by': '`tabSales Promos`.`name`',
      'with_comment_count': 'true'
    });

    request.headers.addAll(commonHeaders);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      // promoType1(itemCode: P1,promoType: "Promo Type 3");
      // promoType1(itemCode: P1,promoType: "Promo Type 5");
      // promoType2(itemCode: P1);
      if(idx == 1){
        setState(() {
          print(response.body);
          String data = response.body;
          promo1Res = json.decode(data);
          fetchPromo1 = false;
          print("promo type 1 success");
          print("promo type 1 res====>>>$promo1Res");
          if(promo1Res['message'].isNotEmpty){
            Id id = Id(p1: promo1Res['message']['values'][0][0]);
            print("??????P1??????===>>${id.p1}");
            ids.add(id.p1);
          }
          promoType1(itemCode: "${itemCode}",promoType: "Promo Type 2",idx: 2);
          // customerOutstandingModel = CustomerOutstandingModel.fromJson(json.decode(data));
          // print("transactionModel====>>$customerOutstandingModel");
        });
      }else if(idx == 2){
        setState(() {
          print(response.body);
          String data = response.body;
          promo2Res = json.decode(data);
          fetchPromo2 = false;
          print("promo type 2 success");
          print("promo type 2 res====>>>$promo2Res");
          if(promo2Res['message'].isNotEmpty){
            Id id = Id(p2: promo2Res['message']['values'][0][0]);
            print("??????P1??????===>>${id.p2}");
            ids.add(id.p2);
          }
          promoType1(itemCode: "${itemCode}",promoType: "Promo Type 3",idx: 3);
          // customerOutstandingModel = CustomerOutstandingModel.fromJson(json.decode(data));
          // print("transactionModel====>>$customerOutstandingModel");
        });
      }else if(idx == 3){
        setState(() {
          print(response.body);
          String data = response.body;
          promo3Res = json.decode(data);
          fetchPromo3 = false;
          print("promo type 3 success");
          print("promo type 3 res====>>>$promo3Res");
          if(promo3Res['message'].isNotEmpty){
            Id id = Id(p3: promo3Res['message']['values'][0][0]);
            print("??????P1??????===>>${id.p3}");
            ids.add(id.p3);
          }
          promoType1(itemCode: "${itemCode}",promoType: "Promo Type 5",idx: 5);
          // customerOutstandingModel = CustomerOutstandingModel.fromJson(json.decode(data));
          // print("transactionModel====>>$customerOutstandingModel");
        });
      }else if(idx == 5){
        setState(() {
          print(response.body);
          String data = response.body;
          promo5Res = json.decode(data);
          fetchPromo5 = false;
          print("promo type 5 success");
          print("promo type 5 res====>>>$promo5Res");
          if(promo5Res['message'].isNotEmpty){
            Id id = Id(p5: promo5Res['message']['values'][0][0]);
            print("??????P1??????===>>${id.p5}");
            ids.add(id.p5);
          }
          print("n is====>>>${ids}");
          showDialog(context: context,builder: (context) =>  CustomDialogue(promo1res: promo1Res,promo2res: promo2Res,promo3res: promo3Res,promo5res: promo5Res,ids: ids));
          // customerOutstandingModel = CustomerOutstandingModel.fromJson(json.decode(data));
          // print("transactionModel====>>$customerOutstandingModel");
        });
      }
    } else {
      print("error cause===>>${response.reasonPhrase}");
      setState(() {
        fetchPromo1 = false;
      });
    }
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
              isOfferAvaibale == true ? Padding(
              padding: EdgeInsets.only(top: 140,right: 10),
              child: Align(
                  alignment: Alignment.centerRight,
                  child: MaterialButton(onPressed: (){
                    print(itemcodecontrollerlist[widget.i].text);
                    showDialog(context: context,builder: (context) =>  CustomDialogue(name: itemcodecontrollerlist[widget.i].text));
                    // ids.clear();
                    // promoType1(itemCode: itemcodecontrollerlist[widget.i].text,promoType: "Promo Type 1",idx: 1);
                  },child: Text("Show Offer",style: TextStyle(color: Colors.white)),color: Constants.buttonColor,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))),
            ) : Container(),
            Padding(
              padding: EdgeInsets.only(bottom: 10, left: 8, right: 8, top: 25),
              child: Column(
                children: [
                  itemCodeField(),
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Brand Name: ",style: TextStyle(fontWeight: FontWeight.bold)),
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
                      Text("Quantity Available: ",style: TextStyle(fontWeight: FontWeight.bold)),
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
                      Text("Last Batch Price: ",style: TextStyle(fontWeight: FontWeight.bold,)),
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
                      Text("MRP: ",style: TextStyle(fontWeight: FontWeight.bold)),
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
      label: 'Item Code:',
      labelStyle: TextStyle(color: blackColor,fontWeight: FontWeight.bold),
      // required: true,
      style: TextStyle(fontSize: 14, color: blackColor),
      itemBuilder: (context, item) {
        print(item);
        return TypeAheadWidgets.itemUi(item);
      },
      onSuggestionSelected: (suggestion) async {
        setItemData(suggestion, widget.i);
        if (!mounted) return;
        setState(() {
          oblist[widget.i].itemcode = suggestion;
        });
        // itemcodecontrollerlist.clear();

        // var result = await getOrderBookingDetails(itemCode,customertype,company,customer, context);
        // print(result["message"]["available_qty"]);
      },
      suggestionsCallback: (pattern) {
        return TypeAheadWidgets.getSuggestions(pattern, itemCodeList);
      },
      // transitionBuilder: (context, suggestionsBox, controller) {
      //   return suggestionsBox;
      // },
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
          // var getitem_code = prefs.getString("item_code");
          // var getorder_list = prefs.getString("order_list");
          // var getorder_booking_items_v2 = prefs.getString("order_booking_items_v2");
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
      label: 'Quantity:',
      labelStyle: TextStyle(color: blackColor,fontWeight: FontWeight.bold),
      style: TextStyle(fontSize: 14, color: blackColor),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class CustomDialogue extends StatefulWidget {
  // var promo1res,promo2res,promo3res,promo5res,ids;
  final promo1res,promo2res,promo3res,promo5res,ids,name;
  CustomDialogue({this.promo1res,this.promo2res,this.promo3res,this.promo5res,this.ids,this.name});

  @override
  State<CustomDialogue> createState() => _CustomDialogueState();
}

class _CustomDialogueState extends State<CustomDialogue> {
  bool showoffer = false;
  OfferModel? offerModel;

  Future showOffer() async {
      print("call");
      setState(() {
        showoffer = true;
      });
      var request = http.Request('GET',Uri.parse(showOfferApi(name: Uri.encodeFull(widget.name))));
      request.headers.addAll(commonHeaders);
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        setState(() {
          print(response.body);
          String data = response.body;
          showoffer = false;
          print("show offer success");
          offerModel = OfferModel.fromJson(json.decode(data));
        });
      }
      else {
        print("error cause===>>${response.reasonPhrase}");
        setState(() {
          showoffer = false;
        });
      }
    }

  @override
  void initState() {
    showOffer();
    print("widget name===>>>${widget.name}");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(5),
      child: showoffer == true ? Container(height: 500,alignment: Alignment.center,child: Container(height: 30,width: 30,child: CircularProgressIndicator(color: textcolor))) : Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            height: 500,
            margin: EdgeInsets.all(5),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  offerModel!.message!.promoTableForQuantityamountBasedDiscount!.isEmpty
                      ? Container()
                      : Text("Quantity Based Promo",
                          style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  offerModel!.message!.promoTableForQuantityamountBasedDiscount!.isEmpty
                      ? Container() :
                  _createDataTable(),
                  SizedBox(height: 5),
                  offerModel!.message!.promosTableOfSameItem!.isEmpty
                      ? Container()
                      : Text("Buy X of item and get Y of same item free", style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  offerModel!.message!.promosTableOfSameItem!.isEmpty
                      ? Container() :
                  _createPromosDataTable(),
                  SizedBox(height: 5),
                  offerModel!.message!.promosTableOfDifferentItems!.isEmpty
                      ? Container()
                      : Text("Buy X of item and get Y of different item free", style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  offerModel!.message!.promosTableOfDifferentItems!.isEmpty
                      ? Container() :
                  _createPromosDiscountDataTable(),
                  SizedBox(height: 5),
                  offerModel!.message!.freeItemForEligibleQuantity!.isEmpty
                      ? Container()
                      : Text("Free Item for Eligible Quantity, Discount for Ineligible Quantity", style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  offerModel!.message!.freeItemForEligibleQuantity!.isEmpty
                      ? Container()
                      : _createTable(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  DataTable _createDataTable() {
    return DataTable(
        columns: _createColumns(),
        rows: _createRows(),
        border: TableBorder.all(color: Colors.black));
  }
  DataTable _createPromosDataTable() {
    return DataTable(
        columns: _createpromosColumns(),
        rows: _createPromosRows(),
        border: TableBorder.all(color: Colors.black));
  }
  DataTable _createPromosDiscountDataTable() {
    return DataTable(
        columns: _createpromosDiscountColumns(),
        rows: _createPromosDiscountRows(),
        border: TableBorder.all(color: Colors.black));
  }
  DataTable _createTable() {
    return DataTable(
        columns: _createtableColumns(),
        rows: _createtableRows(),
        border: TableBorder.all(color: Colors.black));
  }


  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Expanded(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.47,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Quantity',style: TextStyle(fontSize: 11)),
              Text('Bought',style: TextStyle(fontSize: 11)),
            ],
           ),
        ),
      ),
      ),
      DataColumn(label: Expanded(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.47,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Discount',style: TextStyle(fontSize: 11)),
              Text('Slab',style: TextStyle(fontSize: 11)),
            ],
          ),
        ),
      )),
    ];
  }

  List<DataRow> _createRows() {
    return offerModel!.message!.promoTableForQuantityamountBasedDiscount!
        .map((book) => DataRow(
        cells: [
          DataCell(
              Expanded(
                  child: Center(
                    child: Container(
                      // width: 90,
                      width: MediaQuery.of(context).size.width * 0.47,
                      child: Center(
                          child: Text(
                            book.boughtQty.toString(),
                            textAlign: TextAlign.center,style: TextStyle(fontSize: 11),
                          )),
                    ),
                  )),
          ),
          DataCell(
            Expanded(
                child: Center(
                  child: Container(
                    // width: 90,
                    width: MediaQuery.of(context).size.width * 0.47,
                    child: Center(
                        child: Text(
                          "${book.discount.toString()}%",
                          textAlign: TextAlign.center,style: TextStyle(fontSize: 11),
                        )),
                  ),
                )),
          ),
          // DataCell(Container(color: Colors.yellow,width: MediaQuery.of(context).size.width * 0.5,child: Text(book.quantityBought.toString()))),
          // DataCell(Container(color: Colors.green,width: MediaQuery.of(context).size.width * 0.5,child: Text("${book.discountPercentage.toString()}%"))),
        ],
      ),
    ).toList();
  }

  List<DataColumn> _createpromosColumns() {
    return [
      DataColumn(label: Expanded(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Item',style: TextStyle(fontSize: 11)),
              Text('Bought',style: TextStyle(fontSize: 11)),
            ],
          ),
        ),
      )),
      DataColumn(label: Expanded(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Free',style: TextStyle(fontSize: 11)),
              Text('Item',style: TextStyle(fontSize: 11)),
            ],
          ),
        ),
      )),
      DataColumn(label: Expanded(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Eligible',style: TextStyle(fontSize: 11)),
              Text('Quantity',style: TextStyle(fontSize: 11)),
            ],
          ),
        ),
      )),
      DataColumn(label: Expanded(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Free',style: TextStyle(fontSize: 11)),
              Text('Quantity',style: TextStyle(fontSize: 11)),
            ],
          ),
        ),
      )),
      // DataColumn(label: Expanded(child: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Text('Item'),
      //       Text('Bought'),
      //     ],
      //   ),
      // ))),
      // DataColumn(label: Expanded(child: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Text('Free'),
      //       Text('Item'),
      //     ],
      //   ),
      // ))),
      // DataColumn(label: Expanded(child: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Text('Eligible'),
      //       Text('Quantity'),
      //     ],
      //   ),
      // ))),
      // DataColumn(label: Expanded(child: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Text('Free'),
      //       Text('Quantity'),
      //     ],
      //   ),
      // ),),),
    ];
  }

  List<DataRow> _createPromosRows() {
    return offerModel!.message!.promosTableOfSameItem!
        .map((book) => DataRow(cells: [
      DataCell(
        Expanded(
            child: Center(
              child: Container(
                // width: 90,
                width: MediaQuery.of(context).size.width * 0.25,
                child: Center(
                    child: Text(
                      book.boughtItem.toString(),
                      textAlign: TextAlign.center,style: TextStyle(fontSize: 11),
                    )),
              ),
            )),
      ),
      DataCell(
        Expanded(
            child: Center(
              child: Container(
                // width: 90,
                width: MediaQuery.of(context).size.width * 0.2,
                child: Center(
                    child: Text(
                      book.boughtItem.toString(),
                      textAlign: TextAlign.center,style: TextStyle(fontSize: 11),
                    )),
              ),
            )),
      ),
      DataCell(
        Expanded(
            child: Center(
              child: Container(
                // width: 90,
                width: MediaQuery.of(context).size.width * 0.25,
                child: Center(
                    child: Text(
                      book.boughtQty.toString(),
                      textAlign: TextAlign.center,style: TextStyle(fontSize: 11),
                    )),
              ),
            )),
      ),
      DataCell(
        Expanded(
            child: Center(
              child: Container(
                // width: 90,
                width: MediaQuery.of(context).size.width * 0.25,
                child: Center(
                    child: Text(
                      book.freeQty.toString(),
                      textAlign: TextAlign.center,style: TextStyle(fontSize: 11),
                    )),
              ),
            )),
      ),
      // DataCell(Expanded(child: Container(width: 85,child: Center(child: Text(book.boughtItem.toString()))))),
      // DataCell(Expanded(child: Container(width: 85,child: Center(child: Text(book.promoBasedOn.toString()))))),
      // DataCell(Expanded(child: Container(width: 85,child: Center(child: Text(book.forEveryQuantityThatIsBought.toString()))))),
      // DataCell(Expanded(child: Container(width: 85,child: Center(child: Text(book.quantityOfFreeItemsThatsGiven.toString()))))),
    ]))
        .toList();
  }

  List<DataColumn> _createpromosDiscountColumns() {
    return [
      DataColumn(label: Expanded(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Item',style: TextStyle(fontSize: 11)),
              Text('Bought',style: TextStyle(fontSize: 11)),
            ],
          ),
        ),
      )),
      DataColumn(label: Expanded(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Free',style: TextStyle(fontSize: 11)),
              Text('item',style: TextStyle(fontSize: 11)),
            ],
          ),
        ),
      )),
      DataColumn(label: Expanded(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Eligible',style: TextStyle(fontSize: 11)),
              Text('Quantity',style: TextStyle(fontSize: 11)),
            ],
          ),
        ),
      )),
      DataColumn(label: Expanded(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Free',style: TextStyle(fontSize: 11)),
              Text('Quantity',style: TextStyle(fontSize: 11)),
            ],
          ),
        ),
      )),
      // DataColumn(label: Expanded(child: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Text('Item'),
      //       Text('Bought'),
      //     ],
      //   ),
      // ))),
      // DataColumn(label: Expanded(child: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Text('Free'),
      //       Text('item'),
      //     ],
      //   ),
      // ))),
      // DataColumn(label: Expanded(child: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Text('Eligible'),
      //       Text('Quantity'),
      //     ],
      //   ),
      // ))),
      // DataColumn(label: Expanded(child: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Column(
      //         children: [
      //           Text('Free'),
      //           Text('Quantity'),
      //         ],
      //       ),
      //     ],
      //   ),
      // ))),
    ];
  }

  List<DataRow> _createPromosDiscountRows() {
    return offerModel!.message!.promosTableOfDifferentItems!
        .map((book) => DataRow(cells: [
      DataCell(
        Expanded(
            child: Center(
              child: Container(
                // width: 90,
                width: MediaQuery.of(context).size.width * 0.25,
                child: Center(
                    child: Text(
                      book.boughtItem.toString(),
                      textAlign: TextAlign.center,style: TextStyle(fontSize: 11),
                    )),
              ),
            )),
      ), DataCell(
        Expanded(
            child: Center(
              child: Container(
                // width: 90,
                width: MediaQuery.of(context).size.width * 0.25,
                child: Center(
                    child: Text(
                      book.freeItem.toString(),
                      textAlign: TextAlign.center,style: TextStyle(fontSize: 11),
                    )),
              ),
            )),
      ),DataCell(
        Expanded(
            child: Center(
              child: Container(
                // width: 90,
                width: MediaQuery.of(context).size.width * 0.2,
                child: Center(
                    child: Text(
                      book.boughtQty.toString(),
                      textAlign: TextAlign.center,style: TextStyle(fontSize: 11),
                    )),
              ),
            )),
      ),DataCell(
        Expanded(
            child: Center(
              child: Container(
                // width: 90,
                width: MediaQuery.of(context).size.width * 0.25,
                child: Center(
                    child: Text(
                      book.freeQty.toString(),
                      textAlign: TextAlign.center,style: TextStyle(fontSize: 11),
                    )),
              ),
            )),
      ),
      // DataCell(Expanded(child: Container(width: 80,child: Center(child: Text(book.boughtItem.toString(),textAlign: TextAlign.center))))),
      // DataCell(Expanded(child: Container(width: 80,child: Center(child: Text(book.freeItem.toString(),textAlign: TextAlign.center))))),
      // DataCell(Expanded(child: Container(width: 90,child: Center(child: Text(book.forEveryQuantityThatIsBought.toString()))))),
      // DataCell(Expanded(child: Container(width: 90,child: Center(child: Text(book.quantityOfFreeItemsThatsGiven.toString()))))),
    ]))
        .toList();
  }

  List<DataColumn> _createtableColumns() {
    return [
      DataColumn(label: Expanded(child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Item'),
            Text('Bought'),
          ],
        ),
      ))),
      DataColumn(label: Expanded(child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Free'),
            Text('item'),
          ],
        ),
      ))),
      DataColumn(label: Expanded(child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Eligible'),
            Text('Quantity'),
          ],
        ),
      ))),
      DataColumn(label: Expanded(child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Free'),
            Text('Quantity'),
          ],
        ),
      ))),
      DataColumn(label: Expanded(child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Discount'),
          ],
        ),
      ))),
    ];
  }

  List<DataRow> _createtableRows() {
    return offerModel!.message!.freeItemForEligibleQuantity!
        .map((book) => DataRow(cells: [
      DataCell(Center(child: Container(width: 80,child: Text(book.boughtItem.toString(),textAlign: TextAlign.center)))),
      DataCell(Expanded(child: Container(width: 60,child: Center(child: Text(book.boughtItem.toString(),textAlign: TextAlign.center))))),
      DataCell(Expanded(child: Container(width: 65,child: Center(child: Text(book.boughtQty.toString()))))),
      DataCell(Expanded(child: Container(width: 65,child: Center(child: Text(book.freeQty.toString()))))),
      DataCell(Expanded(child: Container(width: 70,child: Center(child: Text("${book.discount.toString()}%"))))),
    ])).toList();
  }
}

class Id{
  Id({this.p1,this.p2,this.p3,this.p5});

  dynamic p1;
  dynamic p2;
  dynamic p3;
  dynamic p5;

  factory Id.fromJson(Map<String, dynamic> json) => Id(
    p1: json['p1'],
    p2: json['p2'],
    p3: json['p3'],
    p5: json['p5'],
  );

  Map<String, dynamic> toJson() => {
    "p1": p1,
    "p2": p2,
    "p3": p3,
    "p5": p5
  };
}


