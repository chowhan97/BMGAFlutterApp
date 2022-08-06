import 'package:dio/dio.dart';
import 'package:ebuzz/common/colors.dart';
import 'package:ebuzz/common/custom_appbar.dart';
import 'package:ebuzz/common_models/product.dart';
import 'package:ebuzz/common_service/common_service.dart';
import 'package:ebuzz/config/color_palette.dart';
import 'package:ebuzz/exception/custom_exception.dart';
import 'package:ebuzz/network/base_dio.dart';
import 'package:ebuzz/orderbooking/model/order_booking.dart';
import 'package:ebuzz/orderbooking/service/orderbooking_api_service.dart';
import 'package:ebuzz/orderbooking/ui/orderbooking_form3.dart';
import 'package:ebuzz/util/apiurls.dart';
import 'package:ebuzz/widgets/custom_card.dart';
import 'package:ebuzz/widgets/custom_textformformfield.dart';
import 'package:ebuzz/widgets/custom_typeahead_formfield.dart';
import 'package:ebuzz/widgets/typeahead_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';
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
    print(widget.company);
    // print(widget.customer);
    }

  getItemList() async {
    try {
      List listData = await CommonService().getItemList(context);
      for (int i = 0; i < listData.length; i++) {
        itemCodeList.add(listData[i]['item_code']);
      }
      print(itemCodeList.length);
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
          onPressed:() {
            // var item_code = itemcodecontrollerlist;
            // var companyDetails = widget.company;
            // companyDetails = companyDetails?.replaceAll(RegExp(' '), '+');
            // companyDetails = companyDetails?.replaceAll(RegExp('&'), '%26');
            // pushScreen(
            //     context,
            //     OrderBookingForm3());
            // print("Clicked");
            var salesPromos = getOrderBookingSalesPromo(item, customerType, companies,orderList, customers, context);
            print(salesPromos);
        },
        child: Icon(
          Icons.arrow_forward,
          color: whiteColor,
        ),
      ),
        ],
      ),
      body: oblist.length == 0
          ? Center(
              child: Text(
              'List is empty',
              style: TextStyle(fontSize: 18, color: blackColor),
            ))
          : Column(
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
    quantitycontrollerlist[index].text = 1.0.toString();
    itemcodecontrollerlist[index].text = itemCode;
    orderDetails = await getOrderBookingDetails(itemCode,customertype,company,customer, context);
    quantityavailablecontrollerlist[index].text = orderDetails["message"]["available_qty"].toString();
    lastbatchpricecontrollerlist[index].text = orderDetails["message"]["price_details"]["price"].toString();
    ratecontractcontrollerlist[index].text = orderDetails["message"]["price_details"]["rate_contract_check"].toString();
    mrpcontractcontrollerlist[index].text = orderDetails["message"]["price_details"]["mrp"].toString();
    brandcontractcontrollerlist[index].text = orderDetails["message"]["brand_name"]["brand_name"].toString();
    // List item = [
    //   for (var i in itemCode)
      
    // ]
      for (int i in item){
       item[i].add(itemCode); 
       print(item);
      }
      
      // item[i].add(orderDetails["message"]["available_qty"]),
    
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
                  Row(
                    children:[
                      SizedBox(
                        height: 50,
                        width: 110,
                        child:TextField(
                        decoration: InputDecoration(
                        labelText: 'Brand Name',
                        ),
                        enabled: false,
                        controller: brandcontractcontrollerlist[widget.i],
                        style: TextStyle(fontSize: 14, color: blackColor),
                      ),
                      ),
                      SizedBox(width: 5),
                      SizedBox(
                        height: 50,
                        width: 110,
                        child:TextField(
                        decoration: InputDecoration(
                        labelText: 'Quantity Available',
                        ),
                        enabled: false,
                        controller: quantityavailablecontrollerlist[widget.i],
                        style: TextStyle(fontSize: 14, color: blackColor),
                      ),
                      ),
                      SizedBox(width: 5),
                      SizedBox(
                        height: 50,
                        width: 110,
                        child:TextField(
                        decoration: InputDecoration(
                        labelText: 'Last Batch Price',
                        ),
                        enabled: false,
                        controller: lastbatchpricecontrollerlist[widget.i],
                        style: TextStyle(fontSize: 14, color: blackColor),
                      ),
                      ),
                      SizedBox(width: 5),
                      SizedBox(
                        height: 50,
                        width: 100,
                        child:TextField(
                        decoration: InputDecoration(
                        labelText: 'Rate Contract',
                        ),
                        enabled: false,
                        controller: ratecontractcontrollerlist[widget.i],
                        style: TextStyle(fontSize: 14, color: blackColor),
                      ),
                      ),
                      SizedBox(width: 5),
                      SizedBox(
                        height: 50,
                        width: 50,
                        child:TextField(
                        decoration: InputDecoration(
                        labelText: 'MRP',
                        ),
                        enabled: false,
                        controller: mrpcontractcontrollerlist[widget.i],
                        style: TextStyle(fontSize: 14, color: blackColor),
                      ),
                      ),
                      SizedBox(width: 5),
                      Expanded(child: quantityField()),
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
      controller: itemcodecontrollerlist[widget.i],
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
      onChanged: (value) {
        if (value != '') {
          oblist[widget.i].qty = double.parse(value);
          if (!mounted) return;
          setState(() {});
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
      labelStyle: TextStyle(color: blackColor),
      style: TextStyle(fontSize: 14, color: blackColor),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

