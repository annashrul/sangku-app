import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/refresh_widget.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/member/data_member_model.dart';
import 'package:sangkuy/model/notif_model.dart';
import 'package:sangkuy/model/wallet/config_wallet_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:sangkuy/provider/member_provider.dart';
import 'package:sangkuy/view/screen/pages.dart';
import 'package:sangkuy/view/screen/profile/notif_screen.dart';
import 'package:sangkuy/view/widget/detail_scaffold.dart';
import 'package:sangkuy/view/widget/error_widget.dart';
import 'package:sangkuy/view/widget/header_widget.dart';
import 'package:sangkuy/view/widget/loading/member_loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WrapperPageWidget extends StatefulWidget {
  List<Widget> children;
  String title;
  Function(dynamic data) callback;
  ScrollController controller;
  WrapperPageWidget({this.children,this.title,this.callback,this.controller});
  @override
  _WrapperPageWidgetState createState() => _WrapperPageWidgetState();
}

class _WrapperPageWidgetState extends State<WrapperPageWidget> with AutomaticKeepAliveClientMixin  {
  @override
  bool get wantKeepAlive => true;
  bool isLoadingMember=false,isLoadingNotif=false;
  DataMemberModel dataMemberModel;
  NotifModel notifModel;
  int total=0;

  Future loadNotif()async{
    var tot=await MemberProvider().countNotif();
    // total=0;
    total=tot;
    if(this.mounted){
      setState(() {});
    }
  }
  Future loadMember()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final res=await MemberProvider().getDataMember();
    dataMemberModel=res;
    isLoadingMember=false;
    prefs.setString("saldo",dataMemberModel.result.saldo);
    widget.callback(dataMemberModel.result.toJson());
    if(this.mounted) setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoadingMember=true;
    loadMember();
    loadNotif();
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
              flexibleSpace: WidgetHelper().myNotif(context,widget.title, total,isLoadingMember?'':dataMemberModel.result.referralCode),
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
    ScreenScaler scaler = ScreenScaler()..init(context);

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
                size:scaler.getTextSize(20),
                padding: 0.0,
              ),
              SizedBox(
                width: scaler.getWidth(2),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  isLoadingMember?WidgetHelper().baseLoading(context, Container(
                    width: 100,
                    height: 5,
                    color: Colors.white,
                  )):WidgetHelper().textQ("${dataMemberModel.result.fullName}",scaler.getTextSize(9),Constant().darkMode,FontWeight.bold),
                  SizedBox(
                    height: scaler.getHeight(0.1),
                  ),
                  isLoadingMember?WidgetHelper().baseLoading(context, Container(
                    width: 100,
                    height: 10,
                    color: Colors.white,
                  )):WidgetHelper().textQ("Rp ${FunctionHelper().formatter.format(int.parse(dataMemberModel.result.saldo))} .-",scaler.getTextSize(9),Constant().moneyColor,FontWeight.bold),
                  SizedBox(
                    height: scaler.getHeight(0.1),
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
                      WidgetHelper().textQ(dataMemberModel.result.membership,scaler.getTextSize(9),Constant().darkMode,FontWeight.bold)
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
                        padding: scaler.getPadding(0.2,1.5),
                        child: Row(
                          children: <Widget>[
                            Image.network(dataMemberModel.result.jenjangKarirBadge,width: 16,height: 16),
                            SizedBox(
                              width: scaler.getWidth(2),
                            ),
                            WidgetHelper().textQ(dataMemberModel.result.jenjangKarir,scaler.getTextSize(9),Constant().darkMode,FontWeight.bold)
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height:scaler.getHeight(0.2)),
                  isLoadingMember?WidgetHelper().baseLoading(context, Container(
                    width: 100,
                    height: 5,
                    color: Colors.white,
                  )):WidgetHelper().textQ("${dataMemberModel.result.referralCode}",scaler.getTextSize(9),Constant().darkMode,FontWeight.bold),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

}



