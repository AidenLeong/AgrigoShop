import 'dart:convert';
import 'dart:io';
import 'package:aggs/cart.dart';
import 'package:aggs/login.dart';
import 'package:aggs/main_menu.dart';
import 'package:aggs/user.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recase/recase.dart';
import 'package:http/http.dart' as http;
import 'manage_product.dart';
import 'shipment.dart';
import 'topup_wallet.dart';
import 'user_order.dart';

class UserProfile extends StatefulWidget {
  final User user;
  const UserProfile({Key key, this.user}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<RefreshIndicatorState> refreshKey;
  TextEditingController emailController = TextEditingController();

  String uploadImageUrl =
      'https://justminedb.com/aggs/php/upload_profile_image.php';
  String cartquantity = "0";
  String titlecenter = "Loading...";
  String server = "https://justminedb.com/aggs";
  String getStatsUrl = "https://justminedb.com/aggs/php/get_statistic.php";
  double height, width;
  bool _isseller = false;
  bool _isbuyer = false;
  int orders;
  List productdata;
  int items;
  File _image;

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadCartQuantity();
    print(double.parse(widget.user.wallet).roundToDouble());
    imageCache.clear();
    imageCache.clearLiveImages();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    if (widget.user.role == "Seller") {
      _isseller = true;
      print(widget.user.role);
    }
    if (widget.user.role == "Buyer") {
      _isbuyer = true;
      print("User is " + widget.user.role);
    }
    print(widget.user.country);
    _getStats();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return WillPopScope(
        onWillPop: () async => true,
        child: Scaffold(
          key: scaffoldKey,
          drawer: mainDrawer(context),
          body: RefreshIndicator(
            key: refreshKey,
            color: Color.fromRGBO(101, 255, 218, 50),
            onRefresh: () async {
              await refreshList();
            },
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: 0,
                  top: 25,
                  child: RawMaterialButton(
                    onPressed: () {
                      scaffoldKey.currentState.openDrawer();
                    },
                    elevation: 8.0,
                    fillColor: Colors.white,
                    child: Icon(Icons.menu, color: Colors.amber),
                    padding: EdgeInsets.all(8.0),
                    shape: CircleBorder(),
                  ),
                ),
                _buildTopHalf(),
                _buildBottomHalf(),
              ],
            ),
          ),
        ));
  }

