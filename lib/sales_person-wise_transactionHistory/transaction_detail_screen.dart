import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ebuzz/common/colors.dart';
import 'package:ebuzz/common/custom_appbar.dart';
import 'package:ebuzz/common/display_helper.dart';
import 'package:ebuzz/common/ui_reusable_widget.dart';
import 'package:ebuzz/common_models/product.dart';
import 'package:ebuzz/common_service/common_service.dart';
import 'package:ebuzz/config/color_palette.dart';
import 'package:ebuzz/exception/custom_exception.dart';
import 'package:ebuzz/network/base_dio.dart';
import 'package:ebuzz/orderbooking/model/notEditable_model.dart';
import 'package:ebuzz/orderbooking/model/order_booking.dart';
// import 'package:ebuzz/orderbooking/model/table_model.dart';
import 'package:ebuzz/orderbooking/service/orderbooking_api_service.dart';
import 'package:ebuzz/orderbooking/ui/orderbooking_form2.dart';
import 'package:ebuzz/orderbooking/ui/orderbooking_form3.dart';
import 'package:ebuzz/sales_person-wise_transactionHistory/transaction_detail_model.dart';
import 'package:ebuzz/salesorder/model/sales_order.dart';
import 'package:ebuzz/salesorder/service/sales_order_service.dart';
import 'package:ebuzz/util/apiurls.dart';
import 'package:ebuzz/widgets/custom_card.dart';
import 'package:ebuzz/widgets/custom_textformformfield.dart';
import 'package:ebuzz/widgets/custom_typeahead_formfield.dart';
import 'package:ebuzz/widgets/typeahead_widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class TransactionDetail extends StatefulWidget {
  String invoiceId;
  TransactionDetail({required this.invoiceId});
  @override
  _TransactionDetailState createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {

  TransactionDetailModel? transactionDetailModel;
  bool isNotEditableLoad = false;

  @override
  void initState() {
    super.initState();
    print("name====>>${widget.invoiceId}");
    getTableData(context,invoiceId: widget.invoiceId);
  }

  Future getTableData(BuildContext context,{invoiceId}) async{
    print("call");
    isNotEditableLoad = true;
    var headers = {
      'Cookie': 'full_name=Jeeva; sid=6a44549626720c83d2d37a33716891f32dc8bf7978dcdaabbcf9b7b6; system_user=yes; user_id=jeeva%40yuvabe.com; user_image='
    };
    var request = http.Request('POST', Uri.parse('https://erptest.bharathrajesh.co.in/api/method/frappe.desk.form.load.getdoc?doctype=Sales+Invoice&name=$invoiceId&_=1661399544137'));

    request.headers.addAll(headers);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      setState(() {
        print(response.body);
        String data = response.body;
        print(data);
        isNotEditableLoad = false;
        print("table call");
        transactionDetailModel = TransactionDetailModel.fromJson(json.decode(data));
        print("${transactionDetailModel!.docs}");
        print("${transactionDetailModel!.docinfo}");
      });
    }
    else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: CustomAppBar(
          title:
          Text('Transaction Detail', style: TextStyle(color: whiteColor)),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: whiteColor,
            ),
          ),
        ),
      ),
      body:  Container(
        height: MediaQuery.of(context).size.height,
        color: Color(0xffcfd6e7),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 10,right: 10),
            child: isNotEditableLoad == true ?
            SizedBox(height: MediaQuery.of(context).size.height * 0.8,
                child: Center(child: CircularProgressIndicator())) :
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Order Information",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Order ID",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text(
                              "#${transactionDetailModel!.docs![0].name}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                cardView(),
                  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    transactionDetailModel!.docs![0].items!.isEmpty ? Container() : header("Items"),
                    transactionDetailModel!.docs![0].items!.isEmpty ? Container() : listOfItems(transactionDetailModel!.docs![0].items!),
                    transactionDetailModel!.docs![0].taxes!.isEmpty ? Container() : header("Taxes"),
                    transactionDetailModel!.docs![0].taxes!.isEmpty ? Container() : listOfTaxes(transactionDetailModel!.docs![0].taxes!),
                  ],
                ),
                SizedBox(height: 50,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  cardView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Icon(Icons.apartment ,color: Colors.grey,),
                    SizedBox(width: 5,),
                    Expanded(child: Text(transactionDetailModel!.docs![0].company.toString(),maxLines: 1,overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Icon(Icons.add_circle_outline_outlined,color: Colors.grey,),
                    SizedBox(width: 5,),
                    Expanded(child: Text(transactionDetailModel!.docs![0].customer.toString(),maxLines: 1,overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Icon(Icons.person,color: Colors.grey,),
                    SizedBox(width: 5,),
                    Expanded(child: Text(transactionDetailModel!.docs![0].customerName.toString(),maxLines: 1,overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Due Date",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                        SizedBox(height: 5),
                        Text(transactionDetailModel!.docs![0].dueDate.toString(),maxLines: 1,overflow: TextOverflow.ellipsis),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Sales Invoice Date",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                        SizedBox(height: 5),
                        Text(transactionDetailModel!.docs![0].postingDate.toString(),maxLines: 1,overflow: TextOverflow.ellipsis),
                      ],
                    ),
                    // Icon(Icons.date_range,color: Colors.grey),
                    // SizedBox(width: 5,),
                    // Expanded(child: Text(transactionDetailModel!.docs![0].dueDate.toString(),maxLines: 1,overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  listOfItems(List<Item> list) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
        elevation: 5,
        child: ListView.builder(
          itemCount: list.length,
          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context,index){
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(list[index].itemName.toString(),style: TextStyle(fontWeight: FontWeight.bold,),),
                      SizedBox(height: 2,),
                      Row(
                        children: [
                          Text("Net Rate : ",style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("${list[index].netRate}",style: TextStyle(color: Colors.grey),),
                        ],
                      ),
                      SizedBox(height: 2,),
                      Text(
                        "${list[index].qty} x ${list[index].rate}",
                        style: TextStyle(fontWeight: FontWeight.bold,),
                      )
                    ],
                  ),
                  Text(
                    "₹${list[index].amount}",
                    style: TextStyle(fontWeight: FontWeight.bold,),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  listOfTaxes(List<Tax> list) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
        elevation: 5,
        child: ListView.builder(
          itemCount: list.length,
          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context,index){
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Taxable Amount : ",),
                      Text(
                        list[index].taxAmount.toString(),
                      ),
                    ],
                  ),
                  SizedBox(height: 2,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Tax Amount : ",),
                      Text(
                        list[index].taxAmount.toString(),
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Grand Total : ",style: TextStyle(fontWeight: FontWeight.bold,)),
                      Text(
                        list[index].total.toString(),style: TextStyle(fontWeight: FontWeight.bold,)
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  header(String s) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(s,style: TextStyle(fontSize: 18),),
    );
  }

  totalHeader(String s) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(s,style: TextStyle(fontWeight: FontWeight.bold),),
    );
  }
}

