import 'package:flutter/material.dart';
import 'package:ono/models/cartItem2.dart';
import 'package:ono/pages/order_track.dart';
//import 'package:ono/pages/order_track.dart';
import 'package:ono/utils/db_helper.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

//int total;
String receipt;
class MyCheckoutDetails extends StatelessWidget {
  final int total;
  MyCheckoutDetails({Key key, @required this.total}):super(key:key);
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          //automaticallyImplyLeading: false,
          title: Text("Checkout"),
          
        ),
        body: CheckOutBody(total2: total),
        //drawer: MyDrawer(),
      ),
    );
  }

  

}



class CheckOutBody extends StatefulWidget{
  final int total2;
  CheckOutBody({Key key,@required this.total2}):super(key:key);

  CheckOutBodyState createState()=>  CheckOutBodyState();
}


class CheckOutBodyState extends State<CheckOutBody> {
  bool defAdd=false;
  SharedPreferences _pref;
  String add;
  TextEditingController addController,promoController;
  DbHelper localDb;
  FirebaseDatabase db;
  List _items;
  Map<dynamic,dynamic> _itemMap=new Map();
  FirebaseUser _crrUser;
  //Map<dynamic,dynamic> _order=new Map();
  int total;
  
  @override
  void initState() {
      // TODO: implement initState
      super.initState();
       addController=TextEditingController();
       promoController=TextEditingController();
      _initdbs();
      total=widget.total2;
      debugPrint(total.toString());   
    }


    void _initdbs() async{
      _pref=await SharedPreferences.getInstance();
      add=_pref.getString("Address");
      localDb=new DbHelper();
      db=FirebaseDatabase.instance;
      _crrUser=await FirebaseAuth.instance.currentUser();
      debugPrint("db initialized");
      //total=0;
      _items = await localDb.getItems();
      receipt="Total:                 $total";
    }
  
  @override
  Widget build(BuildContext context){
    return ListView(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(20.0),
          child: Row(children: <Widget>[
            Checkbox(
            value: defAdd,
            activeColor: Colors.black,
            onChanged: (bool value){_onChanged(value);},
          ),
          Text("Use default address?"),
          ],)
        ),
        Container(
          child: TextField(
            controller: addController,
            enabled: defAdd?false:true,
            maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Address',
                  icon: Icon(Icons.home,color: Colors.black,)
                ),
          ),
        ),
        Padding(padding: EdgeInsets.only(bottom: 20.0),),
        Container(
          child: TextField(
            controller: promoController,
            keyboardType: TextInputType.text,
            //onSubmitted: (String promo){_applyPromo(promo);},
            maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Have a promocode? Apply here',
                  icon: Icon(Icons.local_offer,color: Colors.black,)
                ),
          ),
        ),
        Padding(padding: EdgeInsets.only(bottom: 20.0),),
        Container(
          child: Center(child:RaisedButton(
            color: Colors.blue,
            highlightColor: Colors.black,
            child: Text("Apply Promo",style: TextStyle(color: Colors.white),),

            onPressed: ()=>_applyPromo(),
          ),
        )),
        Padding(padding: EdgeInsets.only(bottom: 20.0),),
        Container(
          child: Center(child:RaisedButton(
            color: Colors.blue,
            highlightColor: Colors.black,
            child: Text("CheckOut",style: TextStyle(color: Colors.white,fontSize: 20.0),),
            onPressed: ()=>_placeOrder(),
          ),
        ))
      ],
    );
  }

  int dis=0;
  void _applyPromo(){
    debugPrint(promoController.text);
    Map<dynamic,dynamic> offerRet;
    db.reference().child("offer").orderByChild("promo").equalTo(promoController.text).once().then((DataSnapshot snapshot){
      //debugPrint("${snapshot.value}");
      offerRet=snapshot.value;
      debugPrint(offerRet.toString());
      if(offerRet==null){
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Invalid Promo"),duration: Duration(seconds: 2),));
      }else if(offerRet.length==1){
        offerRet.forEach((k,v){
          //debugPrint(v['type']);

           bool isValid=DateTime.now().isBefore(DateTime.parse(v['expire']));
           debugPrint(isValid.toString());
          if(isValid){
            if(int.parse(v['minimum'])<=total){
          switch(v['type']){
            case 'Discount':
              dis=((int.parse(v['offerBenifit'].toString())*total)/100).round();
              
              debugPrint(total.toString());
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content:Text("The promo has been applied"),
                  duration:Duration(seconds:2)
                )
              );

            break;

            case 'Free_Item':
            String iname=v['offerBenifit'].toString().trim();
            debugPrint(iname);
            db.reference().child("item/$iname").once().then((DataSnapshot snapshot){
              Map<dynamic,dynamic> freeItem=snapshot.value;
              _itemMap.clear();
              _itemMap.addAll({freeItem['name']:{'quantity':1}});
              debugPrint(_itemMap.toString());
            });
            Scaffold.of(context).showSnackBar(
                SnackBar(
                  content:Text("The promo has been applied"),
                  duration:Duration(seconds:2)
                )
              );
            break;
          }}else{
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text("Minimum order of ${v['minimum']} is required for this promo"),
                duration: Duration(seconds: 2),
              )
            );
          }
          }
          else{
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text("The coupon has expired"),
                duration: Duration(seconds: 2),
              )
            );
          }
        });
      }
    });
  }


  void _onChanged(bool value){

    setState(() {
          defAdd?defAdd=false:defAdd=true;
          defAdd?addController.text=add:addController.clear();
        });
    
  }

  void _placeOrder() async {
    if(addController.text!=""){
    for(int i=0;i<_items.length;i++){
      Item temp=Item.map(_items[i]);
      _itemMap.addAll({temp.itemname:{"quantity":temp.qty}});
    }

    String _uid = _crrUser.uid;
    db.reference().child("users/$_uid/wallet").once().then((DataSnapshot snap){
      int wllt=snap.value;
      if(total>=wllt){
        total=total-wllt;
        wllt=0;
      }else if(total<wllt){
        wllt=wllt-total;
        total=0;
      }
      db.reference().child("users/$_uid/wallet").set(wllt);
      String orId=DateTime.now().toIso8601String();
    orId=orId.replaceAll(":", "_");
    orId=orId.replaceAll(".", "_");
    orId=orId.replaceAll("-", "_");
    debugPrint(orId);
    db.reference().child("order/$orId").set({
      "uid":_uid,
      "total":(total-dis),
      "Address": addController.text,
      "items":_itemMap,
      "status":1,
      "track":0,
      "orderedOn":DateTime.now().toString(),
      "orderDate": DateTime.now().day.toString()+"/"+DateTime.now().month.toString()+"/"+DateTime.now().year.toString()
    });
    _pref.setString("lastord", orId);
    localDb.deleteAll();
    Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Order Placed"),
          duration: Duration(seconds: 3),
        )
      );
    Navigator.push(context,
              MaterialPageRoute(
                builder: (context)=>TrackOrder(orId: orId)
              )
            );
    });
    

    
    }
    else{
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter Address"),
          duration: Duration(seconds: 3),
        )
      );
    }
    
  }
}