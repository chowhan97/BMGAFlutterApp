import 'dart:convert';

import 'package:ebuzz/collection_trip/collection_trip_wise_list_model.dart';
import 'package:ebuzz/common/colors.dart';
import 'package:ebuzz/common/custom_appbar.dart';
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
                              heading: "Cheque Reference",
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
                            showDialog(context: context, builder: (BuildContext context) {
                              return AlertDialog(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${collectionListWiseModel!.docs![0].details![index].invoiceNo}"),
                                    SizedBox(height: 5),
                                    Text("Are you want to add cash/cheque/wire transfer?",style: TextStyle(fontSize: 17)),
                                  ],
                                ),
                                //content: Text("Are you want to add cash/cheque/wire transfer?"),
                                actions: [],
                              );
                            },
                            );
                          },child: Container(padding: EdgeInsets.all(5),decoration: BoxDecoration(color: textcolor,borderRadius: BorderRadius.circular(5)),child: Text(collectionListWiseModel!.docs![0].details![index].docstatus == 1 ? "Submitted" : "Draft", style: TextStyle(fontSize: 16, color: Colors.white)))),
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
