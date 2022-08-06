import 'package:ebuzz/common/colors.dart';
import 'package:ebuzz/common/custom_appbar.dart';
import 'package:ebuzz/common/navigations.dart';
import 'package:ebuzz/orderbooking/model/order_booking.dart';
import 'package:ebuzz/orderbooking/service/orderbooking_api_service.dart';
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
                child: Text(_orderBookingList[index].name.toString()),
                
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
        backgroundColor: blueAccent,
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

  