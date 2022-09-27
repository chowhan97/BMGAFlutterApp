import 'dart:convert';

import 'package:ebuzz/collection_trip/collection_trip_list.dart';
import 'package:ebuzz/collection_trip/collection_trip_wise_list_model.dart';
import 'package:ebuzz/common/colors.dart';
import 'package:ebuzz/common/custom_appbar.dart';
import 'package:ebuzz/common/navigations.dart';
import 'package:ebuzz/util/apiurls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CollectionTripWiseList extends StatefulWidget {
  var name;
  CollectionTripWiseList({this.name});

  @override
  State<CollectionTripWiseList> createState() => _CollectionTripWiseListState();
}

class _CollectionTripWiseListState extends State<CollectionTripWiseList> {
   bool isLoadCollection = false;
   CollectionListWiseModel? collectionListWiseModel;
   NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
   bool isLoadSave = false;

  @override
  void initState() {
    print("name===>>>${widget.name}");
    CollectionTrip();
    super.initState();
  }

  Future CollectionTrip() async {
    setState(() {
      isLoadCollection = true;
    });
    var request = http.Request('GET', Uri.parse(CollectionTripWiseListApi(name: widget.name)));
    request.headers.addAll(commonHeaders);
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      setState(() {
        print(response.body);
        String data = response.body;
        isLoadCollection = false;
        collectionListWiseModel = CollectionListWiseModel.fromJson(json.decode(data));
        print("collectionListModel===>>>${collectionListWiseModel!.docs![0].name}");
      });
    }
    else {
      print("error cause===>>${response.reasonPhrase}");
      setState(() {
        isLoadCollection = false;
      });
    }
  }

  Future save({data,cash,chaque,wire}) async {
    Navigator.pop(context);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row (children: [
            CircularProgressIndicator(
              valueColor:AlwaysStoppedAnimation<Color>(textcolor),
            ),
            Container(margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
          ]),
        );
      },
    );
     setState(() {
       isLoadSave = true;
     });
     var request = http.MultipartRequest('GET', Uri.parse(CollectionTripSaveApi()));
     request.fields.addAll({
       'doc': '{"name":${jsonEncode(collectionListWiseModel!.docs![0].name)},"owner": ${jsonEncode(collectionListWiseModel!.docs![0].owner)},"creation":${jsonEncode(collectionListWiseModel!.docs![0].creation)},"modified":${jsonEncode(collectionListWiseModel!.docs![0].modified)},"modified_by":${jsonEncode(collectionListWiseModel!.docs![0].modifiedBy)},"idx":${jsonEncode(collectionListWiseModel!.docs![0].idx)},"docstatus":${jsonEncode(collectionListWiseModel!.docs![0].docstatus)},"delivery_trip_no":${jsonEncode(collectionListWiseModel!.docs![0].deliveryTripNo)},"collection_person":${jsonEncode(collectionListWiseModel!.docs![0].collectionPerson)},"doctype":${jsonEncode(collectionListWiseModel!.docs![0].doctype)},"details":[{"name": ${jsonEncode(data.name)},"owner":${jsonEncode(data.owner)},"creation":${jsonEncode(data.creation)},"modified":${jsonEncode(data.modified)},"modified_by":${jsonEncode(data.modifiedBy)},"parent":${jsonEncode(data.parent)},"parentfield":${jsonEncode(data.parentfield)},"parenttype":${jsonEncode(data.parenttype)},"idx":${jsonEncode(data.idx)},"docstatus":${jsonEncode(data.docstatus)},"invoice_no":${jsonEncode(data.invoiceNo)},"customer":${jsonEncode(data.customer)},"customer_name":${jsonEncode(data.customerName)},"pending_amount":${jsonEncode(data.pendingAmount)},"cash_amount":${jsonEncode(int.parse(cash))},"cheque_amount":${jsonEncode(int.parse(chaque))},"wire_amount":${jsonEncode(int.parse(wire))},"total_amount":${jsonEncode(data.totalAmount)},"doctype":${jsonEncode(data.doctype)}}],"payment_entry":[],"__unsaved":1}',
       'action': 'Save'
     });
     request.headers.addAll(commonHeaders);
     var streamedResponse = await request.send();
     var response = await http.Response.fromStream(streamedResponse);
     if (response.statusCode == 200) {
       setState(() {
         Navigator.pop(context);
         Navigator.pop(context);
         Navigator.pop(context);
         pushScreen(context, CollectionTripList());
         print(response.body);
         String data = response.body;
         isLoadSave = false;
         // collectionListWiseModel = CollectionListWiseModel.fromJson(json.decode(data));
         // print("collectionListModel===>>>${collectionListWiseModel!.docs![0].name}");
       });
     }
     else {
       print("error cause===>>${response.reasonPhrase}");
       setState(() {
         isLoadSave = false;
       });
     }
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: CustomAppBar(
          title: Text('Collection Trip', style: TextStyle(color: textcolor)),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: textcolor,
            ),
          ),
        ),
      ),
      body: isLoadCollection == true ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(textcolor))) : ListView.separated(
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
                          heading: "Invoice No",
                          val: "${collectionListWiseModel!.docs![0].details![index].invoiceNo}"),
                      SizedBox(height: 8),
                      listText(
                          heading: "Customer Name",
                          val:
                          "${collectionListWiseModel!.docs![0].details![index].customerName}"),
                      SizedBox(height: 8),
                      listText(
                          heading: "Pending Amount",
                          val: "₹${myFormat.format(collectionListWiseModel!.docs![0].details![index].pendingAmount)}"),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          listText(
                              heading: "Cash",
                              val:
                              "₹${myFormat.format(collectionListWiseModel!.docs![0].details![index].cashAmount)}"),
                          listText(
                              heading: "Cheque",
                              val:
                              "₹${myFormat.format(collectionListWiseModel!.docs![0].details![index].chequeAmount)}"),
                        ],
                      ),
                      SizedBox(height: 8),
                      listText(
                          heading: "Wire Transfer",
                          val: "₹${myFormat.format(collectionListWiseModel!.docs![0].details![index].wireAmount)}"),
                      SizedBox(height: 8),
                      listText(
                          heading: "Total Amount Collected",
                          val: "₹${myFormat.format(collectionListWiseModel!.docs![0].details![index].totalAmount)}"),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          collectionListWiseModel!.docs![0].details![index].chequeReference == null ? Container() : listText(
                              heading: "Cheque Ref",
                              val: "${collectionListWiseModel!.docs![0].details![index].chequeReference}"),
                          collectionListWiseModel!.docs![0].details![index].chequeDate == null ? Container() : listText(
                              heading: "Cheque Date",
                              val: "${collectionListWiseModel!.docs![0].details![index].chequeDate}"),
                        ],
                      ),
                      SizedBox(height: 8),
                      if(collectionListWiseModel!.docs![0].details![index].docstatus == 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(onTap: (){
                            showDialog(context: context,
                            builder: (BuildContext context) {
                              TextEditingController cash_controller = TextEditingController();
                              TextEditingController chaque_controller = TextEditingController();
                              TextEditingController wire_controller = TextEditingController();
                              TextEditingController chaque_ref_controller = TextEditingController();
                              TextEditingController chaque_date_controller = TextEditingController();
                              DateTime selectedDate = DateTime.now();
                              var checkval = '';

                              //================================================ select date================================================= //
                              Future<Null> _selectDate(BuildContext context) async {
                                final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: selectedDate,
                                    firstDate: DateTime(1901, 1),
                                    lastDate: DateTime(2100));
                                if (picked != null && picked != selectedDate) if (!mounted) return;
                                setState(() {
                                  selectedDate = picked!;
                                  chaque_date_controller.text = DateFormat('dd-MM-yyy').format(picked).toString();
                                });
                              }
                              return StatefulBuilder(builder: (context,setState){
                                return AlertDialog(
                                  scrollable: true,
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("${collectionListWiseModel!.docs![0].details![index].invoiceNo}"),
                                      SizedBox(height: 5),
                                      Text("Add Payment Detail",style: TextStyle(fontSize: 17)),
                                      SizedBox(height: 8),
                                      TextField(
                                        controller: cash_controller,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 10),
                                            hintText: "Cash",
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      TextField(
                                        controller: chaque_controller,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 10),
                                            hintText: "Check",
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))
                                        ),
                                        onChanged: (val){
                                          setState(() {
                                            checkval = val;
                                          });
                                        },
                                      ),
                                      SizedBox(height: 5),
                                      TextField(
                                        controller: wire_controller,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 10),
                                            hintText: "Wire Transfer",
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      if(checkval.length > 0)
                                      TextField(
                                        controller: chaque_ref_controller,
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 10),
                                            hintText: "Check Ref:",
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      if(checkval.length > 0)
                                      TextField(
                                        controller: chaque_date_controller,
                                        readOnly: true,
                                        onTap: (){
                                          _selectDate(context);
                                        },
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 10),
                                            hintText: "Check Date",
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      InkWell(onTap: (){save(data: collectionListWiseModel!.docs![0].details![index],cash: cash_controller.text,chaque: chaque_controller.text,wire: wire_controller.text);},child: Container(width: double.infinity,padding: EdgeInsets.all(10),decoration: BoxDecoration(color: textcolor,borderRadius: BorderRadius.circular(5)),child: Text("Save", style: TextStyle(fontSize: 16, color: Colors.white),textAlign: TextAlign.center)))
                                    ],
                                  ),
                                  // actions: [InkWell(onTap: (){},child: Container(padding: EdgeInsets.all(10),decoration: BoxDecoration(color: textcolor,borderRadius: BorderRadius.circular(5)),child: Text("Save", style: TextStyle(fontSize: 16, color: Colors.white))))],
                                );
                              });
                            },
                            );
                          },child: Container(padding: EdgeInsets.all(5),decoration: BoxDecoration(color: textcolor,borderRadius: BorderRadius.circular(5)),child: Text(collectionListWiseModel!.docs![0].details![index].docstatus == 1 ? "Submitted" : "Add Amount", style: TextStyle(fontSize: 16, color: Colors.white)))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, index) {
            return SizedBox(height: 0);
          },
          itemCount: collectionListWiseModel!.docs![0].details!.length),
    );
  }


   Widget listText({heading, val}) {
     return Row(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Text("${heading}: ", style: TextStyle(fontWeight: FontWeight.bold)),
         Text(val, style: TextStyle(color: Colors.grey)),
       ],
     );
   }
}
