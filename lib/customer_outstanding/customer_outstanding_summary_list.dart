import 'dart:convert';
import 'package:ebuzz/common/colors.dart';
import 'package:ebuzz/common/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CustomerOutstandingSummary extends StatefulWidget {
  var company, date;
  CustomerOutstandingSummary({this.company, this.date});

  @override
  State<CustomerOutstandingSummary> createState() => _CustomerOutstandingSummaryState();
}

class _CustomerOutstandingSummaryState extends State<CustomerOutstandingSummary> {
  bool fetch = false;
  var responce;
  List accountReceivableSummary = [];
  List header = [];
  bool head = false;

  Future getTableData() async {
    print("call");
    var company = jsonEncode(widget.company);
    var fromDate = jsonEncode(widget.date);
    print(company);
    fetch = true;
    head = true;
    var headers = {
      'Cookie': 'full_name=Vishal%20Patel; sid=a8dd85da2f5ea05156bb1e1a1a83c0b22965ec46a959d0d242d6b46b; system_user=yes; user_id=prithvichowhan97%40gmail.com; user_image=https%3A//secure.gravatar.com/avatar/f8e2205f18d8e3e18fe031120b5aa50b%3Fd%3D404%26s%3D200'
    };
    var request = http.MultipartRequest('GET', Uri.parse('https://erptest.bharathrajesh.co.in/api/method/frappe.desk.query_report.run'));

    request.fields.addAll({
      'report_name': 'Accounts Receivable Summary',
      'filters': '{"company":${company},"report_date":"2022-08-22","ageing_based_on":"Due Date","range1":30,"range2":60,"range3":90,"range4":120}',
      '_': '1661140719612'
    });

    request.headers.addAll(headers);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      setState(() {
        print(response.body);
        String data = response.body;
        responce = json.decode(data);
        fetch = false;
        print("table call");
        for (var i = 0; i < responce['message']['result'].length - 1; i++) {
          accountReceivableSummary.add(responce['message']['result'][i]);
          print("accountReceivable length====>>>>>${accountReceivableSummary.length}");
          print("accountReceivable====>>>>>${accountReceivableSummary}");
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
          title: Text('Accounts Receivable Summary List',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: blueAccent, borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: [
                    Text("Total Invoice Amount",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    head == true ? Container(height: 20,width: 20,child: CircularProgressIndicator(color: Colors.white)) : Text("${header.last[9]}", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: blueAccent, borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: [
                    Text("Total Outstanding Amount",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    head == true ? Container(height: 20,width: 20,child: CircularProgressIndicator(color: Colors.white)) : Text("${header.last[12]}", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
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
                                "${accountReceivableSummary[index]['voucher_type']}"),
                            SizedBox(height: 8),
                            listText(
                                heading: "Customer name",
                                val:
                                "${accountReceivableSummary[index]['customer_name']}"),
                            SizedBox(height: 8),
                            listText(
                                heading: "Posting date",
                                val:
                                "${accountReceivableSummary[index]['posting_date']}"),
                            SizedBox(height: 8),
                            listText(
                                heading: "Voucher number",
                                val:
                                "${accountReceivableSummary[index]['voucher_no']}"),
                            SizedBox(height: 8),
                            listText(
                                heading: "Due date",
                                val:
                                "${accountReceivableSummary[index]['posting_date']}"),
                            SizedBox(height: 8),
                            listText(
                                heading: "Invoice amount",
                                val:
                                "${accountReceivableSummary[index]['invoice_grand_total']}"),
                            SizedBox(height: 8),
                            listText(
                                heading: "Outstanding amount",
                                val:
                                "${accountReceivableSummary[index]['outstanding']}"),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, index) {
                  return SizedBox(height: 0);
                },
                itemCount: accountReceivableSummary.length),
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
