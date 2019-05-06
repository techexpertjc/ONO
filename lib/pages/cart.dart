//import 'dart:async';
//import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ono/models/cartItem2.dart';
import 'package:ono/utils/db_helper.dart';
//import 'package:ono/utils/my_navigators.dart';
import 'package:ono/pages/checkout_details.dart';
import 'package:ono/utils/drawer.dart';
List _items;
int total=0;
DbHelper localDb;
class MyCart extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("MyCart"),
        ),
        body: CartBody(),
        bottomNavigationBar: CartBottomAppBar(),
        drawer: MyDrawer(),
      ),

      
    );
  }

  

}


class CartBody extends StatefulWidget{
  CartBodyState createState()=>  CartBodyState();
}


class CartBodyState extends State<CartBody> {
  bool _itemload=false;
  
  @override
  void initState() {
      // TODO: implement initState
      super.initState();
      //total=0;
      localDb=new DbHelper();  
      _initCart();      
  }


  

  void _initCart() async {
    total=0;
    _items = await localDb.getItems();
    setState(() {
          _itemload=true;
        });
  }
  
 


  @override
  Widget build(BuildContext context){
    return _itemload?(_items.length>=1)?ListView(
      children: cartItems(),
    ):Center(child: Text("Oops cart is Empty"),)
    :Center(
      child: CircularProgressIndicator(),
    );
  }

  List<Widget> cartItems() {
    total=0;
    List<Widget> cartItemTiles = new List();
    for(int i=0;i<_items.length;i++){
      Item item=Item.map(_items[i]);
      cartItemTiles.add(
        ListTile(
          isThreeLine: true,
          title: Text(item.itemname,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22.0),),
          subtitle: Column(
            children: <Widget>[
              Container(
            //width: 153.0,
            child:Row(
            //mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                iconSize: 20.0,
                icon: Icon(Icons.remove_circle,color: Colors.blue,),
                onPressed: ()=>_qtyDec(item),
              ),
              Text(item.qty.toString(),style: TextStyle(fontSize: 16.0,color: Colors.black),),
              IconButton(
                iconSize: 20.0,
                icon: Icon(Icons.add_circle,color: Colors.blue,),
                onPressed: ()=>_qtyInc(item),
              ),
              
          
            ],
          )),
           Row(
             children: <Widget>[
               Text("Price: "+(item.qty*item.price).toString(),style: TextStyle(fontSize: 18.0,color: Colors.black),),
             ],
           )

            ],
          ),
          
          leading: Container(
          child: Image(
            height: 80.0,
            width: 80.0,
            fit: BoxFit.fill,
            image: NetworkImage(
                item.url),
          ),
          decoration: BoxDecoration(
              border: Border.all(
            color: Colors.blue,
          ))),
          trailing:CircleAvatar(
            //alignment: Alignment.centerRight,
            //width: 159.0,
            backgroundColor: Colors.blue,
            child:
             
              IconButton(
                iconSize: 20.0,
              icon: Icon(Icons.delete,color: Colors.white,),
              onPressed: ()=> _delete(item.id),
        )
            
          ),
          )
      );
      cartItemTiles.add(
        Divider(),
      );
      total=total+(item.price * item.qty);
      
    } 
    cartItemTiles.add(
      ListTile(
        title: Text("Total : $total",style: TextStyle(fontSize: 25.0),textAlign: TextAlign.right,),
      )
    );
    return cartItemTiles;
  }

  void _qtyDec(Item item) async{
    if(item.qty>1){
    Item temp = Item.fromMap({
      "id":item.id,
      "itemname":item.itemname,
      "price":item.price,
      "qty":(item.qty-1),
      "url":item.url
    });
    var res=await localDb.updateItem(temp);
    //total=total-temp.price;
    debugPrint(res.toString());
    }
    else{
      debugPrint("cant decrease qty less then 1");
    }

    _initCart();

  }

  void _qtyInc(Item item) async{
    Item temp = Item.fromMap({
      "id":item.id,
      "itemname":item.itemname,
      "price":item.price,
      "qty":(item.qty+1),
      "url":item.url
    });
    var res=await localDb.updateItem(temp);
    //total=total+temp.price;
    debugPrint(res.toString());
    _initCart();
  }

  void _delete(int id) async{ 
    localDb.deleteItem(id);
    _initCart();
  }

}



class CartBottomAppBar extends StatefulWidget{
  CartBottomAppBarState createState()=>  CartBottomAppBarState();
}


class CartBottomAppBarState extends State<CartBottomAppBar> {
  @override
  Widget build(BuildContext context){
    return Container(
      height: 50.0,
      decoration: BoxDecoration(border: Border.all(color: Colors.black),color: Colors.blue), 
        
        
          //Padding(padding: EdgeInsets.all(10.0),),
          
          //Padding(padding: EdgeInsets.all(10.0),),
          child:InkWell(
            child: Container(
              padding: EdgeInsets.only(top: 7.0,bottom: 5.0),
              child:Text("Checkout",style: TextStyle(fontSize: 20.0,color: Colors.white),textAlign: TextAlign.center,),
            
            
          ),
          onTap:(){
            if(_items.length>=1){
            int tempt=total;
            total=0;
            Navigator.push(context,
              MaterialPageRoute(
                builder: (context)=>MyCheckoutDetails(total: tempt,)
              )
            );}else{
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text("Cart Empty, Add something in cart to checkout"),
                  duration: Duration(seconds: 2),
                )
              );
            }
            
          },
          )
        
      
    );
  }

  
}