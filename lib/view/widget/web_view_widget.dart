import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:webview_flutter/platform_interface.dart';
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
  bool isError=false;

  handleRefresh(){
    print('abus');
    setState(() {
      _stackToView=1;
    });
    return _controller.future.then((value){
      if(_stackToView==0){
        // widget.callback();
        value.reload();
        value.loadUrl(widget.val['url']);
        setState(() {
          isError=false;
          _stackToView=1;
        });
      }
    });

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getUrl();
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: isError?Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text("Terjadi kesalahan"),
          )
        ],
      ):IndexedStack(
        index: _stackToView,
        children: [
          WebView(
            // debuggingEnabled: true,
            onWebResourceError: (WebResourceError w){
              setState(() {
                isError =true;
              });
            },
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
          Container(
            child: WidgetHelper().textQ("Terjadi kesalahan", 12, Constant().darkMode,FontWeight.bold),
          )
        ],
      ),
      // floatingActionButton: widget.val['reload']==null?Text(''):FloatingActionButton(
      //   backgroundColor: Constant().mainColor,
      //   foregroundColor: Colors.white,
      //   // onPressed: ()=>_controller.future.then((value){
      //   //   if(_stackToView==0){
      //   //     // widget.callback();
      //   //     value.reload();
      //   //     value.loadUrl(widget.val['url']);
      //   //     setState(() {
      //   //       isError=false;
      //   //       _stackToView=1;
      //   //     });
      //   //   }
      //   // }),
      //   // onPressed:widget.callback(_controller),
      //   child: _stackToView==1?CircularProgressIndicator(backgroundColor: Colors.white,valueColor:new AlwaysStoppedAnimation<Color>(Constant().mainColor)):Icon(AntDesign.reload1),
      // ),

    );
  }
}
