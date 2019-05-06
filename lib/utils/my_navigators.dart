import 'package:flutter/material.dart';

class MyNavigator {
  static void goToHome(BuildContext context) {
    Navigator.pushNamed(context, "/home");
  
  }
   static void goToCart(BuildContext context) {
    Navigator.pushNamed(context, "/cart");
  
  }
    static void goToLogin(BuildContext context) {
    Navigator.pushNamed(context, "/login");
  
  }
  static void goToDetail(BuildContext context) {
    Navigator.pushNamed(context, "/userDetail");
  
  }

  static void goToOffers(BuildContext context){
    Navigator.pushNamed(context, "/offersList");
  }

  static void goToOrders(BuildContext context){
    Navigator.pushNamed(context, "/orders");
  }
  // static void gotoCheckOutDetails(BuildContext context){
  //   Navigator.pushNamed(context, "/checkoutDetails");
  // }

  static void getFeedback(BuildContext context){
    Navigator.pushNamed(context, "/feedback");
  }

}
