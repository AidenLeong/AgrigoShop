import 'dart:convert';
import 'package:flutter/material.dart';
import 'order.dart';
import 'package:http/http.dart' as http;

class OrderDetail extends StatefulWidget {
  final Order order;

  const OrderDetail({Key key, this.order}) : super(key: key);
  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  List _orderdetails;
  String titlecenter = "Loading...";
  double screenHeight, screenWidth;

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
            "Order Details",
            style: TextStyle(
                color: Colors.black, fontFamily: 'Solway', fontSize: 28),
          ),
        ),
      ]),
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 360,
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
                        'Seller: ' + widget.order.selleremail,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontFamily: 'Solway'),
                      ),
                    ),
                  ]),
                  Row(children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(30, 10, 0, 0),
                      child: Text(
                        'Status: ' + widget.order.status,
                        textAlign: TextAlign.start,
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
                  _orderdetails == null
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
                              itemCount: _orderdetails == null
                                  ? 0
                                  : _orderdetails.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding: EdgeInsets.fromLTRB(10, 1, 10, 1),
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
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      height: 40,
                                                      child: Text(
                                                        _orderdetails[index]
                                                            ['name'],
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily: 'Solway',
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
                                                            _orderdetails[index]
                                                                ['cquantity'],
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily: 'Solway',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )));
                              }))
                ]),
              ),
            ),
          ),
        ]),
      ])
    ]));
  }

  _loadOrderDetails() async {
    String urlLoadJobs = "https://justminedb.com/aggs/php/load_carthistory.php";
    await http.post(urlLoadJobs, body: {
      "orderid": widget.order.orderid,
      "selleremail": widget.order.selleremail,
      "id": widget.order.id,
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        setState(() {
          _orderdetails = null;
          titlecenter = "No Previous Payment";
        });
        return;
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          _orderdetails = extractdata["carthistory"];
        });
        return;
      }
    }).catchError((err) {
      print(err);
    });
  }
}
