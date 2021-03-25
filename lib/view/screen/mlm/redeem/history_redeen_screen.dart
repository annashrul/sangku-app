import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/refresh_widget.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/general_model.dart';
import 'package:sangkuy/model/mlm/redeem/history_redeem_model.dart';
import 'package:sangkuy/model/mlm/resi_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:sangkuy/provider/tracking_provider.dart';
import 'package:sangkuy/view/screen/mlm/history/resi_screen.dart';
import 'package:sangkuy/view/screen/pages.dart';
import 'package:sangkuy/view/widget/loading/history_pembelian_loading.dart';

class HistoryRedeemScreen extends StatefulWidget {
  @override
  _HistoryRedeemScreenState createState() => _HistoryRedeemScreenState();
}

class _HistoryRedeemScreenState extends State<HistoryRedeemScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  HistoryRedeemModel historyRedeemModel;
  ScrollController controller;
  int perpage=10;
  int total=0;
  bool isLoading=false,isLoadmore=false,isNodata=false;
  String lbl='';
  int filterStatus=5;
  String dateFrom='',dateTo='',q='';

  Future loadData()async{
    String url='transaction/redeem/report?perpage=$perpage';
    if(dateFrom!=''&&dateTo!=''){
      url+='&datefrom=$dateFrom&dateto=$dateTo';
    }
    if(q!=''){
      url+='&q=$q';
    }
    if(filterStatus!=5){
      url+='&status=$filterStatus';
    }
    var res = await BaseProvider().getProvider(url,historyRedeemModelFromJson,context: context,callback: (){

    });
    if(res==Constant().errNoData){
      setState(() {
        isLoading=false;
        isNodata=true;
      });
    }
    else if(res is HistoryRedeemModel){
      HistoryRedeemModel result=res;
      historyRedeemModel = HistoryRedeemModel.fromJson(result.toJson());
      total = historyRedeemModel.result.total;
      isLoading=false;
      isLoadmore=false;
      isNodata=false;
      if(this.mounted){
        setState(() {});
      }


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
    // print(val);
    WidgetHelper().loadingDialog(context);
    var res=await BaseProvider().putProvider('transaction/redeem/done/${FunctionHelper().decode(val['kd_trx'])}', {},context: context);
    Navigator.pop(context);
    if(res!=null){
      WidgetHelper().notifOneBtnDialog(context,"Berhasil","Selamat ... transaksi redeem anda berhasil diselesaikan", (){
        WidgetHelper().myPushRemove(context,IndexScreen(currentTab: 2));
      });
    }

  }
  Future handleCheckResi(resi,BuildContext context)async{
    WidgetHelper().loadingDialog(context);
    var res = await TrackingProvider().checkResi('JD0099164063', 'jnt', '',context: context);
    if(res is ResiModel){
      ResiModel result=res;
      Navigator.pop(context);
      WidgetHelper().myPush(context,ResiScreen(resiModel: result));
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
      appBar: WidgetHelper().appBarWithFilter(context,"Laporan Redeem Poin",  (){Navigator.pop(context);}, (param){
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
            SizedBox(height: scaler.getHeight(1)),
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
              child: isLoading?HistoryPembelianLoading(tot: 10):isNodata?WidgetHelper().noDataWidget(context):RefreshWidget(
                widget: Scrollbar(child: Column(
                  children: [
                    Expanded(
                        flex:16,
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          controller: controller,
                          itemCount: historyRedeemModel.result.data.length,
                          itemBuilder: (context,index){
                            final val=historyRedeemModel.result.data[index];
                            String status='';
                            Color color;
                            if(val.status==0){
                              status='Dikemas';
                              color=Color(0xFFff9800);
                            }
                            if(val.status==1){
                              status='Dikirim';
                              color=Constant().mainColor;
                            }
                            if(val.status==2){
                              status='Diterima';
                              color=Constant().greenColor;
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
                                            WidgetHelper().textQ(FunctionHelper().formateDate(val.createdAt,''),scaler.getTextSize(8),Constant().mainColor,FontWeight.bold),
                                            WidgetHelper().textQ("(${val.kdTrx})",scaler.getTextSize(8),Constant().mainColor,FontWeight.bold),
                                          ],
                                        ),
                                        WidgetHelper().myBtnBorder(context,val.status!=1?"Lacak Resi":"Selesaikan",(){
                                          print(val.status);
                                          if(val.status!=1){
                                            handleCheckResi(val.resi,context);
                                            // WidgetHelper().myPush(context,ResiScreen());
                                          }else{
                                            if(val.status==1){
                                              handleDone(val.toJson(),context);
                                            }
                                            // print('bus');
                                            // handleDone(val.toJson(),context);
                                          }
                                        },val.status!=1?Constant().mainColor:Constant().greenColor)
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: ListTile(
                                      contentPadding:scaler.getPadding(0,2),
                                      leading:WidgetHelper().baseImage(val.gambar,width: scaler.getWidth(10),height:scaler.getHeight(10)),
                                      title: WidgetHelper().textQ(val.title+' ( ${val.subtotal} poin )',scaler.getTextSize(9),Constant().mainColor2,FontWeight.bold),
                                      subtitle: Column(
                                        children: [
                                          WidgetHelper().textQ("${val.penerima}",scaler.getTextSize(8), Constant().darkMode,FontWeight.bold),
                                          WidgetHelper().textQ("${val.mainAddress}",scaler.getTextSize(8), Constant().darkMode,FontWeight.normal),
                                        ],
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                      ),

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
                )),
                callback: (){
                  setState(() {
                    isLoading=true;
                  });
                  loadData();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
