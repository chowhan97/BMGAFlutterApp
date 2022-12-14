import 'package:ebuzz/common/colors.dart';
import 'package:ebuzz/common/custom_appbar.dart';
import 'package:ebuzz/common/navigations.dart';
import 'package:ebuzz/salesorder/model/sales_order.dart';
import 'package:ebuzz/salesorder/service/sales_order_service.dart';
import 'package:ebuzz/salesorder/ui/sales_order_detail_ui.dart';
import 'package:ebuzz/salesorder/ui/sales_order_form1.dart';
import 'package:flutter/material.dart';

class SalesOrderListUi extends StatefulWidget {
  @override
  _SalesOrderListUiState createState() => _SalesOrderListUiState();
}

class _SalesOrderListUiState extends State<SalesOrderListUi> {
  List<SalesOrder> _salesOrderList = [];
  @override
  void initState() {
    super.initState();
    getSalesOrderList();
  }

  getSalesOrderList() async {
    _salesOrderList = await SalesOrderService().getSalesOrderList(context);
    print("_salesOrderList is=====>>$_salesOrderList");
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
                Text('Sales Order List', style: TextStyle(color: whiteColor)),
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
          itemCount: _salesOrderList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                pushScreen(
                  context,
                  SalesOrderDetail(
                    salesOrder: _salesOrderList[index],
                  ),
                );
              },
              child: SOTileUi(
                soData: _salesOrderList[index],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blueAccent,
        onPressed: () {
          pushScreen(context, SalesOrderForm1());
        },
        child: Icon(
          Icons.add,
          color: whiteColor,
        ),
      ),
    );
  }
}

//SOTileUi class is a reusable widget which contains ui of list of sales order
class SOTileUi extends StatelessWidget {
  final SalesOrder soData;
  const SOTileUi({required this.soData});
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
                    'Modified Date : ' + soData.modified!,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Grand Total : \???' + soData.grandtotal.toString(),
                  ),
                  SizedBox(height: 5),
                  // Row(
                  //   children: [
                  //     Text(
                  //       'Percent Billed : ' +
                  //           soData.perbilled!.toStringAsPrecision(2) +
                  //           '%  ',
                  //     ),
                  //     Text(
                  //       'Percent Delivered : ' +
                  //           soData.perdelivered!.toStringAsPrecision(2) +
                  //           '%',
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(height: 5),
                  Text(
                    'Status : ' + soData.status!,
                  ),
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
