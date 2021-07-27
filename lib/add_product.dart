import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:aggs/user.dart';
import 'package:flutter/material.dart';
//import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:random_string/random_string.dart';

class AddProduct extends StatefulWidget {
  final User user;
  const AddProduct({Key key, this.user}) : super(key: key);
  static final scaffoldKey1 = GlobalKey<ScaffoldState>();

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final GlobalKey<ScaffoldState> _scaffold = new GlobalKey<ScaffoldState>();
  String uploadImageUrl =
      'https://justminedb.com/aggs/php/upload_product_image.php';
  String addItemUrl = 'https://justminedb.com/aggs/php/insert_product.php';

  File _image;
  String pathAsset = 'assets/images/phonecam.png';
  TextEditingController prnameEditingController = new TextEditingController();
  TextEditingController priceEditingController = new TextEditingController();
  TextEditingController desEditingController = new TextEditingController();
  TextEditingController quanEditingController = new TextEditingController();
  TextEditingController speEditingController = new TextEditingController();
  TextEditingController highEditingController = new TextEditingController();
  TextEditingController weightEditingController = new TextEditingController();

  final focus0 = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();
  final focus5 = FocusNode();
  final focus6 = FocusNode();
  final focus7 = FocusNode();
  final focus8 = FocusNode();
  final focus9 = FocusNode();
  String selectedType;
  double screenHeight, screenWidth;
  String id;

