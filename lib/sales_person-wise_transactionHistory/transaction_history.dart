import 'package:ebuzz/common/colors.dart';
import 'package:ebuzz/common/custom_appbar.dart';
import 'package:ebuzz/common/custom_toast.dart';
import 'package:ebuzz/common/navigations.dart';
import 'package:ebuzz/common_service/common_service.dart';
import 'package:ebuzz/sales_person-wise_transactionHistory/transaction_list.dart';
import 'package:ebuzz/util/constants.dart';
import 'package:ebuzz/widgets/custom_typeahead_formfield.dart';
import 'package:ebuzz/widgets/typeahead_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({Key? key}) : super(key: key);

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  TextEditingController fromdate = TextEditingController();
  TextEditingController todate = TextEditingController();
  TextEditingController company = TextEditingController();
  var from_date;
  var to_date;
  List<String> companyList = [];

  getCustomerAndCompanyList() async {
    companyList = await CommonService().getCompanyList(context);
    print(companyList.length);
    setState(() {});
  }

  @override
  void initState() {
    getCustomerAndCompanyList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: CustomAppBar(
          title:
              Text('Transaction Summary', style: TextStyle(color: textcolor)),
          leading: IconButton(
            onPressed: () => Navigator.pop(context, false),
            icon: Icon(
              Icons.arrow_back,
              color: textcolor,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTypeAheadFormField(
                    controller: company,
                    decoration: InputDecoration(
                      fillColor: greyColor,
                      filled: true,
                      isDense: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      hintText: 'Select Company',
                    ),
                    label: 'Company',
                    labelStyle:
                    TextStyle(color: blackColor, fontWeight: FontWeight.bold),
                    style: TextStyle(fontSize: 14, color: blackColor),
                    itemBuilder: (context, item) {
                      return TypeAheadWidgets.itemUi(item);
                    },
                    onSuggestionSelected: (suggestion) async {
                      print("suggestion selected");
                      setState(() {
                        company.text = suggestion;
                      });
                    },
                    suggestionsCallback: (pattern) {
                      print("suggestion list call");
                      return TypeAheadWidgets.getSuggestions(
                          pattern, companyList);
                    },
                    transitionBuilder: (context, suggestionsBox, controller) {
                      return suggestionsBox;
                    },
                    validator: (val) => val == '' || val == null
                        ? 'Company name should not be empty'
                        : null,
                  ),
                  SizedBox(height: 10),
                  Text("From Date",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  dateWidget(
                      hintText: "Select From Date",
                      controller: fromdate,
                      ontap: () {
                        opencalender(isFrom: true);
                      }),
                  SizedBox(height: 10),
                  Text("To Date", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  dateWidget(
                      hintText: "Select To Date",
                      controller: todate,
                      ontap: () {
                        opencalender(isTo: true);
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: MaterialButton(
            onPressed: () {
              if (fromdate.text.isEmpty ||
                  todate.text.isEmpty ||
                  company.text.isEmpty) {
                fluttertoast(
                    whiteColor,
                    greyLightColor,
                    fromdate.text.isEmpty
                        ? "Please choose from date"
                        : todate.text.isEmpty
                            ? "Please choose to date"
                            : "Please choose company");
              } else {
                pushScreen(context, TransactionList(fromdate: from_date, todate: to_date));
              }
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            color: Constants.buttonColor,
            height: 50,
            minWidth: double.infinity,
            child: Text("Fetch History",
                style: TextStyle(fontSize: 18, color: whiteColor))),
      ),
    );
  }

  Widget dateWidget({hintText, controller, ontap}) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: ontap,
      decoration: InputDecoration(
          labelStyle: TextStyle(color: blackColor),
          fillColor: greyColor,
          filled: true,
          isDense: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(5),
          ),
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 14),
          suffixIcon: Icon(Icons.calendar_today_outlined)),
    );
  }

  opencalender({isFrom, isTo}) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: textcolor, // <-- SEE HERE
                onPrimary: Colors.white, // <-- SEE HERE
                onSurface: textcolor, // <-- SEE HERE
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: textcolor, // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime.now());

      if (pickedDate != null) {
      print(pickedDate);
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      String formattedDateNew = DateFormat('yyyy-MM-dd').format(pickedDate);
      print(formattedDate);
      print("picked===>>${pickedDate.year}");
      print("picked===>>${pickedDate.month}");
      print("picked===>>${pickedDate.day}");
      setState(() {
        if (isFrom == true) {
           from_date = formattedDateNew;
           fromdate.text = formattedDate;
          // fromdate.text = "${pickedDate.day.isOdd ? "0${pickedDate.day}" : pickedDate.day}-${pickedDate.month.isOdd ? "0${pickedDate.month}" : pickedDate.month}-${pickedDate.year}";
        } else if (isTo == true) {
          // todate.text = "${pickedDate.day.isOdd ? "0${pickedDate.day}" : pickedDate.day}-${pickedDate.month.isOdd ? "0${pickedDate.month}" : pickedDate.month}-${pickedDate.year}";
           todate.text = formattedDate;
           to_date = formattedDateNew;
        } else {}
      });
    } else {}
  }
}
