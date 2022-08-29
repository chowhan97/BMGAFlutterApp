import 'package:ebuzz/common/colors.dart';
import 'package:ebuzz/common/custom_appbar.dart';
import 'package:ebuzz/common/custom_toast.dart';
import 'package:ebuzz/common/navigations.dart';
import 'package:ebuzz/common_service/common_service.dart';
import 'package:ebuzz/customer_outstanding/customer_outstanding_list.dart';
import 'package:ebuzz/customer_outstanding/customer_outstanding_summary_list.dart';
import 'package:ebuzz/widgets/custom_typeahead_formfield.dart';
import 'package:ebuzz/widgets/typeahead_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomerOutStanding extends StatefulWidget {
  const CustomerOutStanding({Key? key}) : super(key: key);

  @override
  State<CustomerOutStanding> createState() => _CustomerOutStandingState();
}

class _CustomerOutStandingState extends State<CustomerOutStanding> {

  List<String> companyList = [];
  List<String> customerList = [];
  List<String> customerName = [];
  TextEditingController company = TextEditingController();
  TextEditingController customer = TextEditingController();
  TextEditingController customername = TextEditingController();
  TextEditingController reportDate = TextEditingController();
  TextEditingController range1 = TextEditingController();
  TextEditingController range2 = TextEditingController();
  TextEditingController range3 = TextEditingController();
  TextEditingController range4 = TextEditingController();
  bool accountReceivableSummary = true;
  bool accountReceivable = false;

  getCustomerAndCompanyList() async {
    companyList = await CommonService().getCompanyList(context);
    customerList = await CommonService().getCustomerList(context);
    customerName = await CommonService().getCustomerName(context);
    print(companyList.length);
    setState(() {});
  }

