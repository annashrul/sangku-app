import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sangkuy/config/constant.dart';
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
  bool isLoading=false,isLoadmore=false,isError=false,isErrToken,isNodata=false;
  String lbl='';
  int filterStatus=5;

  Future loadData()async{
    var res = await BaseProvider().getProvider('transaction/penjualan/report?page=1&perpage=$perpage&status=$filterStatus',historyPemberlianModelFromJson);
    if(res==Constant().errSocket||res==Constant().errTimeout){
      setState(() {
        isLoading=false;
        isError=true;
        isNodata=false;
      });
    }
    else if(res==Constant().errExpToken){
      setState(() {
        isLoading=false;
        isError=false;
        isErrToken=true;
        isNodata=false;

      });
    }
    else if(res==Constant().errNoData){
      setState(() {
        isLoading=false;
        isError=false;
        isNodata=true;
      });
    }

    else{
      if(res is HistoryPemberlianModel){
        HistoryPemberlianModel result=res;
        if(result.status=='success'){
          historyPemberlianModel = HistoryPemberlianModel.fromJson(result.toJson());
          setState(() {
            total = historyPemberlianModel.result.total;
            isLoading=false;
            isLoadmore=false;
            isError=false;
            isErrToken=false;
            isNodata=false;

          });
        }
        else{
          setState(() {
            isLoading=false;
            isError=false;
            isErrToken=false;
            isNodata=false;

          });
        }
      }
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
    return Scaffold(
      appBar: AppBarNoButton(),
      body: RefreshWidget(
        widget: Container(
          padding: EdgeInsets.only(top:10,bottom:10,left:20,right:20),
          child: Column(
            children: [
              Expanded(
                  flex: 1,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: FunctionHelper.arrStatus.length,
                    itemBuilder: (context,index){
                      return  WidgetHelper().myPress((){
                        setState(() {
                          filterStatus = index;
                          isLoading=true;
                        });
                        loadData();
                      },
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                            decoration: BoxDecoration(
                              color: filterStatus==index?Constant().mainColor:Constant().secondColor,
                              // border: Border.all(width:1.0,color: filterStatus==index?Constant().mainColor:Colors.grey[200]),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                WidgetHelper().textQ("${FunctionHelper.arrStatus[index]}", 10,Constant().secondDarkColor, FontWeight.bold),
                              ],
                            ),
                          )
                      );
                    },
                  )
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                flex: 19,
                child: isLoading?HistoryPembelianLoading(tot: 10):isNodata?WidgetHelper().noDataWidget(context):Scrollbar(child: Column(
                  children: [
                    Expanded(
                        flex:16,
                        child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          controller: controller,
                          itemCount: historyPemberlianModel.result.data.length,
                          itemBuilder: (context,index){
                            final val=historyPemberlianModel.result.data[index];
                            final valDet = historyPemberlianModel.result.data[index].detail;
                            return WidgetHelper().myPress(
                                    (){
                                  WidgetHelper().myPush(context,DetailHistoryPembelianScreen(kdTrx:base64.encode(utf8.encode(val.kdTrx))));
                                },
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).focusColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left:10,right:10,top:10),
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
                                                          Icon(AntDesign.home,size: 10,color:Colors.black87),
                                                          SizedBox(width: 5.0),
                                                          WidgetHelper().textQ("${val.type==0?'Aktivasi':'Repeat Order'}",10,Colors.black87,FontWeight.normal),
                                                        ],
                                                      ),
                                                      SizedBox(height: 5.0),
                                                      WidgetHelper().textQ("#${val.kdTrx}",10,Colors.black87,FontWeight.normal),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            WidgetHelper().myStatus(context,val.status)

                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10,right:10,top:5,bottom:5),
                                        child: Container(
                                          color: Colors.grey[200],
                                          height: 1.0,
                                          width: double.infinity,
                                        ),
                                      ),
                                      ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: valDet.length,
                                        itemBuilder: (context,key){
                                          return Padding(
                                            padding: EdgeInsets.only(left:10,right:10,top:0),
                                            child: Container(
                                              padding: EdgeInsets.only(right:10.0),
                                              color: key%2==0?Color(0xFFEEEEEE):Colors.white70,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Image.network(valDet[key].foto,height:50,width: 50,fit: BoxFit.contain,),
                                                      SizedBox(width: 10.0),
                                                      Column(
                                                        children: [
                                                          Container(
                                                            width: MediaQuery.of(context).size.width/2,
                                                            child: WidgetHelper().textQ(valDet[key].paket,12,Colors.black87,FontWeight.normal),
                                                          ),
                                                          Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              WidgetHelper().textQ("${valDet[key].qty} ITEM ",10,Colors.grey,FontWeight.normal),
                                                              SizedBox(width: 20.0),
                                                              WidgetHelper().textQ("${FunctionHelper().formatter.format(int.parse('${valDet[key].price}'))}",10,Constant().moneyColor,FontWeight.normal),
                                                            ],
                                                          )
                                                        ],
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                      ),
                                                    ],
                                                  ),
                                                  WidgetHelper().textQ(val.metodePembayaran,10,Colors.grey,FontWeight.normal)
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      Padding(
                                        padding: EdgeInsets.only(left:10,right:10),
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
                                                      WidgetHelper().textQ("Total Belanja",10,Colors.black87,FontWeight.normal),
                                                      WidgetHelper().textQ("Rp ${FunctionHelper().formatter.format(int.parse('${val.grandTotal}'))} .-",10,Constant().moneyColor,FontWeight.bold),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                              child:InkWell(
                                                onTap: (){
                                                },
                                                child: Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                    decoration: BoxDecoration(
                                                      color: Constant().mainColor,
                                                      borderRadius: BorderRadius.circular(10.0),

                                                    ),
                                                    child: Center(
                                                      child: WidgetHelper().textQ(val.status==0?"Upload Bukti Transfer":"Lacak Resi",10,Colors.white, FontWeight.bold),
                                                    )
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
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
