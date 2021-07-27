import 'dart:convert';
import 'dart:io';
//import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'product.dart';
import 'user.dart';

class EditProductDetail extends StatefulWidget {
  final User user;
  final Product product;

  const EditProductDetail({Key key, this.user, this.product}) : super(key: key);

  @override
  _EditProductDetailState createState() => _EditProductDetailState();
}

class _EditProductDetailState extends State<EditProductDetail> {
  final GlobalKey<ScaffoldState> _scaffold = new GlobalKey<ScaffoldState>();
  double newprice;
  String uploadImageUrl =
      'https://justminedb.com/aggs/php/upload_product_image.php';
  String server = "https://justminedb.com/aggs";
  String url = 'https://justminedb.com/aggs/php/get_products.php';
  TextEditingController prnameController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  TextEditingController desController = new TextEditingController();
  TextEditingController quanController = new TextEditingController();
  TextEditingController promoteController = new TextEditingController();
  TextEditingController speController = new TextEditingController();
  TextEditingController highController = new TextEditingController();
  TextEditingController weightController = new TextEditingController();
  List productdata;
  double screenHeight, screenWidth;
  final focus0 = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();
  final focus5 = FocusNode();
  final focus6 = FocusNode();
  final focus7 = FocusNode();
  final focus8 = FocusNode();

  File _image;
  String selectedType;

