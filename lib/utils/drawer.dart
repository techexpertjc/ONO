import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ono/pages/catmenupage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'my_navigators.dart';
import 'package:flutter_launch/flutter_launch.dart';

class MyDrawer extends StatefulWidget{
  MyDrawerState createState()=>  MyDrawerState();
}

FirebaseUser currUser;
SharedPreferences sp;
FirebaseDatabase db;
bool _userState=false;
bool checkcat = false;
int bal=0;
Map<dynamic,dynamic> catlist;
class MyDrawerState extends State<MyDrawer> {

  @override
  void initState() {
      // TODO: implement initState
      super.initState();
      db=FirebaseDatabase.instance;
      _getUser();
      _getCat();
    }


    void _getUser() async{
    currUser=await FirebaseAuth.instance.currentUser();
    sp=await SharedPreferences.getInstance();
    setState(() {
        _userState=true;
        });
    String uid=currUser.uid;
    db.reference().child("users/$uid/wallet").once().then((DataSnapshot snap){
      setState(() {
              bal=snap.value;
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

  List<Widget> _cats(){
    List<Widget> catTiles=List();
    if(checkcat)
    catlist.forEach((k,v){
      catTiles.add(
        ListTile(
          onTap: (){
            Navigator.push(context,
              MaterialPageRoute(
                builder: (context)=>CategoryMenu(catName:v['name'])
              )
            );
          },
          title: Text(v['name'],style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
        )
      );
    });

    
      return catTiles;
    
    
  }

  @override
  Widget build(BuildContext context){
    return Drawer(
        
        child: Container(
          color:Colors.blue,
          child:ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
            child:UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              //currentAccountPicture: Text("Wallet: "+bal.toString()),
              accountName: Text(
                _userState?sp.getString("Name"):"Your Name",
                style: TextStyle(color: Colors.white, fontSize: 25.0),
              ),
              accountEmail: Text(
                _userState?currUser.phoneNumber:"Your phone",
                style: TextStyle(fontSize: 15.0,color: Colors.white),
              ),
            ),
            ),
            Container(
              color: Colors.blue,
              child: Column(
                children: <Widget>[
                  //Divider(),
                  ListTile(title:Text("Wallet: "+bal.toString(),style: TextStyle(color: Colors.white),)),
                  Divider(color: Colors.white,),

            ListTile(
              title: Text("Sign Out",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
              trailing: Icon(Icons.exit_to_app,color: Colors.white,),
              onTap: (){
                sp.setString("Address", null);
                MyNavigator.goToLogin(context);
              },
            ),

            Divider(color: Colors.white,),

            ListTile(
              title: Text("Home",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
              trailing: Icon(Icons.home,color: Colors.white),
              onTap: ()=>MyNavigator.goToHome(context),
            ),
            Divider(color: Colors.white,),
            checkcat?ExpansionTile(
              title: Text("Menu",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
              children: _cats(),
            ):
            ListTile(
              title:Text("Menu Loading",style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold))
            ),
            Divider(color: Colors.white,),
            ListTile(
              trailing: Icon(Icons.local_offer,color: Colors.white),
              title: Text("Offers",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
              onTap: ()=>MyNavigator.goToOffers(context),
            ),
            Divider(color: Colors.white,),
            ListTile(
              title: Text("Your Orders",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
              trailing: Icon(Icons.history,color: Colors.white,),
              onTap: ()=>MyNavigator.goToOrders(context),
            ),

            Divider(color: Colors.white,),

            ListTile(
              title: Text("Contact Us.",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
              trailing: Icon(Icons.message,color: Colors.white,),
              onTap: ()async {
                //const String phone="whatsapp://send?phone=7046585850";
                
                
                 await FlutterLaunch.launchWathsApp(phone: "+91 7046585850", message: "Hello");
                
              },
            ),
            Divider(color: Colors.white,),

            
            ],
            ),
            ),
          ],
        ),
      ));
  }
}