import 'dart:convert';
import 'dart:ui';

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
    var total = int.parse(cash) + int.parse(chaque) + int.parse(wire);
    print("total is====>>>$total");
     setState(() {
       isLoadSave = true;
     });
     var request = http.MultipartRequest('POST', Uri.parse(CollectionTripSaveApi()));
     request.fields.addAll({
       'doc': '{"name":${jsonEncode(collectionListWiseModel!.docs![0].name)},"owner": ${jsonEncode(collectionListWiseModel!.docs![0].owner)},"creation":${jsonEncode(collectionListWiseModel!.docs![0].creation)},"modified":${jsonEncode(collectionListWiseModel!.docs![0].modified)},"modified_by":${jsonEncode(collectionListWiseModel!.docs![0].modifiedBy)},"idx":${jsonEncode(collectionListWiseModel!.docs![0].idx)},"docstatus":${jsonEncode(collectionListWiseModel!.docs![0].docstatus)},"delivery_trip_no":${jsonEncode(collectionListWiseModel!.docs![0].deliveryTripNo)},"collection_person":${jsonEncode(collectionListWiseModel!.docs![0].collectionPerson)},"doctype":${jsonEncode(collectionListWiseModel!.docs![0].doctype)},"details":[{"name": ${jsonEncode(data.name)},"owner":${jsonEncode(data.owner)},"creation":${jsonEncode(data.creation)},"modified":${jsonEncode(data.modified)},"modified_by":${jsonEncode(data.modifiedBy)},"parent":${jsonEncode(data.parent)},"parentfield":${jsonEncode(data.parentfield)},"parenttype":${jsonEncode(data.parenttype)},"idx":${jsonEncode(data.idx)},"docstatus":${jsonEncode(data.docstatus)},"invoice_no":${jsonEncode(data.invoiceNo)},"customer":${jsonEncode(data.customer)},"customer_name":${jsonEncode(data.customerName)},"pending_amount":${jsonEncode(data.pendingAmount)},"cash_amount":${jsonEncode(int.parse(cash))},"cheque_amount":${jsonEncode(int.parse(chaque))},"wire_amount":${jsonEncode(int.parse(wire))},"total_amount":${jsonEncode(total)},"doctype":${jsonEncode(data.doctype)}}],"payment_entry":[],"__unsaved":1}',
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
                      Table(
                        border: TableBorder.all(
                            color: greyLightColor,
                            style: BorderStyle.solid),
                        children: [
                          TableRow(children: [
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Column(children:[Text('Cash', style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold))]),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Column(children:[Text('Cheque', style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold))]),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Column(children:[Text('Wire Transfer', style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold))]),
                            ),
                          ]),
                          TableRow(children: [
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Column(children:[Text("₹${myFormat.format(collectionListWiseModel!.docs![0].details![index].cashAmount)}")]),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Column(children:[Text('₹${myFormat.format(collectionListWiseModel!.docs![0].details![index].chequeAmount)}')]),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Column(children:[Text('₹${myFormat.format(collectionListWiseModel!.docs![0].details![index].wireAmount)}')]),
                            ),
                          ]),
                        ],
                      ),
                      // Container(
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text("Cash", style: TextStyle(fontWeight: FontWeight.bold)),
                      //       Text("Cheque", style: TextStyle(fontWeight: FontWeight.bold)),
                      //       Text("Wire Transfer", style: TextStyle(fontWeight: FontWeight.bold)),
                      //     ],
                      //   ),
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     listText(
                      //         heading: "Cash",
                      //         val:
                      //         "₹${myFormat.format(collectionListWiseModel!.docs![0].details![index].cashAmount)}"),
                      //     listText(
                      //         heading: "Cheque",
                      //         val:
                      //         "₹${myFormat.format(collectionListWiseModel!.docs![0].details![index].chequeAmount)}"),
                      //   ],
                      // ),
                      // SizedBox(height: 8),
                      // listText(
                      //     heading: "Wire Transfer",
                      //     val: "₹${myFormat.format(collectionListWiseModel!.docs![0].details![index].wireAmount)}"),
                      SizedBox(height: 8),
                      listText(
                          heading: "Total Amount Collected",
                          val: "₹${myFormat.format(collectionListWiseModel!.docs![0].details![index].totalAmount)}"),
                      //SizedBox(height: 8),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     collectionListWiseModel!.docs![0].details![index].chequeReference == null ? Container() : listText(
                      //         heading: "Cheque Ref",
                      //         val: "${collectionListWiseModel!.docs![0].details![index].chequeReference}"),
                      //     collectionListWiseModel!.docs![0].details![index].chequeDate == null ? Container() : listText(
                      //         heading: "Cheque Date",
                      //         val: "${collectionListWiseModel!.docs![0].details![index].chequeDate}"),
                      //   ],
                      // ),
                      SizedBox(height: 8),
                      if(collectionListWiseModel!.docs![0].details![index].docstatus == 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(onTap: (){
                            List clicked = [];
                            clicked.clear();
                            clicked.add({"name": collectionListWiseModel!.docs![0].details![index].name,"owner": collectionListWiseModel!.docs![0].details![index].owner,"creation": collectionListWiseModel!.docs![0].details![index].creation,"modified": collectionListWiseModel!.docs![0].details![index].modified,"modified_by": collectionListWiseModel!.docs![0].details![index].modifiedBy,"parent": collectionListWiseModel!.docs![0].details![index].parent,"parentfield": collectionListWiseModel!.docs![0].details![index].parentfield,"parenttype": collectionListWiseModel!.docs![0].details![index].parenttype,"idx": collectionListWiseModel!.docs![0].details![index].idx,"docstatus": collectionListWiseModel!.docs![0].details![index].docstatus,"invoice_no": collectionListWiseModel!.docs![0].details![index].invoiceNo,"customer": collectionListWiseModel!.docs![0].details![index].customer,"customer_name": collectionListWiseModel!.docs![0].details![index].customerName,"pending_amount": collectionListWiseModel!.docs![0].details![index].pendingAmount,"cash_amount": collectionListWiseModel!.docs![0].details![index].cashAmount,"cheque_amount": collectionListWiseModel!.docs![0].details![index].chequeAmount,"wire_amount": collectionListWiseModel!.docs![0].details![index].wireAmount,"total_amount": collectionListWiseModel!.docs![0].details![index].totalAmount,"cheque_reference": collectionListWiseModel!.docs![0].details![index].chequeReference,"cheque_date": collectionListWiseModel!.docs![0].details![index].chequeDate,"wire_reference": collectionListWiseModel!.docs![0].details![index].wireReference,"wire_date": collectionListWiseModel!.docs![0].details![index].wireDate,"doctype": collectionListWiseModel!.docs![0].details![index].doctype});
                           // clicked.add(collectionListWiseModel!.docs![0].details![index]);
                            print("aaa==>>${clicked}");
                            print("ind==>>${index}");
                            showDialog(context: context,
                            builder: (BuildContext context) {
                              TextEditingController cash_controller = TextEditingController();
                              TextEditingController chaque_controller = TextEditingController();
                              TextEditingController wire_controller = TextEditingController();
                              TextEditingController chaque_ref_controller = TextEditingController();
                              TextEditingController chaque_date_controller = TextEditingController();
                              TextEditingController wire_ref_controller = TextEditingController();
                              TextEditingController wire_date_controller = TextEditingController();
                              DateTime selectedDate = DateTime.now();
                              var checkval = '';
                              var wireval = '';
                              bool ischeckShow = false;
                              bool iswireShow = false;
                              //print("clicked=======>>>${clicked}");

                              //================================================ select date================================================= //
                              Future<Null> _selectDate(BuildContext context,{type}) async {
                                final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: selectedDate,
                                    firstDate: DateTime(1901, 1),
                                    lastDate: DateTime(2100));
                                if (picked != null && picked != selectedDate) if (!mounted) return;
                                setState(() {
                                  selectedDate = picked!;
                                  if(type == "cheque"){
                                    chaque_date_controller.text = DateFormat('dd-MM-yyy').format(picked).toString();
                                  }else{
                                    wire_date_controller.text = DateFormat('dd-MM-yyy').format(picked).toString();
                                  }
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
                                      Text("Cash",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                                      SizedBox(height: 5),
                                      TextField(
                                        controller: cash_controller,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            fillColor: greyColor,
                                            filled: true,
                                            contentPadding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 10),
                                            hintText: "Cash",
                                            // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: greyColor),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: greyColor),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text("Cheque",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                                      SizedBox(height: 5),
                                      TextField(
                                        controller: chaque_controller,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            fillColor: greyColor,
                                            filled: true,
                                            contentPadding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 10),
                                            hintText: "Cheque",
                                            //border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: greyColor),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: greyColor),
                                          ),
                                          suffixIcon: IconButton(onPressed: (){
                                            setState(() {
                                              ischeckShow = !ischeckShow;
                                              print("ischeckShow======>>${ischeckShow}");
                                            });
                                          }, icon: ClipOval(child: Container(color: Colors.white,alignment: Alignment.center,height: 25,width: 25,child: Icon(ischeckShow ? Icons.add : Icons.remove,color: Colors.black))))

                                        ),
                                        onChanged: (val){
                                          setState(() {
                                            checkval = val;
                                          });
                                        },
                                      ),
                                      SizedBox(height: 5),
                                      if(ischeckShow == false)
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            Text("Cheque Reference",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                                          SizedBox(height: 5),
                                            TextField(
                                              controller: chaque_ref_controller,
                                              decoration: InputDecoration(
                                                fillColor: greyColor,
                                                filled: true,
                                                contentPadding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 10),
                                                hintText: "Cheque Reference",
                                                // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: greyColor),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: greyColor),
                                                ),
                                              ),
                                            ),
                                          SizedBox(height: 5),
                                            Text("Cheque Date",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                                          SizedBox(height: 5),
                                            TextField(
                                              controller: chaque_date_controller,
                                              readOnly: true,
                                              onTap: (){
                                                _selectDate(context,type: "cheque");
                                              },
                                              decoration: InputDecoration(
                                                fillColor: greyColor,
                                                filled: true,
                                                contentPadding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 10),
                                                hintText: "Cheque Date",
                                                // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: greyColor),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: greyColor),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Text("Wire Transfer",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                                      SizedBox(height: 5),
                                      TextField(
                                        controller: wire_controller,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            fillColor: greyColor,
                                            filled: true,
                                            contentPadding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 10),
                                            hintText: "Wire Transfer",
                                            // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: greyColor),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: greyColor),
                                          ),
                                            suffixIcon: IconButton(onPressed: (){
                                              setState(() {
                                                iswireShow = !iswireShow;
                                                print("ischeckShow======>>${iswireShow}");
                                              });
                                            }, icon: ClipOval(child: Container(color: Colors.white,alignment: Alignment.center,height: 25,width: 25,child: Icon(iswireShow ? Icons.add : Icons.remove,color: Colors.black))))
                                        ),
                                        onChanged: (val){
                                          setState(() {
                                            wireval = val;
                                          });
                                        },
                                      ),
                                      if(iswireShow == false)
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 5),
                                          Text("Wire Transfer Reference",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                                          SizedBox(height: 5),
                                          TextField(
                                            controller: wire_ref_controller,
                                            decoration: InputDecoration(
                                              fillColor: greyColor,
                                              filled: true,
                                              contentPadding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 10),
                                              hintText: "Wire Transfer Reference",
                                              // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: greyColor),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: greyColor),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text("Wire Transfer Date",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                                          SizedBox(height: 5),
                                          TextField(
                                            controller: wire_date_controller,
                                            readOnly: true,
                                            onTap: (){
                                              _selectDate(context);
                                            },
                                            decoration: InputDecoration(
                                              fillColor: greyColor,
                                              filled: true,
                                              contentPadding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 10),
                                              hintText: "Wire Transfer Date",
                                              // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: greyColor),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: greyColor),
                                              ),
                                            ),
                                          ),
                                        ],
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
                          },child: Container(padding: EdgeInsets.all(5),decoration: BoxDecoration(color: textcolor,borderRadius: BorderRadius.circular(5)),child: Text(collectionListWiseModel!.docs![0].details![index].docstatus == 1 ? "Submitted" : "Show Details", style: TextStyle(fontSize: 16, color: Colors.white)))),
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
