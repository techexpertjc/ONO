import 'package:flutter/material.dart';
import 'package:carousel/carousel.dart';
import 'package:firebase_database/firebase_database.dart';




class Myreviews extends StatefulWidget {
  _MyreviewsState createState() => _MyreviewsState();
}

class _MyreviewsState extends State<Myreviews> {
  
  FirebaseDatabase db=FirebaseDatabase.instance;
  Map<dynamic,dynamic> fbmap=Map();
  List<Widget> fbList=List();  
  bool load=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initeve();
  }
  
  void initeve() async{
    db.reference().child("feedbacks").orderByChild("show").equalTo(1).once().then((DataSnapshot snapshot){
      fbmap=snapshot.value;
      
      setState(() {
              getlist();
              load=true;
            }); 
    });
    
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      width: 300.0,
      height: 250.0,
       child: load?Carousel(
         displayDuration: Duration(seconds: 3),
         children: fbList,
       ):Container(child:Center(child:CircularProgressIndicator())),
    );
  }

  void getlist(){
    List<Widget> fbList1=List();
    fbmap.forEach((k,v){
      debugPrint(k.toString());
      String name;
      db.reference().child("users/${v['uid']}/Name").once().then((DataSnapshot snapshot){
        name=snapshot.value;
        debugPrint(name);
      });
      
      fbList.add(
        Container(child:Card(child:Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              
              Padding(padding: EdgeInsets.all(10.0),),
              Row(children: <Widget>[
                Padding(padding: EdgeInsets.all(5.0),),
                CircleAvatar(child: Icon(Icons.person),),
                Padding(padding: EdgeInsets.all(3.0),),
                Text(v['name'],style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue,fontSize: 20.0)),
              ],),
              Padding(padding: EdgeInsets.all(3.0),),
              Divider(),
              Padding(padding: EdgeInsets.all(8.0),),
              Row(
                children: <Widget>[
                  Text("Food Quality: ",style:TextStyle(fontWeight: FontWeight.bold)),
                  Text(v['quality'])
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 10.0),),
              Row(
                children: <Widget>[
                  Text("Service: ",style:TextStyle(fontWeight: FontWeight.bold)),
                  Text(v['service'])
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 10.0),),
              Row(
                children: <Widget>[
                  Text("Comments: ",style:TextStyle(fontWeight: FontWeight.bold)),
                  Text(v['comments'])
                ],
              ),

            ],
          ),)
        ))
      );
    });

    debugPrint("length: "+fbList.length.toString());
  
  }


}