//Drawer Interface
  Widget mainDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 2),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.grey],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 90,
                    width: 90,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(90),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/loading.gif',
                        image:
                            'https://justminedb.com/aggs/user_images/${widget.user.email}.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.user.name,
                        style: TextStyle(
                            fontFamily: "Solway", fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 8),
                      Text(widget.user.email,
                          style: TextStyle(
                              fontFamily: "Solway",
                              fontWeight: FontWeight.w600)),
                      SizedBox(height: 8),
                    ],
                  )
                ],
              ),
            ),
            ListTile(
                leading: Icon(
                  Icons.article_outlined,
                  size: 36,
                  color: Colors.amber,
                ),
                title: Text(
                  "Product List",
                  style: TextStyle(
                      fontSize: 15, color: Colors.black, fontFamily: "Solway"),
                ),
                onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => MainMenu(
                                    user: widget.user,
                                  ))),
                      _loadData(),
                    }),
            Visibility(
              visible: _isbuyer,
              child: ListTile(
                  leading: Icon(
                    Icons.shopping_cart,
                    size: 36,
                    color: Colors.amber,
                  ),
                  title: Text(
                    "My Cart",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontFamily: "Solway"),
                  ),
                  onTap: () => {
                        Navigator.pop(context),
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => Cart(
                                      user: widget.user,
                                    ))),
                      }),
            ),
            Visibility(
              visible: _isbuyer,
              child: ListTile(
                  leading: Icon(
                    Icons.local_shipping_outlined,
                    size: 36,
                    color: Colors.amber,
                  ),
                  title: Text(
                    "My Order",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontFamily: "Solway"),
                  ),
                  onTap: () => {
                        Navigator.pop(context),
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => UserOrder(
                                      user: widget.user,
                                    )))
                      }),
            ),
            Visibility(
              visible: _isseller,
              child: ListTile(
                  leading: Icon(
                    Icons.settings,
                    size: 36,
                    color: Colors.amber,
                  ),
                  title: Text(
                    "Manage Product",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontFamily: "Solway"),
                  ),
                  onTap: () => {
                        Navigator.pop(context),
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ManageProduct(
                                      user: widget.user,
                                    )))
                      }),
            ),
            Visibility(
              visible: _isseller,
              child: ListTile(
                  leading: Icon(
                    Icons.local_shipping_outlined,
                    size: 36,
                    color: Colors.amber,
                  ),
                  title: Text(
                    "Shipments",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontFamily: "Solway"),
                  ),
                  onTap: () => {
                        Navigator.pop(context),
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => Shipment(
                                      user: widget.user,
                                    )))
                      }),
            ),
            ListTile(
                leading: Icon(
                  Icons.account_circle,
                  size: 36,
                  color: Colors.amber,
                ),
                title: Text(
                  "User Profile",
                  style: TextStyle(
                      fontSize: 15, color: Colors.black, fontFamily: "Solway"),
                ),
                onTap: () => {
                      Navigator.pop(context),
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => UserProfile(
                                    user: widget.user,
                                  )))
                    }),
            Visibility(
              visible: _isbuyer,
              child: ListTile(
                  leading: Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 36,
                    color: Colors.amber,
                  ),
                  title: Text(
                    "My Wallet",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontFamily: "Solway"),
                  ),
                  onTap: () => {
                        Navigator.pop(context),
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => UserWallet(
                                      user: widget.user,
                                    )))
                      }),
            ),
            Divider(
              thickness: 1,
            ),
            ListTile(
                leading: Icon(
                  Icons.power_settings_new_rounded,
                  size: 36,
                  color: Colors.amber,
                ),
                title: Text(
                  "Log Out",
                  style: TextStyle(
                      fontSize: 15, color: Colors.black, fontFamily: "Solway"),
                ),
                onTap: () => {
                      Navigator.pop(context),
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Login()))
                    }),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHalf() {
    return Stack(
      children: <Widget>[
        Container(
          width: width,
          height: height / 1.65,
          child: FadeInImage.assetNetwork(
            placeholder: 'assets/images/loading.gif',
            image:
                'https://justminedb.com/aggs/user_images/${widget.user.email}.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Container(
          width: width,
          height: height / 1.65,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xFFF4F4F4).withOpacity(0.1),
              Color(0xFFF4F4F4).withOpacity(0.3),
              Color(0xFFF4F4F4).withOpacity(0.75),
              Color(0xFFF4F4F4).withOpacity(1),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            border: Border.all(
              color: Colors.white.withOpacity(0),
            ),
          ),
        ),
        Positioned(
          top: height / 1.95,
          right: 16,
          child: GestureDetector(
            onTap: () => _choose(),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey[200],
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.camera,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: height / 1.95,
          right: 72,
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => new AlertDialog(
                  title: Text(
                    "Update Profile",
                    style: TextStyle(fontFamily: "Solway"),
                  ),
                  actions: <Widget>[
                    MaterialButton(
                      onPressed: changeName,
                      child: Text(
                        "CHANGE USERNAME",
                        style: TextStyle(fontFamily: "Solway"),
                      ),
                    ),
                    MaterialButton(
                      onPressed: changeAddress,
                      child: Text(
                        "CHANGE ADDRESS",
                        style: TextStyle(fontFamily: "Solway"),
                      ),
                    ),
                    MaterialButton(
                      onPressed: changePassword,
                      child: Text(
                        "CHANGE PASSWORD",
                        style: TextStyle(fontFamily: "Solway"),
                      ),
                    ),
                    MaterialButton(
                      onPressed: changePhone,
                      child: Text(
                        "CHANGE CONTACT NUMBER",
                        style: TextStyle(fontFamily: "Solway"),
                      ),
                    ),
                  ],
                ),
              );
            },
            child: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey[300],
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: height / 1.9,
          left: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(widget.user.name,
                      style: TextStyle(
                        fontFamily: "Solway",
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      )),
                  SizedBox(width: 12),
                  Icon(
                    Icons.verified_user_outlined,
                    color: Colors.green,
                  ),
                ],
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
        Positioned(
          left: 0,
          top: 25,
          child: RawMaterialButton(
            onPressed: () {
              scaffoldKey.currentState.openDrawer();
            },
            elevation: 8.0,
            fillColor: Colors.white,
            child: Icon(
              Icons.menu,
              color: Colors.amber,
            ),
            padding: EdgeInsets.all(8.0),
            shape: CircleBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomHalf() {
    return Stack(
      children: [
        Positioned(
            bottom: 0,
            width: width,
            height: height / 2.75,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    "Email Address",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Solway",
                        fontSize: 18),
                  ),
                ]),
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      widget.user.email,
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: "Solway",
                          fontSize: 16),
                    ),
                  ],
                ),
                Divider(
                  thickness: 1,
                ),
                Row(children: [
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    "Address",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Solway",
                        fontSize: 18),
                  ),
                ]),
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    Flexible(
                      child: Text(
                        widget.user.address +
                            ", " +
                            widget.user.city +
                            ", " +
                            widget.user.country,
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontFamily: "Solway",
                            fontSize: 16),
                      ),
                    ),
                  ],
                ),
                Divider(
                  thickness: 1,
                ),
                Row(children: [
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    "Contact Number",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Solway",
                        fontSize: 18),
                  ),
                ]),
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      widget.user.phone,
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: "Solway",
                          fontSize: 16),
                    ),
                  ],
                ),
                Divider(
                  thickness: 1,
                ),
                Row(children: [
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    "My Wallet",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Solway",
                        fontSize: 18),
                  ),
                ]),
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      "RM " + widget.user.wallet,
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: "Solway",
                          fontSize: 16),
                    ),
                  ],
                ),
                Divider(
                  thickness: 1,
                ),
              ],
            )),
      ],
    );
  }

  void changeName() {
    TextEditingController nameController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Change your name?",
                style: TextStyle(color: Colors.black, fontFamily: "Solway"),
              ),
              content: new TextField(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(fontFamily: "Solway"),
                    icon: Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                  )),
              actions: <Widget>[
                // ignore: deprecated_member_use
                new FlatButton(
                    child: new Text(
                      "Yes",
                      style:
                          TextStyle(color: Colors.black, fontFamily: "Solway"),
                    ),
                    onPressed: () =>
                        _changeName(nameController.text.toString())),
                // ignore: deprecated_member_use
                new FlatButton(
                  child: new Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black, fontFamily: "Solway"),
                  ),
                  onPressed: () => {Navigator.of(context).pop()},
                ),
              ]);
        });
  }

  _changeName(String name) {
    if (name == "" || name == null) {
      final snackBar = SnackBar(
        content: Text(
          'Please enter new username',
          style: TextStyle(fontFamily: "Solway"),
        ),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {},
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    ReCase rc = new ReCase(name);
    print(rc.titleCase.toString());
    http.post(server + "/php/update_profile.php", body: {
      "email": widget.user.email,
      "name": rc.titleCase.toString(),
    }).then((res) {
      if (res.body == "success") {
        print('in success');

        setState(() {
          widget.user.name = rc.titleCase;
        });
        final snackBar = SnackBar(
          content: Text(
            'Success',
            style: TextStyle(fontFamily: "Solway"),
          ),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {},
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.of(context).pop();
        return;
      } else {}
    }).catchError((err) {
      print(err);
    });
  }

  void changeAddress() {
    TextEditingController addressController = TextEditingController();
    TextEditingController cityController = TextEditingController();
    TextEditingController countryController = TextEditingController();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Change your address?",
                style: TextStyle(color: Colors.black, fontFamily: "Solway"),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new TextField(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      controller: addressController,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        labelStyle: TextStyle(fontFamily: "Solway"),
                        icon: Icon(
                          Icons.location_city,
                          color: Colors.black,
                        ),
                      )),
                  TextField(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      controller: cityController,
                      decoration: InputDecoration(
                        labelText: 'City',
                        labelStyle: TextStyle(fontFamily: "Solway"),
                        icon: Icon(
                          Icons.location_city,
                          color: Colors.black,
                        ),
                      )),
                  TextField(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      controller: countryController,
                      decoration: InputDecoration(
                        labelText: 'Country',
                        labelStyle: TextStyle(fontFamily: "Solway"),
                        icon: Icon(
                          Icons.location_city,
                          color: Colors.black,
                        ),
                      )),
                ],
              ),
              actions: <Widget>[
                // ignore: deprecated_member_use
                new FlatButton(
                    child: new Text(
                      "Yes",
                      style:
                          TextStyle(color: Colors.black, fontFamily: "Solway"),
                    ),
                    onPressed: () => _changeAddress(
                        addressController.text.toString(),
                        cityController.text.toString(),
                        countryController.text.toString())),
                // ignore: deprecated_member_use
                new FlatButton(
                  child: new Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black, fontFamily: "Solway"),
                  ),
                  onPressed: () => {Navigator.of(context).pop()},
                ),
              ]);
        });
  }

  _changeAddress(String address, String city, String country) {
    if (address == "" ||
        address == null ||
        city == "" ||
        city == null ||
        country == "" ||
        country == null) {
      final snackBar = SnackBar(
        content: Text(
          'Please enter new address',
          style: TextStyle(fontFamily: "Solway"),
        ),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {},
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    ReCase rc = new ReCase(address);
    ReCase rcCity = new ReCase(city);
    ReCase rcCountry = new ReCase(country);
    print(rc.titleCase.toString());
    http.post(server + "/php/update_profile.php", body: {
      "email": widget.user.email,
      "address": rc.titleCase.toString(),
      "city": rcCity.titleCase.toString(),
      "country": rcCountry.titleCase.toString(),
    }).then((res) {
      if (res.body == "success") {
        print('in success');

        setState(() {
          widget.user.address = address;
          widget.user.city = city;
          widget.user.country = country;
        });
        final snackBar = SnackBar(
          content: Text(
            'Success',
            style: TextStyle(fontFamily: "Solway"),
          ),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {},
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.of(context).pop();
        return;
      } else {}
    }).catchError((err) {
      print(err);
    });
  }

  void changePassword() {
    TextEditingController passController = TextEditingController();
    TextEditingController pass2Controller = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Change your password?",
                style: TextStyle(color: Colors.black, fontFamily: "Solway"),
              ),
              content: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      controller: passController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Old Password',
                        labelStyle: TextStyle(fontFamily: "Solway"),
                        icon: Icon(
                          Icons.lock,
                          color: Colors.black,
                        ),
                      )),
                  TextField(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      obscureText: true,
                      controller: pass2Controller,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        labelStyle: TextStyle(fontFamily: "Solway"),
                        icon: Icon(
                          Icons.lock,
                          color: Colors.black,
                        ),
                      )),
                ],
              ),
              actions: <Widget>[
                // ignore: deprecated_member_use
                new FlatButton(
                    child: new Text(
                      "Yes",
                      style:
                          TextStyle(color: Colors.black, fontFamily: "Solway"),
                    ),
                    onPressed: () => updatePassword(
                        passController.text, pass2Controller.text)),
                // ignore: deprecated_member_use
                new FlatButton(
                  child: new Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black, fontFamily: "Solway"),
                  ),
                  onPressed: () => {Navigator.of(context).pop()},
                ),
              ]);
        });
  }

  updatePassword(String pass1, String pass2) {
    if (pass1 == "" || pass2 == "") {
      final snackBar = SnackBar(
        content: Text(
          'Please enter new password',
          style: TextStyle(fontFamily: "Solway"),
        ),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {},
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    http.post(server + "/php/update_profile.php", body: {
      "email": widget.user.email,
      "oldpassword": pass1,
      "newpassword": pass2,
    }).then((res) {
      if (res.body == "success") {
        print('in success');
        setState(() {
          widget.user.password = pass2;
        });
        final snackBar = SnackBar(
          content: Text(
            'Success',
            style: TextStyle(fontFamily: "Solway"),
          ),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {},
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.of(context).pop();
        return;
      } else {}
    }).catchError((err) {
      print(err);
    });
  }

  void changePhone() {
    TextEditingController phoneController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Change contact number?",
                style: TextStyle(color: Colors.black, fontFamily: "Solway"),
              ),
              content: new TextField(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'New Contact Number',
                    labelStyle: TextStyle(fontFamily: "Solway"),
                    icon: Icon(
                      Icons.phone,
                      color: Colors.black,
                    ),
                  )),
              actions: <Widget>[
                // ignore: deprecated_member_use
                new FlatButton(
                    child: new Text(
                      "Yes",
                      style:
                          TextStyle(color: Colors.black, fontFamily: "Solway"),
                    ),
                    onPressed: () =>
                        _changePhone(phoneController.text.toString())),
                // ignore: deprecated_member_use
                new FlatButton(
                  child: new Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black, fontFamily: "Solway"),
                  ),
                  onPressed: () => {Navigator.of(context).pop()},
                ),
              ]);
        });
  }

  _changePhone(String phone) {
    if (phone == "" || phone == null || phone.length < 9) {
      final snackBar = SnackBar(
        content: Text(
          'Please enter new contact number',
          style: TextStyle(fontFamily: "Solway"),
        ),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {},
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    http.post(server + "/php/update_profile.php", body: {
      "email": widget.user.email,
      "phone": phone,
    }).then((res) {
      if (res.body == "success") {
        print('in success');

        setState(() {
          widget.user.phone = phone;
        });
        final snackBar = SnackBar(
          content: Text(
            'Success',
            style: TextStyle(fontFamily: "Solway"),
          ),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {},
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.of(context).pop();
        return;
      } else {}
    }).catchError((err) {
      print(err);
    });
  }

  void _getStats() {
    http.post(getStatsUrl, body: {
      "email": widget.user.email,
    }).then((res) {
      List<String> responses = res.body.split(', ');

      setState(() {
        if (responses[0] == 'Success') {
          orders = int.parse(responses[1]);
          items = int.parse(responses[2]);
        } else {
          orders = 0;
          items = 0;
        }
      });
    }).catchError((err) {
      print(err);
    });
  }

  void _loadData() async {
    String urlLoadJobs = server + "/php/load_products.php";
    await http.post(urlLoadJobs, body: {}).then((res) {
      if (res.body == "nodata") {
        cartquantity = "0";
        titlecenter = "No product found";
        setState(() {
          productdata = null;
        });
        return;
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          productdata = extractdata["products"];
          cartquantity = widget.user.quantity;
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _loadCartQuantity() async {
    String urlLoadJobs = server + "/php/load_cartquantity.php";
    await http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      if (res.body == "nodata") {
      } else {
        widget.user.quantity = res.body;
      }
    }).catchError((err) {
      print(err);
    });
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    _loadData();
    return null;
  }

  void _choose() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      uploadImage(_image);
    });
  }

  void uploadImage(File imageFile) async {
    String base64Image = base64Encode(imageFile.readAsBytesSync());
    http.post(uploadImageUrl, body: {
      "encoded_string": base64Image,
      "email": widget.user.email,
    }).then((res) {
      if (res.body == "Upload Successful") {
        final snackBar = SnackBar(
          content: Text(
            'Upload success, please refresh this page',
            style: TextStyle(fontFamily: "Solway"),
          ),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {},
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      } else {
        final snackBar = SnackBar(
          content: Text(
            'Upload failed, please try again',
            style: TextStyle(fontFamily: "Solway"),
          ),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {},
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _loadUserData() async {
    String urlLoadJobs = server + "/php/load_userdata.php";
    await http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      if (res.body == "nodata") {
        setState(() {});
        return;
      } else {
        setState(() {
          widget.user.wallet = res.body;
          return;
        });
      }
    }).catchError((err) {
      print(err);
    });
  }
}
