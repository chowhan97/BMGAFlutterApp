import 'dart:convert';

import 'package:ebuzz/common/colors.dart';
import 'package:ebuzz/common/custom_appbar.dart';
import 'package:ebuzz/common/display_helper.dart';
import 'package:ebuzz/common/navigations.dart';
import 'package:ebuzz/common_service/common_service.dart';
import 'package:ebuzz/orderbooking/ui/orderbooking_form2.dart';
import 'package:ebuzz/util/constants.dart';
import 'package:ebuzz/widgets/custom_typeahead_formfield.dart';
import 'package:ebuzz/widgets/typeahead_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderBookingForm1 extends StatefulWidget {
  @override
  _OrderBookingForm1State createState() => _OrderBookingForm1State();
}

class _OrderBookingForm1State extends State<OrderBookingForm1> {
  String customertype = 'Retail';
  String portOfDischarge = 'Yokohama, Japan';
  List<String> portList = [
    'Yokohama, Japan',
    'Tokyo, Japan',
    'Nagoya, Japan',
    'Kobe, Japan',
    'Oakland, California, USA',
    'Narita, Japan',
    'Botswana',
    'Sydney, Australia'
  ];
  List<String> customerTypeList = [
    'Retail',
    'Hospital',
    'Institutional',
  ];
  List<String> companyList = [];
  List<String> customerList = [];
  List<String> warehouseList = [];
  List<String> custId = [];

  

  TextEditingController customerController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController warehouseController = TextEditingController();
  TextEditingController CustomerTypeField = TextEditingController();
  TextEditingController CreditlimitField = TextEditingController();
  TextEditingController UnpaidField = TextEditingController();
  // TextEditingController customer_typeController = TextEditingController();
  

  bool loading = false;


  @override
  void initState() {
    super.initState();
    getCustomerAndCompanyList();
  }

  getCustomerAndCompanyList() async {
    companyList = await CommonService().getCompanyList(context);
    // customerList = await CommonService().getCustomerList(context);
    customerList = await CommonService().getCustomerName(context);
    print("customerList????===========?????${customerList}");
    custId = await CommonService().getCustomerList(context);
    // customer_typeList = await
    print(customerList.length);
    print(companyList.length);
    setState(() {});
  }

