import 'dart:convert';

import 'package:ebuzz/common/colors.dart';
import 'package:ebuzz/common/custom_appbar.dart';
import 'package:ebuzz/common/navigations.dart';
import 'package:ebuzz/orderbooking/model/table_model.dart';
import 'package:ebuzz/orderbooking/service/orderbooking_api_service.dart';
import 'package:ebuzz/orderbooking/ui/orderbooking_ui.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    var item_code = [{"item_code": "Demo Item 4","quantity_booked":"1","average_price":"170","amount": "470","quantity_available":"234"}];
    var order_list = [{"item_code": "Demo Item 4","quantity_booked":"1","average_price":"170","amount": "470","quantity_available":"234","rate_contract_check":"0"}];
    String item_codeString = jsonEncode(item_code);
    String order_listString = jsonEncode(order_list);
    print(item_codeString.toString());
    print(order_listString.toString());
    getTableData(context,itemcode: item_codeString,customertype: "Retail",company: "Bharath Medical %26 General Agencies",order_list: order_listString,customer: "CUST-R-00010");
    // getTableData(context,itemcode: '[{"item_code":"ItemA","quantity_booked":21,"average_price":41,"amount":861,"quantity_available":486}]',customertype: "Retail",company: "Bharath Medical & General Agencies",order_list: '[{"item_code":"IT002","quantity_booked":21,"average_price":41,"amount":861,"quantity_available":465,"rate_contract_check":0}]',customer: "CUST-R-00010");
    super.initState();
  }

  TableModel? tableModel;
  var decodedData;
  bool isTableLoad = false;

  Future getTableData(BuildContext context,{itemcode,customertype,company,order_list,customer}) async{
    print("call");
    isTableLoad = true;
    var headers = {
      'Cookie': 'full_name=Jeeva; sid=6a44549626720c83d2d37a33716891f32dc8bf7978dcdaabbcf9b7b6; system_user=yes; user_id=jeeva%40yuvabe.com; user_image='
    };
    var request = http.Request('POST', Uri.parse('https://erptest.bharathrajesh.co.in/api/method/bmga.bmga.doctype.order_booking_v2.api.sales_promos?item_code=$itemcode&customer_type=$customertype&company=$company&order_list=$order_list&customer=$customer'));

    request.headers.addAll(headers);

    // http.StreamedResponse response = await request.send();
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      setState(() {
        isTableLoad = false;
        print(response.body);
        String data = response.body;
        decodedData = jsonDecode(data);
        print(decodedData['message']['sales_order']['sales_order']);
      });
      // var data = await response.stream.bytesToString();
      // tableModel = TableModel.fromJson(json.decode(data));
      // print("table data is===>>>$tableModel");
    }
    else {
      print(response.reasonPhrase);
    }

    // var customerType;
    // try {
    //   Dio _dio = await BaseDio().getBaseDio();
    //   final String so = tableData(itemcode: itemcode,customerType: customertype,company: company,order_list: order_list,customer: customer);
    //   final response = await _dio.get(so);
    //   var data = response.data;
    //   print("table data is====>>>$data");
    //   // customerType = data['message']['pch_customer_type'];
    //   // return customerType;
    // } catch (e) {
    //   exception(e, context);
    // }
    // return customerType;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: CustomAppBar(
          title: Text('Order booking Form V2', style: TextStyle(color: whiteColor)),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: whiteColor,
            ),
          ),
          actions: [
            TextButton(onPressed: (){
              setState(() {
                getOrderBooking();
                // Promodetail = true;
              });
            },
                child: Text("Booking Order",style: TextStyle(color: whiteColor)))
          ],
        ),
      ),
      floatingActionButton:  FloatingActionButton(
        backgroundColor: blueAccent,
        onPressed:() {
          pushReplacementScreen(context, OrderBookingUi());
          // var salesPromos = getOrderBookingSalesPromo(item, customerType, companies,orderList, customers, context);
          // print(salesPromos);
        },
        child: Icon(
          Icons.arrow_forward,
          color: whiteColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                isTableLoad == true ? CircularProgressIndicator(): Text(
                  '${decodedData['message']['sales_order']['sales_order']['qty'].toString()}',
                  // "",
                  style: TextStyle(fontSize: 18, color: blackColor),
                ),
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
            Text("Sales Order Preview",style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Expanded(child: ListView(
              children: [
                _createDataTable(),
              ],
            ),
            ),
            Text("Promos",style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Expanded(child: ListView(
              children: [
                _createPromosDataTable(),
              ],
            ),
            ),
            Text("Promos Discount",style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Expanded(child: ListView(
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
    return DataTable(columns: _createColumns(), rows: _createRows(),border: TableBorder.all(color: Colors.black));
  }
  DataTable _createPromosDataTable() {
    return DataTable(columns: _createpromosColumns(), rows: _createPromosRows(),border: TableBorder.all(color: Colors.black));
  }
  DataTable _createPromosDiscountDataTable() {
    return DataTable(columns: _createpromosDiscountColumns(), rows: _createPromosDiscountRows(),border: TableBorder.all(color: Colors.black));
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
    return _books.map((book) => DataRow(cells: [
      DataCell(Expanded(child: Text(book['item_code'].toString()))),
      DataCell(Expanded(child: Text(book['quantity_available'].toString()))),
      DataCell(Expanded(child: Text(book['quantity'].toString()))),
      DataCell(Expanded(child: Text(book['latest_prize'].toString()))),
      DataCell(Expanded(child: Text(book['promo_type'].toString()))),
    ])).toList();
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
    return promos.map((book) => DataRow(cells: [
      DataCell(Expanded(child: Text(book['bought'].toString()))),
      DataCell(Expanded(child: Text(book['warehouse_qty'].toString()))),
      DataCell(Expanded(child: Text(book['free_items'].toString()))),
      DataCell(Expanded(child: Text(book['qty'].toString()))),
    ])).toList();
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
    return promosDiscount.map((book) => DataRow(cells: [
      DataCell(Expanded(child: Text(book['bought'].toString()))),
      DataCell(Expanded(child: Text(book['free_item'].toString()))),
      DataCell(Expanded(child: Text(book['discounted_prize'].toString()))),
      DataCell(Expanded(child: Text(book['qty'].toString()))),
    ])).toList();
  }
}
