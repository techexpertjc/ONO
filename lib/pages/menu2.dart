import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ono/models/cartItem2.dart';
import 'package:ono/utils/db_helper.dart';
import 'package:ono/utils/drawer.dart';
import 'package:ono/utils/img_slider.dart';
import 'package:ono/utils/my_navigators.dart';
import 'package:ono/utils/reviews.dart';

class MyNewMenu extends StatefulWidget {
  @override
  _MyNewMenuState createState() => _MyNewMenuState();
}
DbHelper localDb;
class _MyNewMenuState extends State<MyNewMenu> {
  var key=GlobalKey<ScaffoldState>();
  ScrollController _scrollController;
  bool checkMenu = false;
  bool checkOffer=false;
  Map<dynamic,dynamic> menulistMap;
  Map<dynamic,dynamic> offersMap;
  Map<dynamic,dynamic> tsMap;
 
  List<Widget> menuList=List();
  List<Widget> tsList=List();
  List<Widget> offersList=List();
  
  int tdspcl;
  FirebaseDatabase db =FirebaseDatabase.instance;
  Widget popularList;
  Widget offersWidget;
  Widget tsListWidget;
  @override
  void initState() {
      // TODO: implement initState
      _initMenuList();
      _initDb();
      super.initState();
    }

    void _initDb() async {
      localDb=new DbHelper();
      //sp=await SharedPreferences.getInstance();
    }

