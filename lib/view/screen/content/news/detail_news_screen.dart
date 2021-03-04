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
  @override
  Widget build(BuildContext context) {
    print(val.toJson());
    // return Scaffold(
    //     key: _scaffoldKey,
    //     body: buildContent(context),
    // );
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Constant().secondColor,
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: WidgetHelper().textQ(val.title,12,Colors.white,FontWeight.bold,maxLines: 1,textAlign: TextAlign.center),
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
                            padding: EdgeInsets.only(bottom:50.0,top:10.0,left:0.0),
                            width: double.infinity,
                            color: Color(0xFFEEEEEE),
                            child:Html(data: val.caption,defaultTextStyle: TextStyle(fontSize: 14.0,color: Constant().secondDarkColor)),
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
  Widget buildContent(BuildContext context){
    return RefreshWidget(
      widget: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              stretch: true,
              onStretchTrigger: (){
                return;
              },
              brightness:Brightness.dark,
              snap: true,
              floating: true,
              pinned: true,
              automaticallyImplyLeading: false,
              leading: new IconButton(
                icon: new Icon(AntDesign.back, color:Constant().mainColor),
                onPressed: () => Navigator.pop(context,false),
              ),
              expandedHeight: 300,
              elevation: 0,
              flexibleSpace: sliderQ(context),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Offstage(
                  offstage:false,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        ClipPath(
                          clipper: WaveClipperOne(flip: true),
                          child: Container(
                            padding: EdgeInsets.only(bottom:50.0,top:10.0,left:15.0),
                            width: double.infinity,
                            color: Constant().secondColor,
                            // child:Html(data: val.caption,style: {"p": Style(fontSize: FontSize(12.0),color: Constant().secondDarkColor)},),
                            child:Html(data: val.caption,defaultTextStyle: TextStyle(fontSize: 12.0,color: Constant().secondDarkColor)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            )
          ]
      ),
      callback: ()async{

      },
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
