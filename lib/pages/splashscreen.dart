import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ono/utils/my_navigators.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget{
  @override
  _SplashScreenState createState() => _SplashScreenState();
}




class _SplashScreenState extends State<SplashScreen>{

      SharedPreferences _pref;
      FirebaseDatabase db=FirebaseDatabase.instance;
      final String imageUrl = 'assets/images/OneNOnly.png';
        @override
        void initState() {
          _checkSaved();
          
          // TODO: implement initState
          super.initState();
          //Timer(Duration(seconds: 5),()=> MyNavigator.goToLogin(context));
          
        }

        void _checkSaved() async {
        _pref=await SharedPreferences.getInstance();
        //String phon=_pref.getString("phonkey");
        String add=_pref.getString("Address");
        String lstord=_pref.getString("lastord");
        if(add!=null)
          {
            if(lstord!="None" && lstord!=null){
              db.reference().child("order/$lstord/track").once().then((DataSnapshot snap){
                //print(snap.value.toString());
                int orStatus=int.parse(snap.value.toString());
                if(orStatus==4){
                  Timer(Duration(seconds:3),()=>MyNavigator.getFeedback(context));
                }else{
                  Timer(Duration(seconds: 3),()=> MyNavigator.goToHome(context));
                }
              });
              //Timer(Duration(seconds:3),()=>MyNavigator.getFeedback(context));
            }
           else{ Timer(Duration(seconds: 3),()=> MyNavigator.goToHome(context));}
            //MyNavigator.goToHome(context);
          }else{
            Timer(Duration(seconds: 3),()=> MyNavigator.goToLogin(context));
            //MyNavigator.goToLogin(context);
          }
        }

        @override
        Widget build(BuildContext context) {
          // TODO: implement build
          return Scaffold(
          bottomNavigationBar: Container(
            color:Color(0x00000000),
            width: MediaQuery.of(context).size.width,
            height: 70.0,
            child:Center(child:Column(children: <Widget>[
              
              Row(children: <Widget>[
                //Padding(padding: EdgeInsets.only(left: 30.0),),
                Text("Made with  ",style: TextStyle(color: Colors.white),),
                Icon(Icons.favorite,color: Colors.red,),
                Text(" by  ",style: TextStyle(color: Colors.white),),
                Padding(padding: EdgeInsets.only(left: 5.0),),
                Image.asset("assets/images/SGlogo.png",width: 25.0,height: 25.0,),
                Text(" StiensGate Inc. ",style: TextStyle(color: Colors.white),)
              ],
              mainAxisAlignment: MainAxisAlignment.center,),
              Text("www.stiensgate.com",style: TextStyle(color:Colors.yellowAccent,),)
            ],))
            
          ),
        body: ListView(
      children: <Widget>[
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.lightBlueAccent,
          ),
        ),
      ],
    ));
        }
      
        

}
