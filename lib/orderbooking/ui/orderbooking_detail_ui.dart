import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ebuzz/common/colors.dart';
import 'package:ebuzz/common/custom_appbar.dart';
import 'package:ebuzz/common/display_helper.dart';
import 'package:ebuzz/common/ui_reusable_widget.dart';
import 'package:ebuzz/common_models/product.dart';
import 'package:ebuzz/common_service/common_service.dart';
import 'package:ebuzz/config/color_palette.dart';
import 'package:ebuzz/exception/custom_exception.dart';
import 'package:ebuzz/network/base_dio.dart';
import 'package:ebuzz/orderbooking/model/order_booking.dart';
import 'package:ebuzz/orderbooking/model/table_model.dart';
import 'package:ebuzz/orderbooking/service/orderbooking_api_service.dart';
import 'package:ebuzz/orderbooking/ui/orderbooking_form3.dart';
import 'package:ebuzz/salesorder/model/sales_order.dart';
import 'package:ebuzz/salesorder/service/sales_order_service.dart';
import 'package:ebuzz/util/apiurls.dart';
import 'package:ebuzz/widgets/custom_card.dart';
import 'package:ebuzz/widgets/custom_textformformfield.dart';
import 'package:ebuzz/widgets/custom_typeahead_formfield.dart';
import 'package:ebuzz/widgets/typeahead_widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

List<String> itemCode_List = [];
List<OrderBookingItems> obblist = [];
List<TextEditingController> itemcode_contlist = <TextEditingController>[];
List<TextEditingController> quantity_contlist = <TextEditingController>[];
List<TextEditingController> quantityavailable_contlist = <TextEditingController>[];
List<TextEditingController> lastbatchprice_contlist = <TextEditingController>[];
List<TextEditingController> ratecontract_contlist = <TextEditingController>[];
List<TextEditingController> mrpcontract_contlist = <TextEditingController>[];
List<TextEditingController> stockUO_contlist = <TextEditingController>[];
List<TextEditingController> salespromo_contlist = <TextEditingController>[];
List<TextEditingController> amount_contlist = <TextEditingController>[];
List<TextEditingController> gst_contlist = <TextEditingController>[];
String _customertype = "Retail";
String _company = "Bharath+Medical+%26+General+Agencies";
String _customer = "CUST-R-00010";

class OrderBookingDetail extends StatefulWidget {
  final OrderBooking bookingOrder;
  OrderBookingDetail({required this.bookingOrder});
  @override
  _OrderBookingDetailState createState() => _OrderBookingDetailState();
}

