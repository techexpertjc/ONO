import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ono/pages/order_track.dart';
import 'package:ono/utils/drawer.dart';
import 'package:ono/utils/my_navigators.dart';


class AllOrders extends StatefulWidget{
  AllOrdersState createState()=>  AllOrdersState();
}


class AllOrdersState extends State<AllOrders> {
  FirebaseDatabase db=FirebaseDatabase.instance;
  Map<dynamic,dynamic> uOrders=Map();
  FirebaseUser currUser;
  bool loaded=false;

  @override
  void initState() {
      // TODO: implement initState
      super.initState();
      loadOrders();
    }

  void loadOrders() async {
    currUser=await FirebaseAuth.instance.currentUser();
    db.reference().child("order").orderByChild("uid").equalTo(currUser.uid).once().then((DataSnapshot snapshot){
      uOrders=snapshot.value;
      //debugPrint(uOrders.toString());
      setState(() {
              loaded=true;
            });
    });
  }

  @override
  Widget build(BuildContext context){
    return WillPopScope(child:Scaffold(
      
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Your Orders"),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: ()=>MyNavigator.goToCart(context),
          )
        ],
      ),
      body:loaded?_ordersBody():Center(child: CircularProgressIndicator()),
      drawer: MyDrawer(),
    ),
    onWillPop: (){
      MyNavigator.goToHome(context);
    },
    );
  }


  Widget _ordersBody(){
    if(uOrders!=null){
    return ListView(
      children: _orderList(),
    );}
    else{
      return Center(
        child: Text("Oops no Orders found... :("),
      );
    }
  }

  List<Widget> _orderList(){
    List<Widget> tempOrderList=List();
    uOrders.forEach((k,v){
      Map<dynamic,dynamic> orderItems=Map();
      orderItems=v['items'];
      //debugPrint(orderItems.toString());
      tempOrderList.add(
        ListTile(
          
          title: Text("Date : "+DateTime.parse(v['orderedOn']).day.toString()+"/"+DateTime.parse(v['orderedOn']).month.toString()+"/"+DateTime.parse(v['orderedOn']).year.toString()+" Time : "+DateTime.parse(v['orderedOn']).hour.toString()+":"+DateTime.parse(v['orderedOn']).minute.toString()+" ",style: TextStyle(fontSize: 22.0,fontWeight: FontWeight.bold,color: Colors.blue ),),
          subtitle: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Total: "+v['total'].toString(),style: TextStyle(color: Colors.black,fontSize: 18.0),),
                Text("Items: "+orderItems.length.toString(),style: TextStyle(color: Colors.black,fontSize: 18.0),)
              ],
            ),
          ),
          onTap: (){
            Navigator.push(context,
              MaterialPageRoute(
                builder: (context)=>TrackOrder(orId: k)
              )
            );
          },
        )
      );
      tempOrderList.add(Divider());
    });
    return tempOrderList;
  }
}