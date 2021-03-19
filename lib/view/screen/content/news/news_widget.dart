import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/content/content_model.dart';
import 'package:sangkuy/view/screen/content/news/detail_news_screen.dart';
import 'package:sangkuy/view/screen/pages.dart';

class NewsWidget extends StatefulWidget {
  ContentModel contentModel;
  final int idx;
  NewsWidget({this.contentModel,this.idx});
  @override
  _NewsWidgetState createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;



  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);

    super.build(context);
    return FlatButton(
        padding: EdgeInsets.all(0),
        // color: Color(0xFFEEEEEE),
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
        onPressed: (){
          WidgetHelper().myPush(context,DetailNewsScreen(contentModel:widget.contentModel,idx: widget.idx));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: WidgetHelper().baseImage(widget.contentModel.result.data[widget.idx].picture,height:scaler.getHeight(10),width: double.infinity,fit: BoxFit.cover),
            ),
            Padding(
              padding:scaler.getPadding(1,0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: Constant().moneyColor,
                  padding:scaler.getPadding(0.5,2),
                  child:WidgetHelper().textQ(widget.contentModel.result.data[widget.idx].category,scaler.getTextSize(9),Constant().secondDarkColor,FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding:scaler.getPadding(0,0),
                child:WidgetHelper().textQ(widget.contentModel.result.data[widget.idx].title,scaler.getTextSize(9),Constant().darkMode,FontWeight.normal,maxLines: 3),
              ),
            )
          ],
        )
    );
  }


  Widget listVertical(BuildContext context){
    ScreenScaler scaler = ScreenScaler()..init(context);

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child:new StaggeredGridView.countBuilder(
          // padding: EdgeInsets.all(0.0),
          primary: false,
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 4,
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).focusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:  WidgetHelper().myPress(
                          ()async{
                      },
                      Column(
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
                              imageUrl: 'https://allrelease.id/wp-content/uploads/2020/03/Telkomsel-Tanggap-Covid-19.jpg',
                              width: double.infinity ,
                              fit:BoxFit.fill,
                              placeholder: (context, url) => Image.network('https://allrelease.id/wp-content/uploads/2020/03/Telkomsel-Tanggap-Covid-19.jpg', fit:BoxFit.fill,width: double.infinity,),
                              errorWidget: (context, url, error) => Image.network('https://allrelease.id/wp-content/uploads/2020/03/Telkomsel-Tanggap-Covid-19.jpg', fit:BoxFit.fill,width: double.infinity,),
                            ),
                          ),
                          SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                            child: WidgetHelper().textQ("Title", 12,Constant().darkMode,FontWeight.normal,maxLines:3 ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                            child: WidgetHelper().textQ("deskripsi", 12,Constant().darkMode,FontWeight.normal,maxLines:3 ),
                          ),
                        ],
                      ),
                      color:Colors.white10
                  ),
                ),

                Positioned(
                  top: 6,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(100)), color: Theme.of(context).accentColor),
                    alignment: AlignmentDirectional.topEnd,
                    child: WidgetHelper().textQ('pengumuman', 10,Colors.white,FontWeight.bold),
                  ),
                )
              ],
            );
          },
          staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
          mainAxisSpacing: 15.0,
          crossAxisSpacing: 15.0,
        )
    );
  }
}