  @override
  void initState() {
    getCustomerAndCompanyList();
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    setState(() {
      reportDate.text = formattedDate;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffcfd6e7),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: CustomAppBar(
          title: Text('Accounts Receivable', style: TextStyle(color: whiteColor)),
          leading: IconButton(
            onPressed: () => Navigator.pop(context, false),
            icon: Icon(
              Icons.arrow_back,
              color: whiteColor,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        setState(() {
                          accountReceivableSummary = true;
                          accountReceivable = false;
                        });
                      },
                      child: Container(
                        height: 65,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: accountReceivableSummary == true ? Colors.blue : greyColor,borderRadius: BorderRadius.only(topLeft: Radius.circular(8),bottomLeft: Radius.circular(8))),
                        child: Text('Account Receivable', style: TextStyle(fontSize: 15,color: accountReceivableSummary == true ?whiteColor : Colors.black),textAlign: TextAlign.center),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        setState(() {
                          accountReceivable = true;
                          accountReceivableSummary = false;
                        });
                      },
                      child: Container(
                        height: 65,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: accountReceivable == true ? Colors.blue : greyColor,borderRadius: BorderRadius.only(topRight:  Radius.circular(8),bottomRight:  Radius.circular(8))),
                        child: Text('Account Receivable\nSummary', style: TextStyle(fontSize: 15,color: accountReceivable == true ?whiteColor : Colors.black),textAlign: TextAlign.center),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 15),
              if(accountReceivableSummary == true)
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: whiteColor, borderRadius: BorderRadius.circular(15)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTypeAheadFormField(
                      controller: company,
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
                      labelStyle:
                      TextStyle(color: blackColor, fontWeight: FontWeight.bold),
                      style: TextStyle(fontSize: 14, color: blackColor),
                      itemBuilder: (context, item) {
                        return TypeAheadWidgets.itemUi(item);
                      },
                      onSuggestionSelected: (suggestion) async {
                        print("suggestion selected");
                        setState(() {
                          company.text = suggestion;
                        });
                      },
                      suggestionsCallback: (pattern) {
                        print("suggestion list call");
                        return TypeAheadWidgets.getSuggestions(
                            pattern, companyList);
                      },
                      transitionBuilder: (context, suggestionsBox, controller) {
                        return suggestionsBox;
                      },
                      validator: (val) => val == '' || val == null
                          ? 'Company name should not be empty'
                          : null,
                    ),
                SizedBox(height: 10),
                CustomTypeAheadFormField(
                  controller: customer,
                  decoration: InputDecoration(
                    fillColor: greyColor,
                    filled: true,
                    isDense: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    hintText: 'Select Customer Name',
                  ),
                  label: 'Customer Name',
                  labelStyle: TextStyle(color: blackColor,fontWeight: FontWeight.bold),
                  // required: true,
                  style: TextStyle(fontSize: 14, color: blackColor),
                  itemBuilder: (context, item) {
                    return TypeAheadWidgets.itemUi(item);
                  },
                  onSuggestionSelected: (suggestion) async {
                    customer.text = suggestion;
                    print("this is index===>>>>${customerName.indexOf(suggestion)}");
                    print("this is code===>>>${customerList[customerName.indexOf(suggestion)]}");
                    setState(() {
                      customername.text = customerList[customerName.indexOf(suggestion)];
                    });
                  },
                  suggestionsCallback: (pattern) {
                    return TypeAheadWidgets.getSuggestions(pattern, customerName);
                  },
                  transitionBuilder: (context, suggestionsBox, controller) {
                    return suggestionsBox;
                  },
                  validator: (val) => val == '' || val == null ? 'Customer name should not be empty' : null,
                ),
                    // SizedBox(height: 10),
                    // Text("From date", style: TextStyle(fontWeight: FontWeight.bold)),
                    // SizedBox(height: 8),
                    // dateWidget(
                    //     hintText: "Select From Date",
                    //     controller: reportDate,
                    //     ontap: () {opencalender();},
                    //     suffixIcon: Icons.calendar_today_outlined,readOnly: true),
                    // SizedBox(height: 10),
                    // Text("Range 1", style: TextStyle(fontWeight: FontWeight.bold)),
                    // SizedBox(height: 8),
                    // dateWidget(
                    //     hintText: "Range 1",
                    //     controller: range1,readOnly: false
                    // ),
                    // SizedBox(height: 10),
                    // Text("Range 2", style: TextStyle(fontWeight: FontWeight.bold)),
                    // SizedBox(height: 8),
                    // dateWidget(
                    //   hintText: "Range 2",
                    //   controller: range2,readOnly: false
                    // ),
                    // SizedBox(height: 10),
                    // Text("Range 3", style: TextStyle(fontWeight: FontWeight.bold)),
                    // SizedBox(height: 8),
                    // dateWidget(
                    //   hintText: "Range 3",
                    //   controller: range3,readOnly: false
                    // ),
                    // SizedBox(height: 10),
                    // Text("Range 4", style: TextStyle(fontWeight: FontWeight.bold)),
                    // SizedBox(height: 8),
                    // dateWidget(
                    //   hintText: "Range 4",
                    //   controller: range4,readOnly: false
                    // ),
                  ],
                ),
              ),
              if(accountReceivable == true)
              Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: whiteColor, borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTypeAheadFormField(
                        controller: company,
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
                        labelStyle:
                        TextStyle(color: blackColor, fontWeight: FontWeight.bold),
                        style: TextStyle(fontSize: 14, color: blackColor),
                        itemBuilder: (context, item) {
                          return TypeAheadWidgets.itemUi(item);
                        },
                        onSuggestionSelected: (suggestion) async {
                          print("suggestion selected");
                          setState(() {
                            company.text = suggestion;
                          });
                        },
                        suggestionsCallback: (pattern) {
                          print("suggestion list call");
                          return TypeAheadWidgets.getSuggestions(
                              pattern, companyList);
                        },
                        transitionBuilder: (context, suggestionsBox, controller) {
                          return suggestionsBox;
                        },
                        validator: (val) => val == '' || val == null
                            ? 'Company name should not be empty'
                            : null,
                      ),
                      // SizedBox(height: 10),
                      // Text("From date", style: TextStyle(fontWeight: FontWeight.bold)),
                      // SizedBox(height: 8),
                      // dateWidget(
                      //     hintText: "Select From Date",
                      //     controller: reportDate,
                      //     ontap: () {opencalender();},
                      //     suffixIcon: Icons.calendar_today_outlined,readOnly: true),
                      // SizedBox(height: 10),
                      // Text("Range 1", style: TextStyle(fontWeight: FontWeight.bold)),
                      // SizedBox(height: 8),
                      // dateWidget(
                      //     hintText: "Range 1",
                      //     controller: range1,readOnly: false
                      // ),
                      // SizedBox(height: 10),
                      // Text("Range 2", style: TextStyle(fontWeight: FontWeight.bold)),
                      // SizedBox(height: 8),
                      // dateWidget(
                      //   hintText: "Range 2",
                      //   controller: range2,readOnly: false
                      // ),
                      // SizedBox(height: 10),
                      // Text("Range 3", style: TextStyle(fontWeight: FontWeight.bold)),
                      // SizedBox(height: 8),
                      // dateWidget(
                      //   hintText: "Range 3",
                      //   controller: range3,readOnly: false
                      // ),
                      // SizedBox(height: 10),
                      // Text("Range 4", style: TextStyle(fontWeight: FontWeight.bold)),
                      // SizedBox(height: 8),
                      // dateWidget(
                      //   hintText: "Range 4",
                      //   controller: range4,readOnly: false
                      // ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: MaterialButton(
            onPressed: () {
              if(accountReceivableSummary == true){
                if(customer.text.isEmpty || company.text.isEmpty){
                  fluttertoast(whiteColor, redColor, company.text.isEmpty ? "Please choose company!!!" : "Please choose customer!!!");
                }else{
                  pushScreen(context, CustomerOutStandingList(company: company.text,date: reportDate.text,customer: customername.text, customerName: customer.text));
                }
              }else{
                if(company.text.isEmpty){
                  fluttertoast(whiteColor, redColor, "Please choose company!!!");
                }else{
                  pushScreen(context, CustomerOutstandingSummary(company: company.text,date: reportDate.text));
                }
              }
              // if (customer.text.isEmpty || company.text.isEmpty) {
              //   fluttertoast(whiteColor, redColor, company.text.isEmpty ? "Please choose company!!!" : "Please choose customer!!!");
              // }
              // else {
              //   if(accountReceivableSummary == true){
              //     pushScreen(context, CustomerOutStandingList(company: company.text,date: reportDate.text,customer: customer.text, customerName: customername.text));
              //   }else{
              //     pushScreen(context, CustomerOutstandingSummary(company: company.text,date: reportDate.text));
              //   }
              // }
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            color: Colors.blue,
            height: 50,
            minWidth: double.infinity,
            child: Text("Fetch Account", style: TextStyle(fontSize: 18, color: whiteColor))),
      ),
    );
  }

  Widget dateWidget({hintText, controller, ontap, suffixIcon, readOnly}) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: ontap,
      decoration: InputDecoration(
          labelStyle: TextStyle(color: blackColor),
          fillColor: greyColor,
          filled: true,
          isDense: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(5),
          ),
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 14),
          suffixIcon: Icon(suffixIcon)),
    );
  }

  opencalender() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2100));

    if (pickedDate != null) {
      print(pickedDate);
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      print(formattedDate);
      setState(() {
        reportDate.text = formattedDate;
      });
    } else {}
  }
}
