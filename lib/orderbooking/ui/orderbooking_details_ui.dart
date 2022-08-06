import 'package:flutter/material.dart';
import 'package:ebuzz/orderbooking/model/order_booking.dart';
import 'package:ebuzz/orderbooking/service/orderbooking_api_service.dart';

class OrderBookingDetails extends StatefulWidget {

  OrderBookingDetails() : super();

  @override
  _OrderBookingDetails createState() => _OrderBookingDetails();
}

class _OrderBookingDetails extends State<OrderBookingDetails>{
  List<OrderBookingDetails> details;
  bool _loading;


  @override initState(){
    super.initState();
    _loading = true;
    Services.getDetails(item_code, customer_type, company, customer).then((details){
      _details = details;
      _loading = false;

    });

  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(_loading ? "Loading......" :"Details"),
      ),
    );
  }
}