  getWarehouseList(String company) async {
    warehouseList = await CommonService().getWarehouseList(company, context);
    print(warehouseList.length);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(displayWidth(context) > 600 ? 80 : 55),
        child: CustomAppBar(
          title: Text('Order Booking', style: TextStyle(color: textcolor)),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: textcolor,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Constants.buttonColor,
        onPressed: () async{
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (customerController.text.isNotEmpty && companyController.text.isNotEmpty) {
            pushScreen(context,
                OrderBookingForm2(
                   unPaidAmount: prefs.getString("unpaid"),
                   creditLimit: prefs.getString("creditlimit"),
                  company: companyController.text,
                  // customer: customerController.text,
                  customer: custId[customerList.indexOf(customerController.text)],
                  customertype: customertype,
                ),
            );
          }
        },
        child: Icon(
          Icons.arrow_forward,
          color: whiteColor,
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    companyField(),
                    SizedBox(height: 15),
                    customerField(),
                    SizedBox(height: 15),
                    customerTypeField(),
                    SizedBox(height: 15),
                    creditlimitField(),
                    SizedBox(height: 15),
                    unpaidAmountField(),
                    // SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget customerTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Customer Type",style: TextStyle(fontWeight: FontWeight.bold),),
        SizedBox(height: 8),
        TextFormField(
          controller: CustomerTypeField,
          readOnly: true,
          decoration: InputDecoration(
            labelStyle: TextStyle(color: blackColor),
            fillColor: greyColor,
            filled: true,
            isDense: true,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(5),
            ),
            hintText: 'Select Customer Type',
            hintStyle: TextStyle(fontSize: 14,),
          ),
        ),
      ],
    );
  }

  Widget creditlimitField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Credit limit",style: TextStyle(fontWeight: FontWeight.bold),),
        SizedBox(height: 8),
        TextFormField(
          controller: CreditlimitField,
          readOnly: true,
          decoration: InputDecoration(
            labelStyle: TextStyle(color: blackColor),
            fillColor: greyColor,
            filled: true,
            isDense: true,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(5),
            ),
            hintText: 'Select Credit limit',
            hintStyle: TextStyle(fontSize: 14,),
          ),
        ),
      ],
    );
  }

  Widget unpaidAmountField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Unpaid Amount",style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        TextFormField(
          controller: UnpaidField,
          readOnly: true,
          decoration: InputDecoration(
            labelStyle: TextStyle(color: blackColor),
            fillColor: greyColor,
            filled: true,
            isDense: true,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(5),
            ),
            hintText: 'Select Unpaid amount',
            hintStyle: TextStyle(fontSize: 14,),
          ),
        ),
      ],
    );
  }

  Widget companyField() {
    return CustomTypeAheadFormField(
      controller: companyController,
      decoration: InputDecoration(
          fillColor: greyColor,
          filled: true,
          isDense: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(5),
          ),
        hintText: 'Select Company',
      ),
      label: 'Company',
      labelStyle: TextStyle(color: blackColor,fontWeight: FontWeight.bold),
      required: true,
      style: TextStyle(fontSize: 14, color: blackColor),
      itemBuilder: (context, item) {
        return TypeAheadWidgets.itemUi(item);
      },
      onSuggestionSelected: (suggestion) async {
        print("suggestion selected");
        companyController.text = suggestion;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          prefs.setString("company", companyController.text);
          var company = prefs.getString("company");
          print("????????????$company");
        });
      },
      suggestionsCallback: (pattern) {
        print("suggestion list call");
        return TypeAheadWidgets.getSuggestions(pattern, companyList);
      },
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      validator: (val) => val == '' || val == null ? 'Company name should not be empty' : null,
    );
  }

  Widget customerField() {
    return CustomTypeAheadFormField(
      controller: customerController,
      decoration: InputDecoration(
          fillColor: greyColor,
          filled: true,
          isDense: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(5),
          ),
        // hintText: 'Select Customer',
        hintText: 'Select Customer name',
      ),
      // label: 'Customer',
      label: 'Customer Name',
      labelStyle: TextStyle(color: blackColor,fontWeight: FontWeight.bold),
      required: true,
      style: TextStyle(fontSize: 14, color: blackColor),
      itemBuilder: (context, item) {
        return TypeAheadWidgets.itemUi(item);
      },
      onSuggestionSelected: (suggestion) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          // prefs.setString("customer", customerController.text);
          // var cust = prefs.getString("customer");
          // print("cust????????$cust");
          print(customerList.indexOf(suggestion));
          print(custId[customerList.indexOf(suggestion)]);
          getCustomerType(suggestion: custId[customerList.indexOf(suggestion)]);
          prefs.setString("customer", custId[customerList.indexOf(suggestion)]);
          customerController.text = suggestion;
          prefs.setString("customerName", suggestion);
          print(custId[customerList.indexOf(suggestion)]);
          var cust = prefs.getString("customer");
          var custName = prefs.getString("customerName");
          print("cust????????$cust");
          print("custName????????$custName");
        });
      },
      suggestionsCallback: (pattern) {
        return TypeAheadWidgets.getSuggestions(pattern, customerList);
      },
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      validator: (val) => val == '' || val == null ? 'Customer name should not be empty' : null,
    );
  }


  getCustomerType({suggestion}) async {
    print("suggestion is====>>${suggestion}");
    var formatter = NumberFormat('#,##,000');
    var customerType = await CommonService().getCustomerType(context,customer: suggestion,company: Uri.encodeFull(companyController.text).replaceAll("&", "%26"));
    print("cust type is===>>$customerType");
    //cust type is===>>[[{cust_type: Retail, unpaid_amount: 0.0, credit_limit: 0}]]
    CustomerTypeField.text = customerType[0][0]['cust_type'].toString();
    UnpaidField.text = "₹${formatter.format(customerType[0][0]['unpaid_amount'])}";
    CreditlimitField.text = "₹${formatter.format(customerType[0][0]['credit_limit'])}";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("cust_type", CustomerTypeField.text);
    prefs.setString("unpaid", customerType[0][0]['unpaid_amount'].toString());
    prefs.setString("creditlimit", customerType[0][0]['credit_limit'].toString());
    var cust_type = prefs.getString("cust_type");
    print("cust_type?????????$cust_type");
    setState(() {});
  }
  //   for (var products in list) {
  //     for (var product in products) {
  //       if (product['name'] == name){
  //         setState(() {
  //           CustomerTypeField.text = product['customer_type'];
  //         });
  //       }
  //       print("product is====>>>>$product");
  //       return product;
  //     }
  //   }
  // }

}
