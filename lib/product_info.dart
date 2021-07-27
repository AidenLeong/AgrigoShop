// import 'dart:convert';
//import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'main_menu.dart';
import 'product.dart';
import 'seller_profile.dart';
import 'user.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

// import 'user.dart';
class ProductInfo extends StatefulWidget {
  final Product product;
  final User user;

  const ProductInfo({Key key, this.product, this.user}) : super(key: key);
  @override
  _ProductInfoState createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  int quantity = 1;
  String cartquantity = "0";
  bool promotion = false;
  bool _isbuyer = false;
  @override
  void initState() {
    super.initState();
    print(widget.user.role);
    if (double.parse(widget.product.promote) > 0) {
      promotion = true;
      return;
    }
    if (widget.user.role == "Buyer") {
      _isbuyer = true;
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
        onWillPop: _onBackPressAppBar,
        child: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: SingleChildScrollView(
              child: Stack(children: <Widget>[
                Column(children: <Widget>[
                  Container(
                    height: height / 2 + 40,
                    width: width,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2,
                          spreadRadius: 1,
                          offset: Offset(1, 1.5),
                        )
                      ],
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          'https://justminedb.com/aggs/product_images/${widget.product.id}.jpg',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 360,
                    child: Column(children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  widget.product.name,
                                  style: TextStyle(
                                      fontFamily: "Solway",
                                      fontSize: 24,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700),
                                ),
                                Visibility(
                                    visible: promotion,
                                    child: Text(
                                      'Discount Price: ',
                                      style: TextStyle(
                                        fontFamily: "Solway",
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    )),
                                Text(
                                  widget.product.sold + " Sold",
                                  style: TextStyle(
                                      fontFamily: "Solway",
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700),
                                ),
                              ]),
                          Column(children: <Widget>[
                            promotion == true
                                ? Text(
                                    'RM ' + widget.product.price,
                                    style: TextStyle(
                                        fontFamily: "Solway",
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: 24,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700),
                                  )
                                : Text(
                                    'RM ' + widget.product.price,
                                    style: TextStyle(
                                        fontFamily: "Solway",
                                        fontSize: 24,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700),
                                  ),
                            Visibility(
                                visible: promotion,
                                child: Text(
                                  'RM ' + widget.product.promote,
                                  style: TextStyle(
                                      fontFamily: "Solway",
                                      fontSize: 24,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700),
                                )),
                            Text("")
                          ]),
                        ],
                      ),
                      Divider(
                        thickness: 1.5,
                      ),
                      GestureDetector(
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      SellerProfile(
                                        user: widget.user,
                                      ))),
                        },
                        child: Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(90),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            'https://justminedb.com/aggs/user_images/${widget.product.email}.jpg',
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
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
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ]),
                                // ignore: deprecated_member_use
                                FlatButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  SellerProfile(
                                                    user: widget.user,
                                                    product: widget.product,
                                                  )));
                                    },
                                    child: Text(
                                      "Visit Shop",
                                      style: TextStyle(fontFamily: "Solway"),
                                    ),
                                    shape: new RoundedRectangleBorder(
                                      side: BorderSide(color: Colors.amber),
                                    )),
                              ]),
                        ),
                      ),
                      Divider(
                        thickness: 1.5,
                      ),
                      SizedBox(height: 8),
                      Table(
                          columnWidths: {
                            0: FlexColumnWidth(2),
                            1: FlexColumnWidth(4),
                          },
                          defaultColumnWidth: IntrinsicColumnWidth(),
                          children: [
                            TableRow(
                              children: [
                                TableCell(
                                  child: IntrinsicHeight(
                                      child: Text("Stock:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Solway',
                                              color: Colors.black))),
                                ),
                                TableCell(
                                  child: IntrinsicHeight(
                                      child: Text(
                                    widget.product.quantity,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Solway',
                                        color: Colors.black),
                                  )),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  child: IntrinsicHeight(
                                      child: Text("Weight:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Solway',
                                              color: Colors.black))),
                                ),
                                TableCell(
                                  child: IntrinsicHeight(
                                      child: Text(
                                    widget.product.weight + " g",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Solway',
                                        color: Colors.black),
                                  )),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  child: IntrinsicHeight(
                                      child: Text("Description:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Solway',
                                              color: Colors.black))),
                                ),
                                TableCell(
                                  child: IntrinsicHeight(
                                      child: Text(
                                    widget.product.description,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Solway',
                                        color: Colors.black),
                                  )),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  child: IntrinsicHeight(
                                      child: Text("Highlight:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Solway',
                                              color: Colors.black))),
                                ),
                                TableCell(
                                  child: IntrinsicHeight(
                                      child: Text(
                                    widget.product.highlight,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Solway',
                                        color: Colors.black),
                                  )),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  child: IntrinsicHeight(
                                      child: Text("Specification:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Solway',
                                              color: Colors.black))),
                                ),
                                TableCell(
                                  child: IntrinsicHeight(
                                      child: Text(
                                    widget.product.specification,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Solway',
                                        color: Colors.black),
                                  )),
                                ),
                              ],
                            ),
                          ]),
                    ]),
                  ),
                ]),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 25, 20, 20),
                  child: RawMaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    elevation: 8.0,
                    fillColor: Colors.white,
                    child: Icon(Icons.arrow_back_ios_rounded),
                    padding: EdgeInsets.all(8.0),
                    shape: CircleBorder(),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Card(
                      child: Column(
                        children: <Widget>[],
                      ),
                    ),
                  ],
                ),
              ]),
            ),
            bottomNavigationBar: GestureDetector(
              child: Container(
                color: Colors.amber,
                height: 50,
                width: 200,
                child: Center(
                  child: Text(
                    "Add to Cart",
                    style: TextStyle(fontFamily: "Solway", color: Colors.white),
                  ),
                ),
              ),
              onTap: () {
                if (widget.user.role == "Buyer") {
                  _addCart();
                } else {
                  final snackBar = SnackBar(
                    content: Text(
                      'Seller cannot perform this function.',
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
              },
            )));
  }

