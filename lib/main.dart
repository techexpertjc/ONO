import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:ono/pages/all_orders.dart';
import 'package:ono/pages/offers_list.dart';
import 'pages/splashscreen.dart';
import 'pages/menu2.dart';
import 'pages/cart.dart';
import 'pages/Login.dart';
import 'pages/details.dart';
import 'pages/orderfeedback.dart';
//import 'pages/checkout_details.dart';

var routes = <String, WidgetBuilder>{
  "/login": (BuildContext context) => Login(),
  "/home": (BuildContext context) => MyNewMenu(),
  "/cart": (BuildContext context) => MyCart(),
  "/userDetail":(BuildContext context) =>UserDetail(),
  //"/checkoutDetails":(BuildContext context) => MyCheckoutDetails()
  "/offersList":(BuildContext context)=>Offers(),
  "/orders":(BuildContext context)=>AllOrders(),
  "/feedback":(BuildContext context)=>OrderReview()
};


void main(){ runApp(MaterialApp(
    theme:
    ThemeData(primaryColor: Colors.blue, accentColor: Colors.lightBlueAccent,fontFamily: "Calibri",backgroundColor: Colors.white,buttonColor: Colors.lightBlue),
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
    routes: routes,
    
)



);

SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp
]);
}


