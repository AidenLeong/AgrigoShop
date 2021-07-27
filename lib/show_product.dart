import 'dart:io';
import 'package:aggs/product.dart';
import 'package:aggs/product_info.dart';
import 'package:aggs/user.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:toast/toast.dart';

import 'main_menu.dart';

class ShowProduct extends StatefulWidget {
  final User user;
  final Product product;
  const ShowProduct({Key key, this.user, this.product}) : super(key: key);

  @override
  _ShowProductState createState() => _ShowProductState();
}

class _ShowProductState extends State<ShowProduct> {
  // final GlobalKey<ScaffoldState> _scaffold = new GlobalKey<ScaffoldState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _prdController = new TextEditingController();
  String cartquantity = "0";
  String titlecenter = "Loading...";
  List productdata;
  double screenHeight, screenWidth;
  String server = "https://justminedb.com/aggs";
  int quantity = 1;
  bool promotion = false;
  bool viewAll = false;

  @override
  void initState() {
    super.initState();
    _loadData();

    _loadCartQuantity();
    print(widget.user.role);
  
    _loadUserData();
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

  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.amber,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                ),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => MainMenu(
                              user: widget.user,
                            ))),
              ),
              title: Text(
                "All Product",
                style: TextStyle(fontFamily: "Solway"),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    searchProduct();
                  },
                ),
              ]),
          key: scaffoldKey,
          body: Builder(builder: (BuildContext context) {
            return Stack(
              children: <Widget>[
                new ListView(children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: screenWidth / 1.09,
                          height: screenHeight / 1.15,
                          child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                productdata == null
                                    ? Flexible(
                                        child: Container(
                                            child: Center(
                                                child: Text(
                                        titlecenter,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Solway',
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ))))
                                    : Expanded(
                                        child: GridView.count(
                                            crossAxisCount: 2,
                                            childAspectRatio:
                                                (screenWidth / screenHeight) /
                                                    0.55,
                                            children: List.generate(
                                                productdata.length, (index) {
                                              return Container(
                                                  child: Card(
                                                      elevation: 1,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            GestureDetector(
                                                              onTap: () =>
                                                                  _onProductDetail(
                                                                      index),
                                                              child: Container(
                                                                height:
                                                                    screenHeight /
                                                                        6.3,
                                                                width:
                                                                    screenWidth /
                                                                        3.5,
                                                                child: ClipRect(
                                                                  child: FadeInImage
                                                                      .assetNetwork(
                                                                    placeholder:
                                                                        'assets/images/loading.gif',
                                                                    image:
                                                                        "https://justminedb.com/aggs/product_images/${productdata[index]['id']}.jpg",
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                                productdata[
                                                                        index]
                                                                    ['name'],
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontFamily:
                                                                        'Solway',
                                                                    color: Colors
                                                                        .black)),
                                                            double.parse(productdata[
                                                                            index]
                                                                        [
                                                                        'promote']) ==
                                                                    0
                                                                ? Text(
                                                                    "RM " +
                                                                        productdata[index]
                                                                            [
                                                                            'price'],
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          'Solway',
                                                                    ),
                                                                  )
                                                                : Text(
                                                                    "RM " +
                                                                        productdata[index]
                                                                            [
                                                                            'price'],
                                                                    style:
                                                                        TextStyle(
                                                                      decoration:
                                                                          TextDecoration
                                                                              .lineThrough,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          'Solway',
                                                                    ),
                                                                  ),
                                                            double.parse(productdata[
                                                                            index]
                                                                        [
                                                                        'promote']) ==
                                                                    0.00
                                                                ? Text("")
                                                                : Text(
                                                                    "RM " +
                                                                        productdata[index]
                                                                            [
                                                                            'promote'],
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          'Solway',
                                                                    ),
                                                                  )
                                                          ],
                                                        ),
                                                      )));
                                            })))
                              ]),
                        ),
                      ],
                    ),
                  ),
                ]),
              ],
            );
          }),
        ));
  }

  void _loadData() async {
    String urlLoadJobs = server + "/php/load_products.php";
    await http.post(urlLoadJobs, body: {}).then((res) {
      if (res.body == "nodata") {
        cartquantity = "0";
        titlecenter = "No product found";
        setState(() {
          productdata = null;
        });return;
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

  void _loadCartQuantity() async {
    String urlLoadJobs = server + "/php/load_cartquantity.php";
    await http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      if (res.body == "nodata") {return;
      } else {
        widget.user.quantity = res.body;return;
      }
    }).catchError((err) {
      print(err);
    });
  }

  _onProductDetail(int index) async {
    print(productdata[index]['name']);
    Product product = new Product(
      id: productdata[index]['id'],
      name: productdata[index]['name'],
      price: productdata[index]['price'],
      description: productdata[index]['description'],
      highlight: productdata[index]['highlight'],
      specification: productdata[index]['specification'],
      type: productdata[index]['type'],
      weight: productdata[index]['weight'],
      quantity: productdata[index]['quantity'],
      email: productdata[index]['email'],
      promote: productdata[index]['promote'],
      sold: productdata[index]['sold'],
    );

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ProductInfo(
                  product: product,
                  user: widget.user,
                )));
    _loadData();
  }

  void searchProduct() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Please input the product name.",
                style: TextStyle(color: Colors.black, fontFamily: "Solway"),
              ),
              content: new TextField(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  controller: _prdController,
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    labelStyle: TextStyle(fontFamily: "Solway"),
                    icon: Icon(
                      Icons.article_outlined,
                      color: Colors.black,
                    ),
                  )),
              actions: <Widget>[
                // ignore: deprecated_member_use
                new FlatButton(
                  child: new Text(
                    "Search",
                    style: TextStyle(color: Colors.black, fontFamily: "Solway"),
                  ),
                  onPressed: () => {_sortItembyName(_prdController.text)},
                ),
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

  void _sortItembyName(String prname) {
    try {
      print(prname);
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true);
      pr.style(message: "Searching...");
      pr.show();
      String urlLoadJobs = server + "/php/load_products.php";
      http
          .post(urlLoadJobs, body: {
            "name": prname.toString(),
          })
          .timeout(const Duration(seconds: 4))
          .then((res) {
            if (res.body == "nodata") {
              final snackBar = SnackBar(
                content: Text(
                  'Product not found',
                  style: TextStyle(fontFamily: "Solway"),
                ),
                action: SnackBarAction(
                  label: 'Close',
                  onPressed: () {},
                ),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              pr.hide();
              setState(() {
                titlecenter = "No product found";
                productdata = null;
              });
              FocusScope.of(context).requestFocus(new FocusNode());

              return;
            } else {
              setState(() {
                var extractdata = json.decode(res.body);
                productdata = extractdata["products"];
                FocusScope.of(context).requestFocus(new FocusNode());
                pr.hide();
                Navigator.of(context).pop();
              });return;
            }
          })
          .catchError((err) {
            pr.hide();
          });
      pr.hide();
    } on TimeoutException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } on SocketException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }
}