  @override
  void initState() {
    super.initState();
    print("edit Product");
    prnameController.text = widget.product.name;
    priceController.text = widget.product.price;
    quanController.text = widget.product.quantity;
    weightController.text = widget.product.weight;
    desController.text = widget.product.description;
    speController.text = widget.product.specification;
    highController.text = widget.product.highlight;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffold,
      resizeToAvoidBottomInset: true,
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            SizedBox(
              height: 25,
            ),
            Row(children: <Widget>[
              RawMaterialButton(
                onPressed: () {
                  _loadData();
                  Navigator.pop(context);
                },
                elevation: 8.0,
                fillColor: Colors.white,
                child: Icon(Icons.arrow_back_ios_rounded, color: Colors.amber),
                padding: EdgeInsets.all(8.0),
                shape: CircleBorder(),
              ),
              SizedBox(
                width: 30,
              ),
              Text("Edit Product",
                  style: TextStyle(fontSize: 28, fontFamily: "Solway")),
            ]),
            SizedBox(height: 10),
            GestureDetector(
                onTap: _choose,
                child: Column(
                  children: [
                    Container(
                      height: screenHeight / 3,
                      width: screenWidth / 1.5,
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
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        ),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: _image == null
                              ? NetworkImage(
                                  'https://justminedb.com/aggs/product_images/${widget.product.id}.jpg',
                                )
                              : FileImage(_image),
                        ),
                      ),
                    )
                  ],
                )),
            SizedBox(height: 6),
            Container(
                width: screenWidth / 1.2,
                child: Card(
                    elevation: 6,
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Table(
                                columnWidths: {
                                  0: FlexColumnWidth(2),
                                  1: FlexColumnWidth(4),
                                },
                                defaultColumnWidth: IntrinsicColumnWidth(),
                                children: [
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text("Product ID",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Solway",
                                                color: Colors.black,
                                              ))),
                                    ),
                                    TableCell(
                                        child: Container(
                                      height: 30,
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text(
                                            " " + widget.product.id,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Solway",
                                            ),
                                          )),
                                    )),
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text("Product Name",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Solway",
                                                color: Colors.black,
                                              ))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        height: 30,
                                        child: TextFormField(
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Solway",
                                            ),
                                            controller: prnameController,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
                                            onFieldSubmitted: (v) {
                                              FocusScope.of(context)
                                                  .requestFocus(focus0);
                                            },
                                            decoration: new InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.all(5),
                                              fillColor: Colors.black,
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0),
                                                borderSide: new BorderSide(),
                                              ),
                                            )),
                                      ),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text("Price (RM)",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Solway",
                                                  color: Colors.black))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        height: 30,
                                        child: TextFormField(
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Solway",
                                            ),
                                            controller: priceController,
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            focusNode: focus0,
                                            onFieldSubmitted: (v) {
                                              FocusScope.of(context)
                                                  .requestFocus(focus1);
                                            },
                                            decoration: new InputDecoration(
                                              fillColor: Colors.black,
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0),
                                                borderSide: new BorderSide(),
                                              ),
                                            )),
                                      ),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text("Quantity",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Solway",
                                                  color: Colors.black))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        height: 30,
                                        child: TextFormField(
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Solway",
                                            ),
                                            controller: quanController,
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            focusNode: focus1,
                                            onFieldSubmitted: (v) {
                                              FocusScope.of(context)
                                                  .requestFocus(focus2);
                                            },
                                            decoration: new InputDecoration(
                                              fillColor: Colors.black,
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0),
                                                borderSide: new BorderSide(),
                                              ),
                                            )),
                                      ),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text("Weight (g)",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Solway",
                                                  color: Colors.black))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        height: 30,
                                        child: TextFormField(
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Solway",
                                            ),
                                            controller: weightController,
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            focusNode: focus2,
                                            onFieldSubmitted: (v) {
                                              FocusScope.of(context)
                                                  .requestFocus(focus3);
                                            },
                                            decoration: new InputDecoration(
                                              fillColor: Colors.black,
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0),
                                                borderSide: new BorderSide(),
                                              ),
                                            )),
                                      ),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 75,
                                          child: Text("Description",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Solway",
                                                  color: Colors.black))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        height: 75,
                                        child: TextFormField(
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: "Solway",
                                          ),
                                          controller: desController,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          focusNode: focus3,
                                          onFieldSubmitted: (v) {
                                            FocusScope.of(context)
                                                .requestFocus(focus4);
                                          },
                                          decoration: new InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(5),
                                            fillColor: Colors.black,
                                            border: new OutlineInputBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      5.0),
                                              borderSide: new BorderSide(),
                                            ),
                                          ),
                                          maxLines: 8,
                                          minLines: 3,
                                        ),
                                      ),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 75,
                                          child: Text("Highlight",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Solway",
                                                  color: Colors.black))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        height: 75,
                                        child: TextFormField(
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: "Solway",
                                          ),
                                          controller: highController,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          focusNode: focus4,
                                          onFieldSubmitted: (v) {
                                            FocusScope.of(context)
                                                .requestFocus(focus5);
                                          },
                                          decoration: new InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(5),
                                            fillColor: Colors.black,
                                            border: new OutlineInputBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      5.0),
                                              borderSide: new BorderSide(),
                                            ),
                                          ),
                                          maxLines: 8,
                                          minLines: 3,
                                        ),
                                      ),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 75,
                                          child: Text("Specification",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Solway",
                                                  color: Colors.black))),
                                    ),
                                    TableCell(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        height: 75,
                                        child: TextFormField(
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: "Solway",
                                          ),
                                          controller: speController,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          focusNode: focus5,
                                          onFieldSubmitted: (v) {
                                            FocusScope.of(context)
                                                .requestFocus(focus6);
                                          },
                                          decoration: new InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(5),
                                            fillColor: Colors.black,
                                            border: new OutlineInputBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      5.0),
                                              borderSide: new BorderSide(),
                                            ),
                                          ),
                                          maxLines: 8,
                                          minLines: 3,
                                        ),
                                      ),
                                    ),
                                  ]),
                                ]),
                            SizedBox(height: 3),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    minWidth: screenWidth / 3,
                                    height: 40,
                                    child: Text(
                                      'Upload Image',
                                      style: TextStyle(
                                        fontFamily: "Solway",
                                      ),
                                    ),
                                    color: Colors.amber,
                                    textColor: Colors.white,
                                    elevation: 5,
                                    onPressed: () => uploadImage(_image),
                                  ),
                                  MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    minWidth: screenWidth / 3,
                                    height: 40,
                                    child: Text(
                                      'Update Product',
                                      style: TextStyle(
                                        fontFamily: "Solway",
                                      ),
                                    ),
                                    color: Colors.amber,
                                    textColor: Colors.white,
                                    elevation: 5,
                                    onPressed: () => updateProductDialog(),
                                  ),
                                ]),
                          ],
                        )))),
          ],
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          promotion();
        },
        child: const Icon(Icons.local_offer),
        backgroundColor: Colors.amber,
      ),
    );
  }

  void promotion() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Please input the promotion amount.",
                style: TextStyle(color: Colors.black, fontFamily: "Solway"),
              ),
              content: new TextField(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  controller: promoteController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Promote Amount (%)',
                    labelStyle: TextStyle(fontFamily: "Solway"),
                    icon: Icon(
                      Icons.local_offer,
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
                  onPressed: () {
                    if (int.parse(promoteController.text) >= 100) {
                      final snackBar = SnackBar(
                        content: Text(
                          'Promotion cannot more than 100%',
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
                      setPromotion();
                      Navigator.of(context).pop(false);
                      return;
                    }
                  },
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

  setPromotion() {
    {
      if (promoteController.text.length < 1) {
        final snackBar = SnackBar(
          content: Text(
            'Please enter the correct information',
            style: TextStyle(fontFamily: "Solway", color: Colors.white),
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
      if (promoteController.text == "0") {
        double promoteprice = 0;

        ProgressDialog pr = new ProgressDialog(context,
            type: ProgressDialogType.Normal, isDismissible: false);
        pr.style(message: "Updating product...");
        pr.show();

        http.post(server + "/php/set_promotion.php", body: {
          "id": widget.product.id,
          "promote": promoteprice.toStringAsFixed(2),
        }).then((res) {
          print(res.body);
          pr.hide();
          if (res.body == "failed") {
            final snackBar = SnackBar(
              content: Text(
                'Update failed',
                style: TextStyle(fontFamily: "Solway", color: Colors.white),
              ),
              action: SnackBarAction(
                label: 'Close',
                textColor: Colors.white,
                onPressed: () {},
              ),
            );

            // ignore: deprecated_member_use
            _scaffold.currentState.showSnackBar(snackBar);
            Navigator.of(context).pop();
            return;
          } else {
            final snackBar = SnackBar(
              content: Text(
                'Update Success',
                style: TextStyle(fontFamily: "Solway", color: Colors.white),
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
          pr.hide();
        });
        return;
      } else {
        newprice = (double.parse(widget.product.price) *
                double.parse(promoteController.text)) /
            100;
        double promoteprice = double.parse(widget.product.price) - newprice;

        ProgressDialog pr = new ProgressDialog(context,
            type: ProgressDialogType.Normal, isDismissible: false);
        pr.style(message: "Updating product...");
        pr.show();

        http.post(server + "/php/set_promotion.php", body: {
          "id": widget.product.id,
          "promote": promoteprice.toStringAsFixed(2),
        }).then((res) {
          print(res.body);
          pr.hide();
          if (res.body == "failed") {
            final snackBar = SnackBar(
              content: Text(
                'Update failed',
                style: TextStyle(fontFamily: "Solway", color: Colors.white),
              ),
              action: SnackBarAction(
                label: 'Close',
                textColor: Colors.white,
                onPressed: () {},
              ),
            );

            // ignore: deprecated_member_use
            _scaffold.currentState.showSnackBar(snackBar);
            Navigator.of(context).pop();
            return;
          } else {
            final snackBar = SnackBar(
              content: Text(
                'Update Success',
                style: TextStyle(fontFamily: "Solway", color: Colors.white),
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
          pr.hide();
        });
        return;
      }
    }
  }

  void _choose() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void uploadImage(File imageFile) async {
    String base64Image = base64Encode(imageFile.readAsBytesSync());
    http.post(uploadImageUrl, body: {
      "encoded_string": base64Image,
      "id": widget.product.id,
    }).then((res) {
      if (res.body == "Upload Successful") {
        final snackBar = SnackBar(
          content: Text(
            'Upload Success',
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
        return;
      } else {
        final snackBar = SnackBar(
          content: Text(
            'Upload Failed',
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
        return;
      }
    }).catchError((err) {
      print(err);
    });
  }

  updateProductDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Update Product ID " + widget.product.id,
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Solway",
            ),
          ),
          content: new Text("Are you sure?",
              style: TextStyle(
                color: Colors.black,
                fontFamily: "Solway",
              )),
          actions: <Widget>[
            // ignore: deprecated_member_use
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Solway",
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                updateProduct();
              },
            ),
            // ignore: deprecated_member_use
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Solway",
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  updateProduct() {
    if (prnameController.text.length < 1) {
      final snackBar = SnackBar(
        content: Text(
          'Please enter the correct information',
          style: TextStyle(fontFamily: "Solway", color: Colors.white),
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
    if (priceController.text.length < 1) {
      final snackBar = SnackBar(
        content: Text(
          'Please enter the correct information',
          style: TextStyle(fontFamily: "Solway", color: Colors.white),
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
    if (quanController.text.length < 1) {
      final snackBar = SnackBar(
        content: Text(
          'Please enter the correct information',
          style: TextStyle(fontFamily: "Solway", color: Colors.white),
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

    if (desController.text.length < 1) {
      final snackBar = SnackBar(
        content: Text(
          'Please enter the correct information',
          style: TextStyle(fontFamily: "Solway", color: Colors.white),
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

    double price = double.parse(priceController.text);
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Updating product...");
    pr.show();

    if (_image != null) {
      http.post(server + "/php/update_product.php", body: {
        "id": widget.product.id,
        "name": prnameController.text,
        "quantity": quanController.text,
        "price": price.toStringAsFixed(2),
        "weight": weightController.text,
        "description": desController.text,
        "specification": speController.text,
        "highlight": highController.text,
      }).then((res) {
        print(res.body);
        pr.hide();
        if (res.body == "failed") {
          final snackBar = SnackBar(
            content: Text(
              'Update failed',
              style: TextStyle(fontFamily: "Solway", color: Colors.white),
            ),
            action: SnackBarAction(
              label: 'Close',
              textColor: Colors.white,
              onPressed: () {},
            ),
          );

          // ignore: deprecated_member_use
          _scaffold.currentState.showSnackBar(snackBar);
          Navigator.of(context).pop();
          return;
        } else {
          final snackBar = SnackBar(
            content: Text(
              'Update Success',
              style: TextStyle(fontFamily: "Solway", color: Colors.white),
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
        pr.hide();
      });
      return;
    } else {
      http.post(server + "/php/update_product.php", body: {
        "id": widget.product.id,
        "name": prnameController.text,
        "quantity": quanController.text,
        "weight": weightController.text,
        "price": price.toStringAsFixed(2),
        "description": desController.text,
        "specification": speController.text,
        "highlight": highController.text,
      }).then((res) {
        print(res.body);
        pr.hide();
        if (res.body == "success") {
          final snackBar = SnackBar(
            content: Text(
              'Update Success',
              style: TextStyle(fontFamily: "Solway", color: Colors.white),
            ),
            action: SnackBarAction(
              label: 'Close',
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          );

          // ignore: deprecated_member_use
          _scaffold.currentState.showSnackBar(snackBar);
          return;
        } else {
          final snackBar = SnackBar(
            content: Text(
              'Update Failed',
              style: TextStyle(fontFamily: "Solway", color: Colors.white),
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
        pr.hide();
      });
      return;
    }
  }

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
}
