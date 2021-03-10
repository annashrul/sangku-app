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
  const BinaryScreen({Key key}) : super(key: key);

  @override
  _BinaryScreenState createState() => _BinaryScreenState();
}

class _BinaryScreenState extends State<BinaryScreen> with SingleTickerProviderStateMixin,AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  String url='';
  bool isLoading=true;
  String fullName='',picture='', referralCode='';
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
          ),description:referralCode,widget: []),

          body:url!=''?Padding(
            padding: EdgeInsets.only(top:0,left:0,right:0),
            child: PageStorage(
              bucket: bucket,
              child: TabBarView(
                  controller: _tabController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    GridViewImagePage(),
                    // WebViewWidget(val: {"url":'http://sangqu.id/web_view/binary/$url',"reload":true}),
                    WebViewWidget(val: {"url":'http://sangqu.id/web_view/sponsor/$url',"reload":true})
                  ]
              ),
            ),
          ):WidgetHelper().loadingWidget(context),
        )
    );
  }

}


class GridViewImagePage extends StatefulWidget {
  @override
  _GridViewImagePageState createState() => _GridViewImagePageState();
}

class _GridViewImagePageState extends State<GridViewImagePage> {
  final images = [
    'https://images.unsplash.com/photo-1440589473619-3cde28941638?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400&q=60',
    'https://images.unsplash.com/photo-1487222477894-8943e31ef7b2?ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=60',
    'https://images.unsplash.com/photo-1499229694635-fc626e0d9c01?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400&q=60',
    'https://images.unsplash.com/photo-1525186402429-b4ff38bedec6?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400&q=60',
    'https://images.unsplash.com/photo-1463453091185-61582044d556?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80',
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400&q=80',
    'https://images.unsplash.com/photo-1506277886164-e25aa3f4ef7f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=375&q=80',
    'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=334&q=80',
    'https://images.unsplash.com/photo-1497551060073-4c5ab6435f12?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400&q=80',
    'https://images.unsplash.com/photo-1482849297070-f4fae2173efe?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400&q=80',
    'https://images.unsplash.com/photo-1527203561188-dae1bc1a417f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400&q=80',
    'https://images.unsplash.com/photo-1488820098099-8d4a4723a490?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400&q=60',
    'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=334&q=80',
    'https://images.unsplash.com/photo-1497551060073-4c5ab6435f12?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400&q=80',
    'https://images.unsplash.com/photo-1482849297070-f4fae2173efe?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400&q=80',
    'https://images.unsplash.com/photo-1527203561188-dae1bc1a417f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400&q=80',
    'https://images.unsplash.com/photo-1488820098099-8d4a4723a490?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400&q=60',
  ];

  final controller = ScrollController();
  static const double padding = 16;
  static const double spacing = 8;
  static const int crossAxisCount = 3;
  int item = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 2/2,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
      ),
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(padding),
      itemCount: images.length,
      controller: controller,
      itemBuilder: (context, index) {
        final item = images[index];

        return InkWell(
          borderRadius: BorderRadius.circular(4.0),
          onTap: () {
          },
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFEEEEEE),
              borderRadius: BorderRadius.circular(4.0),
            ),
            // width: getWidth(context) * 0.78,
            // height: getWidth(context) * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                  child: CachedNetworkImage(
                    imageUrl: item,
                    fit: BoxFit.cover,
                    width: getWidth(context) * 0.78,
                    height: getWidth(context) * 0.28,
                    placeholder: (context, url) => Image.asset(Constant().localAssets+"logo.png", fit:BoxFit.cover),
                    errorWidget: (context, url, error) => Image.asset(Constant().localAssets+"logo.png", fit:BoxFit.cover),
                  ),

                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: Constant().moneyColor,
                      padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                      child:WidgetHelper().textQ("widget.contentModel.result.data[widget.idx].category",10,Constant().secondDarkColor,FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                    child:WidgetHelper().textQ("widget.contentModel.result.data[widget.idx].title",12,Constant().darkMode,FontWeight.normal,maxLines: 2),

                  ),
                )
              ],
            ),
          ),
        );
      },
    ),
  );


}

