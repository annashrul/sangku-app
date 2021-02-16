import 'package:flutter/material.dart';
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
                  child: ListView.builder(
                    // shrinkWrap: true,

                    scrollDirection: Axis.horizontal,
                    itemCount: DataHelper.filterHistoryDeposit.length,
                    itemBuilder: (context,index){
                      return  WidgetHelper().myPress((){
                        setState(() {
                          filterStatus = DataHelper.filterHistoryDeposit[index]['kode'];
                          isLoading=true;
                        });
                        loadData();
                      },
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                            decoration: BoxDecoration(
                              color: filterStatus==DataHelper.filterHistoryDeposit[index]['kode']?Constant().mainColor:Constant().secondColor,
                              // border: Border.all(width:1.0,color: filterStatus==index?Constant().mainColor:Colors.grey[200]),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                WidgetHelper().textQ("${DataHelper.filterHistoryDeposit[index]['value']}", 10,Constant().secondDarkColor, FontWeight.bold),
                              ],
                            ),
                          )
                      );
                    },
                  )
              ),
              Expanded(
                  flex: 19,
                  child: RefreshWidget(
                    widget: isLoading?HistoryTransactionLoading(tot: 10):isNodata?WidgetHelper().noDataWidget(context):ListView.separated(
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
                        separatorBuilder: (context,index){return Divider();},
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
