import 'package:flutter/material.dart';

class OrderBookingDetails extends StatefulWidget {

  OrderBookingDetails() : super();

  @override
  _OrderBookingDetails createState() => _OrderBookingDetails();
}

class _OrderBookingDetails extends State<OrderBookingDetails>{
  late List<OrderBookingDetails> details;
  late bool _loading;


  @override initState(){
    super.initState();
    _loading = true;
    // Services.getDetails(item_code, customer_type, company, customer).then((details){
    //   _details = details;
    //   _loading = false;
    //
    // });

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