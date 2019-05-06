import 'package:flutter/material.dart';


class MyTabs extends StatefulWidget {
  @override
  _MyTabsState createState() => _MyTabsState();
}

class _MyTabsState extends State<MyTabs> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 40.0,
      color: Colors.black,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          SizedBox(
            width: 100.0,
            child: InkWell(
              child: Text("Popular",style: TextStyle(fontSize: 20.0,color: Colors.lightBlue[50]),textAlign: TextAlign.center,),
              splashColor: Colors.lightBlue[50],
              onTap: ()=>debugPrint("Tapped"),
            ),
          ),
          Divider(),
          SizedBox(
            width: 100.0,
            child: InkWell(
              child: Text("Combo",style: TextStyle(fontSize: 20.0,color:Colors.lightBlue[50]),textAlign: TextAlign.center,),
              splashColor: Colors.lightBlue[50],
              onTap: ()=>debugPrint("Tapped"),
            ),
          ),
          Divider(),
          SizedBox(
            width: 100.0,
            child: InkWell(
              child: Text("Bhakhri",style: TextStyle(fontSize: 20.0,color:Colors.lightBlue[50]),textAlign: TextAlign.center,),
              splashColor: Colors.lightBlue[50],
              onTap: ()=>debugPrint("Tapped"),
            ),
          ),
          Divider(),
          SizedBox(
            width: 100.0,
            child: InkWell(
              child: Text("Khakhra",style: TextStyle(fontSize: 20.0,color:Colors.lightBlue[50]),textAlign: TextAlign.center,),
              splashColor: Colors.lightBlue[50],
              onTap: ()=>debugPrint("Tapped"),
            ),
          ),
          Divider(),
          SizedBox(
            width: 100.0,
            child: InkWell(
              child: Text("Farsan",style: TextStyle(fontSize: 20.0,color:Colors.lightBlue[50]),textAlign: TextAlign.center,),
              splashColor: Colors.lightBlue[50],
              onTap: ()=>debugPrint("Tapped"),
            ),
          ),
         
          
        ],
      ),
    );
  }
}