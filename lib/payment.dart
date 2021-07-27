import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'product.dart';
import 'user.dart';

class Payment extends StatefulWidget {
  final User user;
  final Product product;
  final String orderid, val;
  Payment({this.user, this.orderid, this.val, this.product});

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        SizedBox(
          height: 25,
        ),
        Row(children: <Widget>[
          RawMaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            elevation: 8.0,
            fillColor: Colors.white,
            child: Icon(Icons.arrow_back_ios_rounded),
            padding: EdgeInsets.all(8.0),
            shape: CircleBorder(),
          ),
          SizedBox(
            width: 58,
          ),
          Text("Payment", style: TextStyle(fontSize: 28, fontFamily: "Solway")),
          SizedBox(
            width: 44,
          ),
        ]),
        Expanded(
          child: WebView(
            initialUrl: 'https://justminedb.com/aggs/php/payment.php?email=' +
                widget.user.email +
                '&mobile=' +
                widget.user.phone +
                '&name=' +
                widget.user.name +
                '&amount=' +
                widget.val +
                '&orderid=' +
                widget.orderid,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
          ),
        )
      ],
    ));
  }
}
