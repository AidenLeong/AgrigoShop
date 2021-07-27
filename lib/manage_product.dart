import 'dart:convert';

import 'package:aggs/add_product.dart';
import 'package:aggs/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'delete_product.dart';
import 'edit_product.dart';
import 'main_menu.dart';
import 'product.dart';

class ManageProduct extends StatefulWidget {
  final User user;
  final Product product;
  const ManageProduct({Key key, this.user, this.product}) : super(key: key);
  static final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  _ManageProductState createState() => _ManageProductState();
}

class _ManageProductState extends State<ManageProduct> {
  String server = "https://justminedb.com/aggs";
  String cartquantity = "0";
  String titlecenter = "Loading...";
  List productdata;
  double screenHeight, screenWidth;
  int quantity = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 25,
            ),
            Row(children: <Widget>[
              RawMaterialButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => MainMenu(
                                user: widget.user,
                                product: widget.product,
                              )));
                  _loadData();
                },
                elevation: 8.0,
                fillColor: Colors.white,
                child: Icon(Icons.arrow_back_ios_rounded, color: Colors.amber),
                padding: EdgeInsets.all(8.0),
                shape: CircleBorder(),
              ),
              SizedBox(
                width: 12,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(3, 20, 0, 0),
                child: Text(
                  "Manage Product",
                  style: TextStyle(
                      color: Colors.black, fontFamily: 'Solway', fontSize: 28),
                ),
              ),
            ]),
            SizedBox(
              height: 25,
            ),
            Card(
              elevation: 10,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SizedBox(
                          height: 50,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Add New Product',
                          style: TextStyle(
                              fontFamily: 'Solway',
                              color: Colors.black,
                              fontSize: 16),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(color: Colors.black),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onPressed: () {
                            setState(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          AddProduct(
                                            user: widget.user,
                                          )));
                            });
                          },
                        ),
                      ],
                    ),
                  ]),
            ),
            Card(
              elevation: 10,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SizedBox(
                          height: 50,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Edit Product',
                          style: TextStyle(
                              fontFamily: 'Solway',
                              color: Colors.black,
                              fontSize: 16),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(color: Colors.black),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onPressed: () {
                            setState(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          EditProduct(
                                            user: widget.user,
                                          )));
                            });
                          },
                        ),
                      ],
                    ),
                  ]),
            ),
            Card(
              elevation: 10,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SizedBox(
                          height: 50,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Delete Product',
                          style: TextStyle(
                              fontFamily: 'Solway',
                              color: Colors.black,
                              fontSize: 16),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(color: Colors.black),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onPressed: () {
                            setState(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          DeleteProduct(
                                            user: widget.user,
                                          )));
                            });
                          },
                        ),
                      ],
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
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
}
