import 'package:ebuzz/home/ui/home.dart';
import 'package:ebuzz/login/ui/login.dart';
import 'package:ebuzz/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';

class App extends StatelessWidget {
  final bool? login;
  const App({this.login});
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: GetMaterialApp(
        title: Constants.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "Asul",
          // textTheme: GoogleFonts.interTextTheme(
          //   Theme.of(context).textTheme.apply(),
          // ),
          // disabledColor: Colors.black,
          // primaryColor: Colors.white, colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
        ),
        home: login == true ? Home() : Login(),
      ),
    );
  }
}