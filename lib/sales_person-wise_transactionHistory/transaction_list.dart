import 'dart:convert';
import 'package:ebuzz/sales_person-wise_transactionHistory/transaction_model.dart';
import 'package:http/http.dart' as http;
import 'package:ebuzz/common/colors.dart';
import 'package:ebuzz/common/custom_appbar.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatefulWidget {
  var fromdate,todate;
  TransactionList({this.fromdate, this.todate});

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  bool fetch = false;
  TransactionModel? transactionModel;

  Future getTableData() async {
    print("call");
    var toDate = jsonEncode(widget.todate);
    var fromDate = jsonEncode(widget.fromdate);
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
          title:
          Text('Transaction List', style: TextStyle(color: whiteColor)),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${transactionModel!.message!.values![index][8].toString()}",style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("₹ ${transactionModel!.message!.values![index][5].toString()}",style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 8),
                  listText(heading: "Status",val: "${transactionModel!.message!.values![index][6].toString()}"),
                  SizedBox(height: 8),
                  listText(heading: "Due Date",val: "${transactionModel!.message!.values![index][11].toString()}"),
                  SizedBox(height: 8),
                  listText(heading: "Invoice ID",val: "${transactionModel!.message!.values![index][0].toString()}"),
                  SizedBox(height: 8),
                  listText(heading: "Outstanding Amount",val: "${transactionModel!.message!.values![index][10].toString()}"),
                ],
              ),
            ),
          ),
        );
      }, separatorBuilder: (BuildContext context,index){
        return SizedBox(height: 0);
      }, itemCount: transactionModel!.message!.values!.length),
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
