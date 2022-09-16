
import 'package:dio/dio.dart';
import 'package:ebuzz/common_models/product.dart';

import 'package:ebuzz/exception/custom_exception.dart';
import 'package:ebuzz/network/base_dio.dart';
import 'package:ebuzz/util/apiurls.dart';
import 'package:flutter/cupertino.dart';

//ItemApiService class contains function for fetching data or posting  data
class ItemApiService {
  static bool isItemLoading = false;

  Future<Product> getData(String text,BuildContext context) async {
    print("text is====>>>$text");
    try {
      Dio _dio = await BaseDio().getBaseDio();
      final String url = itemDataUrl(text);
      final response = await _dio.get(
        url,
      );
      print("statusCode====>>>${response.statusCode}");
      if (response.statusCode == 200) {
        print("${response.data}");
        return Product(itemCode: response.data['data']['item_code'],itemName: response.data['data']['item_name'],hsn: response.data['data']['gst_hsn_code'],brand: response.data['data']['brand'],shellLife: response.data['data']['shelf_life_in_days'],pch_division: response.data['data']['pch_division']);
        // return Product.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      exception(e,context);
    }
    return Product();
  }

  Future<Product> getItemData({itemcode,company,required BuildContext context}) async {
    isItemLoading = true;
    try {
      Dio _dio = await BaseDio().getBaseDio();
      final String url = ItemDataUrl(itemcode: itemcode,company: company);
      final response = await _dio.get(
        url,
      );
      print("statusCode====>>>${response.statusCode}");
      if (response.statusCode == 200) {
        print("${response.data}");
        isItemLoading = false;
        return Product(quantity_available: response.data['message']['available_qty'],sales_quantity: response.data['message']['sales_qty']);
        // return Product.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      exception(e,context);
      isItemLoading = false;
    }
    return Product();
  }
}