    void _initMenuList() async {
      

      db.reference().child("item").orderByChild("category").equalTo("POPULAR").keepSynced(true);
      db.reference().child("item").orderByChild("category").equalTo("POPULAR").onValue.listen((Event event){
       //menulistMap=event.snapshot.value;

        setState(() {
            menulistMap=event.snapshot.value;
            
            menuList=_refresh();
            checkMenu=true;
            debugPrint(event.snapshot.value.toString());
                    
                });

        
      });

      db.reference().child("tdSpecial/items").keepSynced(true);
      db.reference().child("tdSpecial/items").onValue.listen((Event event){
       //menulistMap=event.snapshot.value;

        setState(() {
            tsMap=event.snapshot.value;
            
            tsList=_refresh2();
            checkMenu=true;
            debugPrint(event.snapshot.value.toString());
                    
                });

        
      });
      
      db.reference().child("tdSpecial/Stock/value").once().then((DataSnapshot snapshot){
        tdspcl=snapshot.value;
        debugPrint(tdspcl.toString());

        setState(() {
                   tdspcl=snapshot.value;
                });
      });

      db.reference().child("offer").once().then((DataSnapshot snapshot){
      //debugPrint("${snapshot.value}");
      offersMap=snapshot.value;
      setState(() {
              checkOffer=true;
            });
    });

    
    }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        exit(0);
      },
      child: SafeArea(child:Scaffold(
        key: key,
        backgroundColor: Colors.white,
        body: NestedScrollView(
          controller:_scrollController,
        headerSliverBuilder: (BuildContext context,bool boxIsScrolled){
          return <Widget>[
            SliverAppBar(
              actions: <Widget>[
                FloatingActionButton(
                  child: Icon(Icons.shopping_cart),
                  onPressed: ()=>MyNavigator.goToCart(context),
                  mini: true,
                  backgroundColor: Color(0x00000000),
                  foregroundColor: Colors.white,
                )
              ],
              expandedHeight: 230.0,
              backgroundColor: Colors.blue,
              floating: false,
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(background: MySlider(),),
              
            )
          ];
        },
        
        body:(checkMenu && checkOffer)?_loadBody():Center(child:CircularProgressIndicator())
        ),
        drawer: MyDrawer(),
      )),
    );
  }

  List<Widget> _refresh(){
    List<Widget> menuList1=List();
    menuList1.clear();
    menulistMap.forEach((k,v){
          menuList1.add(
            SizedBox(
              width: 175.0,
              
              child:Card(
                //elevation: 10.0,
              child: Container(
                //width: 300.0,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(child:Image(image:NetworkImage(v['url']),fit:BoxFit.fitHeight),height: 125.0,),
                    Padding(padding: EdgeInsets.all(5.0),),
                    Text("  "+v['name'],textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Calibri"),),
                    Padding(padding: EdgeInsets.all(5.0),),
                    Text("  ₹"+v['price'],textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.bold),),
                    Padding(padding: EdgeInsets.all(5.0),),
                    Expanded(
                      child:Container(
                        color: Colors.blue,
                        child: Center(
                          child:(v['stock']==1)?FlatButton(
                                child:Text("Add to Cart",style: TextStyle(color: Colors.white),),
                                onPressed: ()=>_saveItem(v['name'],int.parse(v['price']),v['url']),
                              ):FlatButton(
                                child:Text("Out of Stock",style: TextStyle(color: Colors.white),),
                                onPressed: null
                              )
                        ),
                      )
                    )
                  ],
                )
              )
            )
            )
          );
        });

      return menuList1;
  }




  List<Widget> _refresh2(){
    List<Widget> menuList1=List();
    menuList1.clear();
    tsMap.forEach((k,v){
          menuList1.add(
            SizedBox(
              width: 175.0,
              
              child:Card(
                //elevation: 10.0,
              child: Container(
                //width: 300.0,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(child:Image(image:NetworkImage(v['url']),fit:BoxFit.fitHeight),height: 125.0,),
                    Padding(padding: EdgeInsets.all(5.0),),
                    Text("  "+v['name'],textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Calibri"),),
                    Padding(padding: EdgeInsets.all(5.0),),
                    Text("  ₹"+v['price'],textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.bold),),
                    Padding(padding: EdgeInsets.all(5.0),),
                    Expanded(
                      child:Container(
                        color: Colors.blue,
                        child: Center(
                          child:(v['stock']==1)?FlatButton(
                                child:Text("Add to Cart",style: TextStyle(color: Colors.white),),
                                onPressed: ()=>_saveItem(v['name'],int.parse(v['price']),v['url']),
                              ):FlatButton(
                                child:Text("Out of Stock",style: TextStyle(color: Colors.white),),
                                onPressed: null
                              )
                        ),
                      )
                    )
                  ],
                )
              )
            )
            )
          );
        });

      return menuList1;
  }



  Widget _loadBody(){
    //menuList.clear();
    offersList.clear();
    // menulistMap.forEach((k,v){
    //       menuList.add(
    //         SizedBox(
    //           width: 175.0,
              
    //           child:Card(
    //             //elevation: 10.0,
    //           child: Container(
    //             //width: 300.0,
    //             child:Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: <Widget>[
    //                 SizedBox(child:Image(image:NetworkImage(v['url']),fit:BoxFit.fitHeight),height: 125.0,),
    //                 Padding(padding: EdgeInsets.all(5.0),),
    //                 Text("  "+v['name'],textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.bold),),
    //                 Padding(padding: EdgeInsets.all(5.0),),
    //                 Text("  ₹"+v['price'],textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.bold),),
    //                 Padding(padding: EdgeInsets.all(5.0),),
    //                 (v['stock']==1)?FlatButton(
    //                   child:Text("Add to Cart",style: TextStyle(color: Colors.blue),),
    //                   onPressed: ()=>_saveItem(v['name'],int.parse(v['price']),v['url']),
    //                 ):FlatButton(
    //                   child:Text("Out of Stock",style: TextStyle(color: Colors.blue),),
    //                   onPressed: null
    //                 )
    //               ],
    //             )
    //           )
    //         )
    //         )
    //       );
    //     });
        popularList=Container(
          height:240.0,
          child:ListView(
            scrollDirection: Axis.horizontal,
            children:menuList,
            
          )
        );

        tsListWidget=Container(
          height:240.0,
          child:ListView(
            scrollDirection: Axis.horizontal,
            children:tsList,
            
          )
        );

    offersMap.forEach((k,v){
      offersList.add(
        SizedBox(
          width:175.0,
          child:Card(
            child: Container(
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(padding: EdgeInsets.all(5.0),),
                  Text(" "+v['name'].toString(),style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,fontFamily: "Calibri",color: Colors.blue),),
                  Padding(padding: EdgeInsets.all(5.0),),
                  Divider(),
                  Text(v['description'],style: TextStyle(color: Colors.black,fontSize: 15.0),),
                  Padding(padding: EdgeInsets.all(5.0),),
                  Text("Expires on: "+DateTime.parse(v['expire']).day.toString()+"/"+DateTime.parse(v['expire']).month.toString()+"/"+DateTime.parse(v['expire']).year.toString(), style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                  Padding(padding: EdgeInsets.all(3.0),),
                  Expanded(
                    child:Container(
                      color: Colors.blue,
                      child:Center(child:FlatButton(
                          onPressed: (){
                            Clipboard.setData(ClipboardData(text: v['promo']));
                            key.currentState.showSnackBar(
                              SnackBar(
                                content: Text(v['promo']+" Promo code copied to clipboard"),
                              )
                            );
                          },
                          child: Text("Copy Promo",style: TextStyle(color: Colors.white),),
                        ))
                    )
                  )
                ],
              )
            ),
          )

        )
      );
    });

    offersWidget=Container(
      height: 180.0,
      child:ListView(
        scrollDirection: Axis.horizontal,
        children:offersList,
      )
    );


      

    return ListView(
            
            children: <Widget>[
              (tdspcl==1)?Padding(padding: EdgeInsets.all(5.0),):Container(width:0.0, height:0.0),
              
              (tdspcl==1)?Text("  Today's Special",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),):Container(width:0.0, height:0.0),
              
              (tdspcl==1)?Padding(padding: EdgeInsets.all(5.0),):Container(width:0.0, height:0.0),
              (tdspcl==1)?Divider():Container(width:0.0, height:0.0),
              (tdspcl==1)?tsListWidget:Container(width:0.0, height:0.0),
              Padding(padding: EdgeInsets.all(7.0),),
              Myreviews(),
              Divider(),
              Text("  Popular",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
              
              Padding(padding: EdgeInsets.all(5.0),),
              Divider(),
              popularList,
              Divider(),
              Padding(padding: EdgeInsets.all(5.0),),
              Text("  Offers",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
              Padding(padding: EdgeInsets.all(5.0),),
              Divider(),
              offersWidget,
              // Padding(padding: EdgeInsets.all(7.0),),
              // Myreviews()
            ],
          );
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