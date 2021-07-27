import 'package:aggs/register.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  double width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
         crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 170),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    height: 90,
                    width: 90,
                    child: Image.asset('assets/images/logo_new.png'),
                  ),
                ),
                Hero(
                  tag: 'title',
                  child: Material(
                    child: Text(
                      'Agrigo Shop',
                      style: TextStyle(fontSize: 36 , fontFamily: "Solway"),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 120,),
          Container(
            child: Column(children: <Widget>[
              Hero(
                tag: 'registerButton',
                child: MaterialButton(
                  child: Text("Sign Up", style: TextStyle(fontSize: 20,fontFamily:"Solway"),),
                  color: Colors.amber,
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Register())),
                  height: 55.0,
                  minWidth: width ?? 178,
                ),
              ),
              SizedBox(height: 40,),
              Text("OR",style: TextStyle(fontSize: 20,fontFamily:"Solway")),
              SizedBox(height: 40,),
              Hero(
                tag: 'loginButton',
                child: MaterialButton(
                  child: Text("Sign In", style: TextStyle(fontSize: 20,fontFamily:"Solway"),),
                  color: Colors.amber,
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login())),
                  height: 55.0,
                  minWidth: width ?? 178,
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
