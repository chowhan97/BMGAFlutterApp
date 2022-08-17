import 'dart:convert';

import 'package:ebuzz/common/colors.dart';
import 'package:ebuzz/common/custom_appbar.dart';
import 'package:ebuzz/common/custom_toast.dart';
import 'package:ebuzz/common/navigations.dart';
import 'package:ebuzz/orderbooking/model/saveData_model.dart';
import 'package:ebuzz/orderbooking/model/table_model.dart';
import 'package:ebuzz/orderbooking/service/orderbooking_api_service.dart';
import 'package:ebuzz/orderbooking/ui/orderbooking_ui.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrderBookingForm4 extends StatefulWidget {
  @override
  State<OrderBookingForm4> createState() => _OrderBookingForm4State();
}

class _OrderBookingForm4State extends State<OrderBookingForm4> {
  List<Map> _books = [
    {
      'item_code': "Demo item 4",
      'quantity_available': '52',
      'quantity': '20',
      'latest_prize': '₹ 160',
      'promo_type': 'None',
    },
    {
      'item_code': "Demo item 4",
      'quantity_available': '52',
      'quantity': '20',
      'latest_prize': '₹ 136',
      'promo_type': 'Buy x get same and discount',
    },
  ];

  List<Map> promos = [
    {
      'bought': "Demo item 4",
      'warehouse_qty': "20",
      'free_items': "Demo item 4",
      'qty': "4"
    }
  ];

