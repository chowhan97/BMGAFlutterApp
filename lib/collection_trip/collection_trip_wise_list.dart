import 'dart:convert';
import 'dart:ui';

import 'package:ebuzz/collection_trip/collection_trip_list.dart';
import 'package:ebuzz/collection_trip/collection_trip_wise_list_model.dart';
import 'package:ebuzz/collection_trip/employee_wise_collection_trip_model.dart';
import 'package:ebuzz/common/colors.dart';
import 'package:ebuzz/common/custom_appbar.dart';
import 'package:ebuzz/common/navigations.dart';
import 'package:ebuzz/util/apiurls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CollectionTripWiseList extends StatefulWidget {
  var name,EmpId;
  CollectionTripWiseList({this.name,this.EmpId});

  @override
  State<CollectionTripWiseList> createState() => _CollectionTripWiseListState();
}

class _CollectionTripWiseListState extends State<CollectionTripWiseList> {
   bool isLoadCollection = false;
   CollectionListWiseModel? collectionListWiseModel;
   EmployeeWiseCollectionTripModel? employeeWiseCollectionTripModel;
   var listResp;
   NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
   bool isLoadSave = false;
   String? cash = "";
   String? chaque = "";
   String? wire = "";
   String? chaque_ref = "";
   String? chaque_date = "";
   String? wire_ref = "";
   String? wire_date = "";
   bool isLoadEmpCollection = false;
   bool isLoadEmpCollectionUpdate = false;
   var EmpcollectionResp;

  @override
  void initState() {
    // print("name===>>>${widget.name}");
    // GetEmpName();
    EmployeeCollectionTrip(employeeId: widget.EmpId);
    // CollectionTrip();
    // EmployeeCollectionTrip(employeeId: "HR-EMP-00003");
    getData();
    super.initState();
  }