  @override
  void initState() {
    id = '${randomAlpha(1).toLowerCase()}-${randomNumeric(6)}';
    super.initState();
    print(widget.user.email);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffold,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                    child: RawMaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      elevation: 8.0,
                      fillColor: Colors.white,
                      child: Icon(Icons.arrow_back_ios_rounded,
                          color: Colors.amber),
                      padding: EdgeInsets.all(8.0),
                      shape: CircleBorder(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(1, 45, 0, 0),
                    child: Text(
                      "Add New Product",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Solway',
                          fontSize: 28),
                    ),
                  )
                ],
              ),
              SizedBox(height: 27),
              GestureDetector(
                  onTap: () => {_choose()},
                  child: Container(
                    height: screenHeight / 3,
                    width: screenWidth / 1.5,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: _image == null
                            ? AssetImage(pathAsset)
                            : FileImage(_image),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(
                        width: 3.0,
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  )),
              SizedBox(height: 5),
              Text("Click the above image to take picture of your product",
                  style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.black,
                      fontFamily: "Solway")),
              SizedBox(height: 5),
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
                                            child: Text("Product Name",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Solway",
                                                  color: Colors.black,
                                                ))),
                                      ),
                                      TableCell(
                                        child: Container(
                                          margin:
                                              EdgeInsets.fromLTRB(5, 1, 5, 1),
                                          height: 30,
                                          child: TextFormField(
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: "Solway",
                                              ),
                                              controller:
                                                  prnameEditingController,
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
                                          margin:
                                              EdgeInsets.fromLTRB(5, 1, 5, 1),
                                          height: 30,
                                          child: TextFormField(
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: "Solway",
                                              ),
                                              controller:
                                                  priceEditingController,
                                              keyboardType:
                                                  TextInputType.number,
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
                                            child: Text("Description",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: "Solway",
                                                    color: Colors.black))),
                                      ),
                                      TableCell(
                                        child: Container(
                                          margin:
                                              EdgeInsets.fromLTRB(5, 1, 5, 1),
                                          height: 30,
                                          child: TextFormField(
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Solway",
                                            ),
                                            controller: desEditingController,
                                            keyboardType: TextInputType.text,
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
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                                    TableRow(children: [
                                      TableCell(
                                        child: Container(
                                            alignment: Alignment.centerLeft,
                                            height: 30,
                                            child: Text("Highlight",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: "Solway",
                                                    color: Colors.black))),
                                      ),
                                      TableCell(
                                        child: Container(
                                          margin:
                                              EdgeInsets.fromLTRB(5, 1, 5, 1),
                                          height: 30,
                                          child: TextFormField(
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Solway",
                                            ),
                                            controller: highEditingController,
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
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                                    TableRow(children: [
                                      TableCell(
                                        child: Container(
                                            alignment: Alignment.centerLeft,
                                            height: 30,
                                            child: Text("Specification",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: "Solway",
                                                    color: Colors.black))),
                                      ),
                                      TableCell(
                                        child: Container(
                                          margin:
                                              EdgeInsets.fromLTRB(5, 1, 5, 1),
                                          height: 30,
                                          child: TextFormField(
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Solway",
                                            ),
                                            controller: speEditingController,
                                            textInputAction:
                                                TextInputAction.next,
                                            focusNode: focus3,
                                            onFieldSubmitted: (v) {
                                              FocusScope.of(context)
                                                  .requestFocus(focus4);
                                            },
                                            decoration: new InputDecoration(
                                              fillColor: Colors.black,
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0),
                                                borderSide: new BorderSide(),
                                              ),
                                            ),
                                          ),
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
                                          margin:
                                              EdgeInsets.fromLTRB(5, 1, 5, 1),
                                          height: 30,
                                          child: TextFormField(
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: "Solway",
                                              ),
                                              controller: quanEditingController,
                                              keyboardType:
                                                  TextInputType.number,
                                              textInputAction:
                                                  TextInputAction.next,
                                              focusNode: focus4,
                                              onFieldSubmitted: (v) {
                                                FocusScope.of(context)
                                                    .requestFocus(focus5);
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
                                          margin:
                                              EdgeInsets.fromLTRB(5, 1, 5, 1),
                                          height: 30,
                                          child: TextFormField(
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: "Solway",
                                              ),
                                              controller:
                                                  weightEditingController,
                                              keyboardType:
                                                  TextInputType.number,
                                              textInputAction:
                                                  TextInputAction.next,
                                              focusNode: focus5,
                                              onFieldSubmitted: (v) {
                                                FocusScope.of(context)
                                                    .requestFocus(focus5);
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
                                  ]),
                              SizedBox(height: 3),
                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                minWidth: screenWidth / 1.5,
                                height: 40,
                                child: Text(
                                  'Insert New Product',
                                  style: TextStyle(fontFamily: "Solway"),
                                ),
                                color: Colors.amber,
                                textColor: Colors.white,
                                elevation: 5,
                                onPressed: () {
                                  if (prnameEditingController.text == '' ||
                                      prnameEditingController.text == null ||
                                      priceEditingController.text == '' ||
                                      priceEditingController.text == null ||
                                      desEditingController.text == '' ||
                                      desEditingController.text == null ||
                                      quanEditingController.text == '' ||
                                      quanEditingController.text == null ||
                                      highEditingController.text == '' ||
                                      highEditingController.text == null ||
                                      speEditingController.text == '' ||
                                      speEditingController.text == null ||
                                      weightEditingController.text == '' ||
                                      weightEditingController.text == null) {
                                    // ignore: unused_local_variable
                                    final snackBar = SnackBar(
                                      content: Text(
                                        'Incomplele details!',
                                        style: TextStyle(fontFamily: "Solway"),
                                      ),
                                      action: SnackBarAction(
                                        label: 'Close',
                                        textColor: Colors.white,
                                        onPressed: () {},
                                      ),
                                    );

                                    // ignore: deprecated_member_use
                                    _scaffold.currentState
                                        .showSnackBar(snackBar);
                                    return;
                                  }
                                  if (_image == null) {
                                    // ignore: unused_local_variable
                                    final snackBar = SnackBar(
                                      content: Text(
                                        'Please upload a product picture.',
                                        style: TextStyle(fontFamily: "Solway"),
                                      ),
                                      action: SnackBarAction(
                                        label: 'Close',
                                        textColor: Colors.white,
                                        onPressed: () {},
                                      ),
                                    );

                                    // ignore: deprecated_member_use
                                    _scaffold.currentState
                                        .showSnackBar(snackBar);
                                    return;
                                  } else {
                                    insertProduct();
                                    return;
                                  }
                                },
                              ),
                            ],
                          )))),
            ],
          ),
        ),
      ),
    );
  }
  bool priceIsValid(String price) {
    return RegExp(r"[0-9]").hasMatch(price);
  }
    bool quantityIsValid(String quantity) {
    return RegExp(r"[0-9]").hasMatch(quantity);
  }
    bool weightIsValid(String weight) {
    return RegExp(r"[0-9]").hasMatch(weight);
  }
  void _choose() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  insertProduct() {
       if (!priceIsValid(priceEditingController.text)) {
        final snackBar = SnackBar(
          content: Text(
            'Product price can only be in digital form.',
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
         if (!quantityIsValid(quanEditingController.text)) {
        final snackBar = SnackBar(
          content: Text(
            'Product quantity can only be in digital form.',
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
         if (!weightIsValid(weightEditingController.text)) {
        final snackBar = SnackBar(
          content: Text(
            'Product weight can only be in digital form.',
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
    double price = double.parse(priceEditingController.text);
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Inserting new product...");
    pr.show();
    String base64Image = base64Encode(_image.readAsBytesSync());

    http.post("https://justminedb.com/aggs/php/insert_product.php", body: {
      "id": id,
      "name": prnameEditingController.text,
      "price": price.toStringAsFixed(2),
      "description": desEditingController.text,
      "highlight": highEditingController.text,
      "specification": speEditingController.text,
      "email": widget.user.email,
      "quantity": quanEditingController.text,
      "weight": weightEditingController.text,
      "encoded_string": base64Image,
    }).then((res) {
      print(res.body);
      pr.hide();

      if (res.body == "Added Successfully") {
        FocusManager.instance.primaryFocus.unfocus();
        uploadImage(_image, id);
        final snackBar = SnackBar(
          content: Text(
            'Insert Product Successful',
            style: TextStyle(fontFamily: "Solway"),
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
        FocusManager.instance.primaryFocus.unfocus();

        final snackBar = SnackBar(
          content: Text(
            'Insert Failed',
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
      pr.hide();
    });
  }

  void uploadImage(File imageFile, String id) async {
    String base64Image = base64Encode(imageFile.readAsBytesSync());
    http.post(uploadImageUrl, body: {
      "encoded_string": base64Image,
      "id": id,
    }).then((res) {
      if (res.body == "Upload Successful") {
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
}
