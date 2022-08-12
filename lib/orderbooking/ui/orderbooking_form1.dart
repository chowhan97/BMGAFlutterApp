import 'package:ebuzz/common/colors.dart';
import 'package:ebuzz/common/custom_appbar.dart';
import 'package:ebuzz/common/display_helper.dart';
import 'package:ebuzz/common/navigations.dart';
import 'package:ebuzz/common_service/common_service.dart';
import 'package:ebuzz/orderbooking/ui/orderbooking_form2.dart';
import 'package:ebuzz/widgets/custom_dropdown.dart';
import 'package:ebuzz/widgets/custom_textformformfield.dart';
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

  

  TextEditingController customerController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController warehouseController = TextEditingController();
  TextEditingController CustomerTypeField = TextEditingController();
  // TextEditingController customer_typeController = TextEditingController();
  

  bool loading = false;


  @override
  void initState() {
    super.initState();
    getCustomerAndCompanyList();
  }

  getCustomerAndCompanyList() async {
    companyList = await CommonService().getCompanyList(context);
    customerList = await CommonService().getCustomerList(context);
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
          title: Text('Order Booking Form', style: TextStyle(color: whiteColor)),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: whiteColor,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blueAccent,
        onPressed: () {
          if (customerController.text.isNotEmpty && companyController.text.isNotEmpty) {
            pushScreen(context,
                OrderBookingForm2(
                  company: companyController.text,
                  customer: customerController.text,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              companyField(),
              SizedBox(height: 15),
              customerField(),
              SizedBox(height: 15),
              customerTypeField(),
              SizedBox(height: 15),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  Widget customerTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Customer Type"),
        SizedBox(height: 8),
        TextFormField(
          controller: CustomerTypeField,
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
        ),
      ],
    );
    // return CustomDropDown(
    //   value: customertype,
    //   decoration: BoxDecoration(
    //       color: greyColor, borderRadius: BorderRadius.circular(5)),
    //   items:  customerTypeList.map<DropdownMenuItem<String>>((value) {
    //     return DropdownMenuItem<String>(
    //       value: value,
    //       child: Text(
    //         value.toString(),
    //         style: TextStyle(fontSize: 14),
    //       ),
    //     );
    //   }).toList(),
    //   alignment: CrossAxisAlignment.start,
    //   onChanged: (String? newValue) {
    //     setState(() {
    //       customertype = newValue!;
    //     });
    //   },
    //   label: 'Customer Type',
    //   labelStyle: TextStyle(fontSize: 14),
    //   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
    // );
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
      ),
      label: 'Company',
      labelStyle: TextStyle(color: blackColor),
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
        });
        //after selecting company fetch warehuselist

        // getWarehouseList(companyController.text);
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
          )),
      label: 'Customer',
      labelStyle: TextStyle(color: blackColor),
      required: true,
      style: TextStyle(fontSize: 14, color: blackColor),
      itemBuilder: (context, item) {
        return TypeAheadWidgets.itemUi(item);
      },
      onSuggestionSelected: (suggestion) async {
        customerController.text = suggestion;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          prefs.setString("customer", customerController.text);
          getCustomerType(suggestion: suggestion);
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
    var customerType = await CommonService().getCustomerType(context,customer: suggestion);
    CustomerTypeField.text = customerType;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("cust_type", CustomerTypeField.text);
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
