import 'package:flutter/material.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/refresh_widget.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/member/data_member_model.dart';
import 'package:sangkuy/model/wallet/config_wallet_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:sangkuy/provider/member_provider.dart';
import 'package:sangkuy/view/widget/detail_scaffold.dart';
import 'package:sangkuy/view/widget/error_widget.dart';
import 'package:sangkuy/view/widget/header_widget.dart';
import 'package:sangkuy/view/widget/loading/member_loading.dart';

class WrapperPageWidget extends StatefulWidget {
  List<Widget> children;
  Function(dynamic val) callback;

  WrapperPageWidget({this.children,this.callback});
  @override
  _WrapperPageWidgetState createState() => _WrapperPageWidgetState();
}

class _WrapperPageWidgetState extends State<WrapperPageWidget> {
  DataMemberModel dataMemberModel;
  ConfigWalletModel configWalletModel;
  bool isLoadingMember=false;
  bool isLoadingConfig=false,isError=false;
  Future loadMember()async{
    final member = await MemberProvider().getDataMember();
    if(this.mounted)
      setState(() {
        dataMemberModel = member;
        isLoadingMember=false;
      });
  }
  Future loadConfig()async{
    final config = await BaseProvider().getProvider("transaction/wallet/config", configWalletModelFromJson);
    if(config==Constant().errSocket||config==Constant().errTimeout){
      setState(() {
        isLoadingConfig=false;
        isError=true;
      });
    }
    else if(config==Constant().errExpToken){
      setState(() {
        isLoadingConfig=false;
        isError=false;
      });
      WidgetHelper().notifOneBtnDialog(context,Constant().titleErrToken,Constant().descErrToken, ()async{
        FunctionHelper().logout(context);
      });
    }
    else{
      if(config is ConfigWalletModel){
        ConfigWalletModel result=config;
        if(this.mounted){
          setState(() {
            configWalletModel = result;
            isLoadingConfig=false;
            isError=false;
            widget.callback(result.result.toJson());
          });
        }
      }
    }

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoadingMember=true;
    isLoadingConfig=true;
    loadMember();
    loadConfig();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isError?ErrWidget(callback: (){
          setState(() {
            isLoadingConfig=true;
            isLoadingMember=true;
          });
          loadConfig();
          loadMember();
        }):RefreshWidget(
          widget: DetailScaffold(
              hasPinnedAppBar: true,
              expandedHeight:90,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: <Widget>[
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  floating: false,
                  pinned: true,
                  expandedHeight: 90.0,
                  flexibleSpace: HeaderWidget(),
                ),
                SliverList(
                    delegate: SliverChildListDelegate([section1(context)])
                ),
                SliverList(
                    delegate: SliverChildListDelegate(
                      isLoadingConfig?[Text('loadding')]:configWalletModel.result.trxDp=='-'?widget.children:[
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              WidgetHelper().textQ("MASIH ADA TRANSAKSI ANDA YANG BELUM KAMI PROSES",16,Constant().secondDarkColor,FontWeight.bold,textAlign: TextAlign.center,letterSpacing: 5),
                              SizedBox(height: 50.0),
                              Image.network('https://www.nicepng.com/png/full/333-3339964_pending-meal-without-wine-is-called-breakfast-wine.png'),
                            ],
                          ),
                        )
                      ]
                    )
                ),
              ]
          ),
          callback: (){
            setState(() {
              isLoadingConfig=true;
              isLoadingMember=true;
            });
            loadConfig();
            loadMember();
          },
        ),
      ),
    );
  }
  Widget section1(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          isLoadingConfig||isLoadingMember?MemberLoading():Row(
            children: <Widget>[
              CircleImage(
                param: 'network',
                key: Key("profile"),
                image: Constant().avatar,
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
                  WidgetHelper().textQ("${dataMemberModel.result.fullName}",10,Constant().darkMode,FontWeight.bold),
                  const SizedBox(
                    height: 2,
                  ),
                  WidgetHelper().textQ("Rp ${FunctionHelper().formatter.format(int.parse(dataMemberModel.result.saldo))} .-",14,Constant().moneyColor,FontWeight.bold),
                  const SizedBox(
                    height: 4,
                  ),
                  WidgetHelper().textQ("${dataMemberModel.result.referralCode}",10,Constant().darkMode,FontWeight.bold),

                ],
              ),
              Flexible(
                flex: 1,
                child: Container(),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  color: Colors.black12,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                    child: Row(
                      children: <Widget>[
                        Image.network(dataMemberModel.result.membershipBadge,width: 16,height: 16),
                        const SizedBox(
                          width: 4,
                        ),
                        WidgetHelper().textQ("${dataMemberModel.result.membership}",10,Constant().darkMode,FontWeight.bold)
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),

        ],
      ),
    );
  }

}



