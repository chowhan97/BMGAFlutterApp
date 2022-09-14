import 'dart:convert';
import 'package:ebuzz/common/colors.dart';
import 'package:ebuzz/common/custom_appbar.dart';
import 'package:ebuzz/orderbooking/model/notEditable_model.dart';
import 'package:ebuzz/orderbooking/model/order_booking.dart';
import 'package:ebuzz/salesorder/model/sales_order.dart';
import 'package:ebuzz/util/apiurls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class OrderBookingDetail extends StatefulWidget {
  final OrderBooking bookingOrder;
  OrderBookingDetail({required this.bookingOrder});
  @override
  _OrderBookingDetailState createState() => _OrderBookingDetailState();
}

class _OrderBookingDetailState extends State<OrderBookingDetail> {
  List<SalesOrderItems> OrderItems = [];
  List<SalesOrderPaymentSchedule> OrderPaymentSchedule = [];
  TextEditingController companyController = TextEditingController();
  TextEditingController customerController = TextEditingController();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerTypeController = TextEditingController();
  NotEditable? notEditable;
  bool isNotEditableLoad = false;
  var formatter = NumberFormat('#,##,000');

  @override
  void initState() {
    super.initState();
    print("name====>>${widget.bookingOrder.name}");
    print("name====>>${widget.bookingOrder}");
    setState(() {
      companyController.text = widget.bookingOrder.company.toString();
      customerController.text = widget.bookingOrder.customer.toString();
      customerNameController.text = widget.bookingOrder.customer_name.toString();
      customerTypeController.text = widget.bookingOrder.customer_name.toString();
    });
    getTableData(context,name: widget.bookingOrder.name);
  }

  // List<Map> SalesOrderPreview = [
  //   {
  //     'item_code': "Demo item 4",
  //     'quantity_available': '52',
  //     'quantity': '20',
  //     'latest_prize': '₹ 160',
  //     'promo_type': 'None',
  //   },
  //   {
  //     'item_code': "Demo item 4",
  //     'quantity_available': '52',
  //     'quantity': '20',
  //     'latest_prize': '₹ 136',
  //     'promo_type': 'Buy x get same and discount',
  //   },
  // ];

  // List<Map> promos = [
  //   {
  //     'bought': "Demo item 4",
  //     'warehouse_qty': "20",
  //     'free_items': "Demo item 4",
  //     'qty': "4"
  //   }
  // ];

  List<Map> promosDiscount = [
    {
      'bought': "Demo item 4",
      'free_item': "Demo item 4",
      'discounted_prize': "136",
      'qty': "2"
    },
    {
      'bought': "Demo item 4",
      'free_item': "Demo item 4",
      'discounted_prize': "136",
      'qty': "2"
    },
  ];

