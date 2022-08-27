import 'dart:convert';
import 'package:ebuzz/common/colors.dart';
import 'package:ebuzz/common/custom_appbar.dart';
import 'package:ebuzz/customer_outstanding/customer_outstanding_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../util/apiurls.dart';

class CustomerOutStandingList extends StatefulWidget {
  // var company, date, customer, customerName;
  final company, date, customer, customerName;

  CustomerOutStandingList({this.company, this.date, this.customer, this.customerName});

  @override
  State<CustomerOutStandingList> createState() =>
      _CustomerOutStandingListState();
}

class _CustomerOutStandingListState extends State<CustomerOutStandingList> {
  bool fetch = false;
  CustomerOutstandingModel? customerOutstandingModel;
  var responce;
  List accountReceivable = [];
  List header = [];
  bool head = false;

  Future getTableData() async {
    print("call");
    var company = jsonEncode(widget.company);
    var fromDate = jsonEncode(widget.date);
    var customer = jsonEncode(widget.customer);
    var customername = jsonEncode(widget.customerName);
    print(company);
    fetch = true;
    head = true;
    // var headers = {
    //   'Cookie':
    //       'full_name=Vishal%20Patel; sid=52023a9eff5496c6f3997afe3503df636fa06d3560dc2fd0a4416ee9; system_user=yes; user_id=prithvichowhan97%40gmail.com; user_image=https%3A//secure.gravatar.com/avatar/f8e2205f18d8e3e18fe031120b5aa50b%3Fd%3D404%26s%3D200'
    // };
    // var headers = {
    //   'Cookie': 'full_name=Vishal%20Patel; sid=a8dd85da2f5ea05156bb1e1a1a83c0b22965ec46a959d0d242d6b46b; system_user=yes; user_id=prithvichowhan97%40gmail.com; user_image=https%3A//secure.gravatar.com/avatar/f8e2205f18d8e3e18fe031120b5aa50b%3Fd%3D404%26s%3D200'
    // };
    // var request = http.MultipartRequest(
    //     'GET',
    //     Uri.parse(
    //         'https://erptest.bharathrajesh.co.in/api/method/frappe.desk.query_report.run'));
    //
    // request.fields.addAll({
    //   'report_name': 'Accounts Receivable',
    //   // 'filters': '{"company":${company},"report_date":"1899-01-01","ageing_based_on":"Due Date","range1":30,"range2":60,"range3":90,"range4":120}',
    //   'filters':
    //       '{"company":${company},"report_date":"2022-08-22","ageing_based_on":"Due Date","range1":30,"range2":60,"range3":90,"range4":120}',
    //   '_': '1661140719561'
    // });
    // var request = http.Request('GET', Uri.parse('https://erptest.bharathrajesh.co.in/api/method/frappe.desk.query_report.run?report_name=Accounts Receivable&filters={"company":"Bharath Medical %26 General Agencies","report_date":$fromDate,"customer":$customer,"ageing_based_on":"Due Date","range1":30,"range2":60,"range3":90,"range4":120,"customer_name":$customername,"payment_terms":"12 Days"}&_=1661313206364'));
    var request = http.Request('GET', Uri.parse(account_receivable(customer: customer,customername: customername,fromDate: fromDate)));

    request.headers.addAll(commonHeaders);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      setState(() {
        print(response.body);
        String data = response.body;
        responce = json.decode(data);
        // print("${responce['message']['result'][0]['voucher_type']}");
        fetch = false;
        print("table call");
        for (var i = 0; i < responce['message']['result'].length - 1; i++) {
          accountReceivable.add(responce['message']['result'][i]);
          print("accountReceivable length====>>>>>${accountReceivable.length}");
          print("accountReceivable====>>>>>${accountReceivable}");
        }
        for (var i = 0; i < responce['message']['result'].length; i++) {
          header.add(responce['message']['result'][i]);
          print("header length====>>>>>${header.length}");
          print("header====>>>>>${header.last}");
          head = false;
        }
        // customerOutstandingModel = CustomerOutstandingModel.fromJson(json.decode(data));
        // print("transactionModel====>>$customerOutstandingModel");
      });
    } else {
      print("error cause===>>${response.reasonPhrase}");
      setState(() {
        fetch = false;
      });
    }
  }

  @override
  void initState() {
    getTableData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffcfd6e7),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: CustomAppBar(
          title: Text('Accounts Receivable List',
              style: TextStyle(color: whiteColor)),
          leading: IconButton(
            onPressed: () => Navigator.pop(context, false),
            icon: Icon(
              Icons.arrow_back,
              color: whiteColor,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 8),
          Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Total Invoice Amount",
                                style: TextStyle(color: Colors.black)),
                            SizedBox(height: 10),
                            head == true ? Container(height: 20,width: 20,child: CircularProgressIndicator(color: Colors.black)) : Text("${header.last[9] == "" ? "0.0" : header.last[9]}", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17)),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Total Outstanding Amount",
                                style: TextStyle(
                                    color: Colors.black)),
                            SizedBox(height: 10),
                            head == true ? Container(height: 20,width: 20,child: CircularProgressIndicator(color: Colors.black)) : Text("${header.last[12] == "" ? "0.0" : header.last[12]}", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17)),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 180,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("0-30 Total",
                                  style: TextStyle(
                                      color: Colors.black)),
                              SizedBox(height: 10),
                              head == true ? Container(height: 20,width: 20,child: CircularProgressIndicator(color: Colors.black)) : Text("${header.last[14] == "" ? "0.0" : header.last[14]}", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 180,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("31-60 Total",
                                  style: TextStyle(
                                      color: Colors.black)),
                              SizedBox(height: 10),
                              head == true ? Container(height: 20,width: 20,child: CircularProgressIndicator(color: Colors.black)) : Text("${header.last[15] == "" ? "0.0" : header.last[15]}", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 180,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("61-90 Total",
                                  style: TextStyle(
                                      color: Colors.black)),
                              SizedBox(height: 10),
                              head == true ? Container(height: 20,width: 20,child: CircularProgressIndicator(color: Colors.black)) : Text("${header.last[16] == "" ? "0.0" : header.last[16]}", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 180,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("91-120 Total",
                                  style: TextStyle(
                                      color: Colors.black)),
                              SizedBox(height: 10),
                              head == true ? Container(height: 20,width: 20,child: CircularProgressIndicator(color: Colors.black)) : Text("${header.last[17] == "" ? "0.0" : header.last[17]}", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 180,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("121-above Total",
                                  style: TextStyle(
                                      color: Colors.black)),
                              SizedBox(height: 10),
                              head == true ? Container(height: 20,width: 20,child: CircularProgressIndicator(color: Colors.black)) : Text("${header.last[18] == "" ? "0.0" : header.last[17]}", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Container(
              //       padding: EdgeInsets.all(8),
              //       // decoration: BoxDecoration(
              //       //     color: blueAccent, borderRadius: BorderRadius.circular(8)),
              //       child: Column(
              //         children: [
              //           Text("Total Invoice Amount",
              //               style: TextStyle(
              //                   color: Colors.white)),
              //           SizedBox(height: 5),
              //           head == true ? Container(height: 20,width: 20,child: CircularProgressIndicator(color: Colors.white)) : Text("${header.last[9]}", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17)),
              //         ],
              //       ),
              //     ),
              //     Container(width: 1,color: Colors.white,height: 50),
              //     Container(
              //       padding: EdgeInsets.all(8),
              //       // decoration: BoxDecoration(
              //       //     color: blueAccent, borderRadius: BorderRadius.circular(8)),
              //       child: Column(
              //         children: [
              //           Text("Total Outstanding Amount",
              //               style: TextStyle(
              //                   color: Colors.white)),
              //           SizedBox(height: 5),
              //           head == true ? Container(height: 20,width: 20,child: CircularProgressIndicator(color: Colors.white)) : Text("${header.last[12]}", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17)),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
              // Container(width: double.infinity,color: Colors.white,height: 1),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Container(
              //       padding: EdgeInsets.all(8),
              //       // decoration: BoxDecoration(
              //       //     color: blueAccent, borderRadius: BorderRadius.circular(8)),
              //       child: Column(
              //         children: [
              //           Text("0-30",
              //               style: TextStyle(
              //                   color: Colors.white)),
              //           SizedBox(height: 5),
              //           head == true ? Container(height: 20,width: 20,child: CircularProgressIndicator(color: Colors.white)) : Text("${header.last[14]}", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17)),
              //         ],
              //       ),
              //     ),
              //     Container(width: 1,color: Colors.white,height: 50),
              //     Container(
              //       padding: EdgeInsets.all(8),
              //       // decoration: BoxDecoration(
              //       //     color: blueAccent, borderRadius: BorderRadius.circular(8)),
              //       child: Column(
              //         children: [
              //           Text("31-60",
              //               style: TextStyle(
              //                   color: Colors.white)),
              //           SizedBox(height: 5),
              //           head == true ? Container(height: 20,width: 20,child: CircularProgressIndicator(color: Colors.white)) : Text("${header.last[15]}", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17)),
              //         ],
              //       ),
              //     ),
              //     Container(width: 1,color: Colors.white,height: 50),
              //     Container(
              //       padding: EdgeInsets.all(8),
              //       // decoration: BoxDecoration(
              //       //     color: blueAccent, borderRadius: BorderRadius.circular(8)),
              //       child: Column(
              //         children: [
              //           Text("61-90",
              //               style: TextStyle(
              //                   color: Colors.white)),
              //           SizedBox(height: 5),
              //           head == true ? Container(height: 20,width: 20,child: CircularProgressIndicator(color: Colors.white)) : Text("${header.last[16]}", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17)),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
              // Container(width: double.infinity,color: Colors.white,height: 1),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Container(
              //       padding: EdgeInsets.all(8),
              //       // decoration: BoxDecoration(
              //       //     color: blueAccent, borderRadius: BorderRadius.circular(8)),
              //       child: Column(
              //         children: [
              //           Text("91-120",
              //               style: TextStyle(
              //                   color: Colors.white)),
              //           SizedBox(height: 5),
              //           head == true ? Container(height: 20,width: 20,child: CircularProgressIndicator(color: Colors.white)) : Text("${header.last[17] == "" ? "0.0" : header.last[17]}", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17)),
              //         ],
              //       ),
              //     ),
              //     Container(width: 1,color: Colors.white,height: 50),
              //     Container(
              //       padding: EdgeInsets.all(8),
              //       // decoration: BoxDecoration(
              //       //     color: blueAccent, borderRadius: BorderRadius.circular(8)),
              //       child: Column(
              //         children: [
              //           Text("121-above",
              //               style: TextStyle(
              //                   color: Colors.white)),
              //           SizedBox(height: 5),
              //           head == true ? Container(height: 20,width: 20,child: CircularProgressIndicator(color: Colors.white)) : Text("${header.last[18] == "" ? "0.0" : header.last[18]}", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17)),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
          Expanded(
            child: fetch == true
                ? Center(child: CircularProgressIndicator())
                : ListView.separated(
                    itemBuilder: (BuildContext context, index) {
                      return Padding(
                        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                listText(
                                    heading: "Voucher type",
                                    val:
                                        "${accountReceivable[index]['voucher_type']}"),
                                SizedBox(height: 8),
                                listText(
                                    heading: "Customer name",
                                    val:
                                        "${accountReceivable[index]['customer_name']}"),
                                SizedBox(height: 8),
                                listText(
                                    heading: "Posting date",
                                    val:
                                        "${accountReceivable[index]['posting_date']}"),
                                SizedBox(height: 8),
                                listText(
                                    heading: "Voucher number",
                                    val:
                                        "${accountReceivable[index]['voucher_no']}"),
                                SizedBox(height: 8),
                                listText(
                                    heading: "Due date",
                                    val:
                                        "${accountReceivable[index]['posting_date']}"),
                                SizedBox(height: 8),
                                listText(
                                    heading: "Invoice amount",
                                    val:
                                        "${accountReceivable[index]['invoice_grand_total']}"),
                                SizedBox(height: 8),
                                listText(
                                    heading: "Outstanding amount",
                                    val:
                                        "${accountReceivable[index]['outstanding']}"),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, index) {
                      return SizedBox(height: 0);
                    },
                    itemCount: accountReceivable.length),
          )
        ],
      ),
    );
  }

  Widget listText({heading, val}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${heading}:- ", style: TextStyle(fontWeight: FontWeight.bold)),
        Text(val, style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
