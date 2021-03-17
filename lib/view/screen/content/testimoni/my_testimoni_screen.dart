import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/refresh_widget.dart';
import 'package:sangkuy/helper/user_helper.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/content/testimoni_model.dart';
import 'package:sangkuy/provider/content_provider.dart';
import 'package:sangkuy/view/screen/content/testimoni/testimoni_screen.dart';
import 'package:sangkuy/view/widget/loading/testimoni_loading.dart';

class MyTestimoniScreen extends StatefulWidget {
  @override
  _MyTestimoniScreenState createState() => _MyTestimoniScreenState();
}

class _MyTestimoniScreenState extends State<MyTestimoniScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = new GlobalKey<AnimatedListState>();
  bool isLoadingTestimoni=false,isLoadmore=false;
  TestimoniModel testimoniModel;
  int perpage=10,total=0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future loadTestimoni()async{
    final id_member=await UserHelper().getDataUser('id_user');
    var res = await ContentProvider().loadTestimoni("perpage=$perpage&id_member=$id_member");
    if(this.mounted) setState(() {
      testimoniModel = res;
      isLoadingTestimoni=false;
      isLoadmore=false;
      total=testimoniModel.result.total;
    });
  }
  ScrollController controller;
  void _scrollListener() {
    if (!isLoadingTestimoni) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        if(perpage<total){
          print('fetch data');
          setState((){
            perpage=perpage+perpage;
            isLoadmore=true;
          });
          loadTestimoni();
        }
      }
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoadingTestimoni=true;
    loadTestimoni();
    controller = new ScrollController()..addListener(_scrollListener);
  }
  @override
  void dispose() {
    super.dispose();
    controller.removeListener(_scrollListener);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: WidgetHelper().appBarWithButton(context,"Daftar Testimoni Saya",(){Navigator.pop(context);},<Widget>[
        IconButton(icon: Icon(AntDesign.pluscircleo), onPressed: (){
          WidgetHelper().myModal(context,ModalFormTestimoni(val: null,callback: (param){
            if(param=='success'){
              setState(() {
                isLoadingTestimoni=true;
              });
              loadTestimoni();
            }
          }));
        })
      ]),
      body:  isLoadingTestimoni?TestimoniLoading(): RefreshWidget(
        widget: buildContent(context),
        callback: (){
          isLoadingTestimoni=true;
          setState(() {});
          loadTestimoni();
        },
      ),
      bottomNavigationBar: isLoadmore?TestimoniLoading(total: 1):Text(''),
    );
  }

  Widget buildContent(BuildContext context){
    return new ListView.separated(
      primary: false,
      controller: controller,
      physics: AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: testimoniModel.result.data.length,
      itemBuilder: (BuildContext context, int index) {
        String desc='';
        var val=testimoniModel.result.data[index];
        int lng=100;
        if(testimoniModel.result.data[index].caption.length>lng){
          desc=testimoniModel.result.data[index].caption.substring(0,lng)+' ..';
        }else{
          desc=testimoniModel.result.data[index].caption;
        }
        return Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              FlatButton(
                color:Colors.white,
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
                      child: WidgetHelper().baseImage(val.picture,width: double.infinity,fit: BoxFit.contain),
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width/3,
                        ),
                        Icon(FontAwesome.quote_left,size: 10,color: Colors.grey,),
                        Container(
                          width: MediaQuery.of(context).size.width/3,
                        ),
                      ],
                    ),
                    SizedBox(height:10),
                    Padding(
                        padding: EdgeInsets.only(left:10,right:10),
                        child: Center(
                          child: WidgetHelper().textQ(val.caption, 12,Colors.black,FontWeight.bold,maxLines: 12,textAlign: TextAlign.center),
                        )
                    ),
                    SizedBox(height:10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width/3,
                        ),
                        Icon(FontAwesome.quote_left,size: 10,color: Colors.grey,),
                        Container(
                          width: MediaQuery.of(context).size.width/3,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(AntDesign.user,size: 15,color: Colors.grey,),
                          WidgetHelper().textQ(val.writer, 12,Colors.grey,FontWeight.bold,maxLines: 10,textAlign: TextAlign.center)
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.group_work,size: 15,color: Colors.grey,),
                          WidgetHelper().textQ(val.jobs, 12,Colors.grey,FontWeight.bold,maxLines: 10,textAlign: TextAlign.center)
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.timer,size: 15,color: Colors.grey),
                          WidgetHelper().textQ(FunctionHelper().formateDate(val.createdAt, " "), 12,Colors.grey,FontWeight.bold,maxLines: 10,textAlign: TextAlign.center)
                        ],
                      ),
                    ),
                  ],
                ),
                onPressed: (){
                  WidgetHelper().myModal(context,Container(
                      height: MediaQuery.of(context).size.height/1.2,
                      child: ModalFormTestimoni(val: val.toJson(),callback: (String param){
                        if(param=='success'){
                          setState(() {
                            isLoadingTestimoni=true;
                          });
                          loadTestimoni();
                        }
                      })
                  ));
                  // WidgetHelper().myPush(context,DetailNewsScreen(contentModel:contentModel,idx:index));
                },
                padding: EdgeInsets.all(10.0),
              ),
              val.video!='-'?Positioned(
                top: 0,
                right: 10,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)), color:Constant().mainColor),
                    alignment: AlignmentDirectional.center,
                    child:Icon(AntDesign.videocamera,color: Colors.white)
                ),
              ):Text('')
            ],
          ),
        );
      },
      separatorBuilder: (context,index){return SizedBox(height: 10);},
    );
  }
}
