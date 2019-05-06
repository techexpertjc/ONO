import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:ono/utils/drawer.dart';
import 'package:ono/utils/my_navigators.dart';

class Offers extends StatefulWidget {
  @override
  _OffersState createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  FirebaseDatabase db=FirebaseDatabase.instance;
  Map<dynamic,dynamic> offersMap;
  bool offload=false;
  var key=GlobalKey<ScaffoldState>();
  @override
  void initState() {
      // TODO: implement initState
      super.initState();
      loadOffers();
    }

  void loadOffers(){
    db.reference().child("offer").once().then((DataSnapshot snapshot){
      //debugPrint("${snapshot.value}");
      offersMap=snapshot.value;
       setState(() {
          offload=true;
        });
    });
   
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: key,
      appBar: AppBar(
        title: Text("Offers"),    
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: ()=>MyNavigator.goToCart(context),
          )
        ],  
        ),
        body: offload?offerBody():Center(child: CircularProgressIndicator()),
        drawer: MyDrawer(),
        
    );
  }


  Widget offerBody(){
    return (offersMap==null)?Center(child: Text("Oops no offers yet"),):ListView(
      children: offersLIst(),
    );
  }

  List<Widget> offersLIst(){
    List<Widget> listoffer=List();
    offersMap.forEach((k,v){
      listoffer.add(
        ListTile(
          
          title: Text(v['name'].toString(),style: TextStyle(fontSize: 22.0,fontWeight: FontWeight.bold),),
          isThreeLine: true,
          subtitle: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(padding: EdgeInsets.all(10.0),),
                Text(v['description'],style: TextStyle(color: Colors.black,fontSize: 18.0),),
                Padding(padding: EdgeInsets.all(10.0),),
                Text("Expires on: "+DateTime.parse(v['expire']).day.toString()+"/"+DateTime.parse(v['expire']).month.toString()+"/"+DateTime.parse(v['expire']).year.toString(), style: TextStyle(color: Colors.black),),
                Padding(padding: EdgeInsets.all(10.0),),
                Text("Promo Code: "+v['promo'],style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16.0),),

              ],
            ),
          ),
          trailing:CircleAvatar(
            backgroundColor: Colors.blue,
            child:IconButton(
            icon: Icon(Icons.content_copy,color: Colors.white,),
            onPressed: (){
              Clipboard.setData(ClipboardData(text: v['promo']));
              key.currentState.showSnackBar(
                SnackBar(
                  content: Text(v['promo']+" Promo code copied to clipboard"),
                )
              );
            },
          )),
        )
      );
      listoffer.add(Divider());
    });

    return listoffer;
  }

}