import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/refresh_widget.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/general_model.dart';
import 'package:sangkuy/model/mlm/history/history_reward_model.dart';
import 'package:sangkuy/model/mlm/redeem/history_redeem_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:sangkuy/view/screen/pages.dart';
import 'package:sangkuy/view/widget/loading/history_pembelian_loading.dart';

class HistoryRewardScreen extends StatefulWidget {
  @override
  _HistoryRewardScreenState createState() => _HistoryRewardScreenState();
}

class _HistoryRewardScreenState extends State<HistoryRewardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  HistoryRewardModel historyRewardModel;
  ScrollController controller;
  int perpage=10;
  int total=0;
  bool isLoading=false,isLoadmore=false;
  String lbl='';
  String dateFrom='',dateTo='',q='';

  Future loadData()async{
    String url='transaction/reward/report?perpage=$perpage';
    if(dateFrom!=''&&dateTo!=''){
      url+='&datefrom=$dateFrom&dateto=$dateTo';
    }
    if(q!=''){
      url+='&q=$q';
    }
    var res = await BaseProvider().getProvider(url,historyRewardModelFromJson,context: context,callback: (){

    });
    if(res==Constant().errNoData){
      setState(() {
        isLoading=false;
        total=0;
      });
    }
    else if(res is HistoryRewardModel){
      HistoryRewardModel result=res;
      historyRewardModel = HistoryRewardModel.fromJson(result.toJson());
      total = historyRewardModel.result.total;
      isLoading=false;
      isLoadmore=false;
      if(this.mounted)setState(() {});
    }
  }
  void _scrollListener() {
    if (!isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        print('fetch data');
        print('TOTAL $total');
        print('PERPAGE $perpage');
        if(perpage<total){
          setState((){
            perpage+=10;
            isLoadmore=true;
          });
          loadData();
        }
      }
    }
  }

  Future handleDone(val,BuildContext context)async{
    WidgetHelper().loadingDialog(context);
    var res=await BaseProvider().putProvider('transaction/done/${FunctionHelper().decode(val['kd_trx'])}', {},context: context);
    Navigator.pop(context);
    print(res);
    if(res!=null){
      WidgetHelper().notifOneBtnDialog(context,"Berhasil","Selamat ... reward anda berhasil diselesaikan", (){
        WidgetHelper().myPushRemove(context,IndexScreen(currentTab: 2));
      });
    }

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading=true;
    loadData();
    controller = new ScrollController()..addListener(_scrollListener);
    initializeDateFormatting('id');
    dateFrom=FunctionHelper().formatReportDate()['dateFrom'];
    dateTo=FunctionHelper().formatReportDate()['dateTo'];
  }
  @override
  void dispose() {
    super.dispose();
    controller.removeListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);
    return Scaffold(
      appBar: WidgetHelper().appBarWithFilter(context,"Laporan Claim Reward",  (){Navigator.pop(context);}, (param){
        setState(() {
          q=param;
          isLoading=true;
        });
        loadData();
      }, (start, end){
        setState(() {
          dateFrom=start;
          dateTo=end;
          isLoading=true;
        });
        loadData();
      }),
      // appBar: WidgetHelper().appBarWithButton(context,"Laporan PPOB", (){Navigator.pop(context);},<Widget>[]),
      body: Container(
        padding: scaler.getPadding(0,2),
        child: Column(
          children: [
            if(dateFrom!=''||dateTo!=''||q!='')Expanded(
              flex:1,
              child: ListView(
                padding: scaler.getPadding(0,0),
                scrollDirection: Axis.horizontal,
                children: [
                  if(dateFrom!='')InkWell(
                    onTap: (){
                      setState(() {
                        dateFrom='';
                        dateTo='';
                        isLoading=true;
                      });
                      loadData();
                    },
                    child: Container(
                      margin: EdgeInsets.only(right:5.0),
                      child:  Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          FlatButton(
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(4.0)),
                            color: Constant().greenColor,
                            onPressed: (){},
                            child:WidgetHelper().textQ(dateFrom+' s/d '+dateTo,scaler.getTextSize(9),Colors.white,FontWeight.bold),
                          ),
                          Positioned(
                              right: 0,
                              top: 0,
                              child: Icon(AntDesign.closecircleo,size: scaler.getTextSize(9),color:Constant().greyColor)
                          )
                        ],
                      ),
                    ),
                  ),
                  if(q!='')InkWell(
                    onTap: (){
                      setState(() {
                        q='';
                        isLoading=true;
                      });
                      loadData();
                    },
                    child: Container(
                      margin: EdgeInsets.only(right:5.0),
                      child:  Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          FlatButton(
                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(4.0)),
                              color: Constant().greenColor,
                              onPressed: (){},
                              child:WidgetHelper().textQ(q,scaler.getTextSize(9),Colors.white,FontWeight.bold)
                          ),
                          Positioned(
                              right: 0,
                              top: 0,
                              child: Icon(AntDesign.closecircleo,size: scaler.getTextSize(9),color:Constant().greyColor)
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            Expanded(
              flex: 19,
              child: isLoading?HistoryPembelianLoading(tot: 10):total<1?WidgetHelper().noDataWidget(context):Scrollbar(child: RefreshWidget(
                widget: Column(
                  children: [
                    Expanded(
                        flex:16,
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                          // primary: true,
                          // shrinkWrap: true,
                          // shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          controller: controller,
                          itemCount: historyRewardModel.result.data.length,
                          itemBuilder: (context,index){
                            final val=historyRewardModel.result.data[index];
                            String status='';
                            Color color;
                            if(val.status==0){
                              status='Dalam Antrian';
                              color=Color(0xFFff9800);
                            }
                            if(val.status==1){
                              status='Diterima';
                              color=Constant().mainColor2;
                            }
                            if(val.status==2){
                              status='Selesai';
                              color=Constant().greenColor;
                            }
                            if(val.status==2){
                              status='Ditolak';
                              color=Constant().moneyColor;
                            }
                            return FlatButton(
                              padding: EdgeInsets.all(0.0),
                              color: index%2==0?Colors.transparent:Color(0xFFEEEEEE),
                              onPressed: (){

                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:scaler.getPadding(0.5,2),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            WidgetHelper().textQ(FunctionHelper().formateDate(val.createdAt,''),scaler.getTextSize(8),Constant().mainColor,FontWeight.normal),
                                            WidgetHelper().textQ("(${val.kdTrx})",scaler.getTextSize(8),Constant().mainColor,FontWeight.bold),
                                          ],
                                        ),
                                        WidgetHelper().myBtnBorder(context,"Selesaikan",(){
                                          print(val.status);
                                          if(val.status!=1){
                                          }else{
                                            print('bus');
                                            handleDone(val.toJson(),context);
                                          }
                                        },Constant().greenColor)

                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: ListTile(
                                      contentPadding:scaler.getPadding(0,2),
                                      leading:WidgetHelper().baseImage(val.gambar),
                                      title: WidgetHelper().textQ(val.reward,scaler.getTextSize(9),Constant().mainColor2,FontWeight.bold),
                                      subtitle: Column(
                                        children: [
                                          WidgetHelper().textQ("${val.penerima} ( ${val.noHp} )",scaler.getTextSize(8), Constant().darkMode,FontWeight.bold),
                                          WidgetHelper().textQ("${val.mainAddress}",scaler.getTextSize(8), Constant().darkMode,FontWeight.normal),
                                        ],
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                      ),
                                      // trailing: WidgetHelper().textQ(status,scaler.getTextSize(9),color,FontWeight.bold),
                                    ),
                                    // color: Constant().secondColor,
                                  ),
                                  Padding(
                                    padding: scaler.getPadding(0.5,2),
                                    child: Row(
                                      children: [
                                        WidgetHelper().textQ("Status",scaler.getTextSize(8), Constant().darkMode,FontWeight.bold),
                                        SizedBox(width: scaler.getWidth(2),child: WidgetHelper().textQ(":",scaler.getTextSize(8), Constant().darkMode,FontWeight.bold)),
                                        WidgetHelper().textQ(status,scaler.getTextSize(8),color,FontWeight.bold),
                                      ],
                                    ),
                                  )
                                  // Container(
                                  //   child: WidgetHelper().textQ("${val.penerima} ( ${val.noHp} )",scaler.getTextSize(9), Constant().darkMode,FontWeight.normal),
                                  // ),
                                  // Divider(),
                                  // Container(
                                  //   child: WidgetHelper().textQ(val.mainAddress,scaler.getTextSize(8), Constant().darkMode,FontWeight.normal),
                                  // )

                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context,index){
                            return SizedBox(height: 1.0);
                          },
                        )
                    ),
                    SizedBox(height: isLoadmore?10.0:0.0),
                    isLoadmore?Expanded(flex:4,child: HistoryPembelianLoading(tot: 1)):Container()
                  ],
                ),
                callback: (){
                  setState(() {
                    isLoading=true;
                  });
                  loadData();
                },
              )),
            )
          ],
        ),
      ),
    );
  }
}
