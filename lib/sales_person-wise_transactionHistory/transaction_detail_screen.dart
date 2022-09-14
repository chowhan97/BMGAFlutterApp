import 'dart:convert';
import 'package:ebuzz/common/colors.dart';
import 'package:ebuzz/common/custom_appbar.dart';
import 'package:ebuzz/sales_person-wise_transactionHistory/transaction_detail_model.dart';
import 'package:ebuzz/util/apiurls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:test_api/expect.dart';

class TransactionDetail extends StatefulWidget {
  // String invoiceId;
  final invoiceId;
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
    // var headers = {
    //   'Cookie': 'full_name=Jeeva; sid=6a44549626720c83d2d37a33716891f32dc8bf7978dcdaabbcf9b7b6; system_user=yes; user_id=jeeva%40yuvabe.com; user_image='
    // };
    var request = http.Request('POST', Uri.parse('https://erptest.bharathrajesh.co.in/api/method/frappe.desk.form.load.getdoc?doctype=Sales+Invoice&name=$invoiceId&_=1661399544137'));

    request.headers.addAll(commonHeaders);

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
        print("${transactionDetailModel!.docs![0].taxes!.length}");
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
          Text('Transaction Detail', style: TextStyle(color: textcolor)),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: textcolor,
            ),
          ),
        ),
      ),
      body:  Container(
        height: MediaQuery.of(context).size.height,
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
                SizedBox(height: 50),
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
                        Text(DateFormat('dd-MM-yyyy').format(DateTime.parse(transactionDetailModel!.docs![0].dueDate.toString())),maxLines: 1,overflow: TextOverflow.ellipsis),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Sales Invoice Date",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                        SizedBox(height: 5),
                        Text(DateFormat('dd-MM-yyyy').format(DateTime.parse(transactionDetailModel!.docs![0].postingDate.toString())),maxLines: 1,overflow: TextOverflow.ellipsis),
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
    var formatter = NumberFormat('#,##,000');
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
                          Text("${formatter.format(list[index].netRate)}",style: TextStyle(color: Colors.grey)),
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
                    "₹${formatter.format(list[index].amount)}",
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
    var formatter = NumberFormat('#,##,000');
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: list.length > 1 ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("SGST Total",style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("₹ ${formatter.format(list[0].taxAmount)}",style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("CGST Total",style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("₹ ${formatter.format(list[1].taxAmount)}",style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Taxable",style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("₹ ${formatter.format(list[0].total)}",style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Grand total",style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("₹ ${formatter.format(list[1].total)}",style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ) : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("IGST Total",style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("₹ ${formatter.format(list[0].taxAmount)}",style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Taxable",style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("₹ ${formatter.format(list[0].total)}",style: TextStyle(color: Colors.grey)),
                  ],
                ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Grand total",style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("₹ ${formatter.format(list[0].total)}",style: TextStyle(color: Colors.grey)),
                    ],
                  ),
              ],
            ),
          ),
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

