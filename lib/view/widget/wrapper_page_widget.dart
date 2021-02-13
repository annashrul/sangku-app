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

class WrapperPageWidget extends StatefulWidget {
  final dynamic dataMember;
  List<Widget> children;
  Widget action;

  WrapperPageWidget({this.dataMember,this.children,this.action});
  @override
  _WrapperPageWidgetState createState() => _WrapperPageWidgetState();
}

class _WrapperPageWidgetState extends State<WrapperPageWidget> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarIconBrightness: Brightness.dark));
    return Scaffold(
      key: _scaffoldKey,
      body:  DetailScaffold(
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
              CircleImage(
                param: 'network',
                key: Key("profile"),
                image: widget.dataMember['picture'],
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
                  WidgetHelper().textQ("${widget.dataMember['full_name']}",10,Constant().darkMode,FontWeight.bold),
                  const SizedBox(
                    height: 2,
                  ),
                  WidgetHelper().textQ("Rp ${FunctionHelper().formatter.format(int.parse(widget.dataMember['saldo']))} .-",14,Constant().moneyColor,FontWeight.bold),
                  const SizedBox(
                    height: 4,
                  ),
                  WidgetHelper().textQ("${widget.dataMember['referral_code']}",10,Constant().darkMode,FontWeight.bold),

                ],
              ),
              Flexible(
                flex: 1,
                child: Container(),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      color: Colors.black12,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                        child: Row(
                          children: <Widget>[
                            Image.network(widget.dataMember['membership_badge'],width: 16,height: 16),
                            const SizedBox(
                              width: 4,
                            ),
                            WidgetHelper().textQ(widget.dataMember['membership'],10,Constant().darkMode,FontWeight.bold)
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height:5.0),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      color: Colors.black12,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                        child: Row(
                          children: <Widget>[
                            Image.network(widget.dataMember['jenjang_karir_badge'],width: 16,height: 16),
                            const SizedBox(
                              width: 4,
                            ),
                            WidgetHelper().textQ(widget.dataMember['jenjang_karir'],10,Constant().darkMode,FontWeight.bold)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

}



