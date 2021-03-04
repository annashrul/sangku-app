import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/data_helper.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/refresh_widget.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/general_model.dart';
import 'package:sangkuy/model/wallet/history_withdraw_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:sangkuy/view/screen/mlm/history/success_pembelian_screen.dart';
import 'package:sangkuy/view/screen/wallet/history_deposit_screen.dart';
import 'package:sangkuy/view/widget/loading/history_transaction_loading.dart';

class HistoryWithdrawScreen extends StatefulWidget {
  @override
  _HistoryWithdrawScreenState createState() => _HistoryWithdrawScreenState();
}

class _HistoryWithdrawScreenState extends State<HistoryWithdrawScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String filterStatus='';
  bool isLoading=false,isLoadmore=false,isNodata=false,isError=false;
  HistoryWithdrawModel historyWithdrawModel;
  ScrollController controller;
  int perpage=15,total=0;
  Future loadData()async{
    String url='transaction/withdrawal?page=1&perpage=$perpage';
    if(filterStatus!=''){
      url+='&status=$filterStatus';
    }
    var res = await BaseProvider().getProvider(url,historyWithdrawModelFromJson);
    if(res is HistoryWithdrawModel){
      HistoryWithdrawModel result=res;
      if(result.status=='success'){
        if(this.mounted){
          if(result.result.data.length>0){
            setState(() {
              historyWithdrawModel = HistoryWithdrawModel.fromJson(result.toJson());
              isLoading=false;
              isError=false;
              isNodata=false;
              isLoadmore=false;
              total=historyWithdrawModel.result.total;
            });
          }
          else{
            setState(() {
              isLoading=false;
              isError=false;
              isNodata=true;
            });
          }

        }
      }
      else{
        setState(() {
          isLoading=false;
          isError=false;
          isNodata=false;

        });
      }
    }
    else if(res==Constant().errSocket||res==Constant().errTimeout){
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
        isNodata=false;

      });
      WidgetHelper().notifOneBtnDialog(context,Constant().titleErrToken,Constant().descErrToken,()async{
        await FunctionHelper().logout(context);
      });
    }
    else if(res is General){
      General result=res;
      setState(() {
        isLoading=false;
        isError=false;
        isNodata=false;

      });
      WidgetHelper().showFloatingFlushbar(context,"failed",result.msg);
    }
    else if(res==Constant().errNoData){
      setState(() {
        isLoading=false;
        isError=false;
        isNodata=true;
      });
    }
  }
  void _scrollListener() {
    if (!isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
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
    controller = new ScrollController()..addListener(_scrollListener);
    isLoading=true;
    loadData();
    initializeDateFormatting('id');

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: WidgetHelper().appBarWithButton(context,"Laporan Penarikan", (){Navigator.pop(context);},<Widget>[]),
      body: Scrollbar(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(left:10),
                  child: WidgetHelper().filterStatus(context, DataHelper.filterHistoryDeposit, (val){
                    setState(() {
                      filterStatus = val['kode'];
                      isLoading=true;
                    });
                    loadData();
                  },filterStatus),
                ),
              ),
              Expanded(
                  flex: 19,
                  child: RefreshWidget(
                    widget: isLoading?HistoryTransactionLoading(tot: 10):isNodata?WidgetHelper().noDataWidget(context):ListView.builder(
                        controller: controller,
                        padding: EdgeInsets.only(top:10.0),
                        physics: AlwaysScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context,index){
                          var val=historyWithdrawModel.result.data[index];
                          String status='';
                          Color color;
                          if(val.status==0){
                            status='Pending';
                            color = Constant().secondColor;
                          }
                          if(val.status==1){
                            status='Selesai';
                            color = Constant().mainColor;
                          }
                          if(val.status==2){
                            status='Batal';
                            color = Colors.red;
                          }
                          return WidgetHistoryEwallet(
                            color: index%2==0?Color(0xFFEEEEEE):Colors.white,
                            statusColor: color,
                            data: {
                              'kdTrx':val.kdTrx,
                              'bankName':val.bankName,
                              'accNo':val.accNo,
                              'amount':val.amount,
                              'createdAt':val.createdAt,
                              'status':status
                            },
                            callback: (){
                              if(val.status==0){
                                WidgetHelper().myPush(context,SuccessPembelianScreen(kdTrx: FunctionHelper().decode(val.kdTrx)));
                              }
                            },
                          );

                          // return FlatButton(
                          //   color: index%2==0?Color(0xFFEEEEEE):Colors.white,
                          //   padding: EdgeInsets.only(top:10.0,bottom: 10.0),
                          //   onPressed: (){
                          //     if(val.status==0){
                          //       WidgetHelper().myPush(context,SuccessPembelianScreen(kdTrx: FunctionHelper().decode(val.kdTrx)));
                          //     }
                          //   },
                          //   child: ListTile(
                          //     title: Column(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         WidgetHelper().textQ(val.kdTrx, 10,Constant().darkMode,FontWeight.normal),
                          //         SizedBox(height: 5),
                          //         Row(
                          //           children: [
                          //             Icon(AntDesign.creditcard,size: 10),
                          //             SizedBox(width: 5),
                          //             Expanded(
                          //               child: WidgetHelper().textQ(val.bankName, 10,Constant().darkMode,FontWeight.normal),
                          //             )
                          //           ],
                          //         ),
                          //         SizedBox(height: 5),
                          //         Row(
                          //           children: [
                          //             Icon(AntDesign.creditcard,size: 10),
                          //             SizedBox(width: 5),
                          //             Expanded(
                          //               child: WidgetHelper().textQ(val.accNo, 10,Constant().darkMode,FontWeight.normal),
                          //             )
                          //           ],
                          //         ),
                          //         SizedBox(height: 5),
                          //         Row(
                          //           children: [
                          //             Icon(Entypo.credit,size: 10),
                          //             SizedBox(width: 5),
                          //             WidgetHelper().textQ("Rp ${FunctionHelper().formatter.format(int.parse(val.amount))} .-", 10,Constant().moneyColor,FontWeight.normal),
                          //           ],
                          //         ),
                          //         SizedBox(height: 5),
                          //         Row(
                          //           children: [
                          //             Icon(AntDesign.calendar,size: 10),
                          //             SizedBox(width: 5),
                          //             WidgetHelper().textQ(FunctionHelper().formateDate(val.createdAt,"ymd"), 10,Colors.grey,FontWeight.normal),
                          //           ],
                          //         ),
                          //       ],
                          //     ),
                          //     trailing: WidgetHelper().textQ(status, 10,color,FontWeight.normal,textAlign: TextAlign.center),
                          //   ),
                          // );

                          return ListTile(
                            onTap: (){},
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                WidgetHelper().textQ(val.bankName, 10,Constant().darkMode,FontWeight.normal),
                                SizedBox(height:5.0),
                                WidgetHelper().textQ("Rp ${FunctionHelper().formatter.format(int.parse(val.amount))} .-", 14,Constant().moneyColor,FontWeight.normal),
                                SizedBox(height:5.0),
                                WidgetHelper().textQ("${val.kdTrx} - ${DateFormat.yMMMMEEEEd('id').format(val.createdAt)}", 10,Colors.grey,FontWeight.normal),
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                WidgetHelper().textQ("admin : ${val.charge}", 10,Constant().moneyColor,FontWeight.normal),
                                SizedBox(height:5.0),
                                WidgetHelper().textQ(status, 10,color,FontWeight.normal),
                              ],
                            )
                          );
                        },
                        itemCount: historyWithdrawModel.result.data.length
                    ),
                    callback: (){
                      setState(() {
                        isLoading=true;
                      });
                      loadData();
                    },
                  )
              ),
              if(isLoadmore)Expanded(
                  flex: 2,
                  child: HistoryTransactionLoading(tot: 1)
              )
            ],
          )
      ),
    );
  }
}
