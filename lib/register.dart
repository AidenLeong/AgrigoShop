import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'firstpage.dart';
import 'login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<ScaffoldState> _scaffold = new GlobalKey<ScaffoldState>();
  String uploadImageUrl =
      'https://justminedb.com/aggs/php/upload_profile_image.php';
  TextEditingController roleController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String urlRegister = "https://justminedb.com/aggs/php/register_user.php";
  String urlCheck = "https://justminedb.com/aggs/php/check_email.php";

  double width;
  String role, name, email, phone, password, address;
  File _image;
  String pathAsset = 'assets/images/phonecam.png';
  int selectedRadio;
  double screenHeight, screenWidth;
  bool _isChecked = false;
  bool _isHidden = true;
  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        key: _scaffold,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Stack(children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                          onTap: () => {_choose()},
                          child: Container(
                            height: screenHeight / 6.6,
                            width: screenWidth / 3,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: _image == null
                                    ? AssetImage(pathAsset)
                                    : FileImage(_image),
                                fit: BoxFit.cover,
                              ),
                              border: Border.all(
                                width: 3.0,
                                color: Colors.grey,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                          )),
                    ],
                  ),
                ),
                Positioned(
                  top: 126,
                  right: 110,
                  child: GestureDetector(
                    onTap: () => _choose(),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey,
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.camera,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
              Container(
                width: 350,
                child: Column(children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Hero(
                          tag: 'role',
                          child: Material(
                            child: Text(
                              '  Role: ',
                              style:
                                  TextStyle(fontSize: 17, fontFamily: "Solway"),
                            ),
                          ),
                        ),
                        Hero(
                          tag: "roleTextField",
                          child: ButtonBar(
                            alignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Radio(
                                  value: 1,
                                  groupValue: selectedRadio,
                                  activeColor: Colors.green,
                                  onChanged: (val) {
                                    roleController.text = "Buyer";
                                    print("Buyer");
                                    setSelectedRadio(val);
                                    role = "Buyer";
                                  }),
                              new Text(
                                'Buyer',
                                style: new TextStyle(
                                  fontSize: 17.0,
                                  fontFamily: 'Solway',
                                ),
                              ),
                              Radio(
                                  value: 2,
                                  groupValue: selectedRadio,
                                  activeColor: Colors.green,
                                  onChanged: (val) {
                                    roleController.text = "Seller";
                                    print("Seller");
                                    setSelectedRadio(val);
                                    role = "Seller";
                                  }),
                              new Text(
                                'Seller',
                                style: new TextStyle(
                                  fontSize: 17.0,
                                  fontFamily: 'Solway',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                  Hero(
                    tag: 'Name',
                    child: Material(
                        child: TextField(
                      style: TextStyle(fontFamily: "Solway"),
                      controller: nameController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'Full Name',
                        prefixIcon:
                            Icon(Icons.person, color: Colors.amber[600]),
                        hintStyle: TextStyle(fontFamily: "Solway"),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.amber, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.amber, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                      ),
                    )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Hero(
                    tag: 'Email',
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
                          borderSide:
                              BorderSide(color: Colors.amber, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.amber, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                      ),
                    )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Hero(
                    tag: 'Address',
                    child: Material(
                        child: TextField(
                      style: TextStyle(fontFamily: "Solway"),
                      controller: addressController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'Address',
                        prefixIcon:
                            Icon(Icons.location_city, color: Colors.amber[600]),
                        hintStyle: TextStyle(fontFamily: "Solway"),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.amber, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.amber, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                      ),
                    )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: 170,
                          child: Hero(
                            tag: 'City',
                            child: Material(
                                child: TextField(
                              style: TextStyle(fontFamily: "Solway"),
                              controller: cityController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: 'City',
                                prefixIcon: Icon(Icons.location_city,
                                    color: Colors.amber[600]),
                                hintStyle: TextStyle(fontFamily: "Solway"),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.amber, width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.amber, width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                ),
                              ),
                            )),
                          ),
                        ),
                        Container(
                          width: 170,
                          child: Hero(
                            tag: 'Country',
                            child: Material(
                                child: TextField(
                              style: TextStyle(fontFamily: "Solway"),
                              controller: countryController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: 'Country',
                                prefixIcon: Icon(Icons.location_city,
                                    color: Colors.amber[600]),
                                hintStyle: TextStyle(fontFamily: "Solway"),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.amber, width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.amber, width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                ),
                              ),
                            )),
                          ),
                        ),
                      ]),
                  SizedBox(
                    height: 10,
                  ),
                  Hero(
                    tag: 'Password',
                    child: Material(
                        child: TextField(
                      style: TextStyle(fontFamily: "Solway"),
                      controller: passwordController,
                      obscureText: _isHidden,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: Icon(Icons.lock, color: Colors.amber[600]),
                        hintStyle: TextStyle(fontFamily: "Solway"),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.amber, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.amber, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        suffix: InkWell(
                            onTap: _togglePasswordView,
                            child: Icon(
                                _isHidden
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.amber[600])),
                      ),
                    )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Hero(
                    tag: 'Phone',
                    child: Material(
                        child: TextField(
                      style: TextStyle(fontFamily: "Solway"),
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'Contact Number',
                        prefixIcon:
                            Icon(Icons.phone_android, color: Colors.amber[600]),
                        hintStyle: TextStyle(fontFamily: "Solway"),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.amber, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.amber, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                      ),
                    )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Checkbox(
                          value: _isChecked,
                          onChanged: (bool value) {
                            _onChange(value);
                          },
                        ),
                        Text('I accept to the',
                            style: TextStyle(
                              fontFamily: 'Solway',
                              fontSize: 14,
                            )),

                        //Click for show EULA
                        GestureDetector(
                          onTap: _showEULA,
                          child: Text('Terms and Condition',
                              style: TextStyle(
                                  fontFamily: 'Solway',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline)),
                        ),
                      ]),
                  Row(children: <Widget>[
                    Hero(
                      tag: 'check',
                      child: MaterialButton(
                        child: Text(
                          "Check Email ",
                          style: TextStyle(fontFamily: "Solway"),
                        ),
                        color: Colors.amber,
                        onPressed: () {
                          if (emailController.text == "" ||
                              emailController.text == null) {
                            final snackBar = SnackBar(
                              content: Text('Please enter user email!',
                                  style: TextStyle(fontFamily: "Solway")),
                              action: SnackBarAction(
                                label: 'Close',
                                textColor: Colors.white,
                                onPressed: () {},
                              ),
                            );
                            // ignore: deprecated_member_use
                            _scaffold.currentState.showSnackBar(
                              snackBar,
                            );
                            return;
                          } else {
                            checkEmail();
                            return;
                          }
                        },
                        height: 42.0,
                        minWidth: width ?? 168,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(12.0)),
                      ),
                    ),
                    SizedBox(width: 12),
                    Hero(
                      tag: 'registerButton',
                      child: MaterialButton(
                        child: Text(
                          "Sign Up",
                          style: TextStyle(fontFamily: "Solway"),
                        ),
                        color: Colors.amber,
                        onPressed: _onRegister,
                        height: 45.0,
                        minWidth: width ?? 168,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(12.0)),
                      ),
                    ),
                  ]),
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
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainPage())),
                          height: 42.0,
                          minWidth: width ?? 345,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(12.0)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Already have an account? Click',
                        style: TextStyle(fontFamily: "Solway"),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        child: Text(
                          'Login',
                          style: TextStyle(fontFamily: "Solway").copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.amber,
                          ),
                        ),
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login())),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ]),
              ),
            ],
          ),
        ));
  }

  void checkEmail() {
    String _email = emailController.text;
    http.post(urlCheck, body: {
      "email": _email,
    }).then((res) {
      if (res.body == "failed") {
        print(res.body);
        final snackBar = SnackBar(
          content: Text('Email exists! Please input another email.',
              style: TextStyle(fontFamily: "Solway")),
          action: SnackBarAction(
            label: 'Close',
            textColor: Colors.white,
            onPressed: () {},
          ),
        );
        // ignore: deprecated_member_use
        _scaffold.currentState.showSnackBar(
          snackBar,
        );
        return;
      } else {
        final snackBar = SnackBar(
          content: Text('Email is available to use',
              style: TextStyle(
                fontFamily: "Solway",
              )),
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
  }

  void _showEULA() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "EULA of Agrigo Shop",
            style: TextStyle(
              fontFamily: 'Solway',
            ),
          ),
          content: new Container(
            height: screenHeight / 2,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: new SingleChildScrollView(
                    child: RichText(
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'Solway',
                              color: Colors.black,
                              //fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                            ),
                            text:
                                "This End-User License Agreement is a legal agreement between you and Agrigo Shop. This EULA agreement governs your acquisition and use of our Agrigo Shop application directly from Agrigo Shop or indirectly through a Agrigo Shop authorized reseller or distributor (a Reseller). Please read this EULA agreement carefully before completing the installation process and using the Agrigo Shop application. It provides a license to use the Agrigo Shop application and contains warranty information and liability disclaimers. By clicking accept or installing and/or using the Agrigo Shop application, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement. If you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the software, and you must not accept this EULA agreement. This EULA agreement shall apply only to the software supplied by Agrigo Shop here with regardless of whether other software is referred to or described herein. The terms also apply to any Agrigo Shop updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply. This EULA was created by EULA Template for Agrigo Shop. Agrigo Shop shall at all times retain ownership of the software as originally downloaded by you and all subsequent downloads of the Software by you. The software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made thereto) are and shall remain the property of Agrigo Shop. Agrigo Shop reserves the right to grant licences to use the Software to third parties"
                            //children: getSpan(),
                            )),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            // ignore: deprecated_member_use
            new FlatButton(
              child: new Text(
                "Close",
                style: TextStyle(
                  fontFamily: 'Solway',
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void _register1() {
    String _name = nameController.text;
    String _email = emailController.text;
    String _phone = phoneController.text;
    String _address = addressController.text;
    String _city = cityController.text;
    String _country = countryController.text;
    String _password = passwordController.text;
    String _role = role;

    http.post(urlRegister, body: {
      "name": _name,
      "email": _email,
      "password": _password,
      "address": _address,
      "city": _city,
      "country": _country,
      "phone": _phone,
      "role": _role,
    }).then((res) {
      if (res.body == "failed") {
        print(res.body);
        final snackBar = SnackBar(
          content: Text('Registration Failed',
              style: TextStyle(fontFamily: "Solway")),
          action: SnackBarAction(
            label: 'Close',
            textColor: Colors.white,
            onPressed: () {},
          ),
        );
        // ignore: deprecated_member_use
        _scaffold.currentState.showSnackBar(
          snackBar,
        );
        return;
      } else {
        uploadImage(_image);
        final snackBar = SnackBar(
          content: Text('Registration Success',
              style: TextStyle(
                fontFamily: "Solway",
              )),
          action: SnackBarAction(
            label: 'Close',
            textColor: Colors.white,
            onPressed: () {
              Navigator.pop(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Login()));
            },
          ),
        );
        // ignore: deprecated_member_use
        _scaffold.currentState.showSnackBar(snackBar);
        return;
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _onRegister() {
    if (!_isChecked) {
      final snackBar = SnackBar(
        content: Text('Please Accept Term Before Proceed',
            style: TextStyle(
              fontFamily: "Solway",
            )),
        action: SnackBarAction(
          label: 'Close',
          textColor: Colors.white,
          onPressed: () {},
        ),
      );
      // ignore: deprecated_member_use
      _scaffold.currentState.showSnackBar(snackBar);return;
    }
    // confirmation for information
    else {
      if (!emailIsValid(emailController.text)) {
        final snackBar = SnackBar(
          content: Text(
            'Invalid email.',
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
      showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: Text(
            "Is your information is correct?",
            style: TextStyle(fontFamily: "Solway"),
          ),
          content: new Text("Please confirm your information is correct.",
              style: TextStyle(fontFamily: "Solway")),
          actions: <Widget>[
            MaterialButton(
                onPressed: () {
                  if (nameController.text == "" ||
                      nameController.text == null ||
                      roleController.text == "" ||
                      roleController.text == null ||
                      emailController.text == "" ||
                      emailController.text == null ||
                      addressController.text == "" ||
                      addressController.text == null ||
                      cityController.text == "" ||
                      cityController.text == null ||
                      countryController.text == "" ||
                      countryController.text == null ||
                      passwordController.text == "" ||
                      passwordController.text == null ||
                      phoneController.text == "" ||
                      phoneController.text == null) {
                    final snackBar = SnackBar(
                      content: Text(
                        'Incomplele user information!',
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
                    Navigator.of(context).pop();
                    return;
                  }

                  if (_image == null) {
                    final snackBar = SnackBar(
                      content: Text(
                        'Please upload a profile picture.',
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
                    Navigator.of(context).pop();
                    return;
                  } else {
                    Navigator.of(context).pop(_register1());
                    return;
                  }
                },
                child: Text(
                  "Yes",
                  style: TextStyle(
                    fontFamily: 'Solway',
                  ),
                )),
            MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                  FocusManager.instance.primaryFocus.unfocus();
                },
                child: Text("No", style: TextStyle(fontFamily: "Solway"))),
          ],
        ),
      );
    }
  }

  bool emailIsValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  void _choose() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
      //savepref(value);
    });
  }

  void uploadImage(File imageFile) async {
    String base64Image = base64Encode(imageFile.readAsBytesSync());
    http.post(uploadImageUrl, body: {
      "encoded_string": base64Image,
      "email": emailController.text,
    }).then((res) {
      if (res.body == "Upload Successful") {
      } else {
        final snackBar = SnackBar(
          content: Text(
            'Upload Failed',
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
    }).catchError((err) {
      print(err);
    });
  }
}
