import 'dart:convert';
import 'dart:ui';
import 'package:ebuzz/collection_trip/collection_trip_wise_list_model.dart';
import 'package:ebuzz/collection_trip/employee_wise_collection_trip_model.dart';
import 'package:ebuzz/common/colors.dart';
import 'package:ebuzz/common/custom_appbar.dart';
import 'package:ebuzz/common/navigations.dart';
import 'package:ebuzz/util/apiurls.dart';
import 'package:ebuzz/widgets/custom_typeahead_formfield.dart';
import 'package:ebuzz/widgets/typeahead_widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CollectionTripWiseList extends StatefulWidget {
  var name,EmpId;
  bool? isFirstTime;
  List<Message>? filterData;
  CollectionTripWiseList({this.name,this.EmpId,this.filterData,this.isFirstTime});

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
   List<String> territory = [];
   List customer = [];
   TextEditingController territorycontroller = TextEditingController();
   TextEditingController customercontroller = TextEditingController();
   List<String> customer_name = [];
   String? _dropDownValue;
   String? _dropDownCustValue;
   List<String> custName = [];
   List<String> customer_territory = [];

  @override
  void initState() {
    // print("name===>>>${widget.name}");
    // GetEmpName();

    EmployeeCollectionTrip(employeeId: widget.EmpId);
    storeId();

    // CollectionTrip();
    // EmployeeCollectionTrip(employeeId: "HR-EMP-00003");
    getData();
    super.initState();
  }

  storeId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("EmpID",widget.EmpId);
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
         territory.clear();
         custName.clear();
         for(var i=0; i< employeeWiseCollectionTripModel!.message!.length; i++){
           territory.add(employeeWiseCollectionTripModel!.message![i].customer_territory);
           print("territory is==========>>>>$territory");
           print("territory is==========>>>>${territory.length}");
         }
         for(var i=0; i< employeeWiseCollectionTripModel!.message!.length; i++){
           custName.add(employeeWiseCollectionTripModel!.message![i].customer_name);
           print("custName is==========>>>>$custName");
           print("custName is==========>>>>${custName.length}");
         }
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
     print("emp data is====>>>>>${jsonEncode(data)}");
     setState(() {
       isLoadEmpCollectionUpdate = true;
     });
     // var request = http.Request('POST', Uri.parse('https://erptest.bharathrajesh.co.in/api/method/bmga.global_api.update_employee_collection_trips?payload=[{"name": ${jsonEncode(data['name'])},"invoice_no": ${jsonEncode(data['invoice_no'])},"customer_territory": ${jsonEncode(data['customer_territory'])},"customer_name": ${jsonEncode(data['customer_name'])},"pending_amount": ${jsonEncode(data['pending_amount'])},"cash_amount": ${jsonEncode(data['cash_amount'])},"cheque_amount": ${jsonEncode(data['cheque_amount'])},"wire_amount": ${jsonEncode(data['wire_amount'])},"total_amount": ${jsonEncode(data['total_amount'])},"cheque_reference": ${jsonEncode(data['total_amount'])},"cheque_date": ${jsonEncode(data['cheque_date'])},"wire_reference": ${jsonEncode(data['wire_reference'])},"wire_date": ${jsonEncode(data['wire_date'])}}]'));
     var request = http.Request('POST', Uri.parse('https://erptest.bharathrajesh.co.in/api/method/bmga.global_api.update_employee_collection_trips?payload=[${jsonEncode(data)}]'));
     request.headers.addAll(commonHeaders);
     var streamedResponse = await request.send();
     var response = await http.Response.fromStream(streamedResponse);
     if (response.statusCode == 200) {
       SharedPreferences prefs = await SharedPreferences.getInstance();
       setState(() {
         // CollectionTrip();
         // EmployeeCollectionTrip(employeeId: widget.EmpId);
         Navigator.pop(context);
         print("EmpId is====>>>${widget.EmpId}");
         var id = prefs.getString("EmpID");
         pushReplacementScreen(context, CollectionTripWiseList(EmpId: id,isFirstTime: true));
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
          actions: [
            IconButton(onPressed: (){
              territorycontroller.text = "";
              customercontroller.text = "";
              // _dropDownValue = "";
              // _dropDownCustValue = "";
              showDialog(context: context, builder: (BuildContext context) {
                return StatefulBuilder(builder: (context,setState){
                  return AlertDialog(
                    // scrollable: true,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Territory",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(color: greyColor,borderRadius: BorderRadius.circular(5)),
                          height: 50,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: DropdownButton(
                              // hint: customer_territory.isEmpty
                              //     ? Text('Select Territory')
                              //     : Text(
                              //   customer_territory[0],
                              // ),
                              hint:  customer_territory.isEmpty
                                  ? _dropDownValue == null
                                  ? Text('Select Territory') : Text(
                                _dropDownValue!,
                              )
                                  : Text(
                                  customer_territory[0]),
                              isExpanded: true,
                              iconSize: 30.0,
                              // style: TextStyle(color: Colors.blue),
                              items: customer_territory.isEmpty ? territory.toSet().toList().map(
                                    (val) {
                                  return DropdownMenuItem<String>(
                                    value: val,
                                    child: Text(val),
                                  );
                                },
                              ).toList() : customer_territory.toSet().toList().map(
                                    (val) {
                                  return DropdownMenuItem<String>(
                                    value: val,
                                    child: Text(val),
                                  );
                                },
                              ).toList(),
                              onChanged: (val) {
                                setState(() {
                                    _dropDownValue = val as String;
                                    customer_name.clear();
                                        List<Message> results = employeeWiseCollectionTripModel!.message!
                                            .where((elem) =>
                                        elem.customer_territory
                                            .toString()
                                            .toLowerCase()
                                             == _dropDownValue!.toLowerCase()).toList();
                                        for(var v in results){
                                          customer_name.add(v.customer_name);
                                          print(customer_name);
                                     }
                                  },
                                );
                              },underline: Container(),elevation: 16,
                            ),
                          ),
                        ),
                    //   CustomTypeAheadFormField(
                    //   controller: territorycontroller,
                    //   decoration: InputDecoration(
                    //     fillColor: greyColor,
                    //     filled: true,
                    //     isDense: true,
                    //     border: OutlineInputBorder(
                    //       borderSide: BorderSide.none,
                    //       borderRadius: BorderRadius.circular(5),
                    //     ),
                    //     hintText: 'Select Territory',
                    //   ),
                    //   label: 'Territory',
                    //   labelStyle: TextStyle(color: blackColor,fontWeight: FontWeight.bold),
                    //   required: true,
                    //   style: TextStyle(fontSize: 14, color: blackColor),
                    //   itemBuilder: (context, item) {
                    //     return TypeAheadWidgets.itemUi(item);
                    //   },
                    //   onSuggestionSelected: (suggestion) async {
                    //     print("suggestion selected");
                    //     setState(() {
                    //       territorycontroller.text = suggestion;
                    //       customer_name.clear();
                    //       List<Message> results = employeeWiseCollectionTripModel!.message!
                    //           .where((elem) =>
                    //       elem.customer_territory
                    //           .toString()
                    //           .toLowerCase()
                    //           .contains(suggestion.toLowerCase())).toList();
                    //       for(var v in results){
                    //         customer_name.add(v.customer_name);
                    //         print(customer_name);
                    //       }
                    //     });
                    //   },
                    //   suggestionsCallback: (pattern) {
                    //     print("suggestion list call");
                    //     return TypeAheadWidgets.getSuggestions(pattern, territory);
                    //   },
                    //   transitionBuilder: (context, suggestionsBox, controller) {
                    //     return suggestionsBox;
                    //   },
                    //   validator: (val) => val == '' || val == null ? 'Territory should not be empty' : null,
                    // ),
                        SizedBox(height: 10),
                        Text("Customer",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(color: greyColor,borderRadius: BorderRadius.circular(5)),
                          height: 50,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: DropdownButton(
                              // hint: _dropDownCustValue == null
                              //     ? Text('Select Customer')
                              //     : Text(
                              //   _dropDownCustValue!,
                              // ),
                              hint:  customer_name.isEmpty
                                  ? _dropDownCustValue == null
                                  ? Text('Select Customer') : Text(
                                _dropDownCustValue!,
                              )
                                  : Text(
                                  customer_name[0]),
                              isExpanded: true,
                              iconSize: 30.0,
                              // style: TextStyle(color: Colors.blue),
                              items: customer_name.isEmpty ? custName.toSet().toList().map(
                                    (val) {
                                  return DropdownMenuItem<String>(
                                    value: val,
                                    child: Text(val),
                                  );
                                },
                              ).toList() : customer_name.toSet().toList().map(
                                    (val) {
                                  return DropdownMenuItem<String>(
                                    value: val,
                                    child: Text(val),
                                  );
                                },
                              ).toList(),
                              onChanged: (val) {
                                setState(() {
                                  _dropDownCustValue = val as String;
                                  customer_territory.clear();
                                  List<Message> results = employeeWiseCollectionTripModel!.message!
                                      .where((elem) =>
                                      elem.customer_name
                                          .toString()
                                          .toLowerCase()
                                           == _dropDownCustValue!.toLowerCase()).toList();
                                    for(var v in results){
                                      customer_territory.add(v.customer_territory);
                                      print(customer_territory);
                                   }
                                 },
                               );
                              },underline: Container(),elevation: 16,
                            ),
                          ),
                        ),
                        // CustomTypeAheadFormField(
                        //   controller: customercontroller,
                        //   decoration: InputDecoration(
                        //     fillColor: greyColor,
                        //     filled: true,
                        //     isDense: true,
                        //     border: OutlineInputBorder(
                        //       borderSide: BorderSide.none,
                        //       borderRadius: BorderRadius.circular(5),
                        //     ),
                        //     hintText: 'Select Customer',
                        //   ),
                        //   label: 'Customer',
                        //   labelStyle: TextStyle(color: blackColor,fontWeight: FontWeight.bold),
                        //   required: true,
                        //   style: TextStyle(fontSize: 14, color: blackColor),
                        //   itemBuilder: (context, item) {
                        //     return TypeAheadWidgets.itemUi(item);
                        //   },
                        //   onSuggestionSelected: (suggestion) async {
                        //     print("suggestion selected");
                        //     customercontroller.text = suggestion;
                        //   },
                        //   suggestionsCallback: (pattern) {
                        //     print("suggestion list call");
                        //     return TypeAheadWidgets.getSuggestions(pattern, customer_name);
                        //   },
                        //   transitionBuilder: (context, suggestionsBox, controller) {
                        //     return suggestionsBox;
                        //   },
                        //   validator: (val) => val == '' || val == null ? 'Territory should not be empty' : null,
                        // ),
                        SizedBox(height: 20),
                        InkWell(child: Center(child: Container(padding: EdgeInsets.all(10),decoration: BoxDecoration(color: textcolor,borderRadius: BorderRadius.circular(5)),child: Text("Search", style: TextStyle(fontSize: 16, color: Colors.white)))),onTap: (){
                          // print("123==>>>>${employeeWiseCollectionTripModel!.message!.where((e) => e.customer_territory.contains(_dropDownValue) && e.customer_name.contains(_dropDownCustValue)).toList()}");
                          // List<Message> findItem = employeeWiseCollectionTripModel!.message!.where((e) => e.customer_territory.contains(_dropDownValue) && e.customer_name.contains(_dropDownCustValue)).toList();
                          // for(var v in findItem){
                          //   print("1"+v.name);
                          // }
                          Navigator.pop(context);
                          pushReplacementScreen(context, CollectionTripWiseList(filterData: _dropDownCustValue == null ? employeeWiseCollectionTripModel!.message!.where((e) => e.customer_territory == _dropDownValue).toList() : _dropDownValue == null ? employeeWiseCollectionTripModel!.message!.where((e) => e.customer_name == _dropDownCustValue).toList() :  employeeWiseCollectionTripModel!.message!.where((e) => e.customer_territory == _dropDownValue && e.customer_name == _dropDownCustValue).toList(),isFirstTime: false,EmpId: widget.EmpId));
                          // print(employeeWiseCollectionTripModel!.message!.any((element) => element.customer_territory == territorycontroller.text && element.customer_name == customercontroller.text));
                        }),
                      ],
                    ),
                    // actions: [
                    //   Container(padding: EdgeInsets.all(5),decoration: BoxDecoration(color: textcolor,borderRadius: BorderRadius.circular(5)),child: Text("Search", style: TextStyle(fontSize: 16, color: Colors.white))),
                    // ],
                  );
                });
              });
            }, icon: Icon(Icons.filter_alt_outlined,color: Colors.grey))
          ],
        ),
      ),
      body: widget.isFirstTime == false ? ListView.separated(itemBuilder: (BuildContext context, index) {
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
                      val: "${widget.filterData![index].invoiceNo}"),
                  SizedBox(height: 8),
                  listText(
                      heading: "Customer Name",
                      val:
                      "${widget.filterData![index].customer_name}"),
                  SizedBox(height: 8),
                  listText(
                      heading: "Pending Amount",
                      val: "₹${myFormat.format(widget.filterData![index].pendingAmount)}"),
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
                          child: Column(children:[Text("₹${myFormat.format(widget.filterData![index].cashAmount)}")]),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Column(children:[Text('₹${myFormat.format(widget.filterData![index].chequeAmount)}')]),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Column(children:[Text('₹${myFormat.format(widget.filterData![index].wireAmount)}')]),
                        ),
                      ]),
                    ],
                  ),
                  SizedBox(height: 8),
                  listText(
                      heading: "Total Amount Collected",
                      val: "₹${myFormat.format(widget.filterData![index].totalAmount)}"),
                  SizedBox(height: 8),
                  // if(collectionListWiseModel!.docs![0].details![index].docstatus == 0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(onTap: (){
                        print("hii is======>>>${widget.filterData![index].cashAmount}");
                        showDialog(context: context,
                          builder: (BuildContext context) {
                            TextEditingController cash_controller = TextEditingController();
                            TextEditingController chaque_controller = TextEditingController();
                            TextEditingController wire_controller = TextEditingController();
                            TextEditingController chaque_ref_controller = TextEditingController();
                            TextEditingController chaque_date_controller = TextEditingController();
                            TextEditingController wire_ref_controller = TextEditingController();
                            TextEditingController wire_date_controller = TextEditingController();
                            String pass_check_date = '';
                            String pass_wire_date = '';
                            DateTime selectedDate = DateTime.now();
                            cash_controller.text = myFormat.format(widget.filterData![index].cashAmount);
                            chaque_controller.text = myFormat.format(widget.filterData![index].chequeAmount);
                            wire_controller.text = myFormat.format(widget.filterData![index].wireAmount);
                            chaque_ref_controller.text = widget.filterData![index].chequeReference == null ? "" : widget.filterData![index].chequeReference.toString();
                            //chaque_date_controller.text = collectionListWiseModel!.docs![0].details![index].chequeDate.toString();
                            chaque_date_controller.text = widget.filterData![index].chequeDate == null ? "" : DateFormat("dd-MM-yyyy").format(
                              DateTime.parse(widget.filterData![index].chequeDate.toString()),
                            );
                            pass_check_date = widget.filterData![index].chequeDate == null ? "" : DateFormat("yyyy-MM-dd").format(
                              DateTime.parse(widget.filterData![index].chequeDate.toString()),
                            );
                            wire_ref_controller.text = widget.filterData![index].wireReference == null ? "" : widget.filterData![index].wireReference.toString();
                            //wire_date_controller.text = collectionListWiseModel!.docs![0].details![index].wireDate.toString();
                            wire_date_controller.text = widget.filterData![index].wireDate == null ? "" : DateFormat("dd-MM-yyyy").format(
                              DateTime.parse(widget.filterData![index].wireDate.toString()),
                            );
                            pass_wire_date = widget.filterData![index].wireDate == null ? "" : DateFormat("yyyy-MM-dd").format(
                              DateTime.parse(widget.filterData![index].wireDate.toString()),
                            );

                            var checkval = '';
                            var wireval = '';
                            bool ischeckShow = false;
                            bool iswireShow = false;

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
                                  pass_check_date = DateFormat('yyyy-MM-dd').format(picked).toString();
                                }else{
                                  wire_date_controller.text = DateFormat('dd-MM-yyyy').format(picked).toString();
                                  pass_wire_date = DateFormat('yyyy-MM-dd').format(picked).toString();
                                }
                              });
                            }
                            return StatefulBuilder(builder: (context,setState){
                              return AlertDialog(
                                scrollable: true,
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${widget.filterData![index].invoiceNo}"),
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
                                      // List data = [];
                                      // data.clear();
                                      // data.add(widget.filterData);
                                      // print("data is====>>>$data");
                                      // print("data index is====>>>${data[index].cashAmount}");
                                      print(widget.filterData!);
                                      print(widget.filterData![index]);
                                      Map data = {"name":widget.filterData![index].name,"invoice_no":widget.filterData![index].invoiceNo,"customer_territory":widget.filterData![index].customer_territory,"customer_name":widget.filterData![index].customer_name,"pending_amount":widget.filterData![index].pendingAmount,"cash_amount":widget.filterData![index].cashAmount,"cheque_amount":widget.filterData![index].chequeAmount,"wire_amount":widget.filterData![index].wireAmount,"total_amount":widget.filterData![index].totalAmount,"cheque_reference":widget.filterData![index].chequeReference,"cheque_date":widget.filterData![index].chequeDate,"wire_reference":widget.filterData![index].wireReference,"wire_date":widget.filterData![index].wireDate};
                                      print("map data is===>>>${data}");
                                      // print(data);
                                      // List data = [];
                                      // data.clear();
                                      // data.add(widget.filterData![index]);
                                      var total = int.parse(cash_controller.text.replaceAll(",", "")) + int.parse(chaque_controller.text.replaceAll(",", "")) + int.parse(wire_controller.text.replaceAll(",", ""));
                                      print("total is===>>>$total");
                                      data.update("cash_amount", (value) => int.parse(cash_controller.text.replaceAll(",", "")));
                                      data.update("cheque_amount", (value) => int.parse(chaque_controller.text.replaceAll(",", "")));
                                      // data[index].update("cash_amount", (value) => int.parse(cash_controller.text.replaceAll(",", "")));
                                      // data[index].update("cheque_amount", (value) => int.parse(chaque_controller.text.replaceAll(",", "")));
                                      data.update("wire_amount", (value) => int.parse(wire_controller.text.replaceAll(",", "")));
                                      data.update("cheque_reference", (value) => chaque_ref_controller.text);
                                      data.update("cheque_date", (value) => pass_check_date);
                                      data.update("wire_reference", (value) => wire_ref_controller.text);
                                      data.update("wire_date", (value) => pass_wire_date);
                                      data.update("total_amount", (value) => total);
                                      print("updated data is======>>>${data}");
                                      updateEmpCollection(data: data);
                                    },
                                        child: Container(width: double.infinity,padding: EdgeInsets.all(10),decoration: BoxDecoration(color: textcolor,borderRadius: BorderRadius.circular(5)),child: Text("Save", style: TextStyle(fontSize: 16, color: Colors.white),textAlign: TextAlign.center)))
                                  ],
                                ),
                                // actions: [InkWell(onTap: (){},child: Container(padding: EdgeInsets.all(10),decoration: BoxDecoration(color: textcolor,borderRadius: BorderRadius.circular(5)),child: Text("Save", style: TextStyle(fontSize: 16, color: Colors.white))))],
                              );
                            });
                          },
                        );
                      },
                          child: Container(padding: EdgeInsets.all(5),decoration: BoxDecoration(color: textcolor,borderRadius: BorderRadius.circular(5)),child: Text("Add Payment Details", style: TextStyle(fontSize: 16, color: Colors.white)))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }, separatorBuilder: (BuildContext context,index){
        return SizedBox(height: 0);
      }, itemCount: widget.filterData!.length) :
      isLoadEmpCollection == true ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(textcolor))) : ListView.separated(
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
                              showDialog(context: context,
                                builder: (BuildContext context) {
                                  TextEditingController cash_controller = TextEditingController();
                                  TextEditingController chaque_controller = TextEditingController();
                                  TextEditingController wire_controller = TextEditingController();
                                  TextEditingController chaque_ref_controller = TextEditingController();
                                  TextEditingController chaque_date_controller = TextEditingController();
                                  TextEditingController wire_ref_controller = TextEditingController();
                                  TextEditingController wire_date_controller = TextEditingController();
                                  String pass_check_date = '';
                                  String pass_wire_date = '';
                                  DateTime selectedDate = DateTime.now();
                                  cash_controller.text = myFormat.format(employeeWiseCollectionTripModel!.message![index].cashAmount);
                                  chaque_controller.text = myFormat.format(employeeWiseCollectionTripModel!.message![index].chequeAmount);
                                  wire_controller.text = myFormat.format(employeeWiseCollectionTripModel!.message![index].wireAmount);
                                  chaque_ref_controller.text = employeeWiseCollectionTripModel!.message![index].chequeReference == null ? "" : employeeWiseCollectionTripModel!.message![index].chequeReference.toString();
                                  //chaque_date_controller.text = collectionListWiseModel!.docs![0].details![index].chequeDate.toString();
                                  chaque_date_controller.text = employeeWiseCollectionTripModel!.message![index].chequeDate == null ? "" : DateFormat("dd-MM-yyyy").format(
                                    DateTime.parse(employeeWiseCollectionTripModel!.message![index].chequeDate.toString()),
                                  );
                                  pass_check_date = employeeWiseCollectionTripModel!.message![index].chequeDate == null ? "" : DateFormat("yyyy-MM-dd").format(
                                    DateTime.parse(employeeWiseCollectionTripModel!.message![index].chequeDate.toString()),
                                  );
                                  wire_ref_controller.text = employeeWiseCollectionTripModel!.message![index].wireReference == null ? "" : employeeWiseCollectionTripModel!.message![index].wireReference.toString();
                                  //wire_date_controller.text = collectionListWiseModel!.docs![0].details![index].wireDate.toString();
                                  wire_date_controller.text = employeeWiseCollectionTripModel!.message![index].wireDate == null ? "" : DateFormat("dd-MM-yyyy").format(
                                    DateTime.parse(employeeWiseCollectionTripModel!.message![index].wireDate.toString()),
                                  );
                                  pass_wire_date = employeeWiseCollectionTripModel!.message![index].wireDate == null ? "" : DateFormat("yyyy-MM-dd").format(
                                    DateTime.parse(employeeWiseCollectionTripModel!.message![index].wireDate.toString()),
                                  );

                                  var checkval = '';
                                  var wireval = '';
                                  bool ischeckShow = false;
                                  bool iswireShow = false;

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
                                        pass_check_date = DateFormat('yyyy-MM-dd').format(picked).toString();
                                      }else{
                                        wire_date_controller.text = DateFormat('dd-MM-yyyy').format(picked).toString();
                                        pass_wire_date = DateFormat('yyyy-MM-dd').format(picked).toString();
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
                                            print(EmpcollectionResp['message'][index]);
                                            var total = int.parse(cash_controller.text.replaceAll(",", "")) + int.parse(chaque_controller.text.replaceAll(",", "")) + int.parse(wire_controller.text.replaceAll(",", ""));
                                            print("total is===>>>$total");
                                            EmpcollectionResp['message'][index].update("cash_amount", (value) => int.parse(cash_controller.text.replaceAll(",", "")));
                                            EmpcollectionResp['message'][index].update("cheque_amount", (value) => int.parse(chaque_controller.text.replaceAll(",", "")));
                                            EmpcollectionResp['message'][index].update("wire_amount", (value) => int.parse(wire_controller.text.replaceAll(",", "")));
                                            EmpcollectionResp['message'][index].update("cheque_reference", (value) => chaque_ref_controller.text);
                                            EmpcollectionResp['message'][index].update("cheque_date", (value) => pass_check_date);
                                            EmpcollectionResp['message'][index].update("wire_reference", (value) => wire_ref_controller.text);
                                            EmpcollectionResp['message'][index].update("wire_date", (value) => pass_wire_date);
                                            EmpcollectionResp['message'][index].update("total_amount", (value) => total);
                                            print("updated data is======>>>${EmpcollectionResp['message'][index]}");
                                            updateEmpCollection(data: EmpcollectionResp['message'][index]);
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
