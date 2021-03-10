import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewWidget extends StatefulWidget {
  dynamic val;
  WebViewWidget({this.val});
  @override
  _WebViewWidgetState createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends State<WebViewWidget> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  num _stackToView = 1;
  final _key = UniqueKey();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getUrl();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _stackToView,
        children: [
          WebView(
            key: _key,
            initialUrl: widget.val['url'],
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (String uri) {
              setState(() {
                _stackToView = 0;
              });
            },
            onWebViewCreated: (WebViewController webViewController)async {
              _controller.complete(webViewController);
            },
          ),
          Container(child: Center(child: WidgetHelper().loadingWidget(context))),
        ],
      ),
      floatingActionButton: widget.val['reload']==null?Text(''):FloatingActionButton(
        backgroundColor: Constant().mainColor,
        foregroundColor: Colors.white,
        onPressed: ()=>_controller.future.then((value){
          if(_stackToView==0){
            value.reload();
            setState(() {
              _stackToView=1;
            });
          }
        }),
        child: _stackToView==1?CircularProgressIndicator(backgroundColor: Colors.white,valueColor:new AlwaysStoppedAnimation<Color>(Constant().mainColor)):Icon(AntDesign.reload1),
      ),

    );
  }
}
