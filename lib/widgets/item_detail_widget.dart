import 'package:ebuzz/common/colors.dart';
import 'package:ebuzz/common/ui_reusable_widget.dart';
import 'package:ebuzz/common_models/product.dart';
import 'package:ebuzz/widgets/custom_textformformfield.dart';
import 'package:flutter/material.dart';


class ItemDetailWidget extends StatelessWidget {
  final AsyncSnapshot<Product> snapshot;
  const ItemDetailWidget({required this.snapshot});
  @override
  Widget build(BuildContext context) {
    print("snapshot is====>>>>${snapshot.data!.pch_division}");
    return Column(
      children: [
        Stack(
          children: [
            snapshot.hasData ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 16),
                child: Column(
                  children: [
                    // itemDetailWidget('Item Code', snapshot.data?.itemCode),
                    // SizedBox(height: 15),
                    itemDetailWidget('Item Name', snapshot.data?.itemName),
                    SizedBox(height: 15),
                    itemDetailWidget('HSN/SAC', snapshot.data?.hsn),
                    SizedBox(height: 15),
                    itemDetailWidget('Brand', snapshot.data?.brand),
                    SizedBox(height: 15),
                    itemDetailWidget('Division', snapshot.data?.pch_division),
                  ],
                ),
              ),
            ) : CircularProgressIndicator(),
          ],
        ),

      ],
    );
  }
  Widget itemDetailWidget(String label, String? value) {
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
