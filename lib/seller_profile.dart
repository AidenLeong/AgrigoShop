import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'cart.dart';
import 'login.dart';
import 'main_menu.dart';
import 'manage_product.dart';
import 'product.dart';
import 'product_info.dart';
import 'shipment.dart';
import 'topup_wallet.dart';
import 'user.dart';
import 'user_order.dart';
import 'user_profile.dart';
import 'package:http/http.dart' as http;

class SellerProfile extends StatefulWidget {
  final User user;
  final Product product;
  const SellerProfile({Key key, this.user, this.product}) : super(key: key);

  @override
  _SellerProfileState createState() => _SellerProfileState();
}

class _SellerProfileState extends State<SellerProfile> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _prdController = new TextEditingController();
  String cartquantity = "0";
  String titlecenter = "Loading...";
  List productdata;
  double screenHeight, screenWidth;
  String server = "https://justminedb.com/aggs";
  String url = 'https://justminedb.com/aggs/php/get_products.php';

  int quantity = 1;
  bool _isbuyer = false;
  bool _isseller = false;
  bool promotion = false;
  @override
  void initState() {
    super.initState();
    _loadData();

    _loadCartQuantity();
    print(widget.user.role);
    if (widget.user.role == "Seller") {
      _isseller = true;
    }
    if (widget.user.role == "Buyer") {
      _isbuyer = true;
    }
    print(widget.product.email);
    _loadUserData();
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
        });
        return;
      }
    }).catchError((err) {
      print(err);
    });
  }

  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: scaffoldKey,
      drawer: mainDrawer(context),
      body: new ListView(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RawMaterialButton(
              onPressed: () {
                scaffoldKey.currentState.openDrawer();
              },
              elevation: 8.0,
              fillColor: Colors.white,
              child: Icon(Icons.menu, color: Colors.amber),
              padding: EdgeInsets.all(8.0),
              shape: CircleBorder(),
            ),
          ],
        ),
        Container(
          child: Row(children: [
            SizedBox(
              height: 80,
              width: 20,
            ),
            Container(
              height: 50,
              width: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(90),
                child: CachedNetworkImage(
                  imageUrl:
                      'https://justminedb.com/aggs/user_images/${widget.product.email}.jpg',
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://justminedb.com/aggs/user_images/${widget.product.email}.jpg',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              widget.product.email,
              style: TextStyle(
                fontFamily: "Solway",
                fontSize: 17,
                color: Colors.black,
              ),
            ),
            SizedBox(width: 70),
          ]),
        ),
        Divider(
          thickness: 1.5,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "        All Products",
          style: TextStyle(
            fontFamily: "Solway",
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        SizedBox(
          height: 15,
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
                height: screenHeight / 1.39,
                child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
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
                                  (screenWidth / screenHeight) / 0.55,
                              children:
                                  List.generate(productdata.length, (index) {
                                return Container(
                                    child: Card(
                                        elevation: 1,
                                        child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: () =>
                                                    _onProductDetail(index),
                                                child: Container(
                                                  height: screenHeight / 6.3,
                                                  width: screenWidth / 3.5,
                                                  child: ClipRect(
                                                    child: FadeInImage
                                                        .assetNetwork(
                                                      placeholder:
                                                          'assets/images/loading.gif',
                                                      image:
                                                          "https://justminedb.com/aggs/product_images/${productdata[index]['id']}.jpg",
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(productdata[index]['name'],
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Solway',
                                                      color: Colors.black)),
                                              double.parse(productdata[index]
                                                          ['promote']) <
                                                      1
                                                  ? Text(
                                                      "RM " +
                                                          productdata[index]
                                                              ['price'],
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                        fontFamily: 'Solway',
                                                      ),
                                                    )
                                                  : Text(
                                                      "RM " +
                                                          productdata[index]
                                                              ['price'],
                                                      style: TextStyle(
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                        fontFamily: 'Solway',
                                                      ),
                                                    ),
                                              double.parse(productdata[index]
                                                          ['promote']) ==
                                                      0.00
                                                  ? Text("")
                                                  : Text(
                                                      "RM " +
                                                          productdata[index]
                                                              ['promote'],
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                        fontFamily: 'Solway',
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
                      ), /*CachedNetworkImage(
                        imageUrl:
                            'https://justminedb.com/aggs/user_images/${widget.user.email}.jpg',
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                'https://justminedb.com/aggs/user_images/${widget.user.email}.jpg',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),*/
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
                                  ))),
                      _loadUserData()
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

  void _loadData() async {
    String urlLoadJobs = url;
    await http.post(urlLoadJobs, body: {
      "email": widget.product.email,
    }).then((res) {
      if (res.body == "nodata") {
        setState(() {
          productdata = null;
        });
        return;
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          productdata = extractdata["products"];
        });
        return;
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
        return;
      } else {
        widget.user.quantity = res.body;
        return;
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
      quantity: productdata[index]['quantity'],
      email: productdata[index]['email'],
      weight: productdata[index]['weight'],
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
                    "Yes",
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
              });
              return;
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
