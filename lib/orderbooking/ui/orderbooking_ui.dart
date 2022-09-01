import 'package:ebuzz/common/colors.dart';
import 'package:ebuzz/common/custom_appbar.dart';
import 'package:ebuzz/common/navigations.dart';
import 'package:ebuzz/orderbooking/model/order_booking.dart';
import 'package:ebuzz/orderbooking/service/orderbooking_api_service.dart';
import 'package:ebuzz/orderbooking/ui/orderbooking_detail_ui.dart';
import 'package:ebuzz/orderbooking/ui/orderbooking_form2.dart';
import 'package:ebuzz/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:ebuzz/orderbooking/ui/orderbooking_form1.dart';

class OrderBookingUi extends StatefulWidget {
  @override
  _OrderBookingUiState createState() => _OrderBookingUiState();
}

class _OrderBookingUiState extends State<OrderBookingUi> {
  List<OrderBooking> _orderBookingList = [];
  @override
  void initState() {
    super.initState();
    getOrderBookingList();
  }

  getOrderBookingList() async {
    _orderBookingList = await OrderBookingListService().getOrderBookingList(context);
    setState(() {});
  }
  @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: bgColor,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(55),
            child: CustomAppBar(
              title:
                  Text('Order Booking List', style: TextStyle(color: whiteColor)),
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back,
                  color: whiteColor,
                ),
              ),
            )),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: ListView.builder(
            itemCount: _orderBookingList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: (){
                  if(_orderBookingList[index].name == "" || _orderBookingList[index].name == null){
                    pushScreen(context, OrderBookingForm2());
                  }else{
                    pushScreen(
                      context,
                      OrderBookingDetail(
                        bookingOrder: _orderBookingList[index],
                      ),
                    );
                  }
                  // pushScreen(
                  //   context,
                  //   OrderBookingDetail(
                  //     bookingOrder: _orderBookingList[index],
                  //   ),
                  // );
                },
                // child: Text(_orderBookingList[index].name.toString()),
                child: SOTileUi(
                  soData: _orderBookingList[index],index: index,
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
        backgroundColor: Constants.buttonColor,
        onPressed: () {
          pushScreen(context, OrderBookingForm1());
        },
        child: Icon(
          Icons.add,
          color: whiteColor,
        ),
      ),
      );
    }
}

class SOTileUi extends StatelessWidget {
  final OrderBooking soData;
  final int index;
  const SOTileUi({required this.soData,required this.index});
  @override
  Widget build(BuildContext context) {
    print("data==>>>${soData}");
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // soData.customer ?? '',
                    soData.customer_name ?? '',
                    style: TextStyle(fontSize: 16, color: blackColor),
                  ),
                  SizedBox(height: 5),
                  Text(
                    // 'Delivery Date : ' + soData.orderBookingItems!,
                    'Order Booking Id : ' + soData.name.toString(),
                  ),
                  SizedBox(height: 5),
                  Text(
                    // 'Grand Total : \$' + soData.grandtotal.toString(),
                    'Modified : ' + soData.modified.toString(),
                  ),
                  // SizedBox(height: 5),
                  // Row(
                  //   children: [
                  //     Text(
                  //       // 'Percent Billed : ' + soData.perbilled!.toStringAsPrecision(2) + '%  ',
                  //       'Percent Billed : ' + "" + '%  ',
                  //     ),
                  //     Text(
                  //       // 'Percent Delivered : ' + soData.perdelivered!.toStringAsPrecision(2) + '%',
                  //       'Percent Delivered : ' + "" + '%',
                  //     ),
                  //   ],
                  // ),
                ],
              ),
              Spacer(),
              SizedBox(width: 5),
            ],
          ),
        ),
      ),
    );
  }
}

  