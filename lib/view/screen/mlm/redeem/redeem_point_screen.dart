import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/refresh_widget.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/member/data_member_model.dart';
import 'package:sangkuy/model/mlm/redeem/list_redeem_model.dart';
import 'package:sangkuy/provider/content_provider.dart';
import 'package:sangkuy/provider/member_provider.dart';
import 'package:sangkuy/view/screen/redeem/detail_redeem_screen.dart';
import 'package:sangkuy/view/widget/error_widget.dart';
import 'package:sangkuy/view/widget/loading/redeem_loading.dart';
import 'package:sangkuy/view/widget/redeem_widget.dart';

class RedeemPointScreen extends StatefulWidget {
  @override
  _RedeemPointScreenState createState() => _RedeemPointScreenState();
}

class _RedeemPointScreenState extends State<RedeemPointScreen>with WidgetsBindingObserver{
  ListRedeemModel listRedeemModel;
  int perpage=10,total=0;
  bool isLoadingRedeem=true,isErrorRedeem=false,isTokenExpRedeem=false;
  DataMemberModel dataMemberModel;
  bool isLoadingMember=false;
  Future loadMember()async{
    final res=await MemberProvider().getDataMember();
    setState(() {
      dataMemberModel=res;
      isLoadingMember=false;
    });
  }
  Future loadRedeem()async{
    var res = await ContentProvider().loadRedeem("page=1");
    if(res=='error' || res=='failed'){
      setState(() {
        isLoadingRedeem=false;
        isErrorRedeem=true;
      });
    }
    else if(res==Constant().errExpToken){
      setState(() {
        isLoadingRedeem=false;
        isErrorRedeem=false;
        isTokenExpRedeem=true;
      });
      WidgetHelper().notifOneBtnDialog(context,Constant().titleErrToken,Constant().descErrToken,()async{
        await FunctionHelper().logout(context);
      });
    }
    else{
      if(this.mounted)
        setState(() {
          listRedeemModel = res;
          isLoadingRedeem=false;
          isErrorRedeem=false;
          isTokenExpRedeem=false;
        });

    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

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

    print('loading');
    return Scaffold(
        appBar: WidgetHelper().appBarNoButton(context,"Redeem Point",<Widget>[
          FlatButton(
              padding: EdgeInsets.all(0.0),
              highlightColor:Colors.black38,
              splashColor:Colors.black38,
              onPressed:(){},
              child: Container(
                padding: EdgeInsets.only(right: 10.0,top:0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(AntDesign.chrome, color:Constant().mainColor, size: 10,),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child:isLoadingMember?WidgetHelper().baseLoading(context, Container(
                        height: 10,
                        width: 100,
                        color: Colors.white,
                      )): WidgetHelper().textQ("Poin anda : 19",10,Constant().moneyColor,FontWeight.normal)
                    ),

                  ],
                ),
              )
          )
        ]),
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child:isLoadingRedeem||isLoadingMember?RedeemVerticalLoading():isErrorRedeem?ErrWidget(callback: (){
              setState(() {
                isErrorRedeem=false;
                isLoadingRedeem=true;
              });
              loadRedeem();
            }):new StaggeredGridView.countBuilder(
              primary: false,
              physics: AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 4,
              itemCount: listRedeemModel.result.data.length,
              itemBuilder: (BuildContext context, int index) {
                return RedeemWidget(data:listRedeemModel.result.data[index].toJson()..addAll({'point_ro':dataMemberModel.result.pointRo}));
              },
              staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
              mainAxisSpacing: 15.0,
              crossAxisSpacing: 10.0,
            )
        )
    );
  }
}
