import 'package:flutter/material.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/notif_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:sangkuy/provider/member_provider.dart';
import 'package:sangkuy/view/screen/content/testimoni/testimoni_screen.dart';
import 'package:sangkuy/view/widget/loading/testimoni_loading.dart';

class NotifScreen extends StatefulWidget {
  @override
  _NotifScreenState createState() => _NotifScreenState();
}

class _NotifScreenState extends State<NotifScreen> {
  bool isLoading=false,isLoadmore=false;
  int perpage=10,total=0;
  NotifModel notifModel;
  Future loadData()async{
    var res=await MemberProvider().getDataNotif("page=1&perpage=$perpage");
    if(res is NotifModel){
      NotifModel result=res;
      notifModel = result;
      total=notifModel.result.total;
      isLoading=false;
      isLoadmore=false;
      if(this.mounted){
        setState(() {});
      }
    }else{
      total=0;
      isLoading=false;
      isLoadmore=false;
      if(this.mounted){
        setState(() {});
      }
    }
  }
  ScrollController controller;
  void _scrollListener() {
    if (!isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        if(perpage<total){
          print('fetch data');
          setState((){
            perpage=perpage+perpage;
            isLoadmore=true;
          });
          loadData();
        }
      }
    }
  }
  
  Future handleRead(id)async{
    WidgetHelper().loadingDialog(context);
    await BaseProvider().putProvider('site/notif',{"id":id});
    loadData();
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading=true;
    loadData();
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
      appBar: WidgetHelper().appBarWithButton(context,"Notifikasi",(){Navigator.pop(context);},<Widget>[
        Container(
          padding: EdgeInsets.only(top:10.0,bottom: 10.0),
          child: isLoading?Text(''):FlatButton(
              padding: EdgeInsets.all(0.0),
              shape: new CircleBorder(),
              color:Constant().greenColor,
              onPressed:(){},
              child: WidgetHelper().textQ("${notifModel.result.total}",14,Colors.white,FontWeight.bold)
          ),
        )
      ]),
      body: isLoading?TestimoniLoading(total: 10):Scrollbar(
          child: ListView.separated(
            controller: controller,
            itemBuilder: (context,index){
              var val=notifModel.result.data[index];
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(top:10,bottom: 10,left:15,right:15),
                    color: Constant().greyColor,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WidgetHelper().textQ(FunctionHelper().formateDate(val.createdAt,"ymd"),10,Constant().greenColor,FontWeight.bold),
                        WidgetHelper().textQ(val.title,12,Constant().darkMode,FontWeight.bold),
                      ],
                    ),
                  ),
                  // SizedBox(height: 10),
                  FlatButton(
                    padding: EdgeInsets.only(top:0,bottom: 0,left:15,right:15),
                    // color: val.status==0?Constant().greenColor:Colors.transparent,
                    onPressed: (){handleRead(val.id);},
                    child: WidgetHelper().textQ(val.msg,12,Constant().darkMode,FontWeight.normal,maxLines: 100),
                  ),
                  // SizedBox(height: 10),
                ],
              );
            },
            itemCount: notifModel.result.data.length,
            separatorBuilder: (context,index){return Divider();},
          )
      ),
      bottomNavigationBar: isLoadmore?TestimoniLoading(total: 1):Text(''),
    );
  }
}
