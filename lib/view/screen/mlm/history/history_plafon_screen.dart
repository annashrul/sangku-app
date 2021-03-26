import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/refresh_widget.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/mlm/history/history_plafon_model.dart';
import 'package:sangkuy/model/mlm/history/history_transaction_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:sangkuy/view/widget/loading/history_transaction_loading.dart';
import 'package:sangkuy/view/widget/ringkasan_history_widget.dart';

class HistoryPlafonScreen extends StatefulWidget {
  @override
  _HistoryPlafonScreenState createState() => _HistoryPlafonScreenState();
}

class _HistoryPlafonScreenState extends State<HistoryPlafonScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController controller;
  HistoryPlafonModel historyPlafonModel;
  bool isLoading=false,isLoadmore=false;
  int perpage=20,total=0;
  String dateFrom='',dateTo='',q='';
  bool isSelected=false;
  Future loadData()async{
    String url='transaction/history/plafon?perpage=1&perpage=$perpage';
    if(dateFrom!=''&&dateTo!=''){
      url+='&datefrom=$dateFrom&dateto=$dateTo';
    }
    if(q!=''){
      url+='&q=$q';
    }
    var res = await BaseProvider().getProvider(url,historyPlafonModelFromJson,context: context,callback: (){Navigator.pop(context);});
    print(res);
    if(res is HistoryPlafonModel){
      HistoryPlafonModel result=res;
      historyPlafonModel = HistoryPlafonModel.fromJson(result.toJson());
      isLoading=false;
      isLoadmore=false;
      total=historyPlafonModel.result.total;
      if(this.mounted)setState(() {});
    }
    else if(res==Constant().errNoData){
      isLoading=false;
      total=0;
      if(this.mounted)setState(() {});
    }
  }
  void _scrollListener() {
    if (!isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        print('fetch data');
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
  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    isLoading=false;
    isLoadmore=false;
    super.dispose();

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dateFrom=FunctionHelper().formatReportDate()['dateFrom'];
    dateTo=FunctionHelper().formatReportDate()['dateTo'];
    controller = new ScrollController()..addListener(_scrollListener);
    isLoading=true;
    loadData();
    initializeDateFormatting('id');

  }
  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: WidgetHelper().appBarWithFilter(context,"Laporan SangQuota",  (){Navigator.pop(context);}, (param){
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
      },isDetail: true,detail: (){
        WidgetHelper().myModal(context,RingkasanHistoryPlafon(val: historyPlafonModel.result.summary.toJson()));
      }),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: scaler.getHeight(1)),
          if(dateFrom!=''||dateTo!=''||q!='')Expanded(
            flex:1,
            child: ListView(
              padding: scaler.getPadding(0,2),
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
                            child: Icon(AntDesign.closecircleo,size:  scaler.getTextSize(9),color:Constant().greyColor)
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: scaler.getHeight(1)),
          Expanded(
              flex: 20,
              child: isLoading?HistoryTransactionLoading(tot: 10):total<1?WidgetHelper().noDataWidget(context):RefreshWidget(
                widget: ListView.builder(
                  padding: scaler.getPadding(0,0),
                  controller: controller,
                  itemBuilder: (context,index){
                    var val=historyPlafonModel.result.data[index];
                    return FlatButton(
                      onPressed: (){},
                      padding: scaler.getPadding(0,0),
                      color: index%2==0?Color(0xFFEEEEEE):Colors.white,
                      child: ListTile(
                        contentPadding: scaler.getPadding(0.5,2),
                        onTap: (){},
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                WidgetHelper().titleNoButton(context, AntDesign.codepen, val.kdTrx,iconSize: 10,color: Constant().darkMode,fontWeight: FontWeight.normal),
                                WidgetHelper().textQ("Rp ${FunctionHelper().formatter.format(int.parse(val.plafonIn))} .- ( + )", scaler.getTextSize(9),Constant().moneyColor,FontWeight.bold),
                              ],
                            ),
                            SizedBox(height: scaler.getHeight(0.5)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                WidgetHelper().titleNoButton(context, AntDesign.calendar,FunctionHelper().formateDate(val.createdAt,"ymd"),iconSize: 10,color: Constant().darkMode,fontWeight: FontWeight.normal),
                                WidgetHelper().textQ("Rp ${FunctionHelper().formatter.format(int.parse(val.plafonOut))} .- ( - )", scaler.getTextSize(9),Constant().moneyColor,FontWeight.bold),                                ],
                            ),
                            SizedBox(height: scaler.getHeight(0.5)),
                            Container(
                              width: double.infinity,
                              child: WidgetHelper().textQ(val.note, scaler.getTextSize(9), Constant().darkMode, FontWeight.normal),
                            )
                            // WidgetHelper().titleNoButton(context, AntDesign.paperclip, val.note,iconSize: 10,color: Constant().darkMode),

                          ],
                        ),

                      ),
                    );
                  },
                  itemCount: historyPlafonModel.result.data.length,
                ),
                callback: (){
                  setState(() {
                    isLoading=true;
                  });
                  loadData();
                },
              )
          ),

        ],
      ),
      bottomNavigationBar: isLoadmore?HistoryTransactionLoading(tot: 1):Text(''),

    );
  }
}

class RingkasanHistoryPlafon extends StatefulWidget {
  final dynamic val;
  RingkasanHistoryPlafon({this.val});
  @override
  _RingkasanHistoryPlafonState createState() => _RingkasanHistoryPlafonState();
}

class _RingkasanHistoryPlafonState extends State<RingkasanHistoryPlafon> {
  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);
    return Container(
      height: scaler.getHeight(50),
      child: WidgetHelper().wrapperModal(context,"Ringkasan",ListView(
        padding: scaler.getPadding(0,2),
        children: [
          RingkasanHistoryWidget(title:"Saldo Awal",desc:"Rp ${FunctionHelper().formatter.format(int.parse(widget.val['saldo_awal']))}"),
          Divider(thickness: 2,height: scaler.getHeight(2),),
          RingkasanHistoryWidget(title:"Plafon Masuk",desc:"Rp ${FunctionHelper().formatter.format(int.parse(widget.val['plafon_in']))}"),
          Divider(thickness: 2,height: scaler.getHeight(2),),
          RingkasanHistoryWidget(title:"Plafon Keluar",desc:"Rp ${FunctionHelper().formatter.format(int.parse(widget.val['plafon_out']))}"),
          Divider(thickness: 2,height: scaler.getHeight(2),),
          RingkasanHistoryWidget(title:"Saldo Saat Ini",desc:"Rp ${FunctionHelper().formatter.format(int.parse(widget.val['plafon_in'])-int.parse(widget.val['plafon_out']))}"),
        ],
      )),
    );
  }

}




