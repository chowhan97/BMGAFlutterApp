import 'dart:convert';
import 'package:ebuzz/collection_trip/collection_trip_wise_list.dart';
import 'package:ebuzz/common/colors.dart';
import 'package:ebuzz/common/custom_appbar.dart';
import 'package:ebuzz/common/navigations.dart';
import 'package:ebuzz/util/apiurls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'collection_trip_list_model.dart';


class CollectionTripList extends StatefulWidget {
  const CollectionTripList({Key? key}) : super(key: key);

  @override
  State<CollectionTripList> createState() => _CollectionTripListState();
}

class _CollectionTripListState extends State<CollectionTripList> {
  bool isLoadCollection = false;
  CollectionListModel? collectionListModel;

  @override
  void initState() {
    CollectionTrip();
    super.initState();
  }
  Future CollectionTrip() async {
    setState(() {
      isLoadCollection = true;
    });
    var request = http.MultipartRequest('POST', Uri.parse(CollectionTripListApi()));
    request.fields.addAll({
      'doctype': 'Collection Trip',
      'fields': '["`tabCollection Trip`.`name`","`tabCollection Trip`.`owner`","`tabCollection Trip`.`creation`","`tabCollection Trip`.`modified`","`tabCollection Trip`.`modified_by`","`tabCollection Trip`.`_user_tags`","`tabCollection Trip`.`_comments`","`tabCollection Trip`.`_assign`","`tabCollection Trip`.`_liked_by`","`tabCollection Trip`.`docstatus`","`tabCollection Trip`.`parent`","`tabCollection Trip`.`parenttype`","`tabCollection Trip`.`parentfield`","`tabCollection Trip`.`idx`","`tabCollection Trip`.`delivery_trip_no`","`tabCollection Trip`.`collection_person`"]',
      'filters': '[]',
      'order_by': '`tabCollection Trip`.`modified` desc',
      'start': '0',
      'page_length': '20',
      'view': 'List',
      'group_by': '`tabCollection Trip`.`name`',
      'with_comment_count': 'true'
    });
    request.headers.addAll(commonHeaders);
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      setState(() {
        print(response.body);
        String data = response.body;
        isLoadCollection = false;
        collectionListModel = CollectionListModel.fromJson(json.decode(data));
        print("collectionListModel===>>>${collectionListModel!.message!.values}");
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
      body: isLoadCollection == true ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(textcolor))) : Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: collectionListModel!.message!.values!.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: (){
                pushScreen(context, CollectionTripWiseList(name: collectionListModel!.message!.values![index][0]));
                // if(_orderBookingList[index].name == "" || _orderBookingList[index].name == null){
                //   pushScreen(context, OrderBookingForm2());
                // }else{
                //   pushScreen(
                //     context,
                //     OrderBookingDetail(
                //       bookingOrder: _orderBookingList[index],
                //     ),
                //   );
                // }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(collectionListModel!.message!.values![index][0] ?? '',
                              style: TextStyle(fontSize: 16, color: blackColor),
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text("Delivery Trip No: ",style: TextStyle(fontWeight: FontWeight.bold)),
                                Text("${collectionListModel!.message!.values![index][14]}",style: TextStyle(color: greyLightColor),),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text("Collection Person: ",style: TextStyle(fontWeight: FontWeight.bold)),
                                Text("${collectionListModel!.message!.values![index][15]}",style: TextStyle(color: greyLightColor),),
                              ],
                            ),
                            // Text('Delivery Trip No: ' + collectionListModel!.message!.values![index][14]),
                            SizedBox(height: 5),
                            // collectionListModel!.message!.values![index][15] == null ? SizedBox(): Text('Collection Person: ' + collectionListModel!.message!.values![index][15]),
                          ],
                        ),
                        Container(padding: EdgeInsets.all(5),decoration: BoxDecoration(color: collectionListModel!.message!.values![index][9] == 1 ? textcolor : greyLightColor,borderRadius: BorderRadius.circular(5)),child: Text(collectionListModel!.message!.values![index][9] == 1 ? "Submitted" : "Draft", style: TextStyle(fontSize: 16, color: Colors.white))),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
