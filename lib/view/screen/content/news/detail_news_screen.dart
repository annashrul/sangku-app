import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/refresh_widget.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/content/content_model.dart';
import 'package:sangkuy/view/widget/web_view_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailNewsScreen extends StatefulWidget {
  ContentModel contentModel;
  final int idx;
  DetailNewsScreen({this.contentModel,this.idx});
  @override
  _DetailNewsScreenState createState() => _DetailNewsScreenState();
}

class _DetailNewsScreenState extends State<DetailNewsScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TabController _tabController;
  bool isLoading=false,isError=false;
  Datum val;
  @override
  void dispose() {
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading=true;
    val=widget.contentModel.result.data[widget.idx];
  }
  void _launchURL(_url) async =>
      await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              leading: InkWell(
                onTap: ()=>Navigator.pop(context),
                child: Icon(AntDesign.back),
              ),
              title: WidgetHelper().textQ(val.title,12,Constant().darkMode,FontWeight.bold,maxLines: 1,textAlign: TextAlign.center),
              automaticallyImplyLeading: false,
              // backgroundColor: Constant().secondColor,
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  background: CachedNetworkImage(
                    imageUrl:val.picture,
                    width: double.infinity ,
                    fit:BoxFit.cover,
                    placeholder: (context, url) => Image.asset(Constant().localAssets+"logo.png", fit:BoxFit.cover),
                    errorWidget: (context, url, error) => Image.asset(Constant().localAssets+"logo.png", fit:BoxFit.cover),
                  )
              ),
            ),
          ];
        },
        body: CustomScrollView(
          slivers: <Widget>[
            SliverList(
                delegate: SliverChildListDelegate([
                  Offstage(
                    offstage: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          child:  Column(
                            children: [
                              WidgetHelper().textQ(val.title,12,Constant().darkMode,FontWeight.bold,maxLines: 10,textAlign: TextAlign.left),
                              Divider(),
                              WidgetHelper().titleNoButton(context,AntDesign.infocirlceo,val.category,color: Constant().darkMode),
                              SizedBox(height: 10.0),
                              WidgetHelper().titleNoButton(context,AntDesign.user,val.writer,color: Constant().darkMode),
                              SizedBox(height: 10.0),
                              WidgetHelper().titleNoButton(context,AntDesign.calendar,FunctionHelper().formateDate(val.createdAt, ''),color: Constant().darkMode),
                            ],
                          ),
                          padding: EdgeInsets.only(left:5,top:10,bottom: 10),
                        ),
                        ClipPath(
                          clipper: WaveClipperOne(flip: true),
                          child: Container(
                            padding: EdgeInsets.only(bottom:50.0,top:10.0,left:5.0),
                            width: double.infinity,
                            color: Color(0xFFEEEEEE),
                            child:Html(
                                data: val.caption,
                                defaultTextStyle: TextStyle(fontSize: 14.0,color: Constant().darkMode),
                              onLinkTap: (String url){
                                // _launchURL(url);
                                WidgetHelper().myPush(context,Scaffold(
                                    appBar: WidgetHelper().appBarWithButton(context,url, (){Navigator.pop(context);},<Widget>[]),
                                    body: WebViewWidget(val: {"url":url})
                                ));
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ])
            )
          ],
        ),
      ),
    );
  }
  Widget sliderQ(BuildContext context){
    return FlexibleSpaceBar(
      stretchModes: [
        StretchMode.zoomBackground,
        StretchMode.blurBackground,
        StretchMode.fadeTitle
      ],
      collapseMode: CollapseMode.parallax,
      background: Builder(
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: CachedNetworkImage(
              imageUrl:val.picture,
              width: double.infinity ,
              fit:BoxFit.cover,
              placeholder: (context, url) => Image.asset(Constant().localAssets+"logo.png", fit:BoxFit.cover),
              errorWidget: (context, url, error) => Image.asset(Constant().localAssets+"logo.png", fit:BoxFit.cover),
            ),
          );
        },
      ),
    );
  }

}

