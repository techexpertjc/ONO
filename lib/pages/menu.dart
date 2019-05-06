import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ono/utils/db_helper.dart';
import 'package:ono/utils/drawer.dart';
import 'package:ono/utils/my_navigators.dart';
import 'package:ono/utils/img_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ono/models/cartItem2.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Menu extends StatefulWidget {
  @override
  MenuState createState() => MenuState();
}
FirebaseUser currUser;

DbHelper localDb;
SharedPreferences sp;
class MenuState extends State<Menu> {
  var key=GlobalKey<ScaffoldState>();
  ScrollController _scrollController;
  Map<dynamic,dynamic> catlist;
  Map<dynamic,dynamic> menulistMap;
  List<Widget> menuList=List();
  FirebaseDatabase db =FirebaseDatabase.instance;
  bool checkcat = false;
  bool checkMenu = false;
  
  @override
  void initState() {
      // TODO: implement initState
      super.initState();
      
      _getCat();
      _initMenuList();
      _initDb();
      _scrollController=ScrollController();
    }

    void _initDb() async {
      localDb=new DbHelper();
      //sp=await SharedPreferences.getInstance();
    }

    void _initMenuList(){
      setState(() {
              checkMenu=false;
            });
      menuList.clear();
      db.reference().child("item").once().then((DataSnapshot snapshot){
        menulistMap=snapshot.value;
        debugPrint(menulistMap.toString());
        menulistMap.forEach((k,v){
          menuList.add(
            ListTile(
              title: Text(v['name'],style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
              leading: Container(
          child: Image(
            height: 80.0,
            width: 80.0,
            fit: BoxFit.fill,
            image: NetworkImage(
                v['url']),
          ),
          decoration: BoxDecoration(
              border: Border.all(
            color: Colors.blue,
          ))),
          subtitle: Text("Price : ₹"+v["price"],style: TextStyle(fontSize: 16.0,color: Colors.blue,fontWeight: FontWeight.bold),),
          trailing: CircleAvatar(
            backgroundColor: Colors.blue,
            child:  IconButton(
            icon: Icon(Icons.add_shopping_cart,color: Colors.white,),
            onPressed: ()=>_saveItem(v['name'],int.parse(v['price']),v['url']),
          )),
            )
          );
           menuList.add(Divider());
        });
        setState(() {
                  checkMenu=true;
                });
      });
    }

  void _getCat(){
    db.reference().child("category").once().then((DataSnapshot snapshot){
      catlist = snapshot.value;
      debugPrint("$catlist");
      setState(() {
              checkcat = true;
            });
      
    });
  }
  //var key;// = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    //key = new GlobalKey<ScaffoldState>();
    return WillPopScope(
      onWillPop: () {
        exit(0);
      },
      child: Scaffold(
        key: key,
        backgroundColor: Colors.white,
        body: NestedScrollView(
        controller:_scrollController,
        headerSliverBuilder: (BuildContext context,bool boxIsScrolled){
          return <Widget>[
            SliverAppBar(
              actions: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.blue,
                child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed:()=>MyNavigator.goToCart(context),
                ))
              ],
              expandedHeight: 230.0,
              backgroundColor: Colors.blue,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(background: MySlider(),),
              
            )
          ];
        },
        
        body:checkcat?ListView(
          children: <Widget>[
            
            //Divider(),
            _getMenu()
          ],
        ): Center(
          child: CircularProgressIndicator(),
        ),
        ),
         drawer:MyDrawer(), //Drawer(
        