//Show dialog box to ask for the product quantity
  void _addCart() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, newSetState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                title: new Text(
                  "Add " + widget.product.name + " to Cart?",
                  style: TextStyle(fontFamily: "Solway"),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Select quantity of product",
                      style: TextStyle(fontFamily: "Solway"),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // ignore: deprecated_member_use
                            FlatButton(
                              onPressed: () => {
                                newSetState(() {
                                  if (quantity > 1) {
                                    quantity--;
                                    return;
                                  }
                                })
                              },
                              child: Icon(
                                MdiIcons.minus,
                                color: Colors.amber,
                              ),
                            ),
                            Text(
                              quantity.toString(),
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Solway",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // ignore: deprecated_member_use
                            FlatButton(
                              onPressed: () => {
                                newSetState(() {
                                  if (quantity <
                                      (int.parse(widget.product.quantity) -
                                          2)) {
                                    quantity++;
                                    return;
                                  } else {
                                    final snackBar = SnackBar(
                                      content: Text(
                                        'Quantity not available',
                                        style: TextStyle(fontFamily: "Solway"),
                                      ),
                                      action: SnackBarAction(
                                        label: 'Close',
                                        onPressed: () {},
                                      ),
                                    );

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                    return;
                                  }
                                })
                              },
                              child: Icon(
                                MdiIcons.plus,
                                color: Colors.amber,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                actions: <Widget>[
                  MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                        _addtoCart();
                      },
                      child: Text(
                        "Yes",
                        style: TextStyle(fontFamily: "Solway"),
                      )),
                  MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                        print(widget.product.email);
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(fontFamily: "Solway"),
                      )),
                ],
              );
            },
          );
        });
  }

