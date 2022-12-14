import 'dart:convert';
import 'dart:io';
import 'package:ebuzz/common/colors.dart';
import 'package:ebuzz/common/custom_toast.dart';
import 'package:ebuzz/common/navigations.dart';
import 'package:ebuzz/common_service/common_service.dart';
import 'package:ebuzz/home/ui/home.dart';
import 'package:ebuzz/util/preference.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ebuzz/util/apiurls.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

//LoginApiService class contains function login
class LoginApiService {

  //For doing login based on the username and password
  Future login(
      {required String username,
        required String password,
        required BuildContext context,
        required String baseUrl}) async {
    try {
      List<String>? baseurllist = await getBaseUrlList();
      // HomeService _homeService=HomeService();
      baseUrl = "https://erptest.bharathrajesh.co.in";
      // username = "prithvichowhan97@gmail.com";
      // username = "dummy@gmail.com";
      // password = "vishalpatel2022";
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("owner", username);
      final String url = loginUrl(baseUrl);
      var uri=Uri.parse(url);
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': "*",
          'Access-Control-Allow-Credentials': "true",
          'Access-Control-Allow-Headers': "*",
        },
        body: jsonEncode(<String, String>{
          'usr': username,
          'pwd': password,
          'device': "mobile",
        }),
      );
      if (response.statusCode == 200) {
        if (baseurllist != null) {
          if (!baseurllist.contains(baseUrl)) {
            baseurllist.add(baseUrl);
            setBaseUrlList(baseurllist);
          }
        }
        if (baseurllist == null) {
          List<String> list = [];
          list.add(baseUrl);
          setBaseUrlList(list);
        }
        var data = jsonDecode(response.body);
        String fullname = data['full_name'];
        setApiUrl(baseUrl);
        setUserName(username);
        setLoggedIn(true);
        setName(fullname);
        if (kIsWeb) {
          // running on the web!
        } else {
          var cookie = response.headers["set-cookie"];
          String cookieSid = cookie!.split(';').first.toString();
          setCookie(cookieSid);
        }
        // var cookie = response.headers["set-cookie"];
        // String cookieSid = cookie!.split(';').first.toString();
        // setCookie(cookieSid);
        await CommonService().setGlobalDefaults(context);
        print("home page");
        pushReplacementScreen(context, Home());
      }
      if (response.statusCode == 400) {
        fluttertoast(whiteColor, redColor, 'Incorrect username or password');
      }
      if (response.statusCode == 401) {
        fluttertoast(whiteColor, redColor, 'Incorrect username or password');
      }
    } catch (e) {
      if (e is SocketException) {
        fluttertoast(whiteColor, blueAccent, 'No Internet Connection');
      } else {
        fluttertoast(whiteColor, blueAccent, e.toString());
      }
    }
  }
}
