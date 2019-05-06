//import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ono/utils/my_navigators.dart';


class TrackOrder extends StatefulWidget {
  final String orId;
  TrackOrder({Key key,this.orId}):super(key:key);
  
  @override
  _TrackOrderState createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
  FirebaseDatabase db=FirebaseDatabase.instance;
  int orStatus=1;
  SharedPreferences sp;
  //StreamSubscription<Event> _trackSubs;
  Map<dynamic,dynamic> orderDetail=Map();
  List<Step> stepList=[
    Step(
      title: Text("Order Placed"),
      content:Text("Please be patience your order is placed, soon it will be accepted"),
      isActive: true
    ),
    Step(
      title: Text("Order Confirmed"),
      content: Text("Order has been accepted"),
      isActive: true
    ),
    Step(
      title: Text("Order being prepared"),
      content: Text("Our chefs are doing their best to make your food delicious and make you feel like home"),
      isActive: true
    ),
    Step(
      title: Text("Out for delivery"),
      content: Text("Yaay the order has been prepared and is out for delivery"),
      isActive: true
    ),
    Step(
      title: Text("Delivered"),
      content: Text("Seems like you got your food, hope you like it, thanks for ordering at ONO, we'll see you again ;)"),
      isActive: true
    )
  ];
  bool dataLoad=false;
  @override
  void initState() {
      // TODO: implement initState
      super.initState();
      _initSp();
      _init();
      
      //_refresh();
    }

    void _initSp() async {
      sp=await SharedPreferences.getInstance();
    }

    void _init(){
      db.reference().child("order/${widget.orId}").once().then((DataSnapshot snapshot){
        
        orStatus=snapshot.value['track'];
        orderDetail=snapshot.value;
        //debugPrint(orderDetail.toString());
        setState(() {
                  dataLoad=true;
                });

      });
      db.reference().child("order/${widget.orId}/track").keepSynced(true);
      db.reference().child("order/${widget.orId}/track").onValue.listen((Event event){
       
        setState(() {
                  orStatus=event.snapshot.value;
                  String lastord=sp.getString("lastord");
                  if(orStatus==4 && lastord==widget.orId){
                    MyNavigator.getFeedback(context);
                  }
                });
                
      });

    }
    

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child:Scaffold(
      appBar: AppBar(
        title: Text("Order Details"),
        backgroundColor: Colors.blue,
      ),
      body: dataLoad?ListView(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top:10.0,bottom: 10.0)),
          Card(
            
            color: Colors.white,
            elevation: 3.0,
            child: Column(
              children: _itemRows(),
            ),
          ),
          ListView(
            shrinkWrap: true,
            children:<Widget>[Stepper(
          steps: stepList,
          currentStep: orStatus,
          
          
        )
        ]
        ),
        ],
      ):Center(child: CircularProgressIndicator(),),
    ),
    onWillPop: (){
      MyNavigator.goToOrders(context);
    },
    );
  }


  List<Widget> _itemRows(){
    List<Widget> temp=List();
    
      
      Map<dynamic,dynamic> tempItems=orderDetail['items'];
      //debugPrint(.toString());
      tempItems.forEach((k1,v1){
        
        temp.add(
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(padding: EdgeInsets.all(5.0),),
              Text(k1.toString()+" : ",textAlign: TextAlign.start ,style: TextStyle(color: Colors.black,fontSize: 20.0),),
              Text(v1['quantity'].toString(),textAlign: TextAlign.end,style: TextStyle(color: Colors.black,fontSize: 20.0),),
              Padding(padding: EdgeInsets.all(5.0),)
            ],
          )
        );

      
      
    });

    temp.add(
        Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(padding: EdgeInsets.all(5.0),),
              Text("Total "+" : ",textAlign: TextAlign.start ,style: TextStyle(color: Colors.blue,fontSize: 20.0,fontWeight: FontWeight.bold),),
              Text(orderDetail['total'].toString(),textAlign: TextAlign.end,style: TextStyle(color: Colors.blue,fontSize: 20.0,fontWeight: FontWeight.bold),),
              Padding(padding: EdgeInsets.all(5.0),)
            ],
          )
      );


    return temp;
  }

}