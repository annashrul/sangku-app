import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/site_model.dart';
import 'package:sangkuy/view/screen/content/news/detail_news_screen.dart';
import 'package:sangkuy/view/widget/web_view_widget.dart';

class InfoScreen extends StatefulWidget {
  SiteModel siteModel;
  String title;
  InfoScreen({this.siteModel,this.title});
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  String caption='';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.title=='Privacy Policy'){
      caption=widget.siteModel.result.privacy.deskripsi;
    }
    else{
      caption=widget.siteModel.result.terms.deskripsi;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper().appBarWithButton(context,widget.title,(){Navigator.pop(context);},<Widget>[]),
      body: Scrollbar(
          child: ListView(
            padding: EdgeInsets.all(10),
            children: [
              Html(
                data:caption,
                defaultTextStyle: TextStyle(fontSize: 14.0,color: Constant().darkMode),
                onLinkTap: (String url){
                  // _launchURL(url);
                  WidgetHelper().myPush(context,Scaffold(
                      appBar: WidgetHelper().appBarWithButton(context,url, (){Navigator.pop(context);},<Widget>[]),
                      body: WebViewWidget(val: {"url":url})
                  ));
                  // WidgetHelper().myPush(context,WebViewWidget(val: {"url":url,"title":"Privacy Policy"}));

                },
              )
            ],
          )
      ),
    );
  }
}
