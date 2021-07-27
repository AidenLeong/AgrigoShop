import 'package:aggs/product.dart';
import 'package:aggs/user.dart';
import 'package:aggs/user_profile.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'main_menu.dart';
import 'manage_product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeleteProduct extends StatefulWidget {
  final User user;
  final Product product;
  const DeleteProduct({Key key, this.user, this.product}) : super(key: key);
  @override
  _DeleteProductState createState() => _DeleteProductState();
}

class _DeleteProductState extends State<DeleteProduct> {
  final GlobalKey<ScaffoldState> _scaffold = new GlobalKey<ScaffoldState>();
  List productdata;
  bool loading = false;
  double loadingOpacity = 1;
  String server = "https://justminedb.com/aggs";
  bool valuefirst = false;
  bool valuesecond = false;
  String url = 'https://justminedb.com/aggs/php/get_products.php';
  TextEditingController prnameController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  TextEditingController desController = new TextEditingController();

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
        key: _scaffold,
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
                          "Delete Product",
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
                        height: screenHeight / 1.16,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Colors.white,
                          elevation: 5,
                          child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                productdata == null
                                    ? Flexible(
                                        child: Container(
                                            child: Center(
                                                child: Text(
                                        "Loading...",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Solway',
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ))))
                                    : Expanded(
                                        child: ListView.builder(
                                            itemCount: productdata == null
                                                ? 0
                                                : productdata.length,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                  child: Card(
                                                      elevation: 8,
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
                                                            Row(children: [
                                                              IconButton(
                                                                icon: Icon(Icons
                                                                    .cancel),
                                                                onPressed: () =>
                                                                    {
                                                                  _deleteProduct(
                                                                      index)
                                                                },
                                                              ),
                                                              GestureDetector(
                                                                onTap: () => {},
                                                                child:
                                                                    Container(
                                                                  height:
                                                                      screenHeight /
                                                                          9,
                                                                  width:
                                                                      screenWidth /
                                                                          4.5,
                                                                  child:
                                                                      ClipRRect(
                                                                    child: FadeInImage
                                                                        .assetNetwork(
                                                                      placeholder:
                                                                          'assets/images/loading.gif',
                                                                      image:
                                                                          'https://justminedb.com/aggs/product_images/${productdata[index]['id']}.jpg',
                                                                      fit: BoxFit
                                                                          .fill,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 30,
                                                              ),
                                                              Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: [
                                                                    Text(
                                                                        productdata[index]
                                                                            [
                                                                            'name'],
                                                                        maxLines:
                                                                            1,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontFamily:
                                                                                'Solway',
                                                                            color:
                                                                                Colors.black)),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    double.parse(productdata[index]['promote']) <
                                                                            0.01
                                                                        ? Text(
                                                                            "RM " +
                                                                                productdata[index]['price'],
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black,
                                                                              fontFamily: 'Solway',
                                                                            ),
                                                                          )
                                                                        : Text(
                                                                            "RM " +
                                                                                productdata[index]['price'],
                                                                            style:
                                                                                TextStyle(
                                                                              decoration: TextDecoration.lineThrough,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black,
                                                                              fontFamily: 'Solway',
                                                                            ),
                                                                          ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    double.parse(productdata[index]['promote']) ==
                                                                            0.00
                                                                        ? Text(
                                                                            "")
                                                                        : Text(
                                                                            "RM " +
                                                                                productdata[index]['promote'],
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black,
                                                                              fontFamily: 'Solway',
                                                                            ),
                                                                          )
                                                                  ])
                                                            ]),
                                                          ],
                                                        ),
                                                      )));
                                            }))
                              ]),
                        ),
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
              child: CachedNetworkImage(
                imageUrl:
                    'https://justminedb.com/aggs/product_images/${widget.product.id}.jpg',
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => new CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
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
                          'https://justminedb.com/aggs/user_images/${widget.user.email}.jpg',
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

  _deleteProduct(int index) {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Delete ' + productdata[index]['name'] + '?',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Solway',
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                http.post("https://justminedb.com/aggs/php/delete_product.php",
                    body: {
                      "email": widget.user.email,
                      "id": productdata[index]['id'],
                    }).then((res) {
                  print(res.body);

                  if (res.body == "success") {
                    _loadData();
                    final snackBar = SnackBar(
                      content: Text(
                        'Delete Successful',
                        style: TextStyle(
                            fontFamily: "Solway", color: Colors.white),
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
                  } else {
                    final snackBar = SnackBar(
                      content: Text(
                        'Delete Failed',
                        style: TextStyle(
                            fontFamily: "Solway", color: Colors.white),
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
}
