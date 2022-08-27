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
import 'package:ebuzz/orderbooking/ui/orderbooking_form2.dart';
import 'package:ebuzz/orderbooking/ui/orderbooking_form4.dart';
import 'package:ebuzz/util/apiurls.dart';
import 'package:ebuzz/widgets/custom_card.dart';
import 'package:ebuzz/widgets/custom_textformformfield.dart';
import 'package:ebuzz/widgets/custom_typeahead_formfield.dart';
import 'package:ebuzz/widgets/typeahead_widgets.dart';
import 'package:flutter/material.dart';


List<String> item_CodeList = [];
List<OrderBookingItems> _oblist = [];
List<TextEditingController> itemcodecontlist = <TextEditingController>[];
List<TextEditingController> quantitycontlist = <TextEditingController>[];
List<TextEditingController> quantityavailablecontlist = <TextEditingController>[];
List<TextEditingController> lastbatchpricecontlist = <TextEditingController>[];
List<TextEditingController> ratecontractcontlist = <TextEditingController>[];
List<TextEditingController> mrpcontractcontlist = <TextEditingController>[];
List<TextEditingController> stockUOcontlist = <TextEditingController>[];
List<TextEditingController> salespromocontlist = <TextEditingController>[];
List<TextEditingController> amountcontlist = <TextEditingController>[];
List<TextEditingController> gstcontlist = <TextEditingController>[];

class OrderBookingForm3 extends StatefulWidget {
  OrderBookingForm3();
  @override
  _OrderBookingForm3State createState() => _OrderBookingForm3State();

}

class _OrderBookingForm3State extends State<OrderBookingForm3> {
  bool Promodetail = false;
  @override
  void initState() {
    super.initState();
    getItemList();
  }

  getItemList() async {
    try {
      List listData = await CommonService().getItemList(context);
      for (int i = 0; i < listData.length; i++) {
        item_CodeList.add(listData[i]['item_code']);
      }
      print(item_CodeList.length);
    } catch (e) {
      throw Exception(e.toString());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context){
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
          // actions: [
          //   TextButton(onPressed: (){
          //     setState(() {
          //       Promodetail = true;
          //     });
          //   },
          //   child: Text("Apply Promo",style: TextStyle(color: whiteColor)))
          // ],
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
              _oblist.add(OrderBookingItems(
                  amount: 0,
                  itemcode: '',
                  itemname: '',
                  qty: 0,
                  rate: 0));
              itemcodecontlist.add(TextEditingController());
              quantitycontlist.add(TextEditingController());
              quantityavailablecontlist.add(TextEditingController());
              lastbatchpricecontlist.add(TextEditingController());
              ratecontractcontlist.add(TextEditingController());
              mrpcontractcontlist.add(TextEditingController());
              stockUOcontlist.add(TextEditingController());
              amountcontlist.add(TextEditingController());
              gstcontlist.add(TextEditingController());
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
              // getTableData(context,itemcode: '[{"item_code":"ItemA","quantity_booked":21,"average_price":41,"amount":861,"quantity_available":486}]',customertype: "Retail",company: "Bharath Medical %26 General Agencies",order_list: '[{"item_code":"IT002","quantity_booked":21,"average_price":41,"amount":861,"quantity_available":465,"rate_contract_check":0}]',customer: "CUST-R-00010");
              pushScreen(context,OrderBookingForm4());
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: _oblist.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final item = _oblist[index];
                  int lastElement = _oblist.length - 1;
                  return Column(
                    children: [
                      OBItemsform(
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
    );
  }
  void assignIndex(int index, int lastElement) {
    for (int i = index; i < lastElement; i++) {
      setState(() {
        _oblist[i].itemcode = _oblist[i + 1].itemcode;
        _oblist[i].qty = _oblist[i + 1].qty;
        itemcodecontlist[i].text = _oblist[i + 1].itemcode!;
        quantitycontlist[i].text = _oblist[i + 1].qty!.toString();
      });
    }
  }

  void onDelete(int index, int lastElement) {
    if (index != lastElement) {
      assignIndex(index, lastElement);
    }
    _oblist.removeAt(index);
    itemcodecontlist.removeAt(index);
    quantitycontlist.removeAt(index);
    if (!mounted) return;
    setState(() {});
  }
}

typedef OnDelete();

class OBItemsform extends StatefulWidget {
  final OrderBookingItems obi;
  final OnDelete onDelete;
  final int i;

  OBItemsform({required Key key, required this.obi, required this.onDelete, required this.i}) : super(key: key);
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
    _oblist[index].rate = double.parse(product.valuationRate.toString());
    _oblist[index].qty = 1.0;
    _oblist[index].amount = _oblist[index].rate! * _oblist[index].qty!;
    quantitycontlist[index].text = 1.0.toString();
    itemcodecontlist[index].text = itemCode;
    orderDetails = await getOrderBookingDetails(itemCode,customertype,company,customer, context);
    quantityavailablecontlist[index].text = orderDetails["message"]["available_qty"].toString();
    lastbatchpricecontlist[index].text = orderDetails["message"]["price_details"]["price"].toString();
    ratecontractcontlist[index].text = orderDetails["message"]["price_details"]["rate_contract_check"].toString();
    mrpcontractcontlist[index].text = orderDetails["message"]["price_details"]["mrp"].toString();
    stockUOcontlist[index].text = "Unit";
    gstcontlist[index].text = "12%";
    // List item = [
    //   for (var i in itemCode)

    // ]
    for (int i in item){
      item[i].add(itemCode);
      print(item);
    }
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var item_code = [{"item_code":itemcodecontlist[index].text,"quantity_booked":quantitycontlist[index].text,"average_price":lastbatchpricecontlist[index].text,"amount": int.parse(quantitycontlist[index].text) * int.parse(lastbatchpricecontlist[index].text),"quantity_available":quantityavailablecontlist[index].text}];
    // var order_list = [{"item_code":itemcodecontlist[index].text,"quantity_booked":quantitycontlist[index].text,"average_price":lastbatchpricecontlist[index].text,"amount": int.parse(quantitycontlist[index].text) * int.parse(lastbatchpricecontlist[index].text),"quantity_available":quantityavailablecontlist[index].text,"rate_contract_check":ratecontractcontlist[index].text}];
    // var prefscompany = prefs.getString("company");
    // var prefscustomer = prefs.getString("customer");
    // var prefscustomertype = prefs.getString("cust_type");
    // prefs.setString("item_code", jsonEncode(item_code));
    // prefs.setString("order_list", jsonEncode(order_list));
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
                              controller: stockUOcontlist[widget.i],
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
                              controller: quantityavailablecontlist[widget.i],
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
                              controller: lastbatchpricecontlist[widget.i],
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
                              controller: amountcontlist[widget.i],
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
                              controller: gstcontlist[widget.i],
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
                              controller: mrpcontractcontlist[widget.i],
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
      controller: itemcodecontlist[widget.i],
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
          _oblist[widget.i].itemcode = suggestion;
        });
        // var result = await getOrderBookingDetails(itemCode,customertype,company,customer, context);
        // print(result["message"]["available_qty"]);
      },
      suggestionsCallback: (pattern) {
        return TypeAheadWidgets.getSuggestions(pattern, item_CodeList);
      },
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      validator: (val) =>
      val == '' || val == null ? 'Item Code should not be empty' : null,


    );
  }

  Widget quantityField(i) {
    return CustomTextFormField(
      controller: quantitycontlist[widget.i],
      onChanged: (value) {
        if (value != '') {
          _oblist[widget.i].qty = double.parse(value);
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