import 'dart:convert';

import 'package:aggs/cart.dart';
import 'package:aggs/login.dart';
import 'package:aggs/main_menu.dart';
import 'package:aggs/order.dart';
import 'package:aggs/user.dart';
import 'package:aggs/user_profile.dart';
//import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// ignore: unused_import
import 'package:recase/recase.dart';
// ignore: unused_import
import 'package:http/http.dart' as http;
import 'order_detail.dart';
import 'topup_wallet.dart';

class UserOrder extends StatefulWidget {
  final User user;
  const UserOrder({Key key, this.user}) : super(key: key);
  static final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  _UserOrderState createState() => _UserOrderState();
}

class _UserOrderState extends State<UserOrder> {
  //final GlobalKey<ScaffoldState> _scaffold = new GlobalKey<ScaffoldState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  String cartquantity = "0";
  String titlecenter = "Loading...";
  List productdata;
  double screenHeight, screenWidth;
  String server = "https://justminedb.com/aggs";
  int quantity = 1;
  double height, width;
  List _paymentdata;
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  var parsedDate;

  @override
  void initState() {
    super.initState();
    print(widget.user.address);
    _loadPaymentHistory();
    _loadCartQuantity();
    print(widget.user.quantity);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        key: scaffoldKey,
        drawer: mainDrawer(context),
        body: Stack(
          children: <Widget>[
            Column(children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Text("My Orders",
                  style: TextStyle(fontSize: 28, fontFamily: "Solway")),
              _paymentdata == null
                  ? Flexible(
                      child: Container(
                          child: Center(
                              child: Text(
                      titlecenter,
                      style: TextStyle(
                          fontFamily: 'Solway',
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ))))
                  : Expanded(
                      child: ListView.builder(
                          itemCount:
                              _paymentdata == null ? 0 : _paymentdata.length,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                child: InkWell(
                                    onTap: () => loadOrderDetails(index),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 1),
                                      child: Card(
                                        color: Colors.blueAccent[50],
                                        elevation: 50,
                                        child: Table(
                                          defaultColumnWidth:
                                              FlexColumnWidth(1),
                                          columnWidths: {
                                            0: FlexColumnWidth(0.1),
                                            1: FlexColumnWidth(0.1),
                                          },
                                          children: [
                                            TableRow(
                                              children: [
                                                TableCell(
                                                  child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      height: 30,
                                                      child: Text(
                                                          "     Order ID ",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Solway',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .black))),
                                                ),
                                                TableCell(
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 30,
                                                    child: Text(
                                                      _paymentdata[index]
                                                          ['orderid'],
                                                      style: TextStyle(
                                                          fontFamily: 'Solway',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            TableRow(
                                              children: [
                                                TableCell(
                                                  child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      height: 30,
                                                      child: Text(
                                                          "     Total Amount ",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Solway',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .black))),
                                                ),
                                                TableCell(
                                                  child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      height: 30,
                                                      child: Text(
                                                        "RM " +
                                                            _paymentdata[index]
                                                                ['total'],
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Solway',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      )),
                                                ),
                                              ],
                                            ),
                                            TableRow(
                                              children: [
                                                TableCell(
                                                  child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      height: 30,
                                                      child: Text(
                                                          "     Place On ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  'Solway',
                                                              color: Colors
                                                                  .black))),
                                                ),
                                                TableCell(
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 30,
                                                    child: Text(
                                                      f.format(DateTime.parse(
                                                          _paymentdata[index]
                                                              ['date'])),
                                                      style: TextStyle(
                                                          fontFamily: 'Solway',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            TableRow(
                                              children: [
                                                TableCell(
                                                  child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      height: 30,
                                                      child: Text(
                                                          "     Ship From ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  'Solway',
                                                              color: Colors
                                                                  .black))),
                                                ),
                                                TableCell(
                                                  child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      height: 30,
                                                      child: Text(
                                                        _paymentdata[index]
                                                            ['selleremail'],
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Solway',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      )),
                                                ),
                                              ],
                                            ),
                                            TableRow(
                                              children: [
                                                TableCell(
                                                  child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      height: 30,
                                                      child: Text(
                                                          "     Delivery Fees",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  'Solway',
                                                              color: Colors
                                                                  .black))),
                                                ),
                                                TableCell(
                                                  child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      height: 30,
                                                      child: Text(
                                                        'RM' +
                                                            _paymentdata[index]
                                                                ['delivery'],
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Solway',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      )),
                                                ),
                                              ],
                                            ),
                                            widget.user.country != "Malaysia"
                                                ? TableRow(
                                                    children: [
                                                      TableCell(
                                                        child: Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            height: 30,
                                                            child: Text(
                                                                "     International Delivery",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontFamily:
                                                                        'Solway',
                                                                    color: Colors
                                                                        .black))),
                                                      ),
                                                      TableCell(
                                                        child: Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            height: 30,
                                                            child: Text(
                                                              'RM 10.00',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Solway',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black),
                                                            )),
                                                      ),
                                                    ],
                                                  )
                                                : TableRow(
                                                    children: [
                                                      TableCell(
                                                        child: Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            height: 30,
                                                            child: Text(
                                                                "     Status ",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontFamily:
                                                                        'Solway',
                                                                    color: Colors
                                                                        .black))),
                                                      ),
                                                      TableCell(
                                                        child: Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            height: 30,
                                                            child: Text(
                                                              _paymentdata[
                                                                      index]
                                                                  ['status'],
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Solway',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black),
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                          ],
                                        ),
                                      ),
                                    )));
                          }))
            ]),
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
          ],
        ),
      ),
    );
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
                                  )))
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

  Future<void> _loadPaymentHistory() async {
    String urlLoadJobs = "https://justminedb.com/aggs/php/load_order.php";
    await http
        .post(urlLoadJobs, body: {"email": widget.user.email}).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        setState(() {
          _paymentdata = null;
          titlecenter = "No Previous Payment";
        });
        return;
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          _paymentdata = extractdata["payment"];
        });
        return;
      }
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
        return;
      }
    }).catchError((err) {
      print(err);
    });
  }

  loadOrderDetails(int index) {
    Order order = new Order(
        billid: _paymentdata[index]['billid'],
        orderid: _paymentdata[index]['orderid'],
        total: _paymentdata[index]['total'],
        dateorder: _paymentdata[index]['date'],
        selleremail: _paymentdata[index]['selleremail'],
        id: _paymentdata[index]['id'],
        weight: _paymentdata[index]['weight'],
        ttlprice: _paymentdata[index]['ttlprice'],
        status: _paymentdata[index]['status']);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => OrderDetail(
                  order: order,
                )));
  }

  void _loadCartQuantity() async {
    String urlLoadJobs = server + "/php/load_cartquantity.php";
    await http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      if (res.body == "nodata") {
        return;
      } else {
        widget.user.quantity = res.body;
        return;
      }
    }).catchError((err) {
      print(err);
    });
  }
}
