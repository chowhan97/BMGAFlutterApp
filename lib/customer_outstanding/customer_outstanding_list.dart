import 'dart:convert';
import 'package:ebuzz/common/colors.dart';
import 'package:ebuzz/common/custom_appbar.dart';
import 'package:ebuzz/customer_outstanding/customer_outstanding_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CustomerOutStandingList extends StatefulWidget {
  var company,date;
  CustomerOutStandingList({this.company, this.date});

  @override
  State<CustomerOutStandingList> createState() => _CustomerOutStandingListState();
}

class _CustomerOutStandingListState extends State<CustomerOutStandingList> {
  bool fetch = false;
  CustomerOutstandingModel? customerOutstandingModel;
  var responce;

  Future getTableData() async {
    print("call");
    var company = jsonEncode(widget.company);
    var fromDate = jsonEncode(widget.date);
    fetch = true;
    var headers = {
      'Cookie': 'full_name=Vishal%20Patel; sid=52023a9eff5496c6f3997afe3503df636fa06d3560dc2fd0a4416ee9; system_user=yes; user_id=prithvichowhan97%40gmail.com; user_image=https%3A//secure.gravatar.com/avatar/f8e2205f18d8e3e18fe031120b5aa50b%3Fd%3D404%26s%3D200'
    };
    var request = http.MultipartRequest('GET', Uri.parse('https://erptest.bharathrajesh.co.in/api/method/frappe.desk.query_report.run'));

    request.fields.addAll({
      'report_name': 'Accounts Receivable',
      // 'filters': '{"company":${company},"report_date":"1899-01-01","ageing_based_on":"Due Date","range1":30,"range2":60,"range3":90,"range4":120}',
      'filters': '{"company":${company},"report_date":"2022-08-22","ageing_based_on":"Due Date","range1":30,"range2":60,"range3":90,"range4":120}',
      '_': '1661140719561'
    });

    request.headers.addAll(headers);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      setState(() {
        print(response.body);
        String data = response.body;
        responce = json.decode(data);
        print("${responce['message']['result'][0]['voucher_type']}");
        fetch = false;
        print("table call");
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
          title: Text('Accounts Receivable List', style: TextStyle(color: whiteColor)),
          leading: IconButton(
            onPressed: () => Navigator.pop(context, false),
            icon: Icon(
              Icons.arrow_back,
              color: whiteColor,
            ),
          ),
        ),
      ),
      body: fetch == true ? Center(child: CircularProgressIndicator()): ListView.separated(itemBuilder: (BuildContext context,index){
        return Padding(
          padding: EdgeInsets.only(left: 10,right: 10,top: 10),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  listText(heading: "Voucher type",val: "${"Sales Invoice"}"),
                  SizedBox(height: 8),
                  listText(heading: "Customer name",val: "${"Big Hospitals"}"),
                  SizedBox(height: 8),
                  listText(heading: "Posting date",val: "${"2022-06-13"}"),
                  SizedBox(height: 8),
                  listText(heading: "Voucher number",val: "${"SINV-DL-00019"}"),
                  SizedBox(height: 8),
                  listText(heading: "Due date",val: "${"2022-06-13"}"),
                  SizedBox(height: 8),
                  listText(heading: "Invoice amount",val: "${"693.0"}"),
                  SizedBox(height: 8),
                  listText(heading: "Outstanding amount",val: "${"693.0"}"),
                ],
              ),
            ),
          ),
        );
      }, separatorBuilder: (BuildContext context,index){
        return SizedBox(height: 0);
      }, itemCount: 5),
      // body: Padding(
      //   padding: EdgeInsets.only(left: 10,right: 10,top: 10),
      //   child: Container(
      //     height: 200,
      //     child: Card(
      //       elevation: 5,
      //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      //       child: Padding(
      //         padding: EdgeInsets.all(10.0),
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             listText(heading: "Voucher type",val: "${"dfdf"}"),
      //             SizedBox(height: 8),
      //             listText(heading: "Customer name",val: "${"fdjgf"}"),
      //             SizedBox(height: 8),
      //             listText(heading: "Posting date",val: "${"fgjin"}"),
      //             SizedBox(height: 8),
      //             listText(heading: "Voucher number",val: "${"fkgf"}"),
      //             SizedBox(height: 8),
      //             listText(heading: "Due date",val: "${"fkgf"}"),
      //             SizedBox(height: 8),
      //             listText(heading: "Invoice number",val: "${"fkgf"}"),
      //             SizedBox(height: 8),
      //             listText(heading: "Outstanding amount",val: "${"fkgf"}"),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
  Widget listText({heading,val}){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${heading}:- ",style: TextStyle(fontWeight: FontWeight.bold)),
        Text(val,style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
