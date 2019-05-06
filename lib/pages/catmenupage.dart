import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ono/models/cartItem2.dart';
import 'package:ono/utils/db_helper.dart';
import 'package:ono/utils/drawer.dart';
import 'package:ono/utils/my_navigators.dart';


class CategoryMenu extends StatefulWidget{
  final String catName;
  CategoryMenu({Key key,this.catName}):super(key:key);
  CategoryMenuState createState()=>  CategoryMenuState();
}


class CategoryMenuState extends State<CategoryMenu> {
  FirebaseDatabase db=FirebaseDatabase.instance;
  var key=GlobalKey<ScaffoldState>();
  Map<dynamic,dynamic> itemList=Map();
  bool itemLoad=false;
  Widget catMenuWidget;
  DbHelper localDb=DbHelper();
  @override
  void initState() {
      // TODO: implement initState
      _getItems();
      super.initState();
    }
  void _getItems() async{
    db.reference().child("item").orderByChild("category").equalTo(widget.catName).keepSynced(true);
    db.reference().child("item").orderByChild("category").equalTo(widget.catName).onValue.listen((Event event){
      setState(() {
              itemLoad=true;
              itemList=event.snapshot.value;
              catMenuWidget=getItemCards();
            });
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      key: key,
      body: itemLoad?catMenuWidget:Center(
        child:CircularProgressIndicator()
      ),
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text(widget.catName),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: ()=>MyNavigator.goToCart(context),
          )
        ],
      ),
    );
  }

  Widget getItemCards(){

    List<Widget> items=List();

    itemList.forEach((k,v){
      items.add(
        SizedBox(
              width: 175.0,
              
              child:Card(
                elevation: 100.0,
              child: Container(
                //width: 300.0,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(child:Image(image:NetworkImage(v['url']),fit:BoxFit.fitWidth),height: 125.0,width: MediaQuery.of(context).size.width,),
                    Padding(padding: EdgeInsets.all(5.0),),
                    Text("  "+v['name'],textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Calibri"),),
                    Padding(padding: EdgeInsets.all(5.0),),
                    Text("  ₹"+v['price'],textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.bold),),
                    Padding(padding: EdgeInsets.all(5.0),),
                    Container(
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
                  ],
                )
              )
            )
            )
      );
    });


    return ListView(
        // crossAxisCount: 2,
        // mainAxisSpacing: 3.0,
        children: items,
        // childAspectRatio: 0.75,
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