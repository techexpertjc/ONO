//import 'dart:io' show Platform;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ono/utils/my_navigators.dart';
//import 'package:firebase_core/firebase_core.dart';

/*final FirebaseApp app=FirebaseApp.configure(
name: "db",
options: Platform.isAndroid ? const FirebaseOptions(
  googleAppID: "1:554101602434:android:a211c54fa8b718a0",
  apiKey: "AIzaSyAxIKhFT_4MCvYm0UHUuQmz7V2sq1hCefs",
  databaseURL: "https://onenonly-2f2be.firebaseio.com/"
):FirebaseOptions(
  //ios options
  googleAppID: "1:554101602434:android:a211c54fa8b718a0",
  apiKey: "AIzaSyAxIKhFT_4MCvYm0UHUuQmz7V2sq1hCefs",
  databaseURL: "https://onenonly-2f2be.firebaseio.com/"
)
);*/

final FirebaseDatabase _database=FirebaseDatabase.instance;

class UserDetail extends StatefulWidget{
  UserDetailState createState()=>  UserDetailState();
}


class UserDetailState extends State<UserDetail> {
   final TextEditingController _nameController = new TextEditingController();
   final TextEditingController _addController = new TextEditingController();
   final TextEditingController _secPhoneController=new TextEditingController();
   FirebaseUser currUser;
   SharedPreferences _sPref;
  @override
  void initState() {
      // TODO: implement initState
      super.initState();
      _getUserDetails();
          }
      
      
      
        @override
        Widget build(BuildContext context){
          return Material(
            color: Colors.white,
            child:Center(
            child:Container(
            padding: EdgeInsets.all(20.0),
            color: Colors.lightBlue[50],
            child: ListView(
              children: <Widget>[
              Padding(padding:EdgeInsets.only(top: 50.0)),
              TextField(
                controller: _nameController ,
                decoration: InputDecoration(
                  hintText: 'Name',
                  icon: Icon(Icons.person)
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 10.0),),
              TextField(
                controller: _secPhoneController ,
                decoration: InputDecoration(
                  hintText: 'Secondry phone',
                  icon: Icon(Icons.phone_missed)
                ),
                keyboardType: TextInputType.number,
              ),
              Padding(padding: EdgeInsets.only(top: 10.0),),
              TextField(
                controller: _addController,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Address',
                  icon: Icon(Icons.home)
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 30.0),),
              Row(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(right: 50.0),),
                  RaisedButton(
                    color: Colors.blue,
                  child: Text("Submit",style:TextStyle(fontSize: 20.0,color: Colors.blue[50]) ,),
                  onPressed: _saveDetails,
                  ),
                  Padding(padding: EdgeInsets.only(right: 30.0),),
                  RaisedButton(
                  child: Text("Clear",style:TextStyle(fontSize: 20.0,color: Colors.white)),
                  onPressed: (){
                    _nameController.clear();
                    _addController.clear();
                    _secPhoneController.clear();
                  },
                  )
                ],
              )
              
              ],
            ),
          )));
        }
        void _saveDetails() async {
          String uid=currUser.uid;
          if(_nameController.text!="" && _addController.text!=""){
          _database.reference().child("users/$uid").set({
            
            "Name": _nameController.text.toString(),
            "Address": _addController.text.toString(),
            "Number2": _secPhoneController.text.toString(),
            "Number1":currUser.phoneNumber.toString(),
            "wallet":0
          });
          _sPref.setString("Name", _nameController.text.toString());
          _sPref.setString("Address",_addController.text.toString());
          MyNavigator.goToHome(context);}else{
           
            showDialog(
              context: context,
              builder: (BuildContext context){
                return Center(
                  child: AlertDialog(
                    content: Text("PLease enter address and name"),
                    
                  )
                );
              }
            );
          }
        }
        void _getUserDetails() async {
         currUser= await FirebaseAuth.instance.currentUser();
         _sPref=await SharedPreferences.getInstance();
        }
}