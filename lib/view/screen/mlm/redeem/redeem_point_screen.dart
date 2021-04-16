import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/refresh_widget.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/member/data_member_model.dart';
import 'package:sangkuy/model/mlm/redeem/list_redeem_model.dart';
import 'package:sangkuy/provider/content_provider.dart';
import 'package:sangkuy/provider/member_provider.dart';
import 'file:///E:/NETINDO/mobile/sangkuy/lib/view/screen/mlm/redeem/detail_redeem_screen.dart';
import 'package:sangkuy/view/widget/error_widget.dart';
import 'package:sangkuy/view/widget/loading/redeem_loading.dart';
import 'package:sangkuy/view/widget/redeem_widget.dart';

class RedeemPointScreen extends StatefulWidget {
  const RedeemPointScreen({Key key}) : super(key: key);

  @override
  _RedeemPointScreenState createState() => _RedeemPointScreenState();
}

class _RedeemPointScreenState extends State<RedeemPointScreen> with SingleTickerProviderStateMixin,AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  ListRedeemModel listRedeemModel;
  int perpage=10,total=0;
  bool isLoadingRedeem=true,isErrorRedeem=false,isTokenExpRedeem=false;
  DataMemberModel dataMemberModel;
  bool isLoadingMember=false;
  Future loadMember()async{
    final res=await MemberProvider().getDataMember(context,(){
      Navigator.pop(context);
      setState(() {
        isLoadingMember=true;
        isLoadingRedeem=true;
      });
      loadMember();
      loadRedeem();
    });
    dataMemberModel=res;
    isLoadingMember=false;
    if(this.mounted) setState(() {});


  }
  Future loadRedeem()async{
    var res = await ContentProvider().loadRedeem("page=1");
    if(res==Constant().errNoData){
        isLoadingRedeem=false;
        isErrorRedeem=false;
        isTokenExpRedeem=true;
      if(this.mounted) setState(() {});

      WidgetHelper().notifOneBtnDialog(context,Constant().titleErrToken,Constant().descErrToken,()async{
        await FunctionHelper().logout(context);
      });
    }
    else{
      listRedeemModel = res;
      isLoadingRedeem=false;
      isErrorRedeem=false;
      isTokenExpRedeem=false;
      if(this.mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    isLoadingMember=false;
    isLoadingRedeem=false;

    // animationController.dispose() instead of your controller.dispose
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoadingMember=true;
    isLoadingRedeem=true;
    loadRedeem();
    loadMember();
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    print('loading');
    ScreenScaler scaler = ScreenScaler()..init(context);

    return Scaffold(
        appBar: WidgetHelper().appBarNoButton(context,"Redeem Poin",<Widget>[
          FlatButton(
              padding: EdgeInsets.all(0.0),
              highlightColor:Colors.black38,
              splashColor:Colors.black38,
              onPressed:(){},
              child: Container(
                padding: scaler.getPadding(0, 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: scaler.getPadding(0, 1),
                      child: Icon(AntDesign.chrome, color:Constant().mainColor, size: scaler.getTextSize(10),),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child:isLoadingMember?WidgetHelper().baseLoading(context, Container(
                        height: 10,
                        width: 100,
                        color: Colors.white,
                      )): WidgetHelper().textQ("Poin anda : ${FunctionHelper().formatter.format(int.parse(FunctionHelper().rmTitik(dataMemberModel.result.pointRo, 0)))}",scaler.getTextSize(9),Constant().moneyColor,FontWeight.bold)
                    ),

                  ],
                ),
              )
          )
        ]),
        body: Container(
            padding: scaler.getPadding(1, 2),
            child:isLoadingRedeem||isLoadingMember?
            RedeemVerticalLoading():
            isErrorRedeem?
            ErrWidget(callback: (){
              setState(() {
                isErrorRedeem=false;
                isLoadingRedeem=true;
                isLoadingMember=true;
              });
              loadRedeem();
            }):
            RefreshWidget(
              widget: new StaggeredGridView.countBuilder(
                // primary: false,
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                // shrinkWrap: true,
                crossAxisCount: 4,
                itemCount: listRedeemModel.result.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return RedeemWidget(data:listRedeemModel.result.data[index].toJson()..addAll({'point_ro':dataMemberModel.result.pointRo}));
                },
                staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
                mainAxisSpacing: 15.0,
                crossAxisSpacing: 10.0,
              ),
              callback: (){
                setState(() {
                  isLoadingRedeem=true;
                  isLoadingMember=true;
                });
                loadRedeem();
                loadMember();
              },
            )
        )
    );
  }
}
