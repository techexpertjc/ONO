import 'package:flutter/material.dart';
import 'package:ono/utils/my_navigators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ono/utils/drawer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';


class OrderReview extends StatefulWidget {
  _OrderReviewState createState() => _OrderReviewState();
}

class _OrderReviewState extends State<OrderReview> {
  
  SharedPreferences sp;
  FirebaseUser currUser;
  String lstord;
  FirebaseDatabase db;
  String _groupValueQlty="Not Answered";
  String _gruopValueService="Not Answered";
  TextEditingController textController;
  @override
  void initState() {
      // TODO: implement initState

      super.initState();
      initeve();
    }


  void initeve() async{
    textController=TextEditingController();
    sp=await SharedPreferences.getInstance();
    lstord=sp.getString("lastord");
    db=FirebaseDatabase.instance;
    currUser=await FirebaseAuth.instance.currentUser();
  }
  
  @override
  Widget build(BuildContext context) {

    

    return Container(
       child: WillPopScope(
         child:SafeArea(
           child:Scaffold(
             body: Form(
               child:ListView(
                 children: <Widget>[
                   Padding(padding: EdgeInsets.all(10.0),),
                   Text("Please Share us your feedback on your last order:",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0,),),
                   Padding(padding: EdgeInsets.only(bottom: 20.0),),
                   Text("Food Quality:",style: TextStyle(fontWeight: FontWeight.bold),),
                   Row(
                     children: <Widget>[
                       Radio(value:"Excellent",groupValue: _groupValueQlty,onChanged:(String e)=>updateQlty(e)),
                       Text("Excellent"),
                       Radio(value:"Good",groupValue: _groupValueQlty,onChanged:(String e)=>updateQlty(e)),
                       Text("Good"),
                       Radio(value:"Fair",groupValue: _groupValueQlty,onChanged:(String e)=>updateQlty(e)),
                       Text("Fair"),
                       Radio(value:"Poor",groupValue: _groupValueQlty,onChanged:(String e)=>updateQlty(e)),
                       Text("Poor"), 
                     ],
                   ),
                  Text("Service and Packing:",style:TextStyle(fontWeight: FontWeight.bold)),
                   Row(
                     children: <Widget>[
                       Radio(value:"Excellent",groupValue: _gruopValueService,onChanged:(String e)=>updateSrvc(e)),
                       Text("Excellent"),
                       Radio(value:"Good",groupValue: _gruopValueService,onChanged:(String e)=>updateSrvc(e)),
                       Text("Good"),
                       Radio(value:"Fair",groupValue: _gruopValueService,onChanged:(String e)=>updateSrvc(e)),
                       Text("Fair"),
                       Radio(value:"Poor",groupValue: _gruopValueService,onChanged:(String e)=>updateSrvc(e)),
                       Text("Poor"), 
                     ],
                   ),
                   TextField(
                     maxLines: 4,
                     controller: textController,
                     keyboardType: TextInputType.text,
                     decoration: InputDecoration(labelText: "Comments",hintText: "Nice service/Nice Food",icon: Icon(Icons.comment)),
                   ),
                   Padding(padding: EdgeInsets.only(bottom: 30.0),),
                   Row(children: <Widget>[
                   Padding(padding: EdgeInsets.all(20.0),),
                   RaisedButton(child: Text("Submit",style: TextStyle(color:Colors.white),),onPressed: ()=>submit(),),
                   Padding(padding: EdgeInsets.all(20.0),),
                   RaisedButton(child: Text("Skip",style: TextStyle(color:Colors.white)),onPressed: ()=>skip(),)
                 ],)
                 ],
                 
               )
             ),
            appBar: AppBar(
              title: Text("Feedback"),

            ),
            drawer: MyDrawer(),
           )
         ),
         onWillPop: (){
           MyNavigator.goToHome(context);
         },
       ),
    );
  }

  void updateQlty(String s){
    setState(() {
          _groupValueQlty=s;

        });
  }

  void updateSrvc(String s){
    setState(() {
          _gruopValueService=s;

        });
  }

  void submit(){
    debugPrint(textController.text);
    db.reference().child("feedbacks/$lstord").set({
      "uid":currUser.uid,
      "quality":_groupValueQlty,
      "service":_gruopValueService,
      "comments":textController.text,
      "show":0,
      "name":sp.getString("Name")
    });
    sp.setString("lastord", "None");
    MyNavigator.goToHome(context);
  }

  void skip(){
    sp.setString("lastord", "None");
    MyNavigator.goToHome(context);
  }

}