  List<Map> promosDiscount = [
    {
      'bought': "Demo item 4",
      'free_item': "Demo item 4",
      'discounted_prize': "₹ 136",
      'qty': "2"
    }
  ];
  @override
  void initState() {
    // var item_code = [{"item_code":"ItemA","quantity_booked":21,"average_price":41,"amount":861,"quantity_available":486}];
    // var order_list = [{"item_code":"IT002","quantity_booked":21,"average_price":41,"amount":861,"quantity_available":465,"rate_contract_check":0}];
    // String item_codeString = jsonEncode(item_code);
    // String order_listString = jsonEncode(order_list);
    // print(item_codeString.toString());
    // print(order_listString.toString());
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
  var order_booking_items_v2;

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
      prefsitem_code = prefs.getString("item_code");
      print("prefsitem_code????????$prefsitem_code");
      prefsorder_list = prefs.getString("order_list");
      print("prefsorder_list????????$prefsorder_list");
    });
    isTableLoad = true;
    var headers = {
      'Cookie':
          'full_name=Jeeva; sid=6a44549626720c83d2d37a33716891f32dc8bf7978dcdaabbcf9b7b6; system_user=yes; user_id=jeeva%40yuvabe.com; user_image='
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://erptest.bharathrajesh.co.in/api/method/bmga.bmga.doctype.order_booking_v2.api.sales_promos?item_code=${prefsitem_code.toString()}&customer_type=$prefscust_type&company=${company}&order_list=${prefsorder_list.toString()}&customer=$prefscustomer'));

    request.headers.addAll(headers);

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
        var salesorder = [{"docstatus":0,"doctype":"Order booking V2 Sales Order Preview","name":"new-order-booking-v2-sales-order-preview-1","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","parent":"new-order-booking-v2-1","parentfield":"sales_order_preview","parenttype":"Order Booking V2","idx":1,"item_code": tableModel!.message!.salesOrder!.salesOrder![0].itemCode,"quantity_available":tableModel!.message!.salesOrder!.salesOrder![0].qtyAvailable,"quantity":tableModel!.message!.salesOrder!.salesOrder![0].qty,"average": tableModel!.message!.salesOrder!.salesOrder![0].averagePrice,"promo_type":tableModel!.message!.salesOrder!.salesOrder![0].promoType,"warehouse":tableModel!.message!.salesOrder!.salesOrder![0].warehouse},{"docstatus":0,"doctype":"Order booking V2 Sales Order Preview","name":"new-order-booking-v2-sales-order-preview-2","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","parent":"new-order-booking-v2-1","parentfield":"sales_order_preview","parenttype":"Order Booking V2","idx":2,"item_code": tableModel!.message!.salesOrder!.salesOrder![00].itemCode ?? "IT002","quantity_available":tableModel!.message!.salesOrder!.salesOrder![0].qtyAvailable ?? 465,"quantity":tableModel!.message!.salesOrder!.salesOrder![0].qty ?? 21,"average":tableModel!.message!.salesOrder!.salesOrder![0].averagePrice ?? 41,"promo_type":tableModel!.message!.salesOrder!.salesOrder![0].promoType ?? "None","warehouse":tableModel!.message!.salesOrder!.salesOrder![0].warehouse ?? "BMGA Test Warehouse - BMGA"},{"docstatus":0,"doctype":"Order booking V2 Sales Order Preview","name":"new-order-booking-v2-sales-order-preview-3","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","parent":"new-order-booking-v2-1","parentfield":"sales_order_preview","parenttype":"Order Booking V2","idx":3,"item_code":tableModel!.message!.salesOrder!.salesOrder![0].itemCode ?? "IT002","quantity_available":tableModel!.message!.salesOrder!.salesOrder![0].qtyAvailable ?? 465,"quantity":tableModel!.message!.salesOrder!.salesOrder![0].qty ?? 21,"average":tableModel!.message!.salesOrder!.salesOrder![0].averagePrice ?? 41,"promo_type":tableModel!.message!.salesOrder!.salesOrder![0].promoType ?? "None","warehouse":tableModel!.message!.salesOrder!.salesOrder![0].warehouse ?? "BMGA Test Warehouse - BMGA"}];
        var freepromos =  [{"docstatus":0,"doctype":"Order Booking V2 Sales Promo","name":"new-order-booking-v2-sales-promo-1","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","parent":"new-order-booking-v2-1","parentfield":"promos","parenttype":"Order Booking V2","idx":1,"bought_item": tableModel!.message!.boughtItem![0].itemCode,"free_items":tableModel!.message!.boughtItem![0].itemCode,"price":tableModel!.message!.boughtItem![0].amount,"quantity":tableModel!.message!.boughtItem![0].quantityBooked,"warehouse_quantity":tableModel!.message!.boughtItem![0].quantityAvailable,"promo_type":"Buy x get same and discount for ineligible qty"}];
        var promodis = [{"docstatus":0,"doctype":"Order Booking V2 Sales Discount","name":"new-order-booking-v2-sales-discount-1","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","parent":"new-order-booking-v2-1","parentfield":"promos_discount","parenttype":"Order Booking V2","idx":1,"bought_item":tableModel!.message!.boughtItem![0].itemCode,"free_item":tableModel!.message!.boughtItem![0].itemCode,"quantity":tableModel!.message!.boughtItem![0].quantityBooked,"discount":136,"promo_type":"Buy x get same and discount for ineligible qty","amount":tableModel!.message!.boughtItem![0].amount}];
        String sales_order = jsonEncode(salesorder);
        String free_promos = jsonEncode(freepromos);
        String promo_dis = jsonEncode(promodis);
        print("========?????=========$sales_order");
        print("========?????=========$free_promos");
        print("========?????=========$promo_dis");
        prefs.setString("sales_order", sales_order);
        prefs.setString("free_promos", free_promos);
        prefs.setString("promo_dis", promo_dis);
      });
      // var data = await response.stream.bytesToString();
      // tableModel = TableModel.fromJson(json.decode(data));
      // print("table data is===>>>$tableModel");
    } else {
      print(response.reasonPhrase);
    }
  }

  Future SaveData(BuildContext context) async {
    print("call");
    SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        order_booking_items_v2 = prefs.getString("order_booking_items_v2");
        print("prefsorder_list????????$order_booking_items_v2");
     });
      var promos = [{"docstatus":0,"doctype":"Order Booking V2 Sales Promo","name":"new-order-booking-v2-sales-promo-1","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","parent":"new-order-booking-v2-2","parentfield":"promos","parenttype":"Order Booking V2","idx":1,"bought_item":tableModel!.message!.boughtItem![0].itemCode,"free_items":tableModel!.message!.boughtItem![0].itemCode,"price":tableModel!.message!.boughtItem![0].averagePrice,"quantity":tableModel!.message!.boughtItem![0].quantityBooked,"warehouse_quantity":tableModel!.message!.boughtItem![0].quantityAvailable,"promo_type":"Buy x get same x"}];
      String PromosList = jsonEncode(promos);
      var sales_order_preview = [{"docstatus":0,"doctype":"Order booking V2 Sales Order Preview","name":"new-order-booking-v2-sales-order-preview-2","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","parent":"new-order-booking-v2-2","parentfield":"sales_order_preview","parenttype":"Order Booking V2","idx":1,"item_code": tableModel!.message!.salesOrder!.salesOrder![0].itemCode,"quantity_available":tableModel!.message!.salesOrder!.salesOrder![0].qtyAvailable,"quantity":tableModel!.message!.salesOrder!.salesOrder![0].qty,"average":tableModel!.message!.salesOrder!.salesOrder![0].averagePrice,"promo_type":tableModel!.message!.salesOrder!.salesOrder![0].promoType,"warehouse":tableModel!.message!.salesOrder!.salesOrder![0].warehouse},{"docstatus":0,"doctype":"Order booking V2 Sales Order Preview","name":"new-order-booking-v2-sales-order-preview-3","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","parent":"new-order-booking-v2-2","parentfield":"sales_order_preview","parenttype":"Order Booking V2","idx":2,"item_code":tableModel!.message!.salesOrder!.salesOrder![0].itemCode,"quantity_available":tableModel!.message!.salesOrder!.salesOrder![0].qtyAvailable,"quantity":tableModel!.message!.salesOrder!.salesOrder![0].qty,"average":tableModel!.message!.salesOrder!.salesOrder![0].averagePrice,"promo_type":tableModel!.message!.salesOrder!.salesOrder![0].promoType,"warehouse":tableModel!.message!.salesOrder!.salesOrder![0].warehouse}];
      String sales_order_previewList = jsonEncode(sales_order_preview);

      // isNotEditableLoad = true;
    var headers = {
      'Cookie': 'full_name=Jeeva; sid=6a44549626720c83d2d37a33716891f32dc8bf7978dcdaabbcf9b7b6; system_user=yes; user_id=jeeva%40yuvabe.com; user_image='
    };
    var request = http.MultipartRequest('POST', Uri.parse('https://erptest.bharathrajesh.co.in/api/method/frappe.desk.form.save.savedocs'));
    request.fields.addAll({
      // 'doc': '{"docstatus":0,"doctype":"Order Booking V2","name":"new-order-booking-v2-2","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","company":"Bharath Medical & General Agencies","customer_type":"Retail,"customer_name":"Banashankari Medicals","customer":"CUST-R-00002","order_booking_items_v2":[{"docstatus":0,"doctype":"Order Booking Items V2","name":"new-order-booking-items-v2-2","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","quantity_available":${tableModel!.message!.salesOrder!.salesOrder![0].qtyAvailable.toString()},"gst_rate":"12","rate_contract":"0","rate_contract_check":0,"parent":"new-order-booking-v2-2","parentfield":"order_booking_items_v2","parenttype":"Order Booking V2","idx":1,"__unedited":false,"stock_uom":"Unit","item_code":${tableModel!.message!.salesOrder!.salesOrder![0].itemCode.toString()},"average_price":${tableModel!.message!.salesOrder!.salesOrder![0].averagePrice.toString()},"amount_after_gst":140,"brand_name":"Sanofi","quantity_booked":${tableModel!.message!.salesOrder!.salesOrder![0].qty.toString()},"amount":${tableModel!.message!.salesOrder!.salesOrder![0].averagePrice.toString()}}],"order_booking_so":null,"hunting_quotation":null,"promos":[{"docstatus":0,"doctype":"Order Booking V2 Sales Promo","name":"new-order-booking-v2-sales-promo-1","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","parent":"new-order-booking-v2-2","parentfield":"promos","parenttype":"Order Booking V2","idx":1,"bought_item":${tableModel!.message!.boughtItem![0].itemCode.toString()},"free_items":${tableModel!.message!.boughtItem![0].itemCode.toString()},"price":${tableModel!.message!.boughtItem![0].amount.toString()},"quantity":${tableModel!.message!.boughtItem![0].quantityBooked.toString()},"warehouse_quantity":${tableModel!.message!.boughtItem![0].quantityAvailable.toString()},"promo_type":"Buy x get same x"}],"promos_discount":[],"sales_order_preview":[{"docstatus":0,"doctype":"Order booking V2 Sales Order Preview","name":"new-order-booking-v2-sales-order-preview-2","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","parent":"new-order-booking-v2-2","parentfield":"sales_order_preview","parenttype":"Order Booking V2","idx":1,"item_code":${tableModel!.message!.salesOrder!.salesOrder![0].itemCode.toString()},"quantity_available":${tableModel!.message!.salesOrder!.salesOrder![0].qtyAvailable.toString()},"quantity":${tableModel!.message!.salesOrder!.salesOrder![0].qty.toString()},"average":${tableModel!.message!.salesOrder!.salesOrder![0].averagePrice.toString()},"promo_type":${tableModel!.message!.salesOrder!.salesOrder![0].promoType.toString()},"warehouse":${tableModel!.message!.salesOrder!.salesOrder![0].warehouse.toString()}},{"docstatus":0,"doctype":"Order booking V2 Sales Order Preview","name":"new-order-booking-v2-sales-order-preview-3","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","parent":"new-order-booking-v2-2","parentfield":"sales_order_preview","parenttype":"Order Booking V2","idx":2,"item_code":${tableModel!.message!.salesOrder!.salesOrder![0].itemCode.toString()},"quantity_available":${tableModel!.message!.salesOrder!.salesOrder![0].qtyAvailable.toString()},"quantity":${tableModel!.message!.salesOrder!.salesOrder![0].qty.toString()},"average":${tableModel!.message!.salesOrder!.salesOrder![0].averagePrice.toString()},"promo_type":${tableModel!.message!.salesOrder!.salesOrder![0].promoType.toString()},"warehouse":${tableModel!.message!.salesOrder!.salesOrder![0].warehouse.toString()}}]}',
      'doc': '{"docstatus":0,"doctype":"Order Booking V2","name":"new-order-booking-v2-2","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","company":"Bharath Medical & General Agencies","customer_type":"Retail","customer_name":"Banashankari Medicals","customer":"CUST-R-00002","order_booking_items_v2":$order_booking_items_v2,"order_booking_so":null,"hunting_quotation":null,"promos":$PromosList,"promos_discount":[],"sales_order_preview":$sales_order_previewList}',
      'action': 'Save'
    });
    request.headers.addAll(headers);

    // http.StreamedResponse response = await request.send();
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      setState(() {
        print(response.body);
        String data = response.body;
        // isNotEditableLoad = false;
        print("table call");
        saveModel = SaveModel.fromJson(json.decode(data));
        print("${saveModel!.docs}");
        fluttertoast(whiteColor, redColor, "Saved Successful!!!");
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: CustomAppBar(
          title: Text('Order booking Form V2',
              style: TextStyle(color: whiteColor)),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: whiteColor,
            ),
          ),
          // actions: [
          //   TextButton(onPressed: (){
          //     setState(() {
          //       getOrderBooking();
          //       // Promodetail = true;
          //     });
          //   },
          //       child: Text("Booking Order",style: TextStyle(color: whiteColor)))
          // ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: blueAccent,
            onPressed: () {
              SaveData(context);
            },
            child: Icon(
              Icons.save,
              color: whiteColor,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          FloatingActionButton(
            backgroundColor: blueAccent,
            onPressed: () {
              setState(() {
                // 'customer': 'CUST-R-00002',
                // 'order_list': '[{"docstatus":0,"doctype":"Order Booking Items V2","name":"new-order-booking-items-v2-7","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","quantity_available":52,"gst_rate":"12","rate_contract":"0","rate_contract_check":0,"parent":"new-order-booking-v2-1","parentfield":"order_booking_items_v2","parenttype":"Order Booking V2","idx":1,"__unedited":false,"stock_uom":"Unit","item_code":"Demo Item 4","average_price":170,"amount_after_gst":180,"brand_name":"Johnson & Johnson","__checked":0,"quantity_booked":22,"amount":3740}]',
                // 'company': 'Bharath Medical & General Agencies',
                // 'customer_type': 'Retail',
                // 'free_promos': '[{"docstatus":0,"doctype":"Order Booking V2 Sales Promo","name":"new-order-booking-v2-sales-promo-1","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","parent":"new-order-booking-v2-1","parentfield":"promos","parenttype":"Order Booking V2","idx":1,"bought_item":"Demo Item 4","free_items":"Demo Item 4","price":0,"quantity":4,"warehouse_quantity":20,"promo_type":"Buy x get same and discount for ineligible qty"}]',
                // 'promo_dis': '[{"docstatus":0,"doctype":"Order Booking V2 Sales Discount","name":"new-order-booking-v2-sales-discount-1","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","parent":"new-order-booking-v2-1","parentfield":"promos_discount","parenttype":"Order Booking V2","idx":1,"bought_item":"Demo Item 4","free_item":"Demo Item 4","quantity":2,"discount":136,"promo_type":"Buy x get same and discount for ineligible qty","amount":272}]',
                // 'sales_order': '[{"docstatus":0,"doctype":"Order booking V2 Sales Order Preview","name":"new-order-booking-v2-sales-order-preview-1","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","parent":"new-order-booking-v2-1","parentfield":"sales_order_preview","parenttype":"Order Booking V2","idx":1,"item_code":"Demo Item 4","quantity_available":52,"quantity":20,"average":170,"promo_type":"None","warehouse":"BMGA Test Warehouse - BMGA"},{"docstatus":0,"doctype":"Order booking V2 Sales Order Preview","name":"new-order-booking-v2-sales-order-preview-2","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","parent":"new-order-booking-v2-1","parentfield":"sales_order_preview","parenttype":"Order Booking V2","idx":2,"item_code":"Demo Item 4","quantity_available":20,"quantity":4,"average":0,"promo_type":"Buy x get same and discount for ineligible qty","warehouse":"Free Warehouse - BMGA"},{"docstatus":0,"doctype":"Order booking V2 Sales Order Preview","name":"new-order-booking-v2-sales-order-preview-3","__islocal":1,"__unsaved":1,"owner":"jeeva@yuvabe.com","parent":"new-order-booking-v2-1","parentfield":"sales_order_preview","parenttype":"Order Booking V2","idx":3,"item_code":"Demo Item 4","quantity_available":52,"quantity":2,"average":136,"promo_type":"Buy x get same and discount for ineligible qty","warehouse":"BMGA Test Warehouse - BMGA"}]'
                getOrderBooking();
              });
              //pushReplacementScreen(context, OrderBookingUi());
              // var salesPromos = getOrderBookingSalesPromo(item, customerType, companies,orderList, customers, context);
              // print(salesPromos);
            },
            child: Icon(
              Icons.arrow_forward,
              color: whiteColor,
            ),
          ),
        ],
      ),
      body: isTableLoad == true
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Scroll ',
                        style: TextStyle(fontSize: 18, color: blackColor),
                      ),
                      Icon(
                        Icons.arrow_back,
                        color: blackColor,
                        size: 25,
                      ),
                      Text(
                        ' or ',
                        style: TextStyle(fontSize: 18, color: blackColor),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: blackColor,
                        size: 25,
                      ),
                      Text(
                        ' to view table below',
                        style: TextStyle(fontSize: 18, color: blackColor),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  tableModel!.message!.salesOrder!.salesOrder!.isEmpty
                      ? Container()
                      : Text("Sales Order Preview",
                          style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  tableModel!.message!.salesOrder!.salesOrder!.isEmpty
                      ? Container()
                      : Expanded(
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _createDataTable(),
                            ],
                          ),
                        ),
                  tableModel!.message!.salesPromosItems!.isEmpty
                      ? Container()
                      : Text("Promos", style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  tableModel!.message!.salesPromosItems!.isEmpty
                      ? Container()
                      : Expanded(
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _createPromosDataTable(),
                            ],
                          ),
                        ),
                  tableModel!.message!.salesPromoDiscount!.promos!.isEmpty
                      ? Container()
                      : Text("Promos Discount", style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  tableModel!.message!.salesPromoDiscount!.promos!.isEmpty
                      ? Container()
                      : Expanded(
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _createPromosDiscountDataTable(),
                            ],
                          ),
                        ),
                ],
              ),
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

  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Expanded(child: Text('Item Code'))),
      DataColumn(label: Expanded(child: Text('Quantity Available'))),
      DataColumn(label: Expanded(child: Text('Quantity'))),
      DataColumn(label: Expanded(child: Text('Latest Batch Price'))),
      DataColumn(label: Expanded(child: Text('Promo Type')))
    ];
  }

  List<DataRow> _createRows() {
    return tableModel!.message!.salesOrder!.salesOrder!
        .map(
          (book) => DataRow(
            cells: [
              DataCell(Expanded(child: Text(book.itemCode.toString()))),
              DataCell(Expanded(child: Text(book.qtyAvailable.toString()))),
              DataCell(Expanded(child: Text(book.qty.toString()))),
              DataCell(Expanded(child: Text(book.averagePrice.toString()))),
              DataCell(Expanded(child: Text(book.promoType.toString()))),
            ],
          ),
        )
        .toList();
  }

  List<DataColumn> _createpromosColumns() {
    return [
      DataColumn(label: Expanded(child: Text('Bought Item'))),
      DataColumn(label: Expanded(child: Text('Warehouse Quantity'))),
      DataColumn(label: Expanded(child: Text('Free items'))),
      DataColumn(label: Expanded(child: Text('Quantity'))),
    ];
  }

  List<DataRow> _createPromosRows() {
    return tableModel!.message!.salesPromosItems!
        .map((book) => DataRow(cells: [
              DataCell(Expanded(child: Text(book.boughtItem.toString()))),
              DataCell(Expanded(child: Text(book.wQty.toString()))),
              DataCell(Expanded(child: Text(book.promoItem.toString()))),
              DataCell(Expanded(child: Text(book.qty.toString()))),
            ]))
        .toList();
  }

  List<DataColumn> _createpromosDiscountColumns() {
    return [
      DataColumn(label: Expanded(child: Text('Bought Item'))),
      DataColumn(label: Expanded(child: Text('Free item'))),
      DataColumn(label: Expanded(child: Text('Discounted Price'))),
      DataColumn(label: Expanded(child: Text('Quantity'))),
    ];
  }

  List<DataRow> _createPromosDiscountRows() {
    return tableModel!.message!.salesPromoDiscount!.promos!
        .map((book) => DataRow(cells: [
              DataCell(Expanded(child: Text(book.boughtItem.toString()))),
              DataCell(Expanded(child: Text(book.boughtItem.toString()))),
              DataCell(
                  Expanded(child: Text(book.discount.toString()))),
              DataCell(Expanded(child: Text(book.forEveryQuantityThatIsBought.toString()))),
            ]))
        .toList();
  }
}
