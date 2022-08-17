import 'dart:convert';

import 'package:ebuzz/common/colors.dart';
import 'package:ebuzz/common/custom_appbar.dart';
import 'package:ebuzz/common/custom_toast.dart';
import 'package:ebuzz/common_service/common_service.dart';
import 'package:ebuzz/orderbooking/service/orderbooking_api_service.dart';
import 'package:ebuzz/sales_person-wise_transactionHistory/transaction_model.dart';
import 'package:ebuzz/widgets/custom_typeahead_formfield.dart';
import 'package:ebuzz/widgets/typeahead_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({Key? key}) : super(key: key);

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  TextEditingController fromdate = TextEditingController();
  TextEditingController todate = TextEditingController();
  TextEditingController company = TextEditingController();
  List<String> companyList = [];
  bool fetch = false;
  TransactionModel? transactionModel;


  getCustomerAndCompanyList() async {
    companyList = await CommonService().getCompanyList(context);
    print(companyList.length);
    setState(() {});
  }

  Future getTableData() async {
    print("call");
    var toDate = jsonEncode(todate.text);
    var fromDate = jsonEncode(fromdate.text);
    fetch = true;
    var headers = {
      'Cookie': 'full_name=Jeeva; sid=6a44549626720c83d2d37a33716891f32dc8bf7978dcdaabbcf9b7b6; system_user=yes; user_id=jeeva%40yuvabe.com; user_image='
    };
    var request = http.MultipartRequest('POST', Uri.parse('https://erptest.bharathrajesh.co.in/api/method/frappe.desk.reportview.get'));

    request.fields.addAll({
      'doctype': 'Sales Invoice',
      'filters': '[["Sales Invoice","posting_date","<=",$toDate],["Sales Invoice","posting_date",">=",$fromDate],["Sales Invoice","company","=","Bharath Medical & General Agencies"]]',
      'fields': '["`tabSales Invoice`.`name`","`tabSales Invoice`.`docstatus`","`tabSales Invoice`.`title`","`tabSales Invoice`.`customer`","`tabSales Invoice`.`company`","`tabSales Invoice`.`grand_total`","`tabSales Invoice`.`status`","`tabSales Invoice`.`currency`","`tabSales Invoice`.`customer_name`","`tabSales Invoice`.`base_grand_total`","`tabSales Invoice`.`outstanding_amount`","`tabSales Invoice`.`due_date`","`tabSales Invoice`.`is_return`"]',
      'distinct': 'false'
    });

    request.headers.addAll(headers);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      setState(() {
        print(response.body);
        String data = response.body;
        fetch = false;
        print("table call");
        transactionModel = TransactionModel.fromJson(json.decode(data));
        print("transactionModel====>>$transactionModel");
      });
    } else {
      print(response.reasonPhrase);
      setState(() {
        fetch = false;
      });
    }
  }

  @override
  void initState() {
    getCustomerAndCompanyList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffcfd6e7),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: CustomAppBar(
          title:
              Text('Transaction Summary', style: TextStyle(color: whiteColor)),
          leading: IconButton(
            onPressed: () => Navigator.pop(context, false),
            icon: Icon(
              Icons.arrow_back,
              color: whiteColor,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(color: whiteColor,borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("From Date",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  dateWidget(
                      hintText: "Select From Date",
                      controller: fromdate,
                      ontap: () {
                        opencalender(isFrom: true);
                      }),
                  SizedBox(height: 10),
                  Text("To Date",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  dateWidget(
                      hintText: "Select To Date",
                      controller: todate,
                      ontap: () {
                        opencalender(isTo: true);
                      }),
                  SizedBox(height: 10),
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
                    labelStyle: TextStyle(
                        color: blackColor, fontWeight: FontWeight.bold),
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
                      return TypeAheadWidgets.getSuggestions(pattern, companyList);
                    },
                    transitionBuilder: (context, suggestionsBox, controller) {
                      return suggestionsBox;
                    },
                    validator: (val) => val == '' || val == null
                        ? 'Company name should not be empty'
                        : null,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            MaterialButton(onPressed: (){
              if(fromdate.text.isEmpty || todate.text.isEmpty || company.text.isEmpty){
                fluttertoast(whiteColor, redColor, fromdate.text.isEmpty ? "Please choose from date!!!" : todate.text.isEmpty ? "Please choose to date!!!" : "Please choose company!!!");
              }else{
                getTableData();
              }
            },shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),color: Colors.blue,height: 50,minWidth: double.infinity,child: Text("Fetch History",style: TextStyle(fontSize: 18,color: whiteColor)))
          ],
        ),
      ),
    );
  }

  Widget dateWidget({hintText, controller, ontap}) {
    return TextFormField(
      controller: controller,
      readOnly: true,
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
          suffixIcon: Icon(Icons.calendar_today_outlined)),
    );
  }

  opencalender({isFrom,isTo}) async{
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
        if(isFrom == true){
          fromdate.text = formattedDate;
        }else if(isTo == true){
          todate.text = formattedDate;
        }else{}
      });
    } else {}
  }
}
