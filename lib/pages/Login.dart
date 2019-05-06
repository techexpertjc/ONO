import 'dart:async';
//import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:ono/utils/my_navigators.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
//final GoogleSignIn _googleSignIn = new GoogleSignIn();

SharedPreferences _pref;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}




class _LoginState extends State<Login> {
  final TextEditingController _mobController = new TextEditingController();
  final TextEditingController _otpController = new TextEditingController();
  Future<String> _message = new Future<String>.value('');
  String verificationId;
  Future<FirebaseUser> user1=  FirebaseAuth.instance.currentUser();  
  bool phoneEntered=false;

  

  Future<void> _validatePhoneNumber(String phoneNumber1) async {
    _pref=await SharedPreferences.getInstance();
    final String phon="+91"+phoneNumber1.trim();
    final RegExp phoneExp = new RegExp(r'^[\d -+(),.*#]+$');
    if (phoneExp.hasMatch(phon))
       {
          final PhoneVerificationCompleted verificationCompleted=(FirebaseUser user){
            setState(() {
                          _message=Future<String>.value("auto sign in succedded $user");
                          debugPrint("Sign up succedded");
                          _pref.setString("phonkey",user.phoneNumber.toString());
                          MyNavigator.goToDetail(context);
                        });
          };

          final PhoneVerificationFailed verificationFailed=(AuthException authException){
            setState(() {
                          _message=Future<String>.value("verification failed code: ${authException.code}. Message: ${authException.message}");
                        });
          };

          final PhoneCodeSent codeSent=(String verificationId,[int forceResendingToken]) async {
            this.verificationId=verificationId;
            
          };

          final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout = (String verificationId){
            this.verificationId=verificationId;

          };
         
          await _auth.verifyPhoneNumber(
            phoneNumber: phon,
            timeout: Duration(seconds: 60),
            verificationCompleted: verificationCompleted,
            verificationFailed: verificationFailed,
            codeSent: codeSent,
            codeAutoRetrievalTimeout: codeAutoRetrievalTimeout
            );
         
       }else{
         Scaffold.of(context).showSnackBar(SnackBar(content: Text("Enter a valid phone number"),duration: Duration(seconds: 3),));
       }
  }


    @override
    void initState() {
      
      // TODO: implement initState
      super.initState();
      
    }

    void _signInWithOtp() async{
      final FirebaseUser user = await _auth.signInWithPhoneNumber(
      verificationId: verificationId,
      smsCode: _otpController.text,
    );
    setState(() {
          _message=Future<String>.value("auto sign in succedded $user");
          debugPrint("Sign up succedded");
          _pref.setString("phonkey",user.phoneNumber.toString());
          MyNavigator.goToDetail(context);
        });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
     body: ListView(
       children: <Widget>[
          Padding(padding: EdgeInsets.only(top:125.0)),
         Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image:NetworkImage("https://cdn3.iconfinder.com/data/icons/essential-rounded/64/Rounded-31-512.png") ,
              height: 200.0,
              ),
              Padding(padding: EdgeInsets.all(20.0),),
             // Text("Log In",style: TextStyle(fontSize: 25.0,)),
            Container(
             // decoration: BoxDecoration(border: Border.all(color: Colors.black,width: 2.0),color: Colors.transparent),
              height: 250.0,
             // constraints: new BoxConstraints(maxWidth: 35.0),
              margin: EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _mobController,
                    keyboardType: TextInputType.number,
                    
                    
                    decoration: new InputDecoration(
                      hintText: 'Mobile Number',
                      icon: Icon(Icons.phone_android)
                    ),
                  ),
                   Padding(padding: EdgeInsets.only(top: 25.0)),
                  Center(
                    child: RaisedButton(
                      child: Icon(Icons.send,color: Colors.white,),
                      onPressed: ()=>_validatePhoneNumber(_mobController.text.toString()),
                      color: Colors.blue,
                      splashColor: Colors.blueGrey,
                    ),
                  ),
                  TextField(
                      controller: _otpController,
                      //enabled: false,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: InputDecoration(
                        hintText: 'OTP',
                        icon: Icon(Icons.vpn_key)
                      ),
                  ),
                  Padding(padding: EdgeInsets.all(10.0),),
                  Center(child:RaisedButton(
                    child: Text("Submit OTP",style: TextStyle(color:Colors.white),),
                    onPressed: ()=> _signInWithOtp(),
                  )),
                  new FutureBuilder<String>(
              future: _message,
              builder: (_, AsyncSnapshot<String> snapshot) {
                return new Text(snapshot.data ?? '',
                    style: const TextStyle(
                        color: const Color.fromARGB(255, 0, 155, 0)));
              }),
                ],
              ),
              

            ),
          ],
        ),
        
       ],
     ),
    );
  }
}