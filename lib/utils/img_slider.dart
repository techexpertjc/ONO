import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

List<NetworkImage> imgList=List();
FirebaseDatabase db=FirebaseDatabase.instance;
class MySlider extends StatelessWidget {

  MySlider(){
    db.reference().child("imageSlider").once().then((DataSnapshot snapshot){
      Map<dynamic,dynamic> temp=snapshot.value;
      temp.forEach((k,v){
        debugPrint(v['url']);
        imgList.add(
          NetworkImage(v['url'])
        );
      });
      //debugPrint(temp.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Carousel(
      boxFit: BoxFit.fill,
      images: imgList,
      dotSize: 0.0,
      showIndicator: false,
      overlayShadow:true,
      //overlayShadowColors: Colors.black,
      // overlayShadowSize:20.0
    );
  }
}