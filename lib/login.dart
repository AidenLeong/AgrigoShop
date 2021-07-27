import 'package:aggs/main_menu.dart';
import 'package:aggs/register.dart';
import 'package:flutter/services.dart';
import 'package:aggs/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'firstpage.dart';

bool rememberMe = false;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<ScaffoldState> _scaffold = new GlobalKey<ScaffoldState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String urlLogin = "https://justminedb.com/aggs/php/login.php";
  double width;

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 200),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    height: 90,
                    width: 90,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
                Hero(
                  tag: 'title',
                  child: Material(
                    child: Text(
                      'Agrigo Shop',
                      style: TextStyle(fontSize: 36, fontFamily: "Solway"),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            width: 350,
            child: Column(children: <Widget>[
              Hero(
                tag: "emailTextField",
                child: Material(
                    child: TextField(
                  style: TextStyle(fontFamily: "Solway"),
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Email Address',
                    prefixIcon: Icon(Icons.email, color: Colors.amber[600]),
                    hintStyle: TextStyle(fontFamily: "Solway"),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                  ),
                )),
              ),
              SizedBox(
                height: 20,
              ),
              Hero(
                tag: "passwordTextField",
                child: Material(
                    child: TextField(
                  style: TextStyle(fontFamily: "Solway"),
                  controller: passwordController,
                  obscureText: true,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock, color: Colors.amber[600]),
                    hintStyle: TextStyle(fontFamily: "Solway"),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                  ),
                )),
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                    value: rememberMe,
                    onChanged: (bool value) {
                      _onRememberMeChanged(value);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(),
                    child: Text('Remember Me ',
                        style: TextStyle(
                            fontFamily: 'Solway',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Hero(
                    tag: 'registerButton',
                    child: MaterialButton(
                      child: Text(
                        "Register",
                        style: TextStyle(fontFamily: "Solway"),
                      ),
                      color: Colors.amber,
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Register())),
                      height: 42.0,
                      minWidth: width ?? 168,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(12.0)),
                    ),
                  ),
                  SizedBox(width: 12),
                  Hero(
                    tag: 'loginButton',
                    child: MaterialButton(
                      child: Text(
                        "Login",
                        style: TextStyle(fontFamily: "Solway"),
                      ),
                      color: Colors.amber,
                      onPressed: _userLogin,
                      height: 42.0,
                      minWidth: width ?? 168,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(12.0)),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Hero(
                    tag: 'cancelButton',
                    child: MaterialButton(
                      child: Text(
                        "Cancel",
                        style: TextStyle(fontFamily: "Solway"),
                      ),
                      color: Colors.amber,
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MainPage())),
                      height: 42.0,
                      minWidth: width ?? 345,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(12.0)),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }

  void _userLogin() async {
    try {
      String _email = emailController.text;
      String _password = passwordController.text;

      http.post(urlLogin, body: {
        "email": _email,
        "password": _password,
      }).then((res) {
        print(res.body);
        var string = res.body;
        List userdata = string.split(",");
        if (userdata[0] == "success") {
          User _user = new User(
            name: userdata[1],
            email: _email,
            password: _password,
            phone: userdata[3],
            role: userdata[4],
            address: userdata[5],
            wallet: userdata[6],
            quantity: userdata[7],
            city: userdata[8],
            country: userdata[9],
          );

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => MainMenu(
                        user: _user,
                      )));
          return;
        } else {
          final snackBar = SnackBar(
            content: Text(
              'Login Failed!',
              style: TextStyle(fontFamily: "Solway"),
            ),
            action: SnackBarAction(
              label: 'Close',
              textColor: Colors.white,
              onPressed: () {},
            ),
          );

          // ignore: deprecated_member_use
          _scaffold.currentState.showSnackBar(snackBar);
          return;
        }
      }).catchError((err) {
        print(err);
      });
    } on Exception catch (_) {
      final snackBar = SnackBar(
        content: Text(
          'Error!',
          style: TextStyle(fontFamily: "Solway"),
        ),
        action: SnackBarAction(
          label: 'Close',
          textColor: Colors.white,
          onPressed: () {},
        ),
      );

      // ignore: deprecated_member_use
      _scaffold.currentState.showSnackBar(snackBar);
    }
  }

  void loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    if (email.length > 1) {
      setState(() {
        emailController.text = email;
        passwordController.text = password;
        rememberMe = true;
      });
      return;
    }
  }

  void savepref(bool value) async {
    String email = emailController.text;
    String password = passwordController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      //save preference
      await prefs.setString('email', email);
      await prefs.setString('pass', password);
      final snackBar = SnackBar(
        content: Text(
          'Preference have been saved',
          style: TextStyle(fontFamily: "Solway"),
        ),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {},
        ),
      );

      // ignore: deprecated_member_use
      _scaffold.currentState.showSnackBar(snackBar);
      return;
    } else {
      //delete preference
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      setState(() {
        emailController.text = '';
        passwordController.text = '';
        rememberMe = false;
      });
      final snackBar = SnackBar(
        content: Text(
          'Preference Removed!',
          style: TextStyle(fontFamily: "Solway"),
        ),
        action: SnackBarAction(
          label: 'Close',
          textColor: Colors.white,
          onPressed: () {},
        ),
      );

      // ignore: deprecated_member_use
      _scaffold.currentState.showSnackBar(snackBar);
      return;
    }
  }

  void _onRememberMeChanged(bool newValue) => setState(() {
        rememberMe = newValue;
        print(rememberMe);
        if (rememberMe) {
          savepref(true);
          return;
        } else {
          savepref(false);
          return;
        }
      });
}