//Add to user cart
  void _addtoCart() {
    try {
      int cquantity = int.parse(widget.product.quantity);
      print(cquantity);
      print(widget.product.id);
      print(widget.user.email);

      //If promote price = 0
      if (widget.product.promote == "0.00") {
        double totalprice = double.parse(widget.product.price) * quantity;
        double deliveryPerProduct = double.parse(widget.product.weight) *
            double.parse(widget.product.price) *
            0.0006;
        if (cquantity > 0) {
          ProgressDialog pr = new ProgressDialog(context,
              type: ProgressDialogType.Normal, isDismissible: true);
          pr.style(message: "Add to cart...");
          pr.show();
          String urlLoadJobs =
              "https://justminedb.com/aggs/php/insert_cart.php";
          http.post(urlLoadJobs, body: {
            "email": widget.user.email,
            "id": widget.product.id,
            "quantity": quantity.toString(),
            "selleremail": widget.product.email,
            "ttlprice": totalprice.toString(),
            "weight": widget.product.weight,
            "delivery": deliveryPerProduct.toString(),
          }).then((res) {
            print(res.body);
            if (res.body == "failed") {
              final snackBar = SnackBar(
                content: Text(
                  'Failed add to cart',
                  style: TextStyle(fontFamily: "Solway"),
                ),
                action: SnackBarAction(
                  label: 'Close',
                  onPressed: () {},
                ),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              pr.hide();
              return;
            } else {
              List respond = res.body.split(",");
              setState(() {
                cartquantity = respond[1];
                widget.user.quantity = cartquantity;
              });
              final snackBar = SnackBar(
                content: Text(
                  'Success add to cart',
                  style: TextStyle(fontFamily: "Solway"),
                ),
                action: SnackBarAction(
                  label: 'Close',
                  onPressed: () {},
                ),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              print(widget.product.email);

              Navigator.pop(context);
            }
            pr.hide();
          }).catchError((err) {
            print(err);
            pr.hide();
          });
          pr.hide();
          return;
        } else {
          final snackBar = SnackBar(
            content: Text(
              'Out of stock',
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
      }
      //If promote price > 0
      else {
        double totalprice = double.parse(widget.product.promote) * quantity;
        double deliveryPerProduct = double.parse(widget.product.weight) *
            double.parse(widget.product.promote) *
            0.0006;
        if (cquantity > 0) {
          ProgressDialog pr = new ProgressDialog(context,
              type: ProgressDialogType.Normal, isDismissible: true);
          pr.style(message: "Add to cart...");
          pr.show();
          String urlLoadJobs =
              "https://justminedb.com/aggs/php/insert_cart.php";
          http.post(urlLoadJobs, body: {
            "email": widget.user.email,
            "id": widget.product.id,
            "quantity": quantity.toString(),
            "selleremail": widget.product.email,
            "ttlprice": totalprice.toString(),
            "delivery": deliveryPerProduct.toString(),
          }).then((res) {
            print(res.body);
            if (res.body == "failed") {
              final snackBar = SnackBar(
                content: Text(
                  'Failed add to cart',
                  style: TextStyle(fontFamily: "Solway"),
                ),
                action: SnackBarAction(
                  label: 'Close',
                  onPressed: () {},
                ),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              pr.hide();
              return;
            } else {
              List respond = res.body.split(",");
              setState(() {
                cartquantity = respond[1];
                widget.user.quantity = cartquantity;
              });
              final snackBar = SnackBar(
                content: Text(
                  'Successful add to cart',
                  style: TextStyle(fontFamily: "Solway"),
                ),
                action: SnackBarAction(
                  label: 'Close',
                  onPressed: () {},
                ),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              print(widget.product.email);

              Navigator.pop(context);
            }
            pr.hide();
          }).catchError((err) {
            print(err);
            pr.hide();
          });
          pr.hide();
          return;
        } else {
          final snackBar = SnackBar(
            content: Text(
              'Out of stock',
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
      }
    } catch (e) {
      final snackBar = SnackBar(
        content: Text(
          'Failed add to cart',
          style: TextStyle(fontFamily: "Solway"),
        ),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {},
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

//Exit to Main Menu
  Future<bool> _onBackPressAppBar() async {
    Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => MainMenu(user: widget.user),
        ));
    return Future.value(false);
  }
}