   getData() async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     cash = prefs.getString("cash_controller").toString();
     chaque =  prefs.getString("chaque_controller").toString();
     wire =  prefs.getString("wire_controller").toString();
     chaque_ref =  prefs.getString("chaque_ref_controller").toString();
     chaque_date =  prefs.getString("chaque_date_controller").toString();
     wire_ref =  prefs.getString("wire_ref_controller").toString();
     wire_date =  prefs.getString("wire_date_controller").toString();
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
        listResp = json.decode(data);
        isLoadCollection = false;
        collectionListWiseModel = CollectionListWiseModel.fromJson(json.decode(data));
        // print("collectionListModel===>>>${collectionListWiseModel!.docs![0].name}");
      });
    }
    else {
      print("error cause===>>${response.reasonPhrase}");
      setState(() {
        isLoadCollection = false;
      });
    }
  }


   Future EmployeeCollectionTrip({employeeId}) async {
     setState(() {
       isLoadEmpCollection = true;
     });
     var request = http.Request('GET', Uri.parse('https://erptest.bharathrajesh.co.in/api/method/bmga.global_api.fetch_employee_collection_trips?employee=${employeeId}'));
     request.headers.addAll(commonHeaders);
     var streamedResponse = await request.send();
     var response = await http.Response.fromStream(streamedResponse);
     if (response.statusCode == 200) {
       setState(() {
         isLoadEmpCollection = false;
         print(response.body);
         String data = response.body;
         EmpcollectionResp = json.decode(data);
         print("EmpcollectionResp=>>${EmpcollectionResp['message']}");
         employeeWiseCollectionTripModel = EmployeeWiseCollectionTripModel.fromJson(json.decode(data));
         print("employeeWiseCollectionTripModel===>>>${employeeWiseCollectionTripModel!.message![0].name}");
       });
     }
     else {
       print("error cause===>>${response.reasonPhrase}");
       setState(() {
         isLoadEmpCollection = false;
       });
     }
   }

  Future updateEmpCollection({data}) async{
    print("updateEmpCollection========>>>>>${data}");
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
     List emp = [];
     emp.clear();
     emp.add(data);
     setState(() {
       isLoadEmpCollectionUpdate = true;
     });
     var request = http.Request('GET', Uri.parse('https://erptest.bharathrajesh.co.in/api/method/bmga.global_api.update_employee_collection_trips?payload=${jsonEncode(emp)}'));
     request.headers.addAll(commonHeaders);
     var streamedResponse = await request.send();
     var response = await http.Response.fromStream(streamedResponse);
     if (response.statusCode == 200) {
       setState(() {
         // CollectionTrip();
         EmployeeCollectionTrip(employeeId: widget.EmpId);
         Navigator.pop(context);
         print(response.body);
         String data = response.body;
         var d = json.decode(data);
         isLoadEmpCollectionUpdate = false;
       });
     }
     else {
       print("error cause===>>${response.reasonPhrase}");
       setState(() {
         isLoadEmpCollectionUpdate = false;
       });
     }
  }


  Future save({index,updatedData}) async {
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
     var request = http.MultipartRequest('POST', Uri.parse(CollectionTripSaveApi()));
     List data = [];
     data.clear();
      collectionListWiseModel!.docs![0].details!.forEach((element){
        data.add(element);
        // print("data===>>>${data}");
        // print("total data===>>>${data.length}");
        // print("index is===>>>$index");
        // print("data index===>>>${data[index].cashAmount}");
        // print("updatedData===>>>${updatedData}");
        // data[index] = updatedData;
        // print("data is====>>>${data}");
        // print("data is====>>>${data.length}");
        // data.forEach((element2) {
        //   print("total ele is===>>>${element2}");
        // });
    });
    print("data===>>>${data}");
    print("total data===>>>${data.length}");
    print("index is===>>>$index");
    print("data index===>>>${data[index].cashAmount}");
    print("updatedData===>>>${updatedData}");
    // data.remove(index);
    data[index] = updatedData;
    print("data is====>>>${data}");
    print("data is====>>>${data.length}");
    request.fields.addAll({
      // 'doc': '{"name":${jsonEncode(collectionListWiseModel!.docs![0].name)},"owner": ${jsonEncode(collectionListWiseModel!.docs![0].owner)},"creation":${jsonEncode(collectionListWiseModel!.docs![0].creation)},"modified":${jsonEncode(collectionListWiseModel!.docs![0].modified)},"modified_by":${jsonEncode(collectionListWiseModel!.docs![0].modifiedBy)},"idx":${jsonEncode(collectionListWiseModel!.docs![0].idx)},"docstatus":${jsonEncode(collectionListWiseModel!.docs![0].docstatus)},"delivery_trip_no":${jsonEncode(collectionListWiseModel!.docs![0].deliveryTripNo)},"collection_person":${jsonEncode(collectionListWiseModel!.docs![0].collectionPerson)},"collection_person_name":${jsonEncode(collectionListWiseModel!.docs![0].collectionPersonName)},"doctype":${jsonEncode(collectionListWiseModel!.docs![0].doctype)},"details":${jsonEncode(data)},"payment_entry":${jsonEncode(collectionListWiseModel!.docs![0].paymentEntry)},"__last_sync_on":2022-09-28T11:38:58.033Z,"__unsaved":1}',
      'doc': '{"name":${jsonEncode(collectionListWiseModel!.docs![0].name)},"owner":${jsonEncode(collectionListWiseModel!.docs![0].owner)},"creation":${jsonEncode(collectionListWiseModel!.docs![0].creation)},"modified":${jsonEncode(collectionListWiseModel!.docs![0].modified)},"modified_by":${jsonEncode(collectionListWiseModel!.docs![0].modifiedBy)},"idx":${jsonEncode(collectionListWiseModel!.docs![0].idx)},"docstatus":${jsonEncode(collectionListWiseModel!.docs![0].docstatus)},"delivery_trip_no":${jsonEncode(collectionListWiseModel!.docs![0].deliveryTripNo)},"collection_person":${jsonEncode(collectionListWiseModel!.docs![0].collectionPerson)},"collection_person_name":${jsonEncode(collectionListWiseModel!.docs![0].collectionPersonName)},"doctype":${jsonEncode(collectionListWiseModel!.docs![0].doctype)},"details":${jsonEncode(data)},"payment_entry":${jsonEncode(collectionListWiseModel!.docs![0].paymentEntry)},"__last_sync_on":"2022-09-28T11:38:58.033Z","__unsaved":1}',
      'action': 'Save'
    });
     request.headers.addAll(commonHeaders);
     var streamedResponse = await request.send();
     var response = await http.Response.fromStream(streamedResponse);
     if (response.statusCode == 200) {
       setState(() {
         // CollectionTrip();
         Navigator.pop(context);
         // Navigator.pop(context);
         // Navigator.pop(context);
         // pushScreen(context, CollectionTripList());
         print(response.body);
         String data = response.body;
         var d = json.decode(data);
         isLoadSave = false;
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
      body: isLoadEmpCollection == true ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(textcolor))) : ListView.separated(
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
                          val: "${employeeWiseCollectionTripModel!.message![index].invoiceNo}"),
                      SizedBox(height: 8),
                      listText(
                          heading: "Customer Name",
                          val:
                          "${employeeWiseCollectionTripModel!.message![index].customer_name}"),
                      SizedBox(height: 8),
                      listText(
                          heading: "Pending Amount",
                          val: "₹${myFormat.format(employeeWiseCollectionTripModel!.message![index].pendingAmount)}"),
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
                              child: Column(children:[Text("₹${myFormat.format(employeeWiseCollectionTripModel!.message![index].cashAmount)}")]),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Column(children:[Text('₹${myFormat.format(employeeWiseCollectionTripModel!.message![index].chequeAmount)}')]),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Column(children:[Text('₹${myFormat.format(employeeWiseCollectionTripModel!.message![index].wireAmount)}')]),
                            ),
                          ]),
                        ],
                      ),
                      SizedBox(height: 8),
                      listText(
                          heading: "Total Amount Collected",
                          val: "₹${myFormat.format(employeeWiseCollectionTripModel!.message![index].totalAmount)}"),
                      SizedBox(height: 8),
                      // if(collectionListWiseModel!.docs![0].details![index].docstatus == 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(onTap: (){
                            print("hii is======>>>${EmpcollectionResp['message'][index]}");
                            // print("collectionListWiseModel!.docs![0].details![index]=====>>>${listResp['docs'][0]["details"][index]}");
                            // if(collectionListWiseModel!.docs![0].details![index].docstatus == 1){
                            //   print("submit");
                            //   showDialog(context: context, builder: (BuildContext context) {
                            //     return StatefulBuilder(builder: (context,setState){
                            //       TextEditingController cash_controller = TextEditingController();
                            //       TextEditingController chaque_controller = TextEditingController();
                            //       TextEditingController wire_controller = TextEditingController();
                            //       TextEditingController chaque_ref_controller = TextEditingController();
                            //       TextEditingController chaque_date_controller = TextEditingController();
                            //       TextEditingController wire_ref_controller = TextEditingController();
                            //       TextEditingController wire_date_controller = TextEditingController();
                            //
                            //       cash_controller.text = myFormat.format(collectionListWiseModel!.docs![0].details![index].cashAmount);
                            //       chaque_controller.text = myFormat.format(collectionListWiseModel!.docs![0].details![index].chequeAmount);
                            //       wire_controller.text = myFormat.format(collectionListWiseModel!.docs![0].details![index].wireAmount);
                            //       chaque_ref_controller.text = collectionListWiseModel!.docs![0].details![index].chequeReference == null ? "" : collectionListWiseModel!.docs![0].details![index].chequeReference.toString();
                            //       chaque_date_controller.text = collectionListWiseModel!.docs![0].details![index].chequeDate == null ? "" : collectionListWiseModel!.docs![0].details![index].chequeDate.toString();
                            //       wire_ref_controller.text = collectionListWiseModel!.docs![0].details![index].wireReference == null ? "" : collectionListWiseModel!.docs![0].details![index].wireReference.toString();
                            //       wire_date_controller.text = collectionListWiseModel!.docs![0].details![index].wireDate == null ? "" : collectionListWiseModel!.docs![0].details![index].wireDate.toString();
                            //       return AlertDialog(
                            //         scrollable: true,
                            //         title: Column(
                            //           crossAxisAlignment: CrossAxisAlignment.start,
                            //           children: [
                            //             Text("${collectionListWiseModel!.docs![0].details![index].invoiceNo}"),
                            //             SizedBox(height: 5),
                            //             Text("Show Payment Detail",style: TextStyle(fontSize: 17)),
                            //             SizedBox(height: 8),
                            //             Text("Cash",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                            //             SizedBox(height: 5),
                            //             TextField(
                            //               controller: cash_controller,
                            //               readOnly: true,
                            //               keyboardType: TextInputType.number,
                            //               decoration: InputDecoration(
                            //                 fillColor: greyColor,
                            //                 filled: true,
                            //                 contentPadding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 10),
                            //                 hintText: "Cash",
                            //                 // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                            //                 enabledBorder: OutlineInputBorder(
                            //                   borderSide: BorderSide(
                            //                       color: greyColor),
                            //                 ),
                            //                 focusedBorder: OutlineInputBorder(
                            //                   borderSide: BorderSide(
                            //                       color: greyColor),
                            //                 ),
                            //               ),
                            //             ),
                            //             SizedBox(height: 5),
                            //             Text("Cheque",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                            //             SizedBox(height: 5),
                            //             TextField(
                            //               controller: chaque_controller,
                            //               readOnly: true,
                            //               keyboardType: TextInputType.number,
                            //               decoration: InputDecoration(
                            //                   fillColor: greyColor,
                            //                   filled: true,
                            //                   contentPadding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 10),
                            //                   hintText: "Cheque",
                            //                   //border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                            //                   enabledBorder: OutlineInputBorder(
                            //                     borderSide: BorderSide(
                            //                         color: greyColor),
                            //                   ),
                            //                   focusedBorder: OutlineInputBorder(
                            //                     borderSide: BorderSide(
                            //                         color: greyColor),
                            //                   ),
                            //                   // suffixIcon: IconButton(onPressed: (){
                            //                   //   setState(() {
                            //                   //     ischeckShow = !ischeckShow;
                            //                   //     print("ischeckShow======>>${ischeckShow}");
                            //                   //   });
                            //                   // }, icon: ClipOval(child: Container(color: Colors.white,alignment: Alignment.center,height: 25,width: 25,child: Icon(ischeckShow ? Icons.add : Icons.remove,color: Colors.black))))
                            //
                            //               ),
                            //               // onChanged: (val){
                            //               //   setState(() {
                            //               //     checkval = val;
                            //               //   });
                            //               // },
                            //             ),
                            //             SizedBox(height: 5),
                            //               Column(
                            //                 crossAxisAlignment: CrossAxisAlignment.start,
                            //                 children: [
                            //                   Text("Cheque Reference",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                            //                   SizedBox(height: 5),
                            //                   TextField(
                            //                     controller: chaque_ref_controller,
                            //                     readOnly: true,
                            //                     decoration: InputDecoration(
                            //                       fillColor: greyColor,
                            //                       filled: true,
                            //                       contentPadding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 10),
                            //                       hintText: "Cheque Reference",
                            //                       // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))
                            //                       enabledBorder: OutlineInputBorder(
                            //                         borderSide: BorderSide(color: greyColor),
                            //                       ),
                            //                       focusedBorder: OutlineInputBorder(
                            //                         borderSide: BorderSide(color: greyColor),
                            //                       ),
                            //                     ),
                            //                   ),
                            //                   SizedBox(height: 5),
                            //                   Text("Cheque Date",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                            //                   SizedBox(height: 5),
                            //                   TextField(
                            //                     controller: chaque_date_controller,
                            //                     readOnly: true,
                            //                     decoration: InputDecoration(
                            //                       fillColor: greyColor,
                            //                       filled: true,
                            //                       contentPadding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 10),
                            //                       hintText: "Cheque Date",
                            //                       // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))
                            //                       enabledBorder: OutlineInputBorder(
                            //                         borderSide: BorderSide(color: greyColor),
                            //                       ),
                            //                       focusedBorder: OutlineInputBorder(
                            //                         borderSide: BorderSide(color: greyColor),
                            //                       ),
                            //                     ),
                            //                   ),
                            //                 ],
                            //               ),
                            //             SizedBox(height: 5),
                            //             Text("Wire Transfer",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                            //             SizedBox(height: 5),
                            //             TextField(
                            //               controller: wire_controller,
                            //               readOnly: true,
                            //               keyboardType: TextInputType.number,
                            //               decoration: InputDecoration(
                            //                   fillColor: greyColor,
                            //                   filled: true,
                            //                   contentPadding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 10),
                            //                   hintText: "Wire Transfer",
                            //                   // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))
                            //                   enabledBorder: OutlineInputBorder(
                            //                     borderSide: BorderSide(color: greyColor),
                            //                   ),
                            //                   focusedBorder: OutlineInputBorder(
                            //                     borderSide: BorderSide(color: greyColor),
                            //                   ),
                            //                   // suffixIcon: IconButton(onPressed: (){
                            //                   //   setState(() {
                            //                   //     iswireShow = !iswireShow;
                            //                   //     print("ischeckShow======>>${iswireShow}");
                            //                   //   });
                            //                   // }, icon: ClipOval(child: Container(color: Colors.white,alignment: Alignment.center,height: 25,width: 25,child: Icon(iswireShow ? Icons.add : Icons.remove,color: Colors.black))))
                            //               ),
                            //               // onChanged: (val){
                            //               //   setState(() {
                            //               //     wireval = val;
                            //               //   });
                            //               // },
                            //             ),
                            //               Column(
                            //                 crossAxisAlignment: CrossAxisAlignment.start,
                            //                 children: [
                            //                   SizedBox(height: 5),
                            //                   Text("Wire Transfer Reference",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                            //                   SizedBox(height: 5),
                            //                   TextField(
                            //                     controller: wire_ref_controller,
                            //                     readOnly: true,
                            //                     decoration: InputDecoration(
                            //                       fillColor: greyColor,
                            //                       filled: true,
                            //                       contentPadding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 10),
                            //                       hintText: "Wire Transfer Reference",
                            //                       // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))
                            //                       enabledBorder: OutlineInputBorder(
                            //                         borderSide: BorderSide(color: greyColor),
                            //                       ),
                            //                       focusedBorder: OutlineInputBorder(
                            //                         borderSide: BorderSide(color: greyColor),
                            //                       ),
                            //                     ),
                            //                   ),
                            //                   SizedBox(height: 5),
                            //                   Text("Wire Transfer Date",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                            //                   SizedBox(height: 5),
                            //                   TextField(
                            //                     controller: wire_date_controller,
                            //                     readOnly: true,
                            //                     decoration: InputDecoration(
                            //                       fillColor: greyColor,
                            //                       filled: true,
                            //                       contentPadding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 10),
                            //                       hintText: "Wire Transfer Date",
                            //                       // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))
                            //                       enabledBorder: OutlineInputBorder(
                            //                         borderSide: BorderSide(color: greyColor),
                            //                       ),
                            //                       focusedBorder: OutlineInputBorder(
                            //                         borderSide: BorderSide(color: greyColor),
                            //                       ),
                            //                     ),
                            //                   ),
                            //                 ],
                            //               ),
                            //             SizedBox(height: 5),
                            //           ],
                            //         ),
                            //       );
                            //     });
                            //   });
                            // }
                            // else{
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
                                  cash_controller.text = myFormat.format(employeeWiseCollectionTripModel!.message![index].cashAmount);
                                  chaque_controller.text = myFormat.format(employeeWiseCollectionTripModel!.message![index].chequeAmount);
                                  wire_controller.text = myFormat.format(employeeWiseCollectionTripModel!.message![index].wireAmount);
                                  chaque_ref_controller.text = employeeWiseCollectionTripModel!.message![index].chequeReference == null ? "" : employeeWiseCollectionTripModel!.message![index].chequeReference.toString();
                                  //chaque_date_controller.text = collectionListWiseModel!.docs![0].details![index].chequeDate.toString();
                                  chaque_date_controller.text = employeeWiseCollectionTripModel!.message![index].chequeDate == null ? "" : DateFormat("dd-MM-yyyy").format(
                                    DateTime.parse(employeeWiseCollectionTripModel!.message![index].chequeDate.toString()),
                                  );
                                  wire_ref_controller.text = employeeWiseCollectionTripModel!.message![index].wireReference == null ? "" : employeeWiseCollectionTripModel!.message![index].wireReference.toString();
                                  //wire_date_controller.text = collectionListWiseModel!.docs![0].details![index].wireDate.toString();
                                  wire_date_controller.text = employeeWiseCollectionTripModel!.message![index].wireDate == null ? "" : DateFormat("dd-MM-yyyy").format(
                                    DateTime.parse(employeeWiseCollectionTripModel!.message![index].wireDate.toString()),
                                  );

                                  var checkval = '';
                                  var wireval = '';
                                  bool ischeckShow = false;
                                  bool iswireShow = false;
                                  // Map<String, dynamic> clicked = {"name":collectionListWiseModel!.docs![0].details![index].name,"owner":collectionListWiseModel!.docs![0].details![index].owner,"creation":collectionListWiseModel!.docs![0].details![index].creation,"modified":collectionListWiseModel!.docs![0].details![index].modified,"modified_by":collectionListWiseModel!.docs![0].details![index].modifiedBy,"parent":collectionListWiseModel!.docs![0].details![index].parent,"parentfield":collectionListWiseModel!.docs![0].details![index].parentfield,"parenttype":collectionListWiseModel!.docs![0].details![index].parenttype,"idx":collectionListWiseModel!.docs![0].details![index].idx,"docstatus":collectionListWiseModel!.docs![0].details![index].docstatus,"invoice_no":collectionListWiseModel!.docs![0].details![index].invoiceNo,"customer":collectionListWiseModel!.docs![0].details![index].customer,"customer_name":collectionListWiseModel!.docs![0].details![index].customerName,"pending_amount":collectionListWiseModel!.docs![0].details![index].pendingAmount,"cash_amount":collectionListWiseModel!.docs![0].details![index].cashAmount,"cheque_amount":collectionListWiseModel!.docs![0].details![index].chequeAmount,"wire_amount":collectionListWiseModel!.docs![0].details![index].wireAmount,"total_amount":collectionListWiseModel!.docs![0].details![index].totalAmount,"cheque_reference":collectionListWiseModel!.docs![0].details![index].chequeReference,"cheque_date":collectionListWiseModel!.docs![0].details![index].chequeDate,"wire_reference":collectionListWiseModel!.docs![0].details![index].wireReference,"wire_date":collectionListWiseModel!.docs![0].details![index].wireDate,"doctype":collectionListWiseModel!.docs![0].details![index].doctype};
                                  // print("clicked is====>>>${jsonEncode(clicked)}");

                                  //================================================select date========================================================//
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
                                        chaque_date_controller.text = DateFormat('dd-MM-yyyy').format(picked).toString();
                                      }else{
                                        wire_date_controller.text = DateFormat('dd-MM-yyyy').format(picked).toString();
                                      }
                                    });
                                  }
                                  return StatefulBuilder(builder: (context,setState){
                                    return AlertDialog(
                                      scrollable: true,
                                      title: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("${employeeWiseCollectionTripModel!.message![index].invoiceNo}"),
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
                                          //InkWell(onTap: (){save(data: collectionListWiseModel!.docs![0].details![index],cash: cash_controller.text,chaque: chaque_controller.text,wire: wire_controller.text);},child: Container(width: double.infinity,padding: EdgeInsets.all(10),decoration: BoxDecoration(color: textcolor,borderRadius: BorderRadius.circular(5)),child: Text("Save", style: TextStyle(fontSize: 16, color: Colors.white),textAlign: TextAlign.center)))
                                          InkWell(onTap: () async{
                                            var total = int.parse(cash_controller.text.replaceAll(",", "")) + int.parse(chaque_controller.text.replaceAll(",", "")) + int.parse(wire_controller.text.replaceAll(",", ""));
                                            print("total is===>>>$total");
                                            EmpcollectionResp['message'][index].update("cash_amount", (value) => int.parse(cash_controller.text.replaceAll(",", "")));
                                            EmpcollectionResp['message'][index].update("cheque_amount", (value) => int.parse(chaque_controller.text.replaceAll(",", "")));
                                            EmpcollectionResp['message'][index].update("wire_amount", (value) => int.parse(wire_controller.text.replaceAll(",", "")));
                                            EmpcollectionResp['message'][index].update("cheque_reference", (value) => chaque_ref_controller.text);
                                            EmpcollectionResp['message'][index].update("cheque_date", (value) => chaque_date_controller.text);
                                            EmpcollectionResp['message'][index].update("wire_reference", (value) => wire_ref_controller.text);
                                            EmpcollectionResp['message'][index].update("wire_date", (value) => wire_date_controller.text);
                                            EmpcollectionResp['message'][index].update("total_amount", (value) => total);
                                            print("updated data is======>>>${EmpcollectionResp['message'][index]}");
                                            // updateEmpCollection(data: EmpcollectionResp['message'][index]);
                                            // SharedPreferences prefs = await SharedPreferences.getInstance();
                                            // prefs.setString('cash_controller', cash_controller.text.isEmpty ? "" : cash_controller.text);
                                            // prefs.setString('chaque_controller', chaque_controller.text.isEmpty ? "" : chaque_controller.text);
                                            // prefs.setString('wire_controller', wire_controller.text.isEmpty ? "" : wire_controller.text);
                                            // prefs.setString('chaque_ref_controller', chaque_ref_controller.text.isEmpty ? "" : chaque_ref_controller.text);
                                            // prefs.setString('chaque_date_controller', chaque_date_controller.text.isEmpty ? "" : chaque_date_controller.text);
                                            // prefs.setString('wire_ref_controller', wire_ref_controller.text.isEmpty ? "" : wire_ref_controller.text);
                                            // prefs.setString('wire_date_controller', wire_date_controller.text.isEmpty ? "" : wire_date_controller.text);
                                            // cash = prefs.getString("cash_controller").toString();
                                            // chaque =  prefs.getString("chaque_controller").toString();
                                            // wire =  prefs.getString("wire_controller").toString();
                                            // chaque_ref =  prefs.getString("chaque_ref_controller").toString();
                                            // chaque_date =  prefs.getString("chaque_date_controller").toString();
                                            // wire_ref =  prefs.getString("wire_ref_controller").toString();
                                            // wire_date =  prefs.getString("wire_date_controller").toString();
                                            //
                                            // var total = int.parse(cash_controller.text.replaceAll(",", "")) + int.parse(chaque_controller.text.replaceAll(",", "")) + int.parse(wire_controller.text.replaceAll(",", ""));
                                            // print("total is===>>>$total");
                                            // clicked.update("cash_amount", (value) => int.parse(cash_controller.text.replaceAll(",", "")));
                                            // clicked.update("cheque_amount", (value) => int.parse(chaque_controller.text.replaceAll(",", "")));
                                            // clicked.update("wire_amount", (value) => int.parse(wire_controller.text.replaceAll(",", "")));
                                            // clicked.update("cheque_reference", (value) => chaque_ref_controller.text);
                                            // clicked.update("cheque_date", (value) => chaque_date_controller.text);
                                            // clicked.update("wire_reference", (value) => wire_ref_controller.text);
                                            // clicked.update("wire_date", (value) => wire_date_controller.text);
                                            // clicked.update("total_amount", (value) => total);
                                            //
                                            //
                                            // listResp['docs'][0]["details"][index].update("cash_amount", (value) => int.parse(cash_controller.text.replaceAll(",", "")));
                                            // listResp['docs'][0]["details"][index].update("cheque_amount", (value) => int.parse(chaque_controller.text.replaceAll(",", "")));
                                            // listResp['docs'][0]["details"][index].update("wire_amount", (value) => int.parse(wire_controller.text.replaceAll(",", "")));
                                            // listResp['docs'][0]["details"][index].update("total_amount", (value) => total);
                                            // print("updated data is===>>>${listResp['docs'][0]["details"][index]}");
                                            // save(index: index,updatedData: listResp['docs'][0]["details"][index]);
                                          },
                                              child: Container(width: double.infinity,padding: EdgeInsets.all(10),decoration: BoxDecoration(color: textcolor,borderRadius: BorderRadius.circular(5)),child: Text("Save", style: TextStyle(fontSize: 16, color: Colors.white),textAlign: TextAlign.center)))
                                        ],
                                      ),
                                      // actions: [InkWell(onTap: (){},child: Container(padding: EdgeInsets.all(10),decoration: BoxDecoration(color: textcolor,borderRadius: BorderRadius.circular(5)),child: Text("Save", style: TextStyle(fontSize: 16, color: Colors.white))))],
                                    );
                                  });
                                },
                              );
                            ;
                          // },child: Container(padding: EdgeInsets.all(5),decoration: BoxDecoration(color: textcolor,borderRadius: BorderRadius.circular(5)),child: Text(collectionListWiseModel!.docs![0].details![index].docstatus == 1 ? "Show Details" : "Add Payment Details", style: TextStyle(fontSize: 16, color: Colors.white)))),
                          },child: Container(padding: EdgeInsets.all(5),decoration: BoxDecoration(color: textcolor,borderRadius: BorderRadius.circular(5)),child: Text("Add Payment Details", style: TextStyle(fontSize: 16, color: Colors.white)))),
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
          itemCount: employeeWiseCollectionTripModel!.message!.length),
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
