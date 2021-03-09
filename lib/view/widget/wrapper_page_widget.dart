import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/refresh_widget.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/member/data_member_model.dart';
import 'package:sangkuy/model/wallet/config_wallet_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:sangkuy/provider/member_provider.dart';
import 'package:sangkuy/view/screen/pages.dart';
import 'package:sangkuy/view/widget/detail_scaffold.dart';
import 'package:sangkuy/view/widget/error_widget.dart';
import 'package:sangkuy/view/widget/header_widget.dart';
import 'package:sangkuy/view/widget/loading/member_loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WrapperPageWidget extends StatefulWidget {
  List<Widget> children;
  Widget action;
  Function(dynamic data) callback;
  ScrollController controller;
  WrapperPageWidget({this.children,this.action,this.callback,this.controller});
  @override
  _WrapperPageWidgetState createState() => _WrapperPageWidgetState();
}

class _WrapperPageWidgetState extends State<WrapperPageWidget> with AutomaticKeepAliveClientMixin  {
  @override
  bool get wantKeepAlive => true;
  bool isLoadingMember=false;
  DataMemberModel dataMemberModel;
  Future loadMember()async{
    final res=await MemberProvider().getDataMember();
    dataMemberModel=res;
    isLoadingMember=false;
    widget.callback(dataMemberModel.result.toJson());

    if(this.mounted) setState(() {});
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoadingMember=true;
    loadMember();
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarIconBrightness: Brightness.dark));
    return Scaffold(
      key: _scaffoldKey,
      body:  DetailScaffold(
          controller: widget.controller,
          hasPinnedAppBar: true,
          expandedHeight:90,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              floating: false,
              pinned: true,
              expandedHeight: 90.0,
              flexibleSpace: widget.action,
            ),
            SliverList(
                delegate: SliverChildListDelegate([
                  section1(context),
                ])
            ),
            SliverList(
                delegate:SliverChildListDelegate(
                  widget.children,
                )
            ),
          ]
      ),
    );
  }
  Widget section1(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              isLoadingMember?WidgetHelper().baseLoading(context, Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white
                ),
              )):CircleImage(
                param: 'network',
                key: Key("profile"),
                image: dataMemberModel.result.picture,
                size: 50.0,
                padding: 0.0,
              ),
              SizedBox(
                width: 16,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  isLoadingMember?WidgetHelper().baseLoading(context, Container(
                    width: 100,
                    height: 5,
                    color: Colors.white,
                  )):WidgetHelper().textQ("${dataMemberModel.result.fullName}",10,Constant().darkMode,FontWeight.bold),
                  const SizedBox(
                    height: 2,
                  ),
                  isLoadingMember?WidgetHelper().baseLoading(context, Container(
                    width: 100,
                    height: 10,
                    color: Colors.white,
                  )):WidgetHelper().textQ("Rp ${FunctionHelper().formatter.format(int.parse(dataMemberModel.result.saldo))} .-",14,Constant().moneyColor,FontWeight.bold),
                  const SizedBox(
                    height: 4,
                  ),
                  isLoadingMember?WidgetHelper().baseLoading(context, Container(
                    width: 100,
                    height: 15,
                    color: Colors.white,
                  )):Row(
                    children: <Widget>[
                      Image.network(dataMemberModel.result.membershipBadge,width: 16,height: 16),
                      const SizedBox(
                        width: 4,
                      ),
                      WidgetHelper().textQ(dataMemberModel.result.membership,10,Constant().darkMode,FontWeight.bold)
                    ],
                  )


                ],
              ),
              Flexible(
                flex: 1,
                child: Container(),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  isLoadingMember?WidgetHelper().baseLoading(context, Container(
                    width: 100,
                    height: 16,
                    color: Colors.white,
                  )):ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      color: Colors.black12,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                        child: Row(
                          children: <Widget>[
                            Image.network(dataMemberModel.result.jenjangKarirBadge,width: 16,height: 16),
                            const SizedBox(
                              width: 4,
                            ),
                            WidgetHelper().textQ(dataMemberModel.result.jenjangKarir,10,Constant().darkMode,FontWeight.bold)
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height:5.0),

                  isLoadingMember?WidgetHelper().baseLoading(context, Container(
                    width: 100,
                    height: 5,
                    color: Colors.white,
                  )):WidgetHelper().textQ("${dataMemberModel.result.referralCode}",10,Constant().darkMode,FontWeight.bold),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

}



