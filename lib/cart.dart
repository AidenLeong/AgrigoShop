import 'dart:async';
import 'dart:convert';
import 'package:aggs/payment.dart';
import 'package:aggs/topup_wallet.dart';
//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:aggs/user.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
//import 'package:cached_network_image/cached_network_image.dart';
import 'package:random_string/random_string.dart';
import 'package:intl/intl.dart';
import 'main_menu.dart';
import 'product.dart';

class Cart extends StatefulWidget {
  final User user;
  final Product product;
  const Cart({Key key, this.user, this.product}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  List cartData;
  double screenHeight, screenWidth;
  String email;

  double _totalprice = 0.0;
  final GlobalKey<ScaffoldState> _scaffold = new GlobalKey<ScaffoldState>();
  String server = "https://justminedb.com/aggs";
  String label;
  double ttldeliveryfee = 0.0;
  double deliveryfee = 0.0, internationalfee = 0.00;
  int option;
  double amountpayable, amountwithdev;
  String titlecenter = "Loading cart...";
  int groupValue, walletValue;
  double remain;
  String i = "0";
  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffold,
      body: WillPopScope(
          onWillPop: _onBackPressed,
          child: Container(
              child: Column(
            children: <Widget>[
              SizedBox(
                height: 25,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RawMaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      elevation: 8.0,
                      fillColor: Colors.white,
                      child: Icon(Icons.arrow_back_ios_rounded),
                      padding: EdgeInsets.all(8.0),
                      shape: CircleBorder(),
                    ),
                    Text("My Cart",
                        style: TextStyle(fontSize: 28, fontFamily: "Solway")),
                    RawMaterialButton(
                      onPressed: () {
                        deleteAll();
                      },
                      elevation: 8.0,
                      fillColor: Colors.white,
                      child: Icon(Icons.delete),
                      padding: EdgeInsets.all(8.0),
                      shape: CircleBorder(),
                    ),
                  ]),
              cartData == null
                  ? Flexible(
                      child: Container(
                          child: Center(
                              child: Text(
                      titlecenter,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontFamily: 'Solway',
                          fontWeight: FontWeight.bold),
                    ))))
                  : Expanded(
                      child: ListView.builder(
                          itemCount: cartData == null ? 1 : cartData.length + 2,
                          itemBuilder: (context, index) {
                            if (index == cartData.length) {
                              return Column(children: <Widget>[
                                InkWell(
                                  onLongPress: () => {print("Delete")},
                                  child: Card(
                                    elevation: 10,
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]);
                            }

                            if (index == cartData.length + 1) {
                              return Column(children: <Widget>[
                                Card(
                                  elevation: 10,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                          height: 100,
                                          padding:
                                              EdgeInsets.fromLTRB(50, 0, 50, 0),
                                          child: Table(
                                              defaultColumnWidth:
                                                  FlexColumnWidth(1.0),
                                              columnWidths: {
                                                0: FlexColumnWidth(7),
                                                1: FlexColumnWidth(3),
                                              },
                                              children: [
                                                TableRow(children: [
                                                  TableCell(
                                                    child: Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        height: 30,
                                                        child: Text(
                                                            "Subtotal Amount ",
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
                                                          "RM" +
                                                                  _totalprice
                                                                      .toStringAsFixed(
                                                                          2) ??
                                                              "0.0",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  'Solway',
                                                              color: Colors
                                                                  .black)),
                                                    ),
                                                  ),
                                                ]),
                                                TableRow(children: [
                                                  TableCell(
                                                    child: Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        height: 30,
                                                        child: Text(
                                                            "Delivery Fees",
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
                                                          "RM" +
                                                                  ttldeliveryfee
                                                                      .toStringAsFixed(
                                                                          2) ??
                                                              "0.0",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  'Solway',
                                                              color: Colors
                                                                  .black)),
                                                    ),
                                                  ),
                                                ]),
                                                widget.user.country !=
                                                        "Malaysia"
                                                    ? TableRow(children: [
                                                        TableCell(
                                                          child: Container(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              height: 30,
                                                              child: Text(
                                                                  "International Delivery Fees",
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
                                                                "RM" +
                                                                    internationalfee.toStringAsFixed(
                                                                        2),
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontFamily:
                                                                        'Solway',
                                                                    color: Colors
                                                                        .black)),
                                                          ),
                                                        ),
                                                      ])
                                                    : TableRow(children: [
                                                        TableCell(
                                                          child: Container(),
                                                        ),
                                                        TableCell(
                                                          child: Container(),
                                                        ),
                                                      ])
                                              ])),
                                    ],
                                  ),
                                ),
                                Card(
                                  child: Column(
                                    children: <Widget>[
                                      // ignore: deprecated_member_use
                                      Container(
                                        height: 100,
                                        alignment: Alignment.center,
                                        child: Column(
                                          children: <Widget>[
                                            Row(children: <Widget>[
                                              SizedBox(
                                                width: 20,
                                                height: 40,
                                              ),
                                            ]),
                                            Row(
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 14,
                                                ),
                                                Text("  "),
                                                Flexible(
                                                  child: Text(
                                                    "Your address: \n" +
                                                        widget.user.address +
                                                        ", " +
                                                        widget.user.city +
                                                        ", " +
                                                        widget.user.country,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: "Solway",
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ]);
                            }
                            index -= 0;
                            return Container(
                                width: 10,
                                child: Card(
                                    elevation: 10,
                                    child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Row(children: <Widget>[
                                          IconButton(
                                            icon: Icon(Icons.cancel),
                                            onPressed: () =>
                                                {_deleteCart(index)},
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Container(
                                                height: screenHeight / 7,
                                                width: screenWidth / 4,
                                                child: ClipRRect(
                                                  child:
                                                      FadeInImage.assetNetwork(
                                                    placeholder:
                                                        'assets/images/loading.gif',
                                                    image: server +
                                                        "/product_images/${cartData[index]['id']}.jpg",
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Container(
                                              width: screenWidth / 2.9,
                                              child: Row(
                                                children: <Widget>[
                                                  Flexible(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          cartData[index]
                                                              ['name'],
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Solway',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          "Quantity: " +
                                                              cartData[index]
                                                                  ['cquantity'],
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'Solway',
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          "Weight: " +
                                                              cartData[index]
                                                                  ['weight'] +
                                                              " g",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'Solway',
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          "Delivery Fees: RM" +
                                                              cartData[index]
                                                                  ['delivery'],
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'Solway',
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        cartData[index]['promote'] ==
                                                                "0"
                                                            ? Text(
                                                                "Total: RM" +
                                                                    cartData[index][
                                                                        'yourprice'],
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Solway',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .black))
                                                            : Text(
                                                                "Total: RM" +
                                                                    cartData[index][
                                                                        'promote'],
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Solway',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .black))
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              )),
                                          SizedBox(
                                            width: 30,
                                          ),
                                          new Column(children: <Widget>[
                                            Container(
                                                width: 50,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    IconButton(
                                                      icon: Icon(
                                                          Icons.arrow_drop_up),
                                                      onPressed: () => {
                                                        _updateCart(
                                                            index, "add"),
                                                      },
                                                    ),
                                                    Text(
                                                      cartData[index]
                                                          ['cquantity'],
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily: 'Solway',
                                                      ),
                                                    ),
                                                    IconButton(
                                                      icon: Icon(Icons
                                                          .arrow_drop_down),
                                                      onPressed: () => {
                                                        _updateCart(
                                                            index, "remove"),
                                                      },
                                                    ),
                                                  ],
                                                )),
                                          ]),
                                        ]))));
                          })),
              Card(
                child: Column(
                  children: <Widget>[
                    Table(children: [
                      TableRow(children: [
                        TableCell(
                          child: Container(
                            height: 50,
                            alignment: Alignment.center,
                            child: Text(
                                "Total Amount:" +
                                        '\n' +
                                        'RM ' +
                                        amountpayable.toStringAsFixed(2) ??
                                    "0.0",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Solway',
                                    color: Colors.black)),
                          ),
                        ),
                        TableCell(
                          child: MaterialButton(
                              color: Colors.blue,
                              height: 50,
                              elevation: 10,
                              onPressed: () {
                                setState(() {
                                  if (double.parse(widget.user.wallet) <
                                      amountpayable) {
                                    final snackBar = SnackBar(
                                      content: Text(
                                        'Insufficient balance',
                                        style: TextStyle(fontFamily: "Solway"),
                                      ),
                                      action: SnackBarAction(
                                        label: 'Reload',
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          UserWallet(
                                                            user: widget.user,
                                                          )));
                                        },
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } else {
                                    makePayment();
                                  }
                                });
                              },
                              child: Text("Check Out",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Solway',
                                      color: Colors.white))),
                        ),
                      ])
                    ]),
                  ],
                ),
              ),
            ],
          ))),
    );
  }

  Future<bool> _onBackPressed() {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => MainMenu(
                  user: widget.user,
                )));
  }

  void _loadCart() {
    _totalprice = 0.0;
    amountpayable = 0.0;
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    pr.show();
    String urlLoadJobs = "https://justminedb.com/aggs/php/load_cart.php";
    http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.body);
      pr.hide();
      if (res.body == "Cart Empty") {
        titlecenter = "Cart is empty";

        pr.hide();
      }
      setState(() {
        var extractdata = json.decode(res.body);
        cartData = extractdata["cart"];
        if (widget.user.country != "Malaysia") {
          internationalfee = 10.0;
        }
        for (int i = 0; i < cartData.length; i++) {
          ttldeliveryfee += double.parse(cartData[i]['delivery']);
        }
        for (int i = 0; i < cartData.length; i++) {
          if (cartData[i]['promote'] == "0") {
            _totalprice = double.parse(cartData[i]['yourprice']) + _totalprice;
          } else {
            _totalprice = double.parse(cartData[i]['promote']) + _totalprice;
          }
        }

        amountpayable = _totalprice;
        amountwithdev = amountpayable + ttldeliveryfee + internationalfee;
        amountpayable = amountwithdev;
        print("amountwithdev: ");
        print(amountwithdev);
      });
    }).catchError((err) {
      print(err);
      pr.hide();
    });
    pr.hide();
  }

  void _loadCart1() {
    _totalprice = 0.0;
    amountpayable = 0.0;
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    pr.hide();
    String urlLoadJobs = "https://justminedb.com/aggs/php/load_cart.php";
    http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.body);
      pr.hide();
      if (res.body == "Cart Empty") {
        titlecenter = "Cart is empty";
        pr.hide();
      }
      setState(() {
        var extractdata = json.decode(res.body);
        cartData = extractdata["cart"];

        for (int i = 0; i < cartData.length; i++) {
          if (cartData[i]['promote'] == "0") {
            _totalprice = double.parse(cartData[i]['yourprice']) + _totalprice;
          } else {
            _totalprice = double.parse(cartData[i]['promote']) + _totalprice;
          }
        }

        amountpayable = _totalprice;
        amountwithdev = amountpayable + ttldeliveryfee + internationalfee;
        amountpayable = amountwithdev;
        print("amountwithdev: ");
        print(amountwithdev);
      });
    }).catchError((err) {
      print(err);
      pr.hide();
    });
    pr.hide();
  }

  _updateCart(int index, String op) {
    int curquantity = int.parse(cartData[index]['quantity']);
    int quantity = int.parse(cartData[index]['cquantity']);
    if (op == "add") {
      quantity++;
      if (quantity > (curquantity - 2)) {
        final snackBar = SnackBar(
          content: Text('Quantity not available'),
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
    if (op == "remove") {
      quantity--;
      if (quantity == 0) {
        _deleteCart(index);
      }
    }
    if (cartData[index]['proprice'] == "0.00") {
      double ttp = double.parse(cartData[index]['price']) * quantity;
      String urlLoadJobs = "https://justminedb.com/aggs/php/update_cart.php";
      http.post(urlLoadJobs, body: {
        "email": widget.user.email,
        "id": cartData[index]['id'],
        "quantity": quantity.toString(),
        "ttlprice": ttp.toString(),
      }).then((res) {
        print(res.body);
        if (res.body == "success") {
          _loadCart1();
          final snackBar = SnackBar(
            content: Text(
              'Cart Updated!',
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
        } else {
          final snackBar = SnackBar(
            content: Text('Failed'),
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
    } else {
      double ttp = double.parse(cartData[index]['proprice']) * quantity;
      String urlLoadJobs = "https://justminedb.com/aggs/php/update_cart.php";
      http.post(urlLoadJobs, body: {
        "email": widget.user.email,
        "id": cartData[index]['id'],
        "quantity": quantity.toString(),
        "ttlprice": ttp.toString(),
      }).then((res) {
        print(res.body);
        if (res.body == "success") {
          _loadCart();
          final snackBar = SnackBar(
            content: Text(
              'Cart Updated!',
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
        } else {
          final snackBar = SnackBar(
            content: Text('Failed'),
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

  _deleteCart(int index) {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Delete item?',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Solway',
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                http.post("https://justminedb.com/aggs/php/delete_cart.php",
                    body: {
                      "email": widget.user.email,
                      "id": cartData[index]['id'],
                    }).then((res) {
                  print(res.body);

                  if (res.body == "success") {
                    _loadCart1();
                    final snackBar = SnackBar(
                      content: Text(
                        'Item deleted!',
                        style: TextStyle(fontFamily: 'Solway'),
                      ),
                      action: SnackBarAction(
                        label: 'Close',
                        textColor: Colors.white,
                        onPressed: () {},
                      ),
                    );

                    // ignore: deprecated_member_use
                    _scaffold.currentState.showSnackBar(snackBar);
                  } else {
                    final snackBar = SnackBar(
                      content: Text('Failed'),
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
              },
              child: Text(
                "Yes",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Solway',
                ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Solway',
                ),
              )),
        ],
      ),
    );
  }

  Future<void> makePayment() async {
    double newamount = double.parse(widget.user.wallet) - amountpayable;
    _payusingwallet(newamount);
    var now = new DateTime.now();
    var formatter = new DateFormat('ddMMyyyyhhmmss-');
    String orderid = formatter.format(now) + randomAlphaNumeric(10);
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => Payment(
                  user: widget.user,
                  val: amountpayable.toStringAsFixed(2),
                  orderid: orderid,
                  product: widget.product,
                )));
    _loadCart();
    _loadUserData();
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void deleteAll() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Delete all items?',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Solway',
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                http.post("https://justminedb.com/aggs/php/delete_cart.php",
                    body: {
                      "email": widget.user.email,
                    }).then((res) {
                  print(res.body);

                  if (res.body == "success") {
                    _loadCart();
                    final snackBar = SnackBar(
                      content: Text(
                        'Item deleted!',
                        style: TextStyle(fontFamily: "Solway"),
                      ),
                      action: SnackBarAction(
                        label: 'Close',
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.pop(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      MainMenu()));
                        },
                      ),
                    );

                    // ignore: deprecated_member_use
                    _scaffold.currentState.showSnackBar(snackBar);
                  } else {
                    final snackBar = SnackBar(
                      content: Text(
                        'Failed',
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
              },
              child: Text(
                "Yes",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Solway',
                ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Solway',
                ),
              )),
        ],
      ),
    );
  }

  void _loadUserData() async {
    String urlLoadJobs = server + "/php/load_userdata.php";
    await http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      if (res.body == "nodata") {
        setState(() {});
      } else {
        setState(() {
          widget.user.wallet = res.body;
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  String generateOrderid() {
    var now = new DateTime.now();
    var formatter = new DateFormat('ddMMyyyyhhmmss-');
    String orderid = formatter.format(now) + randomAlphaNumeric(10);
    return orderid;
  }

  Future<void> _payusingwallet(double newamount) async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);

    pr.style(message: "Updating cart...");
    pr.show();
    String urlPayment = server + "/php/paymentsc.php";
    await http.post(urlPayment, body: {
      "userid": widget.user.email,
      "amount": amountpayable.toStringAsFixed(2),
      "orderid": generateOrderid(),
      "newwl": newamount.toStringAsFixed(2)
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        final snackBar = SnackBar(
          content: Text(
            'Payment success.',
            style: TextStyle(fontFamily: "Solway"),
          ),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      Navigator.pop(context);

      pr.hide();
    }).catchError((err) {
      print(err);
    });
  }
}