      //   child: ListView(
      //     children: <Widget>[
      //       Container(
      //       child:UserAccountsDrawerHeader(
      //         decoration: BoxDecoration(color: Colors.lightBlue[50]),
      //         accountName: Text(
      //           _userState?sp.getString("Name"):"Your Name",
      //           style: TextStyle(color: Colors.black, fontSize: 25.0),
      //         ),
      //         accountEmail: Text(
      //           _userState?currUser.phoneNumber:"Your phone",
      //           style: TextStyle(fontSize: 15.0,color: Colors.black),
      //         ),
      //       ),
      //       ),
      //       Container(
      //         color: Colors.black,
      //         child: Column(
      //           children: <Widget>[
      //       ListTile(
      //         title: Text("Menu",style: TextStyle(color: Colors.lightBlue[50]),),
      //         trailing: Icon(Icons.fastfood,color: Colors.lightBlue[50]),
      //       ),
      //       Divider(color: Colors.white,),
      //       ListTile(
      //         trailing: Icon(Icons.local_offer,color: Colors.lightBlue[50]),
      //         title: Text("Offers",style: TextStyle(color: Colors.lightBlue[50]),),
      //         onTap: ()=>MyNavigator.goToOffers(context),
      //       ),
      //       Divider(color: Colors.white,),
      //       ListTile(
      //         title: Text("Your Orders",style: TextStyle(color: Colors.lightBlue[50]),),
      //         trailing: Icon(Icons.history,color: Colors.lightBlue[50],),
      //         onTap: ()=>MyNavigator.goToOrders(context),
      //       ),
      //       ],
      //       ),
      //       ),
      //     ],
      //   ),
      // ),
      bottomNavigationBar: SizedBox(
              
              height: 50.0,
              child:checkcat?ListView(
                //padding: EdgeInsets.only(right: 4.0,left: 4.0),
          scrollDirection: Axis.horizontal,
          children: _getTabs(),):Container(),
            ),
        ),
      
      
    );
  }

  

  Widget _getMenu() {

    return checkMenu?
    Column(
      
      children: menuList,
      ):Center(
        child:CircularProgressIndicator() ,
      );

  }

  List<Widget> _getTabs(){
    List<Widget> tabList = List();
    tabList.add(
      Container(
        child:InkWell(
          onTap: ()=>_initMenuList(),
          child: Container(
          //height: 30.0,
          padding:EdgeInsets.only(left:8.0,right: 8.0,top: 8.0),
          //margin: EdgeInsets.only(left: 7.0),
          decoration: BoxDecoration(color: Colors.blue,),
          child:Text("All",style: TextStyle(fontSize: 20.0,color: Colors.white,fontWeight: FontWeight.bold),),
        )
        ),
      )
    );
    catlist.forEach((k,v){
      tabList.add(
        InkWell(
          onTap: ()=>updateMenu(v["name"]),
          child: Container(
          //height: 30.0,
          //color: Colors.black,
          decoration: BoxDecoration(color: Colors.blue),
          padding:EdgeInsets.only(left:8.0,right: 8.0,top: 8.0),
          //margin: EdgeInsets.only(left: 7.0),
          child:Text(v["name"],style: TextStyle(fontSize: 20.0,color: Colors.white,fontWeight:FontWeight.bold),),
        )
        ),
      );
      // tabList.add(
      //   Container(
      //     width: 0.0,
      //     //height: 10.0,
      //     decoration: BoxDecoration(color: Colors.black,border: Border.all()),
      //   )
      // );
    });
    
    return tabList;
  }
  void updateMenu(String cat){
    setState(() {
              checkMenu=false;
            });
    db.reference().child("item").orderByChild("category").equalTo(cat).once().then((DataSnapshot snapshot){
      
            menuList.clear();
      menulistMap=snapshot.value;
        menulistMap.forEach((k,v){
          menuList.add(
            ListTile(
              title: Text(v['name'],style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
              leading: Container(
          child: Image(
            height: 80.0,
            width: 80.0,
            fit: BoxFit.fill,
            image: NetworkImage(
                v['url']),
          ),
          decoration: BoxDecoration(
              border: Border.all(
            color: Colors.blue,
          ))),
          subtitle: Text("Price : ₹"+v["price"],style: TextStyle(color: Colors.blue,fontSize: 16.0,fontWeight: FontWeight.bold),),
          trailing: CircleAvatar(
            backgroundColor: Colors.blue,
            child:IconButton(
            highlightColor: Colors.black,
            icon: Icon(Icons.add_shopping_cart,color: Colors.white,),
            onPressed: ()=>_saveItem(v['name'],int.parse(v['price']),v['url']),
          )),
            )
          );
          // menuList.add(
          //   Divider()
          // );
        });
        setState(() {
                  checkMenu=true;
                });
    });
  }

  void _saveItem(String name,int price,String url) async {
    Item res1=await localDb.getItem(name);
    if(res1==null){
      
      int res=await localDb.saveItem(Item(name,price,1,url));
      key.currentState.showSnackBar(
        SnackBar(
          content: Text("$name added in cart"),
          duration: Duration(seconds: 1),
         
          
        )
      );
      //debugPrint("saved the item $res");
    }else{
      key.currentState.showSnackBar(
        SnackBar(
          content: Text("$name already in cart"),
          duration: Duration(seconds: 1),
        )
      );
    }
  }

  

  
    



  
}