class _OrderBookingDetailState extends State<OrderBookingDetail> {
  List<SalesOrderItems> OrderItems = [];
  List<SalesOrderPaymentSchedule> OrderPaymentSchedule = [];
  TextEditingController companyController = TextEditingController();
  TextEditingController customerController = TextEditingController();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerTypeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      companyController.text = widget.bookingOrder.company.toString();
      customerController.text = widget.bookingOrder.customer.toString();
      customerNameController.text = widget.bookingOrder.customer_name.toString();
      customerTypeController.text = widget.bookingOrder.customer_name.toString();
    });
    getItemList();
  }

  getItemList() async {
    try {
      List listData = await CommonService().getItemList(context);
      for (int i = 0; i < listData.length; i++) {
        itemCode_List.add(listData[i]['item_code']);
      }
      print(itemCode_List.length);
    } catch (e) {
      throw Exception(e.toString());
    }
    setState(() {});
  }

  List<Map> SalesOrderPreview = [
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: CustomAppBar(
          title:
          Text('Order Booking Detail', style: TextStyle(color: whiteColor)),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: whiteColor,
            ),
          ),
        ),
      ),
      floatingActionButton:  FloatingActionButton(
        heroTag: 'Add Button',
        backgroundColor: blueAccent,
        onPressed: () {
          obblist.add(OrderBookingItems(
              amount: 0,
              itemcode: '',
              itemname: '',
              qty: 0,
              rate: 0));
          itemcode_contlist.add(TextEditingController());
          quantity_contlist.add(TextEditingController());
          quantityavailable_contlist.add(TextEditingController());
          lastbatchprice_contlist.add(TextEditingController());
          ratecontract_contlist.add(TextEditingController());
          mrpcontract_contlist.add(TextEditingController());
          stockUO_contlist.add(TextEditingController());
          amount_contlist.add(TextEditingController());
          gst_contlist.add(TextEditingController());
          // salespromocontractcontrollerlist.add(TextEditingController()) == [itemcodecontrollerlist.add(TextEditingController()), quantitycontrollerlist.add(TextEditingController())];
          setState(() {});
        },
        child: Icon(
          Icons.add,
          color: whiteColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              companyField(),
              SizedBox(height: 15),
              customerField(),
              SizedBox(height: 15),
              customerNameField(),
              SizedBox(height: 15),
              customerTypeField(),
              SizedBox(height: 15),
              // Container(
              //   height: 200,
              //   child: ListView.builder(
              //       scrollDirection: Axis.vertical,
              //       itemCount: obblist.length,
              //       shrinkWrap: true,
              //       itemBuilder: (context, index) {
              //         final item = obblist[index];
              //         int lastElement = obblist.length - 1;
              //         return Column(
              //           children: [
              //             OBItemsform(
              //               key: ObjectKey(item),
              //               obi: item,
              //               i: index,
              //               onDelete: () => onDelete(index, lastElement),
              //             ),
              //           ],
              //         );
              //       }),
              // ),
              // Text("Sales Order Preview",style: TextStyle(fontSize: 18)),
              // SizedBox(height: 8),
              // ListView(
              //       children: [
              //        _createDataTable(),
              //     ],
              //  ),
              // Text("Promos",style: TextStyle(fontSize: 18)),
              // SizedBox(height: 8),
              // Container(
              //   height: 200,
              //   child: ListView(
              //     children: [
              //       _createPromosDataTable(),
              //     ],
              //   ),
              // ),
              // Text("Promos Discount",style: TextStyle(fontSize: 18)),
              // SizedBox(height: 8),
              // Container(
              //   height: 200,
              //   child: ListView(
              //     children: [
              //       _createPromosDiscountDataTable(),
              //     ],
              //   ),
              // ),
              obblist.isEmpty ? Container() : Container(
                height: 200,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: obblist.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final item = obblist[index];
                      int lastElement = obblist.length - 1;
                      return Column(
                        children: [
                      // companyController.text = widget.bookingOrder.company.toString();
                      // customerController.text = widget.bookingOrder.customer.toString();
                      // customerNameController.text = widget.bookingOrder.customer_name.toString();
                      // customerTypeController.text = widget.bookingOrder.customer_name.toString();
                          OBItemsform(
                            key: ObjectKey(item),
                            obi: item,
                            i: index,
                            onDelete: () => onDelete(index, lastElement),
                            company: widget.bookingOrder.company.toString(),
                            customer: widget.bookingOrder.customer.toString(),
                            cust_type: "Retail",
                          ),
                        ],
                      );
                    }),
              ),
              Text("Sales Order Preview",style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Container(
                height: 180,
                child: ListView(
                      children: [
                       _createDataTable(),
                    ],
                 ),
              ),
              Text("Promos",style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Container(
                height: 130,
                child: ListView(
                  children: [
                    _createPromosDataTable(),
                  ],
                ),
              ),
              Text("Promos Discount",style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Container(
                height: 130,
                child: ListView(
                  children: [
                    _createPromosDiscountDataTable(),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
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
    return SalesOrderPreview.map((book) => DataRow(cells: [
      DataCell(Expanded(child: Text(book['item_code'].toString()))),
      DataCell(Expanded(child: Text(book['quantity_available'].toString()))),
      DataCell(Expanded(child: Text(book['quantity'].toString()))),
      DataCell(Expanded(child: Text(book['latest_prize'].toString()))),
      DataCell(Expanded(child: Text(book['promo_type'].toString()))),
    ],
    ),
    ).toList();
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

  void assignIndex(int index, int lastElement) {
    for (int i = index; i < lastElement; i++) {
      setState(() {
        obblist[i].itemcode = obblist[i + 1].itemcode;
        obblist[i].qty = obblist[i + 1].qty;
        itemcode_contlist[i].text = obblist[i + 1].itemcode!;
        quantity_contlist[i].text = obblist[i + 1].qty!.toString();
      });
    }
  }

  void onDelete(int index, int lastElement) {
    if (index != lastElement) {
      assignIndex(index, lastElement);
    }
    obblist.removeAt(index);
    itemcode_contlist.removeAt(index);
    quantity_contlist.removeAt(index);
    if (!mounted) return;
    setState(() {});
  }

  Widget companyField() {
    return TextFormField(
      controller: companyController,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: blackColor),
        fillColor: greyColor,
        filled: true,
        isDense: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
  Widget customerField() {
    return TextFormField(
      controller: customerController,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: blackColor),
        fillColor: greyColor,
        filled: true,
        isDense: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
  Widget customerNameField() {
    return TextFormField(
      controller: customerNameController,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: blackColor),
        fillColor: greyColor,
        filled: true,
        isDense: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
  Widget customerTypeField() {
    return TextFormField(
      controller: customerTypeController,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: blackColor),
        fillColor: greyColor,
        filled: true,
        isDense: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}

typedef OnDelete();

class OBItemsform extends StatefulWidget {
  final OrderBookingItems obi;
  final OnDelete onDelete;
  final int i;
  var customer,cust_type,company;

  OBItemsform({required Key key, required this.obi, required this.onDelete, required this.i, required this.customer, required this.company, required this.cust_type}) : super(key: key);
  @override
  _OBItemsformState createState() => _OBItemsformState();
}

class _OBItemsformState extends State<OBItemsform> with AutomaticKeepAliveClientMixin {
  int count = 0;
  Product product = Product();
  DateTime selectedDate = DateTime.now();
  var orderDetails;
  List item = [];
  String txt = " ";
  bool valuefirst = false;

  @override
  void initState() {
    super.initState();
  }


  setItemData(String itemCode, int index) async {
    product = await getData(itemCode);
    // print(product);
    print(itemCode);
    obblist[index].rate = double.parse(product.valuationRate.toString());
    obblist[index].qty = 1.0;
    obblist[index].amount = obblist[index].rate! * obblist[index].qty!;
    quantity_contlist[index].text = 1.0.toString();
    itemcode_contlist[index].text = itemCode;
    orderDetails = await getOrderBookingDetails(itemCode,_customertype,_company,_customer, context);
    quantityavailable_contlist[index].text = orderDetails["message"]["available_qty"].toString();
    lastbatchprice_contlist[index].text = orderDetails["message"]["price_details"]["price"].toString();
    ratecontract_contlist[index].text = orderDetails["message"]["price_details"]["rate_contract_check"].toString();
    mrpcontract_contlist[index].text = orderDetails["message"]["price_details"]["mrp"].toString();
    stockUO_contlist[index].text = "Unit";
    gst_contlist[index].text = "12%";
    amount_contlist[index].text = lastbatchprice_contlist[index].text * int.parse(obblist[index].qty!.toString());
    // List item = [
    //   for (var i in itemCode)
    // ]
    for (int i in item){
      item[i].add(itemCode);
      print(item);
    }
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                deleteWidget(),
                // Checkbox(
                //   value: this.valuefirst,
                //   onChanged: (bool? value) {
                //     setState(() {
                //       this.valuefirst = value as bool;
                //     });
                //   },
                // ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10, left: 8, right: 8, top: 25),
              child: Column(
                children: [
                  itemCodeField(),
                  Column(
                    children: [
                      Row(
                        children:[
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Stock UO',
                              ),
                              enabled: false,
                              controller: stockUO_contlist[widget.i],
                              style: TextStyle(fontSize: 14, color: blackColor),
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Quantity Available',
                              ),
                              enabled: false,
                              controller: quantityavailable_contlist[widget.i],
                              style: TextStyle(fontSize: 14, color: blackColor),
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(child: quantityField(widget.i)),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Last Batch Price',
                              ),
                              enabled: false,
                              controller: lastbatchprice_contlist[widget.i],
                              style: TextStyle(fontSize: 14, color: blackColor),
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Amount',
                              ),
                              enabled: false,
                              controller: amount_contlist[widget.i],
                              style: TextStyle(fontSize: 14, color: blackColor),
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'GST Rate',
                              ),
                              enabled: false,
                              controller: gst_contlist[widget.i],
                              style: TextStyle(fontSize: 14, color: blackColor),
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'MRP',
                              ),
                              enabled: false,
                              controller: mrpcontract_contlist[widget.i],
                              style: TextStyle(fontSize: 14, color: blackColor),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),

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
      controller: itemcode_contlist[widget.i],
      decoration: InputDecoration(
          fillColor: greyColor,
          filled: true,
          isDense: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(5),
          )),
      label: 'Item Code',
      labelStyle: TextStyle(color: blackColor),
      required: true,
      style: TextStyle(fontSize: 14, color: blackColor),
      itemBuilder: (context, item) {
        return TypeAheadWidgets.itemUi(item);
      },
      onSuggestionSelected: (suggestion) async {
        setItemData(suggestion, widget.i);
        if (!mounted) return;
        setState(() {
          obblist[widget.i].itemcode = suggestion;
          /////// table api //////////
          String item_codeString = jsonEncode([{"item_code": itemcode_contlist[widget.i].text,"quantity_booked": int.parse(quantity_contlist[widget.i].text),"average_price": int.parse(lastbatchprice_contlist[widget.i].text),"amount": int.parse(amount_contlist[widget.i].text),"quantity_available": int.parse(quantityavailable_contlist[widget.i].text)}]);
          String order_listString = jsonEncode([{"item_code": itemcode_contlist[widget.i].text,"quantity_booked": int.parse(quantity_contlist[widget.i].text),"average_price": int.parse(lastbatchprice_contlist[widget.i].text),"amount": int.parse(amount_contlist[widget.i].text),"quantity_available": int.parse(quantityavailable_contlist[widget.i].text),"rate_contract_check":int.parse(ratecontract_contlist[widget.i].text)}]);
          // getTableData(context,customer: widget.customer,company: widget.company,customertype: widget.cust_type,itemcode: item_codeString,order_list: order_listString);
        });
        // var result = await getOrderBookingDetails(itemCode,customertype,company,customer, context);
        // print(result["message"]["available_qty"]);
      },
      suggestionsCallback: (pattern) {
        return TypeAheadWidgets.getSuggestions(pattern, itemCode_List);
      },
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      validator: (val) => val == '' || val == null ? 'Item Code should not be empty' : null,
    );
  }

  Widget quantityField(i) {
    return CustomTextFormField(
      controller: quantity_contlist[widget.i],
      readOnly: true,
      onChanged: (value) {
        if (value != '') {
          obblist[widget.i].qty = double.parse(value);
          if (!mounted) return;
          setState(() {});
        }
        setState(() {
          // amountcontlist[i].text = lastbatchpricecontlist[i].text *  int.parse(quantitycontlist[i].text);
        });
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
      labelStyle: TextStyle(color: blackColor),
      style: TextStyle(fontSize: 14, color: blackColor),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
