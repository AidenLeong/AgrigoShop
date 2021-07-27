import 'dart:async';
import 'package:aggs/topup_wallet.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'user.dart';
import 'package:http/http.dart' as http;

class TopUp extends StatefulWidget {
  final User user;
  final String val;
  TopUp({this.user, this.val});
  @override
  _TopUpState createState() => _TopUpState();
}

class _TopUpState extends State<TopUp> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  String server = "https://justminedb.com/aggs";
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => _loadUserData(),
          ),
          backgroundColor: Colors.indigo,
          title: Text(
            'Top Up',
            style: TextStyle(fontFamily: 'Solway', color: Colors.white),
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: WebView(
                initialUrl: 'https://justminedb.com/aggs/php/topup.php?email=' +
                    widget.user.email +
                    '&mobile=' +
                    widget.user.phone +
                    '&name=' +
                    widget.user.name +
                    '&amount=' +
                    widget.val +
                    '&currentwallet=' +
                    widget.user.wallet,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
              ),
            )
          ],
        ));
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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => UserWallet(
                        user: widget.user,
                      )));
        });
        return;
      }
    }).catchError((err) {
      print(err);
    });
  }
}