  Future getTableData(BuildContext context,{name}) async{
    print("call");
    isNotEditableLoad = true;
    // var headers = {
    //   'Cookie': 'full_name=Jeeva; sid=6a44549626720c83d2d37a33716891f32dc8bf7978dcdaabbcf9b7b6; system_user=yes; user_id=jeeva%40yuvabe.com; user_image='
    // };
    var request = http.Request('POST', Uri.parse('https://erptest.bharathrajesh.co.in/api/method/frappe.desk.form.load.getdoc?doctype=Order+Booking+V2&name=${name}&_=1660542323085'));

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
        notEditable = NotEditable.fromJson(json.decode(data));
        print("${notEditable!.docs}");
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
          Text('Order Booking Detail', style: TextStyle(color: textcolor)),
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
              child: Column(
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
                                "#${widget.bookingOrder.name}",
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
                  isNotEditableLoad == true ? SizedBox(height: 300,child: Center(child: CircularProgressIndicator())) :  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      notEditable!.docs![0].orderBookingItemsV2!.isEmpty ? Container() : header("Order Items"),
                      notEditable!.docs![0].orderBookingItemsV2!.isEmpty ? Container() : listOrderBooking(notEditable!.docs![0].orderBookingItemsV2!),
                      notEditable!.docs![0].promos!.isEmpty ? Container() : header("Promos"),
                      notEditable!.docs![0].promos!.isEmpty ? Container() : listPromosView(notEditable!.docs![0].promos!),
                      notEditable!.docs![0].promosDiscount!.isEmpty ? Container() : header("Promos Discount"),
                      notEditable!.docs![0].promosDiscount!.isEmpty ? Container() : listPromosDiscountView(notEditable!.docs![0].promosDiscount!),
                      notEditable!.docs![0].salesOrderPreview!.isEmpty ? Container() : header("Sales Order Preview"),
                      notEditable!.docs![0].salesOrderPreview!.isEmpty ? Container() : listSalesOverView(notEditable!.docs![0].salesOrderPreview!),


                    ],
                  ),
                  SizedBox(height: 50,),
                ],
              ),
              // child: Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     companyField(),
              //     SizedBox(height: 15),
              //     customerField(),
              //     SizedBox(height: 15),
              //     customerNameField(),
              //     SizedBox(height: 15),
              //     customerTypeField(),
              //     SizedBox(height: 15),
              //     Expanded(child: isNotEditableLoad == true ? Center(child: CircularProgressIndicator()) : Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         notEditable!.docs![0].orderBookingItemsV2!.isEmpty ? Container(): Text("Order Booking Items V2",style: TextStyle(fontSize: 18)),
              //         SizedBox(height: 8),
              //         notEditable!.docs![0].orderBookingItemsV2!.isEmpty ? Container(): Expanded(
              //           child: ListView(
              //             scrollDirection: Axis.horizontal,
              //             children: [
              //               _createDataTable(),
              //             ],
              //           ),
              //         ),
              //         SizedBox(height: 8),
              //         notEditable!.docs![0].salesOrderPreview!.isEmpty ? Container(): Text("Sales Order Preview",style: TextStyle(fontSize: 18)),
              //         SizedBox(height: 8),
              //         notEditable!.docs![0].salesOrderPreview!.isEmpty ? Container(): Expanded(
              //               child: ListView(
              //                 scrollDirection: Axis.horizontal,
              //                 children: [
              //                   _createPromosDataTable(),
              //                 ],
              //               ),
              //             ),
              //           SizedBox(height: 8),
              //           notEditable!.docs![0].promos!.isEmpty  ? Container(): Text("Promos",style: TextStyle(fontSize: 18)),
              //           SizedBox(height: 8),
              //            notEditable!.docs![0].promos!.isEmpty  ? Container(): Expanded(
              //               child: ListView(
              //                 scrollDirection: Axis.horizontal,
              //                 children: [
              //                   _createPromosDiscountDataTable(),
              //                 ],
              //               ),
              //             ),
              //         SizedBox(height: 8),
              //         notEditable!.docs![0].promosDiscount!.isEmpty  ? Container(): Text("Promos Discount",style: TextStyle(fontSize: 18)),
              //         SizedBox(height: 8),
              //         notEditable!.docs![0].promosDiscount!.isEmpty  ? Container(): Expanded(
              //           child: ListView(
              //             scrollDirection: Axis.horizontal,
              //             children: [
              //               _createPromosDiscDataTable(),
              //             ],
              //           ),
              //         ),
              //       ],
              //     ),),
              //   ],
              // ),
            ),
          ),
        ),
    );
  }
  // DataTable _createDataTable() {
  //   return DataTable(columns: _createColumns(), rows: _createRows(),border: TableBorder.all(color: Colors.black));
  // }
  // DataTable _createPromosDataTable() {
  //   return DataTable(columns: _createpromosColumns(), rows: _createPromosRows(),border: TableBorder.all(color: Colors.black));
  // }
  // DataTable _createPromosDiscountDataTable() {
  //   return DataTable(columns: _createpromosDiscountColumns(), rows: _createPromosDiscountRows(),border: TableBorder.all(color: Colors.black));
  // }
  // DataTable _createPromosDiscDataTable() {
  //   return DataTable(columns: _createpromosDiscColumns(), rows: _createPromosDiscRows(),border: TableBorder.all(color: Colors.black));
  // }
  // List<DataColumn> _createColumns() {
  //   return [
  //     DataColumn(label: Expanded(child: Text('Item Code'))),
  //     DataColumn(label: Expanded(child: Text('stock Uom'))),
  //     DataColumn(label: Expanded(child: Text('Quantity Available'))),
  //     DataColumn(label: Expanded(child: Text('Quantity Booked'))),
  //     DataColumn(label: Expanded(child: Text('Latest Base Price'))),
  //     DataColumn(label: Expanded(child: Text('Amount'))),
  //     DataColumn(label: Expanded(child: Text('GST Rate'))),
  //     DataColumn(label: Expanded(child: Text('MRP'))),
  //   ];
  // }
  // List<DataRow> _createRows() {
  //   return notEditable!.docs![0].orderBookingItemsV2!.map((book) => DataRow(cells: [
  //     DataCell(Expanded(child: Text(book.itemCode.toString()))),
  //     DataCell(Expanded(child: Text(book.stockUom.toString()))),
  //     DataCell(Expanded(child: Text(book.quantityAvailable.toString()))),
  //     DataCell(Expanded(child: Text(book.quantityBooked.toString()))),
  //     DataCell(Expanded(child: Text(book.averagePrice.toString()))),
  //     DataCell(Expanded(child: Text(book.amount.toString()))),
  //     DataCell(Expanded(child: Text(book.gstRate.toString()))),
  //     DataCell(Expanded(child: Text(book.amountAfterGst.toString()))),
  //   ],
  //   ),
  //   ).toList();
  // }
  // List<DataColumn>  _createpromosColumns() {
  //   return [
  //     DataColumn(label: Expanded(child: Text('Item Code'))),
  //     DataColumn(label: Expanded(child: Text('Quantity Available'))),
  //     DataColumn(label: Expanded(child: Text('Quantity Booked'))),
  //     DataColumn(label: Expanded(child: Text('Latest Base Price'))),
  //     DataColumn(label: Expanded(child: Text('Warehouse'))),
  //     DataColumn(label: Expanded(child: Text('Promo Type'))),
  //   ];
  // }
  // List<DataRow> _createPromosRows() {
  //   return notEditable!.docs![0].salesOrderPreview!.map((book) => DataRow(cells: [
  //     DataCell(Expanded(child: Text(book.itemCode.toString()))),
  //     DataCell(Expanded(child: Text(book.quantityAvailable.toString()))),
  //     DataCell(Expanded(child: Text(book.quantity.toString()))),
  //     DataCell(Expanded(child: Text(book.average.toString()))),
  //     DataCell(Expanded(child: Text(book.warehouse.toString()))),
  //     DataCell(Expanded(child: Text(book.promoType.toString()))),
  //   ])).toList();
  // }
  // List<DataColumn> _createpromosDiscountColumns() {
  //   return [
  //     DataColumn(label: Expanded(child: Text('Bought Item'))),
  //     DataColumn(label: Expanded(child: Text('Warehouse Quantity'))),
  //     DataColumn(label: Expanded(child: Text('Free items'))),
  //     DataColumn(label: Expanded(child: Text('Quantity'))),
  //   ];
  // }
  // List<DataRow> _createPromosDiscountRows() {
  //   return notEditable!.docs![0].promos!.map((book) => DataRow(cells: [
  //     DataCell(Expanded(child: Text(book.boughtItem.toString()))),
  //     DataCell(Expanded(child: Text(book.warehouseQuantity.toString()))),
  //     DataCell(Expanded(child: Text(book.freeItems.toString()))),
  //     DataCell(Expanded(child: Text(book.quantity.toString()))),
  //   ])).toList();
  // }
  // List<DataColumn> _createpromosDiscColumns() {
  //   return [
  //     DataColumn(label: Expanded(child: Text('Bought Item'))),
  //     DataColumn(label: Expanded(child: Text('Free Item'))),
  //     DataColumn(label: Expanded(child: Text('Discounted Price'))),
  //     DataColumn(label: Expanded(child: Text('Quantity'))),
  //   ];
  // }
  // List<DataRow> _createPromosDiscRows() {
  //   return notEditable!.docs![0].promosDiscount!.map((book) => DataRow(cells: [
  //     DataCell(Expanded(child: Text(book.boughtItem.toString()))),
  //     DataCell(Expanded(child: Text(book.warehouseQuantity.toString()))),
  //     DataCell(Expanded(child: Text(book.freeItems.toString()))),
  //     DataCell(Expanded(child: Text(book.quantity.toString()))),
  //   ])).toList();
  // }



  Widget companyField() {
    return TextFormField(
      controller: companyController,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: blackColor),
        fillColor: greyColor,
        filled: true,
        isDense: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
  Widget customerField() {
    return TextFormField(
      controller: customerController,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: blackColor),
        fillColor: greyColor,
        filled: true,
        isDense: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
  Widget customerNameField() {
    return TextFormField(
      controller: customerNameController,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: blackColor),
        fillColor: greyColor,
        filled: true,
        isDense: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
  Widget customerTypeField() {
    return TextFormField(
      controller: customerTypeController,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: blackColor),
        fillColor: greyColor,
        filled: true,
        isDense: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(5),
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
                    Expanded(child: Text(widget.bookingOrder.company.toString(),maxLines: 1,overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Icon(Icons.add_circle_outline_outlined,color: Colors.grey,),
                    SizedBox(width: 5,),
                    Expanded(child: Text(widget.bookingOrder.customer.toString(),maxLines: 1,overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Icon(Icons.person,color: Colors.grey,),
                    SizedBox(width: 5,),
                    Expanded(child: Text(widget.bookingOrder.customer_name.toString(),maxLines: 1,overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  listOrderBooking(List<OrderBookingItemsV2> list) {
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
                      Text(list[index].itemCode.toString(),style: TextStyle(fontWeight: FontWeight.bold,),),
                      SizedBox(height: 2,),
                      Row(
                        children: [
                          Text("MRP : ",style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("${list[index].amountAfterGst}",style: TextStyle(color: Colors.grey),),
                        ],
                      ),
                      SizedBox(height: 2,),
                      Text(
                          "${list[index].quantityBooked} x ${list[index].averagePrice}",
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
  
  listSalesOverView(List<SalesOrderPreview> list) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
        elevation: 5,
        child:  ListView.builder(
          itemCount: list.length,
          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context,index){
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(list[index].itemCode.toString(),style: TextStyle(fontWeight: FontWeight.bold,),),
                        SizedBox(height: 2,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("PromoType : ",style: TextStyle(fontWeight: FontWeight.bold,)),
                            Container(
                              width: MediaQuery.of(context).size.width / 2.9,
                              child: Text(
                                "${list[index].promoType}",style: TextStyle(color: Colors.grey),
                                // maxLines: 2,overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Text("PromoType : ",style: TextStyle(fontWeight: FontWeight.bold,)),
                            // Container(
                            //   width: MediaQuery.of(context).size.width / 1.7,
                            //   child: Text(
                            //     "PromoType : ${list[index].promoType}",style: TextStyle(fontWeight: FontWeight.bold,),
                            //       // maxLines: 2,overflow: TextOverflow.ellipsis,
                            //   ),
                            // ),
                          ],
                        ),
                        // Text("PromoType : ${list[index].promoType}",style: TextStyle(color: Colors.grey),maxLines: 2,overflow: TextOverflow.ellipsis),
                        SizedBox(height: 2,),
                        Text(
                          "${list[index].quantity} x ${list[index].average}",
                          style: TextStyle(fontWeight: FontWeight.bold,),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 10,),
                  Text(
                    "₹" + formatter.format((list[index].quantity!) * list[index].average!).toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  listPromosView(List<Promo> list) {
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
                      Text(list[index].boughtItem.toString(),style: TextStyle(fontWeight: FontWeight.bold,),),
                      SizedBox(height: 2,),
                      Row(
                        children: [
                          Text("Free Item : ",style: TextStyle(fontWeight: FontWeight.bold,),),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.38,
                              child: Text(
                                "${list[index].freeItems}",
                                style: TextStyle(color: Colors.grey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2,),
                      Text(
                        "${list[index].quantity} Quantity",
                        style: TextStyle(fontWeight: FontWeight.bold,),
                          maxLines: 1,overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("PromoType : ",style: TextStyle(fontWeight: FontWeight.bold,)),
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Text(
                              "${list[index].promoType}",style: TextStyle(color: Colors.grey),
                              // maxLines: 2,overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Container(
                          //   width: MediaQuery.of(context).size.width / 1.7,
                          //   child: Text(
                          //     "PromoType : ${list[index].promoType}",style: TextStyle(fontWeight: FontWeight.bold,),
                          //     // maxLines: 2,overflow: TextOverflow.ellipsis,
                          //   ),
                          // ),
                        ],
                      ),
                      // Text(
                      //   "PromoType : ${list[index].promoType}",
                      //   style: TextStyle(color: Colors.grey),
                      // ),
                    ],
                  ),
                  SizedBox(width: 10),
                  Text(
                    "₹" + formatter.format(int.parse(list[index].quantity!) * list[index].price!).toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  listPromosDiscountView(List<PromosDiscount> list) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
        elevation: 5,
        child:  ListView.builder(
          itemCount: list.length,
          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context,index){
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(list[index].boughtItem.toString(),style: TextStyle(fontWeight: FontWeight.bold,),),
                        SizedBox(height: 2,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("PromoType : ",style: TextStyle(fontWeight: FontWeight.bold)),
                            Container(
                              width: MediaQuery.of(context).size.width / 2.9,
                              child: Text(
                                "${list[index].promoType}",style: TextStyle(color: Colors.grey),
                                // maxLines: 2,overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Container(
                            //   width: MediaQuery.of(context).size.width / 1.7,
                            //   child: Text(
                            //     "PromoType : ${list[index].promoType}",style: TextStyle(fontWeight: FontWeight.bold,),
                            //     // maxLines: 2,overflow: TextOverflow.ellipsis,
                            //   ),
                            // ),
                          ],
                        ),
                        // Text("PromoType : "+list[index].promoType.toString(), style: TextStyle(color: Colors.grey),maxLines: 1,overflow: TextOverflow.ellipsis,),
                        SizedBox(height: 2),
                        Text(
                          "${list[index].quantity} x ${list[index].discount}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 10,),
                  Text(
                    "₹" + formatter.format(int.parse(list[index].quantity!) * list[index].discount!).toString(),
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

  header(String s) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(s,style: TextStyle(fontSize: 18)),
    );
  }

  totalHeader(String s) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(s,style: TextStyle(fontWeight: FontWeight.bold),),
    );
  }
}

