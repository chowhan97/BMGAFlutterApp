import 'dart:convert';
import 'package:ebuzz/common/navigations.dart';
import 'package:ebuzz/sales_person-wise_transactionHistory/transaction_detail_screen.dart';
import 'package:ebuzz/sales_person-wise_transactionHistory/transaction_model.dart';
import 'package:ebuzz/util/apiurls.dart';
import 'package:http/http.dart' as http;
import 'package:ebuzz/common/colors.dart';
import 'package:ebuzz/common/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatefulWidget {
  // var fromdate, todate;
  final fromdate, todate;
  TransactionList({this.fromdate,this.todate});

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  bool fetch = false;
  TransactionModel? transactionModel;
  List selectedValue = [];
  var total = [];
  var total2 = [];
  num sum = 0;
  num Gross_sum = 0;
  var formatter = NumberFormat('#,##,000');

  Future getTableData() async {
    print("call");
    // print("from date===>>>>>${DateFormat("yyyy-MM-dd").format(DateTime.parse(widget.fromdate))}");
    // print("to date===>>>>>${DateFormat("yyyy-MM-dd").format(DateTime.parse(widget.todate))}");
    var toDate = jsonEncode(widget.todate);
    var fromDate = jsonEncode(widget.fromdate);
    fetch = true;
    // var headers = {
    //   'Cookie':
    //       'full_name=Jeeva; sid=6a44549626720c83d2d37a33716891f32dc8bf7978dcdaabbcf9b7b6; system_user=yes; user_id=jeeva%40yuvabe.com; user_image='
    // };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://erptest.bharathrajesh.co.in/api/method/frappe.desk.reportview.get'));

    request.fields.addAll({
      'doctype': 'Sales Invoice',
      'filters':
          '[["Sales Invoice","posting_date","<=",$toDate],["Sales Invoice","posting_date",">=",$fromDate],["Sales Invoice","company","=","Bharath Medical & General Agencies"]]',
      'fields':
          '["`tabSales Invoice`.`name`","`tabSales Invoice`.`docstatus`","`tabSales Invoice`.`title`","`tabSales Invoice`.`customer`","`tabSales Invoice`.`company`","`tabSales Invoice`.`grand_total`","`tabSales Invoice`.`status`","`tabSales Invoice`.`currency`","`tabSales Invoice`.`customer_name`","`tabSales Invoice`.`base_grand_total`","`tabSales Invoice`.`outstanding_amount`","`tabSales Invoice`.`due_date`","`tabSales Invoice`.`is_return`","`tabSales Invoice`.`total`"]',
      'distinct': 'false'
    });
    print("request.fields ${request.fields}");
    request.headers.addAll(commonHeaders);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      setState(() {
        print(response.body);
        String data = response.body;
        fetch = false;
        print("table call");
        transactionModel = TransactionModel.fromJson(json.decode(data));
        print("transactionModel====>>${transactionModel!.message!.keys}");
        for(int i = 0;i < transactionModel!.message!.values!.length; i++){
          setState(() {
            selectedValue.add([
              {
                "name":transactionModel!.message!.values![i][0],
                "docstatus":transactionModel!.message!.values![i][1],
                "title":transactionModel!.message!.values![i][2],
                "customer":transactionModel!.message!.values![i][3],
                "company":transactionModel!.message!.values![i][4],
                "grand_total":transactionModel!.message!.values![i][5],
                "status":transactionModel!.message!.values![i][6],
                "currency":transactionModel!.message!.values![i][7],
                "customer_name":transactionModel!.message!.values![i][8],
                "base_grand_total":transactionModel!.message!.values![i][9],
                "outstanding_amount":transactionModel!.message!.values![i][10],
                "due_date":transactionModel!.message!.values![i][11],
                "is_return":transactionModel!.message!.values![i][12],
                "total":transactionModel!.message!.values![i][13]
              },
            ]);
            total.clear();
            total2.clear();
            total.add(transactionModel!.message!.values![i][5]);
            total2.add(transactionModel!.message!.values![i][13]);
            print("total is====>>>>$total");
            print("total is====>>>>$total2");
            for (var i in total) {
              sum = sum + i;
            }
            for (var i in total2) {
              Gross_sum = Gross_sum + i;
            }
            print(sum);
            print("Gross_sum${Gross_sum}");
          });
          //{"message":{"keys":["name","docstatus","title","customer","company","grand_total","status","currency","customer_name","base_grand_total","outstanding_amount","due_date","is_return"],"values":[["SINV-22-00015",1,"Big Hospitals","CUST-H-00001","Bharath Medical & General Agencies",-693.0,"Return","INR","Big Hospitals",-693.0,0.0,"2022-08-13",1],["SINV-22-00016",1,"Balaji Medicals","CUST-R-00006","Bharath Medical & General Agencies",496.0,"Credit Note Issued","INR","Balaji Medicals",496.0,0.0,"2022-08-20",0],["SINV-22-00017",1,"Balaji Medicals","CUST-R-00006","Bharath Medical & General Agencies",-248.0,"Return","INR","Balaji Medicals",-248.0,0.0,"2022-08-20",1],["SINV-DL-00072",0,"Banashankari Medicals","CUST-R-00002","Bharath Medical & General Agencies",336268.3,"Draft","INR","Banashankari Medicals",336268.3,336268.0,"2022-08-11",0],["SINV-DL-00073",0,"Banashankari Medicals","CUST-R-00002","Bharath Medical & General Agencies",4185.0,"Draft","INR","Banashankari Medicals",4185.0,4185.0,"2022-08-12",0],
          // print(data);

        }
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: CustomAppBar(
          title: Text('Transaction List', style: TextStyle(color: textcolor)),
          leading: IconButton(
            onPressed: () => Navigator.pop(context, false),
            icon: Icon(
              Icons.arrow_back,
              color: textcolor,
            ),
          ),
        ),
      ),
      body: fetch == true
          ? Center(child: CircularProgressIndicator())
          : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.circular(15)),
                          child:  transactionModel!.message!.values!.isEmpty ? CircularProgressIndicator(): Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Gross Sales",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                              SizedBox(height: 5),
                              Text("???${formatter.format(Gross_sum)}",style: TextStyle(fontSize: 15)),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.circular(15)),
                          child:  transactionModel!.message!.values!.isEmpty ? CircularProgressIndicator(): Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Total Sales",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                              SizedBox(height: 5),
                              Text("???${formatter.format(sum)}",style: TextStyle(fontSize: 15)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                    transactionModel!.message!.values!.isEmpty
                    ? Container()
                    : Expanded(
                        child: ListView(
                          // scrollDirection: Axis.horizontal,
                          children: [
                            _createDataTable(),
                      ],
                   ),
                 ),
              ],
            ),

      //    fetch == true ? Center(child: CircularProgressIndicator())  : ListView.separated(itemBuilder: (BuildContext context,index){
      //   return Padding(
      //     padding: EdgeInsets.only(left: 10,right: 10,top: 10),
      //     child: Card(
      //       elevation: 5,
      //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      //       child: Padding(
      //         padding: EdgeInsets.all(10.0),
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 Text("${transactionModel!.message!.values![index][8].toString()}",style: TextStyle(fontWeight: FontWeight.bold)),
      //                 Text("??? ${transactionModel!.message!.values![index][5].toString()}",style: TextStyle(fontWeight: FontWeight.bold)),
      //               ],
      //             ),
      //             SizedBox(height: 8),
      //             listText(heading: "Status",val: "${transactionModel!.message!.values![index][6].toString()}"),
      //             SizedBox(height: 8),
      //             listText(heading: "Due Date",val: "${transactionModel!.message!.values![index][11].toString()}"),
      //             SizedBox(height: 8),
      //             listText(heading: "Invoice ID",val: "${transactionModel!.message!.values![index][0].toString()}"),
      //             SizedBox(height: 8),
      //             listText(heading: "Outstanding Amount",val: "${transactionModel!.message!.values![index][10].toString()}"),
      //           ],
      //         ),
      //       ),
      //     ),
      //   );
      // }, separatorBuilder: (BuildContext context,index){
      //   return SizedBox(height: 0);
      // }, itemCount: transactionModel!.message!.values!.length),
    );
  }

  DataTable _createDataTable() {
    return DataTable(
        headingRowHeight: 80,
        dataRowHeight: 80,
        columns: _createColumns(),
        rows: _createRows(),
        border: TableBorder.all(color: Colors.black));
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(
          label: Expanded(
              child: Container(
                  // width: 75,
                width: MediaQuery.of(context).size.width * 0.1,
                  child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Invoice',style: TextStyle(fontSize: 11)),
                          Text('Id',style: TextStyle(fontSize: 11)),
                        ],
                      ))))),
      DataColumn(
          label: Expanded(child:
          Container(
              // width: 90,
              width: MediaQuery.of(context).size.width * 0.13,
              child: Center(child: Text('Name',style: TextStyle(fontSize: 11)))))),
      DataColumn(
          label: Expanded(
              child: Container(
                  // width: 60,
                  width: MediaQuery.of(context).size.width * 0.09,
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Text('Doc',style: TextStyle(fontSize: 11)),
                      Text('Status',style: TextStyle(fontSize: 11)),
                    ],
                  ))))),
      DataColumn(
          label: Expanded(
              child: Container(
                  // width: 90,
                  width: MediaQuery.of(context).size.width * 0.13,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Outstanding',style: TextStyle(fontSize: 11)),
                      Text('Amount',style: TextStyle(fontSize: 11)),
                    ],
                  )))),
           DataColumn(
           label: Expanded(
           child: Container(
            // width: 70,
            width: MediaQuery.of(context).size.width * 0.09,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Invoice',style: TextStyle(fontSize: 11)),
                Text('Amount',style: TextStyle(fontSize: 11))
              ],
            )),
      ))
    ];
  }

  List<DataRow> _createRows() {
    var formatter = NumberFormat('#,##,000');
    return selectedValue.map(
      (book) {
        print("book ${book}");
        return DataRow(
          cells: [
            DataCell(
                Expanded(
                    child: Center(
                      child: Container(
                        // width: 75,
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: Center(
                            child: Text(
                              book[0]['name'].toString(),
                              textAlign: TextAlign.center,style: TextStyle(fontSize: 11),
                            )),
                      ),
                    )), onTap: () {
              pushScreen(
                  context,
                  TransactionDetail(
                    invoiceId: book[0]['name'].toString(),
                  )
              );
              // showDialog(
              //   context: context,
              //   builder: (BuildContext context) {
              //     return AlertDialog(
              //       contentPadding: EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(15),
              //       ),
              //       content: Container(
              //         height: MediaQuery.of(context).size.height * 0.5,
              //         child: Center(
              //           child: SingleChildScrollView(
              //             child: Column(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 listText(
              //                     heading: "Name",
              //                     val: "${book[0]['name'].toString()}"),
              //                 SizedBox(height: 8),
              //                 listText(
              //                     heading: "Doc Status",
              //                     val: "${book[0]['docstatus'].toString()}"),
              //                 SizedBox(height: 8),
              //                 listText(
              //                     heading: "Title",
              //                     val: "${book[0]['title'].toString()}"),
              //                 SizedBox(height: 8),
              //                 listText(
              //                     heading: "Customer Id",
              //                     val: "${book[0]['customer'].toString()}"),
              //                 SizedBox(height: 8),
              //                 listText1(
              //                     heading: "Company Name",
              //                     val: "${book[0]['company'].toString()}"),
              //                 SizedBox(height: 8),
              //                 listText(
              //                     heading: "Grand Total",
              //                     val: "${book[0]['grand_total'].toString()}"),
              //                 SizedBox(height: 8),
              //                 listText(
              //                     heading: "Status",
              //                     val: "${book[0]['status'].toString()}"),
              //                 SizedBox(height: 8),
              //                 listText(
              //                     heading: "Currency",
              //                     val: "${book[0]['currency'].toString()}"),
              //                 SizedBox(height: 8),
              //                 listText1(
              //                     heading: "Customer Name",
              //                     val:
              //                     "${book[0]['customer_name'].toString()}"),
              //                 SizedBox(height: 8),
              //                 listText(
              //                     heading: "Base Grand Total",
              //                     val:
              //                     "${book[0]['base_grand_total'].toString()}"),
              //                 SizedBox(height: 8),
              //                 listText(
              //                     heading: "Outstanding Amount",
              //                     val:
              //                     "${book[0]['outstanding_amount'].toString()}"),
              //                 SizedBox(height: 8),
              //                 listText(
              //                     heading: "Due Date",
              //                     val: "${book[0]['due_date'].toString()}"),
              //                 SizedBox(height: 8),
              //                 listText(
              //                     heading: "Is Return",
              //                     val: "${book[0]['is_return'].toString()}"),
              //                 SizedBox(height: 8),
              //               ],
              //             ),
              //           ),
              //         ),
              //       ),
              //     );
              //   },
              // );
            }),
            DataCell(
                Expanded(
                    child: Center(
                  child: Container(
                    // width: 90,
                    width: MediaQuery.of(context).size.width * 0.13,
                    child: Center(
                        child: Text(
                      book[0]['title'].toString(),
                      textAlign: TextAlign.center,style: TextStyle(fontSize: 11),
                    )),
                  ),
                )),
                onTap: () {
                  pushScreen(
                      context,
                      TransactionDetail(
                        invoiceId: book[0]['name'].toString(),
                      )
                  );
            }),
            DataCell(
                Expanded(
                    child: Center(
                  child: Container(
                      // width: 60,
                      width: MediaQuery.of(context).size.width * 0.09,
                      child: Center(
                          child: Text(
                        book[0]['status'].toString(),
                        textAlign: TextAlign.center,style: TextStyle(fontSize: 11),
                      ))),
                )),
                onTap: () {
              pushScreen(
                  context,
                  TransactionDetail(
                    invoiceId: book[0]['name'].toString(),
                  )
              );
            }),
            DataCell(
                Expanded(
                    child: Center(
                  child: Container(
                      // width: 90,
                      width: MediaQuery.of(context).size.width * 0.13,
                      child: Center(child: Text("???${formatter.format(book[0]['outstanding_amount'])}",style: TextStyle(fontSize: 11)))),
                )), onTap: () {
              pushScreen(
                  context,
                  TransactionDetail(
                    invoiceId: book[0]['name'].toString(),
                  )
              );
            }),
            DataCell(
                Expanded(
                  child: Center(
                    child: Container(
                      // width: 70,
                      width: MediaQuery.of(context).size.width * 0.09,
                      child: Center(
                        child: Text("???${formatter.format(book[0]['grand_total'])}",
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 11)),
                      ),
                    ),
                  ),
                ), onTap: () {
              pushScreen(
                  context,
                  TransactionDetail(
                    invoiceId: book[0]['name'].toString(),
                  )
              );
            }),
          ],
        );
      },
    ).toList();
  }

  Widget listText({heading, val}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${heading}:- ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        Expanded(
            child: Text(
          val,
          style: TextStyle(color: Colors.grey, fontSize: 14),
          overflow: TextOverflow.clip,
        )),
      ],
    );
  }

  Widget listText1({heading, val}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("${heading}:- ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        SizedBox(
          height: 5,
        ),
        Text(
          val,
          style: TextStyle(color: Colors.grey, fontSize: 14),
          overflow: TextOverflow.clip,
        ),
      ],
    );
  }
// Widget listText({heading,val}){
//   return Row(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text("${heading}:- ",style: TextStyle(fontWeight: FontWeight.bold)),
//       Text(val,style: TextStyle(color: Colors.grey)),
//     ],
//   );
// }
}
