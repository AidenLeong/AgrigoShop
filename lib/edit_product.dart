import 'package:aggs/product.dart';
import 'package:aggs/user.dart';
import 'package:aggs/user_profile.dart';
import 'package:flutter/material.dart';
import 'edit_product_detail.dart';
import 'login.dart';
import 'main_menu.dart';
import 'manage_product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProduct extends StatefulWidget {
  final User user;
  final Product product;
  const EditProduct({Key key, this.user, this.product}) : super(key: key);
  static final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  List productdata;
  bool loading = false;
  double loadingOpacity = 1;
  String server = "https://justminedb.com/aggs";
  String titlecenter = "Loading...";
  String url = 'https://justminedb.com/aggs/php/get_products.php';
  TextEditingController prnameController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  TextEditingController desController = new TextEditingController();
  TextEditingController quanController = new TextEditingController();

  void _getItems() async {
    setState(() {
      loading = true;
      loadingOpacity = .2;
    });
    http.post(url, body: {}).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        productdata = extractdata["products"];
      });

      setState(() {
        loading = false;
        loadingOpacity = 1;
      });
    }).catchError((e) {
      print(e);
      setState(() {
        loading = false;
        loadingOpacity = 1;
      });
    });
  }

  @override
  void initState() {
    _getItems();
    _loadData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        key: scaffoldKey,
        body: Builder(builder: (BuildContext context) {
          return Stack(
            children: <Widget>[
              new ListView(children: <Widget>[
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(1, 20, 0, 0),
                        child: Text(
                          "My Product",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Solway',
                              fontSize: 28),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: screenWidth / 1.09,
                        height: screenHeight / 1.15,
                        child: Row(mainAxisSize: MainAxisSize.min, children: <
                            Widget>[
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
                                      children: List.generate(
                                          productdata.length, (index) {
                                        return Container(
                                            child: Card(
                                                elevation: 1,
                                                child: Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      GestureDetector(
                                                        onTap: () =>
                                                            _onProductDetail(
                                                                index),
                                                        child: Container(
                                                          height: screenHeight /
                                                              6.3,
                                                          width:
                                                              screenWidth / 3.5,
                                                          child: ClipRect(
                                                            child: FadeInImage
                                                                .assetNetwork(
                                                              placeholder:
                                                                  'assets/images/loading.gif',
                                                              image:
                                                                  'https://justminedb.com/aggs/product_images/${productdata[index]['id']}.jpg',
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                          productdata[index]
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
                                                                  ['promote']) <
                                                              0.01
                                                          ? Text(
                                                              "RM " +
                                                                  productdata[
                                                                          index]
                                                                      ['price'],
                                                              style: TextStyle(
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
                                                                  productdata[
                                                                          index]
                                                                      ['price'],
                                                              style: TextStyle(
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
                                                                      index][
                                                                  'promote']) ==
                                                              0.00
                                                          ? Text("")
                                                          : Text(
                                                              "RM " +
                                                                  productdata[
                                                                          index]
                                                                      [
                                                                      'promote'],
                                                              style: TextStyle(
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
              new Center(
                  child: new Column(
                children: <Widget>[],
              )),
              Positioned(
                left: 0,
                top: 25,
                child: RawMaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  elevation: 8.0,
                  fillColor: Colors.white,
                  child:
                      Icon(Icons.arrow_back_ios_rounded, color: Colors.amber),
                  padding: EdgeInsets.all(8.0),
                  shape: CircleBorder(),
                ),
              ),
            ],
          );
        }));
  }

 /* Widget menuEdit(BuildContext context) {
    return Container(
      height: 100,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.amber],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 2,
            spreadRadius: 1,
            offset: Offset(1, 1.5),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 90,
            width: 90,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/loading.gif',
                image:
                    'https://justminedb.com/aggs/product_images/${widget.product.id}.jpg',
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.product.name}',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '${widget.product.id}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                Spacer(),
                Text(
                  '\$${widget.product.price}',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 42,
            child: IconButton(
                icon: Icon(
                  Icons.edit,
                  size: 26,
                  color: Colors.grey,
                ),
                onPressed: () {}),
          )
        ],
      ),
    );
  }*/

  void _loadData() async {
    String urlLoadJobs = url;
    await http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      if (res.body == "nodata") {
        setState(() {
          productdata = null;
        });return;
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          productdata = extractdata["products"];
        });return;
      }
    }).catchError((err) {
      print(err);
    });
  }

  Widget circleButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(90),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2,
              spreadRadius: 1,
              offset: Offset(1, 1.5),
            )
          ],
          color: Colors.white),
      child: CircleAvatar(
        radius: 22,
        backgroundColor: Colors.white,
        child: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            mainDrawer(context);
          },
        ),
      ),
    );
  }

  Widget mainDrawer(BuildContext context) {
    return Drawer(
      child: ListView(children: <Widget>[
        SizedBox(
          height: 200,
          child: DrawerHeader(
              padding:
                  EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.grey],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Column(children: <Widget>[
                SizedBox(
                  height: 90,
                  width: 90,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(90),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/loading.gif',
                      image:
                          'https://justminedb.com/aggs/product_images/${widget.user.email}.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.user.name,
                        style: TextStyle(fontFamily: "Solway"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.user.email,
                        style: TextStyle(fontFamily: "Solway"),
                      ),
                    ]),
              ])),
        ),
        ListTile(
            leading: Icon(
              Icons.spa_rounded,
              color: Colors.blue,
            ),
            title: Text('Product List', style: TextStyle(fontFamily: "Solway")),
            onTap: () => {
                  Navigator.pop(context),
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => MainMenu(
                                user: widget.user,
                              )))
                }),
        ListTile(
            leading: Icon(
              Icons.account_circle,
              color: Colors.blue,
            ),
            title: Text('User Profile', style: TextStyle(fontFamily: "Solway")),
            onTap: () => {
                  Navigator.pop(context),
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => UserProfile(
                                user: widget.user,
                              )))
                }),
        Column(
          children: <Widget>[
            ListTile(
                leading: Icon(
                  Icons.settings,
                  color: Colors.blue,
                ),
                title: Text(
                  'Manage Product',
                  style: TextStyle(fontFamily: "Solway"),
                ),
                onTap: () => {
                      Navigator.pop(context),
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => ManageProduct(
                                    user: widget.user,
                                  )))
                    }),
          ],
        ),
        Container(),
        Divider(
          thickness: 1,
        ),
        ListTile(
            leading: Icon(
              Icons.power_settings_new_rounded,
              color: Colors.blue,
            ),
            title: Text('Log Out', style: TextStyle(fontFamily: "Solway")),
            onTap: () => {
                  Navigator.pop(context),
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Login()))
                }),
      ]),
    );
  }

  _onProductDetail(int index) async {
    print(productdata[index]['name']);
    Product product = new Product(
      id: productdata[index]['id'],
      name: productdata[index]['name'],
      price: productdata[index]['price'],
      description: productdata[index]['description'],
      quantity: productdata[index]['quantity'],
      highlight: productdata[index]['highlight'],
      specification: productdata[index]['specification'],
      weight: productdata[index]['weight'],
    );

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => EditProductDetail(
                  product: product,
                  user: widget.user,
                )));
    _loadData();
  }
}
