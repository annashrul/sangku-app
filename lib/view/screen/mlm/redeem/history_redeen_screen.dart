import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/refresh_widget.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/mlm/redeem/history_redeem_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
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
  bool isLoading=false,isLoadmore=false;
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
    if(res is HistoryRedeemModel){
      HistoryRedeemModel result=res;
      if(result.status=='success'){
        historyRedeemModel = HistoryRedeemModel.fromJson(result.toJson());
        setState(() {
          total = historyRedeemModel.result.total;
          isLoading=false;
          isLoadmore=false;
        });
      }
      else{
        setState(() {
          isLoading=false;
          isLoadmore=false;
          total=0;
        });
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
      body: RefreshWidget(
        widget: Container(
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
                              child:WidgetHelper().textQ(dateFrom+' s/d '+dateTo,scaler.getTextSize(8),Colors.white,FontWeight.bold),
                            ),
                            Positioned(
                                right: 0,
                                top: 0,
                                child: Icon(AntDesign.closecircleo,size: scaler.getTextSize(8),color:Constant().greyColor)
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
                                child:WidgetHelper().textQ(q,scaler.getTextSize(8),Colors.white,FontWeight.bold)
                            ),
                            Positioned(
                                right: 0,
                                top: 0,
                                child: Icon(AntDesign.closecircleo,size: scaler.getTextSize(8),color:Constant().greyColor)
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
                child: isLoading?HistoryPembelianLoading(tot: 10):Scrollbar(child: Column(
                  children: [
                    Expanded(
                        flex:16,
                        child: ListView.separated(
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
                                WidgetHelper().myModal(context,DetailHistoryRedeem(
                                  historyRedeemModel: historyRedeemModel,
                                  index: index,
                                ));
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
                                        WidgetHelper().textQ(FunctionHelper().formateDate(val.createdAt,''),scaler.getTextSize(8),Constant().darkMode,FontWeight.normal),
                                        WidgetHelper().textQ("(${val.kdTrx})",scaler.getTextSize(8),Constant().mainColor,FontWeight.bold),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: ListTile(
                                      contentPadding:scaler.getPadding(0,2),
                                      leading:WidgetHelper().baseImage(val.gambar,width: scaler.getWidth(10),height:scaler.getHeight(10)),
                                      title: WidgetHelper().textQ(val.title,scaler.getTextSize(9),Constant().darkMode,FontWeight.bold),
                                      subtitle: WidgetHelper().textQ(status,scaler.getTextSize(9),color,FontWeight.bold),
                                      trailing: IconButton(
                                        icon:Icon(Ionicons.ios_arrow_dropdown_circle),
                                        onPressed: (){
                                          WidgetHelper().myModal(context,DetailHistoryRedeem(
                                            historyRedeemModel: historyRedeemModel,
                                            index: index,
                                          ));
                                        },
                                      ),
                                    ),
                                    // color: Constant().secondColor,
                                  ),
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
              )
            ],
          ),
        ),
        callback: (){
          setState(() {
            isLoading=true;
          });
          loadData();
        },
      ),
    );
  }
}

class DetailHistoryRedeem extends StatefulWidget {
  HistoryRedeemModel historyRedeemModel;
  final int index;
  DetailHistoryRedeem({this.historyRedeemModel,this.index});
  @override
  _DetailHistoryRedeemState createState() => _DetailHistoryRedeemState();
}

class _DetailHistoryRedeemState extends State<DetailHistoryRedeem> {

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);
    var val=widget.historyRedeemModel.result.data[widget.index];
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
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
      ),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height:scaler.getHeight(1)),
          Center(
            child: Container(
              padding:scaler.getPadding(1,2),
              width: scaler.getWidth(10),
              height: scaler.getHeight(1),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius:  BorderRadius.circular(10.0),
              ),
            ),
          ),
          SizedBox(height:scaler.getHeight(1)),
          Padding(
            padding:scaler.getPadding(0,2),
            child: WidgetHelper().titleNoButton(context, AntDesign.infocirlceo, 'Info Barang',color: Constant().mainColor1,iconSize: 12),
          ),
          SizedBox(height:scaler.getHeight(1)),
          ListTile(
            onTap: (){},
            contentPadding:scaler.getPadding(0,2),
            leading:WidgetHelper().baseImage(val.gambar,width: scaler.getWidth(10),height:scaler.getHeight(10)),
            title: WidgetHelper().textQ(val.title,scaler.getTextSize(9),Constant().darkMode,FontWeight.bold),
            subtitle: WidgetHelper().textQ(status,scaler.getTextSize(9),color,FontWeight.bold),
            trailing: FlatButton(
              color:color,
                onPressed: (){},
                child: WidgetHelper().textQ(status,scaler.getTextSize(9),Colors.white,FontWeight.bold)
            ),
          ),

          SizedBox(height:scaler.getHeight(1)),
          WidgetHelper().desc(context,"Poin yang di redeem", "${val.subtotal} Poin"),
          SizedBox(height:scaler.getHeight(1)),
          WidgetHelper().desc(context,"No.Invoice", val.kdTrx),
          SizedBox(height:scaler.getHeight(1)),
          WidgetHelper().desc(context,"Tanggal",FunctionHelper().formateDate(val.createdAt,"ymd")),
          SizedBox(height:scaler.getHeight(1)),
          Padding(
            padding:scaler.getPadding(0,2),
            child: WidgetHelper().titleNoButton(context, AntDesign.infocirlceo, 'Detail Penerima',color: Constant().mainColor1,iconSize: 12),
          ),
          SizedBox(height:scaler.getHeight(1)),
          WidgetHelper().desc(context,"Penerima", val.penerima),
          SizedBox(height:scaler.getHeight(1)),
          Padding(
            padding:scaler.getPadding(0,2),
            child: WidgetHelper().textQ(val.mainAddress,scaler.getTextSize(9), Constant().darkMode,FontWeight.normal),
          ),
          SizedBox(height:scaler.getHeight(1)),
          Row(
            children: [
              InkWell(
                onTap: (){},
                child: WidgetHelper().textQ("selesaikan",scaler.getTextSize(9),Colors.black,FontWeight.bold),
              )
            ],
          )
        ],
      ),
    );
  }
}

