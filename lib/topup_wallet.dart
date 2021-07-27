import 'package:aggs/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'cart.dart';
import 'login.dart';
import 'main_menu.dart';
import 'topup.dart';
import 'user.dart';
import 'user_order.dart';

class UserWallet extends StatefulWidget {
  final User user;
  const UserWallet({Key key, this.user}) : super(key: key);
  @override
  _UserWalletState createState() => _UserWalletState();
}

class _UserWalletState extends State<UserWallet> {
  TextEditingController _topUpEditingController = new TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<RefreshIndicatorState> refreshKey;
  String cartquantity = "0";
  String titlecenter = "Loading...";
  List productdata;
  double screenHeight, screenWidth;
  String server = "https://justminedb.com/aggs";
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    _loadUserData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: mainDrawer(context),
      body: RefreshIndicator(
        key: refreshKey,
        color: Colors.black,
        onRefresh: () async {
          await refreshList();
        },
        child: Stack(children: [
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
          Column(children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Text("My Wallet",
                style: TextStyle(fontSize: 28, fontFamily: "Solway")),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 427,
              child: Card(
                elevation: 10,
                child: Column(children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Top Up',
                        style: TextStyle(
                            fontFamily: 'Solway',
                            color: Colors.black,
                            fontSize: 20),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        width: 360,
                        child: TextField(
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Solway',
                          ),
                          controller: _topUpEditingController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Please enter the amount (RM)',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              elevation: 10,
                              child: Text(
                                "Proceed",
                                style: TextStyle(
                                    fontFamily: 'Solway',
                                    color: Colors.white,
                                    fontSize: 14),
                              ),
                              color: Colors.amber,
                              onPressed: () {
                                _topUp(_topUpEditingController.text.toString());
                              },
                            ),
                            SizedBox(width: 25)
                          ]),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      MaterialButton(
                        elevation: 10,
                        child: Text(
                          "RM50",
                          style: TextStyle(
                              fontFamily: 'Solway',
                              color: Colors.black,
                              fontSize: 14),
                        ),
                        onPressed: () {
                          _topUp("50");
                        },
                      ),
                      MaterialButton(
                        child: Text(
                          "RM100",
                          style: TextStyle(
                              fontFamily: 'Solway',
                              color: Colors.black,
                              fontSize: 14),
                        ),
                        onPressed: () {
                          _topUp("100");
                        },
                      ),
                      MaterialButton(
                        child: Text(
                          "RM200",
                          style: TextStyle(
                              fontFamily: 'Solway',
                              color: Colors.black,
                              fontSize: 14),
                        ),
                        onPressed: () {
                          _topUp("200");
                        },
                      ),
                      MaterialButton(
                        child: Text(
                          "RM500",
                          style: TextStyle(
                              fontFamily: 'Solway',
                              color: Colors.black,
                              fontSize: 14),
                        ),
                        onPressed: () {
                          _topUp("500");
                        },
                      ),
                    ],
                  ),
                ]),
              ),
            ),
            Container(
              width: 427,
              child: Card(
                elevation: 10,
                child: Column(children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Current Balance',
                        style: TextStyle(
                            fontFamily: 'Solway',
                            color: Colors.black,
                            fontSize: 16),
                      ),
                    ],
                  ),
                  Row(children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'RM ',
                      style: TextStyle(
                          fontFamily: 'Solway',
                          color: Colors.black,
                          fontSize: 16),
                    ),
                    Text(
                      widget.user.wallet,
                      style: TextStyle(
                          fontFamily: 'Solway',
                          color: Colors.black,
                          fontSize: 24),
                    ),
                  ]),
                  SizedBox(height: 10),
                ]),
              ),
            ),
          ]),
        ]),
      ),
    );
  }

  _topUp(String uwallet) {
    print("RM " + uwallet);
    if (uwallet.length <= 0) {
      final snackBar = SnackBar(
        content: Text(
          'Please enter correct amount',
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
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Top up RM' + uwallet + '?',
          style: TextStyle(fontFamily: 'Solway', color: Colors.black),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                Navigator.of(context).pop(false);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => TopUp(
                              user: widget.user,
                              val: uwallet,
                            )));
              },
              child: Text(
                "Yes",
                style: TextStyle(fontFamily: 'Solway', color: Colors.black),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                _loadUserData();
              },
              child: Text(
                "No",
                style: TextStyle(fontFamily: 'Solway', color: Colors.black),
              )),
        ],
      ),
    );
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    _loadData();
    _loadUserData();

    return null;
  }

  void _loadData() async {
    String urlLoadJobs = server + "/php/load_userdata.php";
    await http.post(urlLoadJobs, body: {}).then((res) {
      if (res.body == "nodata") {
        cartquantity = "0";
        titlecenter = "No product found";
        setState(() {});return;
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          productdata = extractdata["products"];
          cartquantity = widget.user.quantity;
        });return;
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
        setState(() {});return;
      } else {
        setState(() {
          widget.user.wallet = res.body;
        });return;
      }
    }).catchError((err) {
      print(err);
    });
  }

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
            ListTile(
                leading: Icon(
                  Icons.shopping_cart,
                  size: 36,
                  color: Colors.amber,
                ),
                title: Text(
                  "My Cart",
                  style: TextStyle(
                      fontSize: 15, color: Colors.black, fontFamily: "Solway"),
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
            ListTile(
                leading: Icon(
                  Icons.local_shipping_outlined,
                  size: 36,
                  color: Colors.amber,
                ),
                title: Text(
                  "My Order",
                  style: TextStyle(
                      fontSize: 15, color: Colors.black, fontFamily: "Solway"),
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
                                  ))),
                      _loadUserData()
                    }),
            ListTile(
                leading: Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 36,
                  color: Colors.amber,
                ),
                title: Text(
                  "My Wallet",
                  style: TextStyle(
                      fontSize: 15, color: Colors.black, fontFamily: "Solway"),
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
}
