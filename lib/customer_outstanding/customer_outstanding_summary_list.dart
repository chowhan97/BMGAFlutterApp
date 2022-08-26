import 'dart:convert';
import 'dart:developer';
import 'package:ebuzz/common/colors.dart';
import 'package:ebuzz/common/custom_appbar.dart';
import 'package:ebuzz/common/navigations.dart';
import 'package:ebuzz/customer_outstanding/customer_outstanding_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
  String formatted = "";

  Future getTableData() async {
    print("call");
    log('data:call');
    var company = jsonEncode(widget.company);
    var fromDate = jsonEncode(widget.date);
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    formatted = formatter.format(now);
    print(formatted); // something like 2013-04-20
    print(company);
    fetch = true;
    head = true;
    var headers = {
      'Cookie': 'full_name=Vishal%20Patel; sid=a8dd85da2f5ea05156bb1e1a1a83c0b22965ec46a959d0d242d6b46b; system_user=yes; user_id=prithvichowhan97%40gmail.com; user_image=https%3A//secure.gravatar.com/avatar/f8e2205f18d8e3e18fe031120b5aa50b%3Fd%3D404%26s%3D200'
    };
    var request = http.MultipartRequest('GET', Uri.parse('https://erptest.bharathrajesh.co.in/api/method/frappe.desk.query_report.run'));

    request.fields.addAll({
      'report_name': 'Accounts Receivable Summary',
      'filters': '{"company":${company},"report_date":${jsonEncode(formatted)},"ageing_based_on":"Due Date","range1":30,"range2":60,"range3":90,"range4":120}',
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                        head == true ? Container(height: 20,width: 20,child: CircularProgressIndicator(color: Colors.black)) : Text("${header.last[3]}", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17)),
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
                            style: TextStyle(color: Colors.black)),
                        SizedBox(height: 10),
                        head == true ? Container(height: 20,width: 20,child: CircularProgressIndicator(color: Colors.black)) : Text("${header.last[6]}", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17)),
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
                          head == true ? Container(height: 20,width: 20,child: CircularProgressIndicator(color: Colors.black)) : Text("${header.last[7]}", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17)),
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
                          head == true ? Container(height: 20,width: 20,child: CircularProgressIndicator(color: Colors.black)) : Text("${header.last[8]}", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17)),
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
                          head == true ? Container(height: 20,width: 20,child: CircularProgressIndicator(color: Colors.black)) : Text("${header.last[9]}", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17)),
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
                          head == true ? Container(height: 20,width: 20,child: CircularProgressIndicator(color: Colors.black)) : Text("${header.last[10] == "" ? "0.0" : header.last[10]}", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17)),
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
                          Text("121-above Total", style: TextStyle(color: Colors.black)),
                          SizedBox(height: 10),
                          head == true ? Container(height: 20,width: 20,child: CircularProgressIndicator(color: Colors.black)) : Text("${header.last[11] == "" ? "0.0" : header.last[11]}", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: fetch == true
                ? Center(child: CircularProgressIndicator())
                : ListView.separated(
                itemBuilder: (BuildContext context, index) {
                  return Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: InkWell(
                      onTap: (){
                        pushScreen(context, CustomerOutStandingList(company: "Bharath Medical & General Agencies",date: formatted,customer: accountReceivableSummary[index]['party'], customerName: accountReceivableSummary[index]['party_name']));
                      },
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
                                  heading: "Customer",
                                  val:
                                  "${accountReceivableSummary[index]['party']}"),
                              SizedBox(height: 8),
                              listText(
                                  heading: "Customer name",
                                  val:
                                  "${accountReceivableSummary[index]['party_name']}"),
                              SizedBox(height: 8),
                              listText(
                                  heading: "Customer group",
                                  val:
                                  "${accountReceivableSummary[index]['customer_group']}"),
                              SizedBox(height: 8),
                              listText(
                                  heading: "Territory",
                                  val:
                                  "${accountReceivableSummary[index]['territory']}"),
                              SizedBox(height: 8),
                              listText(
                                  heading: "Due amount",
                                  val:
                                  "${accountReceivableSummary[index]['total_due']}"),
                              SizedBox(height: 8),
                              listText(
                                  heading: "Invoice amount",
                                  val:
                                  "${accountReceivableSummary[index]['invoiced']}"),
                              SizedBox(height: 8),
                              listText(
                                  heading: "Outstanding amount",
                                  val:
                                  "${accountReceivableSummary[index]['outstanding']}"),
                            ],
                          ),
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
