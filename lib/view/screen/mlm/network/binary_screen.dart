import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/user_helper.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/view/screen/pages.dart';
import 'package:sangkuy/view/widget/header_widget.dart';
import 'package:sangkuy/view/widget/web_view_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BinaryScreen extends StatefulWidget {
  final WebViewWidget homePageState;

  const BinaryScreen({Key key, @required this.homePageState}) : super(key: key);

  @override
  _BinaryScreenState createState() => _BinaryScreenState();
}

class _BinaryScreenState extends State<BinaryScreen> with SingleTickerProviderStateMixin,AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  String url='';
  bool isLoading=true;
  String fullName='',picture='', referralCode='';
  // GlobalKey<WebViewWidget> _myKey = GlobalKey();

  Future loadMember()async{
    final name=await UserHelper().getDataUser("full_name");
    final img=await UserHelper().getDataUser("picture");
    final ref=await UserHelper().getDataUser("referral_code");
    setState(() {
      fullName=name;
      picture=img;
      referralCode=ref;
    });
  }
  Future getUrl()async{
    final uid = await UserHelper().getDataUser('referral_code');
    final token = await FunctionHelper().decode(await UserHelper().getDataUser('token'));
    String concat = FunctionHelper().decode(uid+"|"+token);
    http://sangqu.id/web_view/binary/TUI1NzExODY4ODI1fFpYbEthR0pIWTJsUGFVcEpWWHBKTVU1cFNYTkpibEkxWTBOSk5rbHJjRmhXUTBvNUxtVjVTakZqTWxaNVUxZFJhVTlwU1hoSmFYZHBZVmRHTUVscWIzaE9ha1V3VG5wWk5FOUVUVEpNUTBwc1pVaEJhVTlxUlRKTlZHTjZUbXBCTkUxNldqa3VSV3BwUlZGNE4zUmFVR053ZFZGbk5UbFVRa3RFUW14TGREZE1OR3hOWmxobVlUQkhVM0JpVEV0bFZRPT0=
    setState(() {
      // referralCode=uid;
      isLoading=false;
      url = concat;
      // url = "http://sangqu.id/web_view/binary/"+concat;
    });
    print(url);
  }
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUrl();
    loadMember();
    _tabController = TabController(length: 2, initialIndex: _tabIndex, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }
  int _tabIndex=0;
  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      print(_tabController.indexIsChanging);
      setState(() {
        _tabIndex = _tabController.index;
      });
    }
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  String lbl='';
  final PageStorageBucket bucket = PageStorageBucket();





  Completer<WebViewController> _controller = Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    Map<String, dynamic> row = {
      'Binary':'Binary',
      'Sponsor':'Sponsor',
    };
    return DefaultTabController(
        key: widget.key,
        length: 2,
        initialIndex: 0,
        child:  Scaffold(
          appBar: WidgetHelper().appBarWithTab(context,_tabController, fullName,row,_tabIndex==0?"Binary":"Sponsor",(idx){
            setState(() {lbl = idx;});
          },leading:Padding(
            padding: EdgeInsets.all(8.0),
            child:  CircleImage(
              param: 'network',
              key: Key("packageScreen"),
              image: picture,
              size: 50.0,
              padding: 0.0,
            ),
          ),description:referralCode,widget: [
            IconButton(icon: Icon(AntDesign.reload1), onPressed:(){
              widget.homePageState.
              // WebViewWidget().createState().handleRefresh();
            })
          ]),

          body:url!=''?Padding(
            padding: EdgeInsets.only(top:0,left:0,right:0),
            child: PageStorage(
              bucket: bucket,
              child: TabBarView(
                  controller: _tabController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    WebViewWidget(val: {"url":'http://sangqu.id/web_view/binary/$url',"reload":true}),
                    WebViewWidget(val: {"url":'http://sangqu.id/web_view/sponsor/$url',"reload":true})
                  ]
              ),
            ),
          ):WidgetHelper().loadingWidget(context),
        )
    );
  }

}

