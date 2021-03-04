import 'dart:async';
import 'dart:io';
import 'dart:math';

// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/user_helper.dart';
// import 'package:graphview/GraphView.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:sangkuy/view/screen/pages.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BinaryScreen extends StatefulWidget {
  const BinaryScreen({Key key}) : super(key: key);

  @override
  _BinaryScreenState createState() => _BinaryScreenState();
}

class _BinaryScreenState extends State<BinaryScreen> {
  String url='';
  bool isLoading=true;
  Future getUrl()async{
    final uid = await UserHelper().getDataUser('referral_code');
    final token = FunctionHelper().decode(await UserHelper().getDataUser('token'));
    print(uid);
    print(token);
    String concat = FunctionHelper().decode(uid+"|"+token);
    http://sangqu.id/web_view/binary/TUI1NzExODY4ODI1fFpYbEthR0pIWTJsUGFVcEpWWHBKTVU1cFNYTkpibEkxWTBOSk5rbHJjRmhXUTBvNUxtVjVTakZqTWxaNVUxZFJhVTlwU1hoSmFYZHBZVmRHTUVscWIzaE9ha1V3VG5wWk5FOUVUVEpNUTBwc1pVaEJhVTlxUlRKTlZHTjZUbXBCTkUxNldqa3VSV3BwUlZGNE4zUmFVR053ZFZGbk5UbFVRa3RFUW14TGREZE1OR3hOWmxobVlUQkhVM0JpVEV0bFZRPT0=
    setState(() {
      isLoading=false;
      url = "http://sangqu.id/web_view/binary/"+concat;
    });
    print('######################### $url #############################');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper().appBarNoButton(context,"Jaringan",<Widget>[]),
        body: isLoading?WidgetHelper().loadingWidget(context):WikipediaExplorer(url:url)
    );
  }



}

class WikipediaExplorer extends StatefulWidget {
  final String url;
  WikipediaExplorer({this.url});
  @override
  _WikipediaExplorerState createState() => _WikipediaExplorerState();
}

class _WikipediaExplorerState extends State<WikipediaExplorer> {
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
      body:IndexedStack(
        index: _stackToView,
        children: [
          WebView(
            key: _key,
            // initialUrl: "http://sangqu.id/web_view/binary/TUI1NzExODY4ODI1fFpYbEthR0pIWTJsUGFVcEpWWHBKTVU1cFNYTkpibEkxWTBOSk5rbHJjRmhXUTBvNUxtVjVTakZqTWxaNVUxZFJhVTlwU1hoSmFYZHBZVmRHTUVscWIzaE9ha1V3VG5wWk5FOUVUVEpNUTBwc1pVaEJhVTlxUlRKTlZHTjZUbXBCTkUxNldqa3VSV3BwUlZGNE4zUmFVR053ZFZGbk5UbFVRa3RFUW14TGREZE1OR3hOWmxobVlUQkhVM0JpVEV0bFZRPT0=",
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (String uri) {
              // print('Page finished loading: $url');
              // print('Page finished loading: $uri');
              //hide you progressbar here
              setState(() {
                _stackToView = 0;
              });
            },
            // onPageFinished: _handleLoad,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
          ),
          Container(child: Center(child: WidgetHelper().loadingWidget(context))),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Constant().mainColor,
        foregroundColor: Colors.white,
        onPressed: ()=>_controller.future.then((value){
          print(value.reload());
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