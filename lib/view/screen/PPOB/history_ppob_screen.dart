import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/refresh_widget.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/PPOB/detail_history_ppob_model.dart';
import 'package:sangkuy/model/PPOB/history_ppob_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:sangkuy/view/widget/loading/history_pembelian_loading.dart';

class HistoryPPOBScreen extends StatefulWidget {
  @override
  _HistoryPPOBScreenState createState() => _HistoryPPOBScreenState();
}

class _HistoryPPOBScreenState extends State<HistoryPPOBScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  HistoryPpobModel historyPpobModel;
  ScrollController controller;
  int perpage=10;
  int total=0;
  bool isLoading=false,isLoadmore=false,isError=false,isErrToken,isNodata=false;
  String lbl='';
  int filterStatus=5;
  Future loadData()async{
    String url='transaction/ppob/report?page=1&perpage=$perpage';
    if(dateFrom!=''&&dateTo!=''){
      url+='&datefrom=$dateFrom&dateto=$dateTo';
    }
    if(q!=''){
      url+='&q=$q';
    }
    if(filterStatus!=5){
      url+='&status=$filterStatus';
    }
    var res = await BaseProvider().getProvider(url,historyPpobModelFromJson,context: context,callback: (){Navigator.pop(context);});
    if(res==Constant().errNoData){
      isLoading=false;
      total=0;
      if(this.mounted)setState(() {});
    }
    else if(res is HistoryPpobModel){
      HistoryPpobModel result=res;
      historyPpobModel = HistoryPpobModel.fromJson(result.toJson());
      total = historyPpobModel.result.total;
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
  String dateFrom='',dateTo='',q='';

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);

    return Scaffold(
      appBar: WidgetHelper().appBarWithFilter(context,"Laporan PPOB",  (){Navigator.pop(context);}, (param){
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
          // padding: EdgeInsets.only(top:0,bottom:10,left:0,right:0),
          child: Column(
            children: [
              SizedBox(height: 10),
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
              Expanded(
                flex: 19,
                child: isLoading?HistoryPembelianLoading(tot: 10):total<1?WidgetHelper().noDataWidget(context):Scrollbar(child: Column(
                  children: [
                    Expanded(
                        flex:16,
                        child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          controller: controller,
                          itemCount: historyPpobModel.result.data.length,
                          itemBuilder: (context,index){
                            final val=historyPpobModel.result.data[index];
                            String status='';
                            Color color;
                            if(val.status==0){
                              status='Dalam Antrian';
                              color=Color(0xFFff9800);
                            }
                            if(val.status==1){
                              status='Transaksi Berhasil';
                              color=Constant().greenColor;
                            }
                            if(val.status==2){
                              status='Transaksi Gagal/Dibatalkan';
                              color=Constant().moneyColor;
                            }
                            return FlatButton(
                              padding: EdgeInsets.all(0.0),
                                color: index%2==0?Colors.transparent:Color(0xFFEEEEEE),
                                onPressed: (){
                                  WidgetHelper().myModal(context,ModalDetailHistoryPPOB(kdTrx:base64.encode(utf8.encode(val.kdTrx))));
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left:10,right:10,top:10,bottom: 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          WidgetHelper().textQ(FunctionHelper().formateDate(val.createdAt,''),10,Constant().darkMode,FontWeight.normal),
                                          WidgetHelper().textQ("(${val.kdTrx})",10,Constant().mainColor,FontWeight.bold),

                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 0,right:0,top:0,bottom:0),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.only(left: 10,right:0,top:0,bottom:0),
                                        leading:WidgetHelper().baseImage(val.tipe==0?val.logo:val.icon,width: 50,height:50),
                                        title: WidgetHelper().textQ(val.produk,10,Constant().darkMode,FontWeight.bold),
                                        subtitle: WidgetHelper().textQ('No. ${val.target}',10,Constant().darkMode,FontWeight.normal),
                                      ),
                                      // color: Constant().secondColor,
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(left: 10,right:10,top:5,bottom:5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              WidgetHelper().textQ(val.kategori,10,Colors.black87,FontWeight.normal),
                                              WidgetHelper().textQ(status,10,color,FontWeight.bold),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              WidgetHelper().textQ("Rp ${FunctionHelper().formatter.format(int.parse(val.harga))} .-",10,Constant().moneyColor,FontWeight.bold),
                                            ],
                                          )
                                        ],
                                      ),
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


class ModalDetailHistoryPPOB extends StatefulWidget {
  final String kdTrx;
  ModalDetailHistoryPPOB({this.kdTrx});
  @override
  _ModalDetailHistoryPPOBState createState() => _ModalDetailHistoryPPOBState();
}

class _ModalDetailHistoryPPOBState extends State<ModalDetailHistoryPPOB> {

  bool isLoading=false;
  DetailHistoryPpobModel detailHistoryPpobModel;
  Future loadData()async{
    var res = await BaseProvider().getProvider('transaction/ppob/report/${widget.kdTrx}',detailHistoryPpobModelFromJson);
    if(res is DetailHistoryPpobModel){
      DetailHistoryPpobModel result=res;
      setState(() {
        isLoading=false;
        detailHistoryPpobModel = result;
      });
      print(detailHistoryPpobModel.result.tagihan.admin);
      print(detailHistoryPpobModel.result.tagihan.toJson().containsValue(null));

    }
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading=true;
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    var val;
    String status='';
    Color color;
    if(!isLoading){
      val = detailHistoryPpobModel.result;
      if(val.status==0){
        status='Dalam Antrian';
        color=Color(0xFFff9800);
      }
      if(val.status==1){
        status='Transaksi Berhasil';
        color=Constant().mainColor;
      }
      if(val.status==2){
        status='Transaksi Gagal/Dibatalkan';
        color=Constant().moneyColor;
      }
    }
    return Container(
      // height: MediaQuery.of(context).size.height/1.2,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
      ),
      child:isLoading?WidgetHelper().loadingWidget(context):Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height:10.0),
          Center(
            child: Container(
              padding: EdgeInsets.only(top:10.0),
              width: 50,
              height: 10.0,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius:  BorderRadius.circular(10.0),
              ),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.all(0.0),
            leading: IconButton(icon: Icon(AntDesign.back), onPressed:(){Navigator.pop(context);}),
            title: WidgetHelper().textQ('Detail Transaksi #${detailHistoryPpobModel.result.kdTrx}',12,Colors.grey,FontWeight.bold),
          ),
          Container(
            width: double.infinity,
            // color: Constant().secondColor,
            padding: EdgeInsets.only(bottom:0.0,top:0.0,left:0.0,right:0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height:10),
                desc(context,'Invoice',detailHistoryPpobModel.result.kdTrx),
                Divider(),
                desc(context,'Status',status,color: color),
                Divider(),
                desc(context,'Kategori',detailHistoryPpobModel.result.kategori),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 10.0),
                  leading: Icon(AntDesign.infocirlceo,color: Constant().mainColor),
                  title: WidgetHelper().textQ("DETAIL PEMBELIAN", 12,Constant().mainColor,FontWeight.bold),
                ),
                Divider(color: Colors.grey),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 10.0),
                  leading: Image.network(val.tipe==0?val.logo:val.icon),
                  title: WidgetHelper().textQ(val.produk,12,Constant().darkMode,FontWeight.bold),
                  subtitle: WidgetHelper().textQ(detailHistoryPpobModel.result.target,12,Constant().darkMode,FontWeight.bold),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.only(left:10),
                  child: WidgetHelper().textQ('Serial Number',12,Constant().darkMode,FontWeight.normal),
                ),
                Padding(
                  padding: EdgeInsets.only(left:10),
                  child: WidgetHelper().textQ(detailHistoryPpobModel.result.token!=null?detailHistoryPpobModel.result.token:'-',12,Constant().darkMode,FontWeight.bold),
                ),
                Divider(),
                desc(context,'Total Pembayaran','Rp ${FunctionHelper().formatter.format(int.parse(detailHistoryPpobModel.result.harga))} .-',color: Constant().moneyColor),
                if(!detailHistoryPpobModel.result.tagihan.toJson().containsValue(null))ListTile(
                  contentPadding: EdgeInsets.only(left:10.0),
                  leading: Icon(AntDesign.infocirlceo,color: Constant().mainColor),
                  title: WidgetHelper().textQ("DETAIL TAGIHAN", 12,Constant().mainColor,FontWeight.bold),
                ),
                if(!detailHistoryPpobModel.result.tagihan.toJson().containsValue(null))Divider(color: Colors.grey),
                if(!detailHistoryPpobModel.result.tagihan.toJson().containsValue(null))Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    desc(context,'Nomor Pelanggan',detailHistoryPpobModel.result.tagihan.noPelanggan),
                    Divider(),
                    desc(context,'Nama Pelanggan',detailHistoryPpobModel.result.tagihan.namaPalanggan),
                    Divider(),
                    // desc(context,'Jumlah Tagihan','Rp ${FunctionHelper().formatter.format(detailHistoryPpobModel.result.tagihan.totalBayar)} .-',color: Constant().moneyColor),
                    // Divider(),
                    desc(context,'Jumlah Tagihan','Rp ${FunctionHelper().formatter.format(detailHistoryPpobModel.result.tagihan.totalBayar)} .-',color: Constant().moneyColor),
                    Divider(),
                    desc(context,'Periode',detailHistoryPpobModel.result.tagihan.periode),

                  ],
                ),
                SizedBox(height:20.0),
                FlatButton(
                    padding: EdgeInsets.all(15.0),
                    color: Constant().moneyColor,
                    onPressed: (){
                      // handleSubmit();
                      // checkingAccount();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(AntDesign.checkcircleo,color: Colors.white),
                        SizedBox(width: 10.0),
                        WidgetHelper().textQ("BELI LAGI", 14,Colors.white,FontWeight.bold)
                      ],
                    )
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget desc(BuildContext context,title,desc,{Color color=Colors.black}){
    return Padding(
      padding: EdgeInsets.only(left:10,right:10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetHelper().textQ(title,12,Constant().darkMode,FontWeight.normal),
          WidgetHelper().textQ(desc,12,color,FontWeight.bold)

        ],
      ),
    );
  }

}

