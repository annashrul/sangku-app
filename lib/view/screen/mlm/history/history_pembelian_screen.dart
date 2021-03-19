import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/data_helper.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/refresh_widget.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'file:///E:/NETINDO/mobile/sangkuy/lib/model/mlm/history/history_pembelian_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:sangkuy/view/screen/mlm/history/detail_history_pembelian_screen.dart';
import 'package:sangkuy/view/widget/appbar_widget.dart';
import 'package:sangkuy/view/widget/loading/history_pembelian_loading.dart';

class HistoryPembelianScreen extends StatefulWidget {
  @override
  _HistoryPembelianScreenState createState() => _HistoryPembelianScreenState();
}

class _HistoryPembelianScreenState extends State<HistoryPembelianScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  HistoryPemberlianModel historyPemberlianModel;
  ScrollController controller;
  int perpage=10;
  int total=0;
  bool isLoading=false,isLoadmore=false;
  String lbl='';
  String filterStatus='';

  Future loadData()async{
    String url='transaction/penjualan/report?page=1&perpage=$perpage';
    if(filterStatus!=''){
      url+='&status=$filterStatus';
    }
    var res = await BaseProvider().getProvider(url,historyPemberlianModelFromJson,context: context,callback: (){Navigator.pop(context);});
    if(res==Constant().errNoData){
      isLoading=false;
      total=0;
      if(this.mounted)setState(() {});
    }
    else if(res is HistoryPemberlianModel){
      HistoryPemberlianModel result=res;
      historyPemberlianModel = result;
      total = historyPemberlianModel.result.total;
      isLoading=false;
      isLoadmore=false;
      if(this.mounted)setState(() {});
    }
  }
  void _scrollListener() {
    if (!isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        if(perpage<total){
          setState((){
            perpage = perpage+perpage;
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
      appBar: WidgetHelper().appBarWithButton(context,"Laporan Pembelian", (){Navigator.pop(context);},<Widget>[]),
      body: RefreshWidget(
        widget: Container(
          padding: scaler.getPadding(1,0),
          child: Column(
            children: [
              // Expanded
              Expanded(
                flex: 1,
                child: Padding(
                  padding:scaler.getPadding(0,2),
                  child: WidgetHelper().filterStatus(context, DataHelper.filterHistoryPembelian, (val){
                    setState(() {
                      filterStatus = val['kode'];
                      isLoading=true;
                    });
                    loadData();
                  },filterStatus),
                )
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                flex: 19,
                child: isLoading?HistoryPembelianLoading(tot: 10):total<1?WidgetHelper().noDataWidget(context):Scrollbar(child: Column(
                  children: [
                    Expanded(
                        flex:16,
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          controller: controller,
                          itemCount: historyPemberlianModel.result.data.length,
                          itemBuilder: (context,index){
                            print(historyPemberlianModel.result.data.length);
                            final val=historyPemberlianModel.result.data[index];
                            final valDet = historyPemberlianModel.result.data[index].detail;

                            return FlatButton(
                              padding: EdgeInsets.all(0.0),
                                onPressed: (){
                                  WidgetHelper().myPush(context,DetailHistoryPembelianScreen(kdTrx:base64.encode(utf8.encode(val.kdTrx))));
                                },
                                color: index%2==0?Colors.transparent:Color(0xFFEEEEEE),
                                // shape: BoxShape,
                                child:  Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: scaler.getHeight(1),left: scaler.getWidth(2),right: scaler.getWidth(2)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: Column(
                                              children: [
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                            Constant().localIcon+'lainnya_icon.svg',
                                                            height: scaler.getHeight(1),
                                                            width: scaler.getWidth(1),
                                                            color:Constant().secondColor
                                                        ),
                                                        SizedBox(width:scaler.getWidth(1)),
                                                        WidgetHelper().textQ("${val.type==0?'Aktivasi':'Repeat Order'}",scaler.getTextSize(9),Constant().darkMode,FontWeight.bold),
                                                      ],
                                                    ),
                                                    SizedBox(height:scaler.getHeight(0.5)),
                                                    WidgetHelper().textQ("#${val.kdTrx}",scaler.getTextSize(9),Constant().mainColor,FontWeight.bold),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          WidgetHelper().myStatus(context,val.status)
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: valDet.length,
                                      itemBuilder: (context,key){
                                        return Padding(
                                          padding: scaler.getPadding(0,2),
                                          child: Container(
                                            padding: EdgeInsets.only(right:10.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    WidgetHelper().baseImage(valDet[key].foto,height:scaler.getHeight(3)),
                                                    // Image.network(valDet[key].foto,height:50,width: 50,fit: BoxFit.contain,),
                                                    SizedBox(width:scaler.getWidth(2)),
                                                    Column(
                                                      children: [
                                                        Container(
                                                          width: scaler.getWidth(70),
                                                          child: WidgetHelper().textQ(valDet[key].paket,scaler.getTextSize(9),Constant().darkMode,FontWeight.bold),
                                                        ),
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            WidgetHelper().textQ("${valDet[key].qty} ITEM ",scaler.getTextSize(9),Colors.grey,FontWeight.normal),
                                                            SizedBox(width:scaler.getWidth(2)),
                                                            WidgetHelper().textQ("${FunctionHelper().formatter.format(int.parse('${valDet[key].price}'))}",scaler.getTextSize(9),Constant().moneyColor,FontWeight.normal),
                                                          ],
                                                        )
                                                      ],
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    Padding(
                                      padding: scaler.getPadding(0,2),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: Column(
                                              children: [
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    WidgetHelper().textQ("Total Belanja",scaler.getTextSize(9),Colors.black87,FontWeight.normal),
                                                    WidgetHelper().textQ("Rp ${FunctionHelper().formatter.format(int.parse('${val.grandTotal}'))} .-",scaler.getTextSize(9),Constant().moneyColor,FontWeight.bold),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            child: Column(
                                              children: [
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    WidgetHelper().textQ(val.metodePembayaran,scaler.getTextSize(9),Constant().greenColor,FontWeight.bold),
                                                    WidgetHelper().baseImage(val.kurir,height: 30,width: 40,fit: BoxFit.contain)
                                                  ],
                                                )
                                              ],
                                            ),
                                          )

                                          // WidgetHelper().textQ(val.kurir,10,Colors.black87,FontWeight.normal),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                )
                            );
                          },
                          separatorBuilder: (context,index){
                            return SizedBox(height: 10.0);
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
