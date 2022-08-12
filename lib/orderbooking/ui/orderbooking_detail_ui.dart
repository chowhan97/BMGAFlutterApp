import 'package:ebuzz/common/colors.dart';
import 'package:ebuzz/common/custom_appbar.dart';
import 'package:ebuzz/common/display_helper.dart';
import 'package:ebuzz/common/ui_reusable_widget.dart';
import 'package:ebuzz/orderbooking/model/order_booking.dart';
import 'package:ebuzz/salesorder/model/sales_order.dart';
import 'package:ebuzz/salesorder/service/sales_order_service.dart';
import 'package:ebuzz/widgets/custom_textformformfield.dart';
import 'package:flutter/material.dart';

class OrderBookingDetail extends StatefulWidget {
  final OrderBooking bookingOrder;
  OrderBookingDetail({required this.bookingOrder});
  @override
  _OrderBookingDetailState createState() => _OrderBookingDetailState();
}

class _OrderBookingDetailState extends State<OrderBookingDetail> {
  List<SalesOrderItems> _salesOrderItems = [];
  List<SalesOrderPaymentSchedule> _salesOrderPaymentSchedule = [];

  @override
  void initState() {
    super.initState();
    getSalesOrderItemsAndPaymentSchedule();
  }

  getSalesOrderItemsAndPaymentSchedule() async {
    _salesOrderItems = await SalesOrderService()
        .getSalesOrderItemList(widget.bookingOrder.name!, context);
    _salesOrderPaymentSchedule = await SalesOrderService()
        .getSalesOrderPaymentScheduleList(widget.bookingOrder.name!, context);
    print(_salesOrderItems.length);
    print(_salesOrderPaymentSchedule.length);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: CustomAppBar(
          title:
          Text('Order Booking Detail', style: TextStyle(color: whiteColor)),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: whiteColor,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  salesOrderDetailWidget('Customer', widget.bookingOrder.customer),
                  SizedBox(height: 15),
                  salesOrderDetailWidget('Company', widget.bookingOrder.customer),
                  SizedBox(height: 15),
                  salesOrderDetailWidget('Order Type', widget.bookingOrder.customer),
                  SizedBox(height: 15),
                  salesOrderDetailWidget('Transaction Date', widget.bookingOrder.customer),
                  SizedBox(height: 15),
                  salesOrderDetailWidget('Delivery Date', widget.bookingOrder.customer),
                  SizedBox(height: 15),
                  salesOrderDetailWidget('Purchase Order Date', widget.bookingOrder.customer),
                  SizedBox(height: 15),
                  salesOrderDetailWidget('Purchase Order No', widget.bookingOrder.customer),
                  SizedBox(height: 15),
                  salesOrderDetailWidget('Port of Discharge', widget.bookingOrder.customer),
                  SizedBox(height: 15),
                  salesOrderDetailWidget('Total Quantity', widget.bookingOrder.customer),
                  SizedBox(height: 15),
                  salesOrderDetailWidget('Total Net Weight', widget.bookingOrder.customer),
                  SizedBox(height: 15),
                  salesOrderDetailWidget('Grand Total (INR)', widget.bookingOrder.customer),
                  SizedBox(height: 15),
                  salesOrderDetailWidget('Grand Total (USD)', widget.bookingOrder.customer),
                  SizedBox(height: 15),
                  salesOrderDetailWidget('Status', widget.bookingOrder.customer),
                  SizedBox(height: 15),
                  salesOrderDetailWidget('Advance Paid', widget.bookingOrder.customer),
                  SizedBox(height: 15),
                ],
              ),
            ),
            Column(
              children: [
                scrollToViewTableBelow(context),
                SizedBox(height: 5),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: <DataColumn>[
                      tableColumnText(context, 'Item Code'),
                      tableColumnText(context, 'ItemName'),
                      tableColumnText(context, 'Delivery Date'),
                      tableColumnText(context, 'Quantity'),
                      tableColumnText(context, 'Rate'),
                      tableColumnText(context, 'Amount'),
                    ],
                    rows: _salesOrderItems
                        .map((data) => DataRow(cells: <DataCell>[
                      dataCellText(context, data.itemcode ?? '',
                          displayWidth(context) * 0.3),
                      dataCellText(context, data.itemname ?? '',
                          displayWidth(context) * 0.7),
                      dataCellText(
                          context,
                          data.deliverydate.toString(),
                          displayWidth(context) * 0.3),
                      dataCellText(context, data.qty.toString(),
                          displayWidth(context) * 0.3),
                      dataCellText(context, data.rate.toString(),
                          displayWidth(context) * 0.3),
                      dataCellText(context, data.amount.toString(),
                          displayWidth(context) * 0.3),
                    ]))
                        .toList(),
                  ),
                ),
                SizedBox(height: 5),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: <DataColumn>[
                      tableColumnText(context, 'Payment Term'),
                      tableColumnText(context, 'Description'),
                      tableColumnText(context, 'Due Date'),
                      tableColumnText(context, 'Invoice Portion'),
                      tableColumnText(context, 'Payment Amount'),
                    ],
                    rows: _salesOrderPaymentSchedule
                        .map((data) => DataRow(cells: <DataCell>[
                      dataCellText(context, data.paymentterm ?? '',
                          displayWidth(context) * 0.3),
                      dataCellText(context, data.description ?? '',
                          displayWidth(context) * 0.7),
                      dataCellText(context, data.duedate.toString(),
                          displayWidth(context) * 0.4),
                      dataCellText(
                          context,
                          data.invoiceportion.toString(),
                          displayWidth(context) * 0.3),
                      dataCellText(
                          context,
                          data.paymentamount.toString(),
                          displayWidth(context) * 0.4),
                    ]))
                        .toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget salesOrderDetailWidget(String label, String? value) {
    return CustomTextFormField(
      decoration: InputDecoration(
          fillColor: greyColor,
          filled: true,
          isDense: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(5),
          )),
      label: label,
      readOnly: true,
      initialValue: value,
      labelStyle: TextStyle(color: blackColor),
      style: TextStyle(fontSize: 14, color: blackColor),
    );
  }
}
