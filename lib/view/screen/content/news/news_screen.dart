import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/refresh_widget.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/content/content_model.dart';
import 'package:sangkuy/provider/content_provider.dart';
import 'package:sangkuy/view/screen/content/news/detail_news_screen.dart';
import 'package:sangkuy/view/screen/content/news/news_widget.dart';
import 'package:sangkuy/view/widget/loading/package_loading.dart';
import 'package:sangkuy/view/widget/loading/redeem_loading.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  bool isLoading=false,isError=false,isTokenExp=false;
  ContentModel contentModel;
  Future loadNews()async{
    var res = await ContentProvider().loadData("page=1");
    if(res=='error' || res=='failed'){
      setState(() {
        isLoading=false;
        isError=true;
      });
    }
    else if(res==Constant().errExpToken){
      setState(() {
        isLoading=false;
        isError=false;
        isTokenExp=true;
      });
    }
    else{
      setState(() {
        contentModel = res;
        isLoading=false;
        isError=false;
        isTokenExp=false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading=true;
    loadNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper().appBarWithButton(context,"Berita", (){Navigator.pop(context);},<Widget>[]),
      body: isLoading?RedeemVerticalLoading():Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child:RefreshWidget(
            widget: new StaggeredGridView.countBuilder(
              primary: false,
              physics: AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 4,
              itemCount: contentModel.result.data.length,
              itemBuilder: (BuildContext context, int index) {
                String desc='';
                int lng=100;
                if(contentModel.result.data[index].caption.length>lng){
                  desc=contentModel.result.data[index].caption.substring(0,lng)+' ..';
                }else{
                  desc=contentModel.result.data[index].caption;
                }
                return Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: [
                    FlatButton(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(6),
                                topRight: Radius.circular(6),
                              ),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: contentModel.result.data[index].picture,
                              width: double.infinity ,
                              fit:BoxFit.fill,
                              placeholder: (context, url) => Image.asset(Constant().localAssets+"logo.png", fit:BoxFit.cover),
                              errorWidget: (context, url, error) => Image.asset(Constant().localAssets+"logo.png", fit:BoxFit.cover),
                            ),
                          ),
                          SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                            child: WidgetHelper().textQ(contentModel.result.data[index].title, 12,Constant().darkMode,FontWeight.bold,maxLines:3 ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                            child:Html(
                                data: desc,
                                defaultTextStyle: TextStyle(fontSize: 12.0,color: Constant().darkMode),
                              onLinkTap: (String url){
                                  print(url);
                              },
                            ),
                            // child: WidgetHelper().textQ(contentModel.result.data[index].caption, 12,Constant().darkMode,FontWeight.normal,maxLines:3 ),
                          ),
                        ],
                      ),
                      onPressed: (){
                        WidgetHelper().myPush(context,DetailNewsScreen(contentModel:contentModel,idx:index));
                      },
                      color: Color(0xFFEEEEEE),
                      padding: EdgeInsets.all(0.0),
                    ),
                    Positioned(
                      top: 6,
                      right: 10,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(100)), color:Constant().moneyColor),
                        alignment: AlignmentDirectional.topEnd,
                        child: WidgetHelper().textQ('${contentModel.result.data[index].category}', 10,Colors.white,FontWeight.bold),
                      ),
                    )
                  ],
                );
              },
              staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
              mainAxisSpacing: 15.0,
              crossAxisSpacing: 15.0,
            ),
            callback: (){
              setState(() {
                isLoading=true;
              });
              loadNews();
            },
          )
      ),
    );
  }
}
