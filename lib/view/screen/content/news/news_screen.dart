import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/content/content_model.dart';
import 'package:sangkuy/provider/content_provider.dart';
import 'package:sangkuy/view/screen/content/news/news_widget.dart';
import 'package:sangkuy/view/widget/loading/package_loading.dart';

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
      body: isLoading?AddressLoading(tot: 10):Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child:new StaggeredGridView.countBuilder(
            // padding: EdgeInsets.all(0.0),
            primary: false,
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 4,
            itemCount: contentModel.result.data.length,
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
                                imageUrl: contentModel.result.data[index].picture,
                                width: double.infinity ,
                                fit:BoxFit.fill,
                                placeholder: (context, url) => Image.network('https://allrelease.id/wp-content/uploads/2020/03/Telkomsel-Tanggap-Covid-19.jpg', fit:BoxFit.fill,width: double.infinity,),
                                errorWidget: (context, url, error) => Image.network('https://allrelease.id/wp-content/uploads/2020/03/Telkomsel-Tanggap-Covid-19.jpg', fit:BoxFit.fill,width: double.infinity,),
                              ),
                            ),
                            SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                              child: WidgetHelper().textQ(contentModel.result.data[index].title, 12,Constant().darkMode,FontWeight.normal,maxLines:3 ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                              child:Html(data: contentModel.result.data[index].caption,style: {
                                "p": Style(fontSize: FontSize(12.0),color: Constant().darkMode)
                              },),
                              // child: WidgetHelper().textQ(contentModel.result.data[index].caption, 12,Constant().darkMode,FontWeight.normal,maxLines:3 ),
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
                      child: WidgetHelper().textQ('${contentModel.result.data[index].category}', 10,Colors.white,FontWeight.bold),
                    ),
                  )
                ],
              );
            },
            staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
            mainAxisSpacing: 15.0,
            crossAxisSpacing: 15.0,
          )
      ),
    );
  }
}
