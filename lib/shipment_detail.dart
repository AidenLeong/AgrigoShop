import 'dart:convert';
import 'package:flutter/material.dart';
import 'order.dart';
import 'package:http/http.dart' as http;

import 'shipment.dart';

class ShipmentDetail extends StatefulWidget {
  final Order order;

  const ShipmentDetail({Key key, this.order}) : super(key: key);
  @override
  _ShipmentDetailState createState() => _ShipmentDetailState();
}

class _ShipmentDetailState extends State<ShipmentDetail> {
  final GlobalKey<ScaffoldState> _scaffold = new GlobalKey<ScaffoldState>();
  String urlStatus = "https://justminedb.com/aggs/php/update_status.php";
  TextEditingController statusController = TextEditingController();
  List _shipmentdetails;
  String titlecenter = "Loading...";
  double screenHeight, screenWidth;
  String dropdownValue = 'One';

  @override
  void initState() {
    super.initState();
    _loadOrderDetails();
    print(widget.order.ttlprice);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffold,
      body: Stack(children: [
        Positioned(
          left: 0,
          top: 25,
          child: RawMaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            elevation: 8.0,
            fillColor: Colors.white,
            child: Icon(
              Icons.arrow_back_ios_outlined,
              color: Colors.amber,
            ),
            padding: EdgeInsets.all(8.0),
            shape: CircleBorder(),
          ),
        ),
        Column(children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Center(
            child: Text(
              "Shipment Details",
              style: TextStyle(
                  color: Colors.black, fontFamily: 'Solway', fontSize: 28),
            ),
          ),
        ]),
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 390,
              height: 450,
              child: Card(
                elevation: 10,
                child: Center(
                  child: Column(children: <Widget>[
                    Row(children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(30, 10, 0, 0),
                        child: Text(
                          'Order ID: ' + widget.order.orderid,
                          textAlign: TextAlign.start,
                          style: TextStyle(fontFamily: 'Solway'),
                        ),
                      )
                    ]),
                    Row(children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(30, 10, 0, 0),
                        child: Text(
                          'Place on: ' + widget.order.dateorder,
                          textAlign: TextAlign.start,
                          style: TextStyle(fontFamily: 'Solway'),
                        ),
                      ),
                    ]),
                    Row(children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(30, 10, 0, 0),
                        child: Text(
                          'Total Amount: RM ' + widget.order.ttlprice,
                          textAlign: TextAlign.end,
                          style: TextStyle(fontFamily: 'Solway'),
                        ),
                      ),
                    ]),
                    Row(children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(30, 10, 0, 0),
                        child: Text(
                          'Ship To: ' + widget.order.buyeremail,
                          textAlign: TextAlign.end,
                          style: TextStyle(fontFamily: 'Solway'),
                        ),
                      ),
                    ]),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40.0, vertical: 1),
                      child: Table(
                        defaultColumnWidth: FlexColumnWidth(1),
                        columnWidths: {
                          0: FlexColumnWidth(0.1),
                          1: FlexColumnWidth(0.1),
                        },
                        children: [
                          TableRow(
                            children: [
                              TableCell(
                                child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 30,
                                    child: Text("   Item ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Solway',
                                            color: Colors.black))),
                              ),
                              TableCell(
                                child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 30,
                                    child: Text(
                                      "            Quantity ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Solway',
                                          color: Colors.black),
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _shipmentdetails == null
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
                            child: ListView.builder(
                                itemCount: _shipmentdetails == null
                                    ? 0
                                    : _shipmentdetails.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 1, 10, 1),
                                      child: InkWell(
                                          onTap: null,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 40.0, vertical: 1),
                                            child: Table(
                                              border: TableBorder(
                                                  bottom: BorderSide(
                                                color: Colors.blue,
                                                width: 1,
                                              )),
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
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        height: 40,
                                                        child: Text(
                                                          _shipmentdetails[
                                                              index]['name'],
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'Solway',
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    TableCell(
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        height: 30,
                                                        child: Text(
                                                          '     ' +
                                                              _shipmentdetails[
                                                                      index]
                                                                  ['cquantity'],
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'Solway',
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )));
                                })),
                    Row(children: [
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                          width: 300,
                          height: 70,
                          child: TextField(
                            style: TextStyle(fontFamily: "Solway"),
                            controller: statusController,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: 'Shipment Status',
                              hintStyle: TextStyle(fontFamily: "Solway"),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.amber, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                              ),
                            ),
                          )),
                      IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            _updateStatus();
                          })
                    ]),
                  ]),
                ),
              ),
            )
          ]),
        ])
      ]),
    );
  }

  void _updateStatus() {
    String _status = statusController.text;

    http.post(urlStatus, body: {
      "status": _status,
      "orderid": widget.order.orderid,
      "selleremail": widget.order.selleremail,
      "id": widget.order.id,
    }).then((res) {
      if (res.body == "failed") {
        print(res.body);

        final snackBar = SnackBar(
          content:
              Text('Update Failed', style: TextStyle(fontFamily: "Solway")),
          action: SnackBarAction(
            label: 'Close',
            textColor: Colors.white,
            onPressed: () {},
          ),
        );

        // ignore: deprecated_member_use
        _scaffold.currentState.showSnackBar(
          snackBar,
        );
        return;
      } else {
        final snackBar = SnackBar(
          content: Text('Update Success',
              style: TextStyle(
                fontFamily: "Solway",
              )),
          action: SnackBarAction(
            label: 'Close',
            textColor: Colors.white,
            onPressed: () {
              Navigator.pop(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Shipment()));
            },
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

  _loadOrderDetails() async {
    String urlLoadJobs =
        "https://justminedb.com/aggs/php/load_shipmenthistory.php";
    await http.post(urlLoadJobs, body: {
      "orderid": widget.order.orderid,
      "selleremail": widget.order.selleremail,
      "id": widget.order.id,
      "buyeremail": widget.order.buyeremail,
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        setState(() {
          _shipmentdetails = null;
          titlecenter = "No Previous Payment";
        });
        return;
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          _shipmentdetails = extractdata["carthistory"];
        });
        return;
      }
    }).catchError((err) {
      print(err);
    });
  }
}
