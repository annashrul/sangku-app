import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/refresh_widget.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/general_model.dart';
import 'package:sangkuy/model/mlm/history/history_transaction_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:sangkuy/view/widget/loading/history_transaction_loading.dart';

class HistoryTransactionScreen extends StatefulWidget {
  @override
  _HistoryTransactionScreenState createState() => _HistoryTransactionScreenState();
}

class _HistoryTransactionScreenState extends State<HistoryTransactionScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController controller;
  HistoryTransactionModel historyTransactionModel;
  var qController = TextEditingController();
  final FocusNode qFocus = FocusNode();

  bool isLoading=false,isLoadmore=false,isNodata=false,isError=false;
  int perpage=10,total=0;
  String dateFrom='',dateTo='';
  bool isSelected=false;
  Future loadData()async{
    String url='transaction/history?page=1&perpage=$perpage&datefrom=$dateFrom&dateto=$dateTo';
    if(qController.text!=''){
      url+='&q=${qController.text}';
    }
    var res = await BaseProvider().getProvider(url,historyTransactionModelFromJson);
    print(res);
    if(res is HistoryTransactionModel){
      HistoryTransactionModel result=res;
      if(result.status=='success'){
        if(this.mounted){
          if(result.result.data.length>0){
            setState(() {
              historyTransactionModel = HistoryTransactionModel.fromJson(result.toJson());
              isLoading=false;
              isError=false;
              isNodata=false;
              isLoadmore=false;
              total=historyTransactionModel.result.total;
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
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);

    var formattedDate = "${dateParse.year}-${dateParse.month.toString().padLeft(2, '0')}-${dateParse.day.toString().padLeft(2, '0')}";
    dateFrom = "${DateFormat('yyyy-MM-dd').format(DateTime(dateParse.year, dateParse.month - 1, dateParse.day))}";
    dateTo = formattedDate;
    controller = new ScrollController()..addListener(_scrollListener);
    isLoading=true;
    loadData();
    initializeDateFormatting('id');

  }
  void _showDatePicker(var param) async{
    await WidgetHelper().showDatePickerQ(context,param=='1'?'Dari':'Sampai', (_dateTime,index)async{
      isLoading=true;
      if(param=='1'){
        setState(() {
          dateFrom = '${_dateTime.year}-${_dateTime.month.toString().padLeft(2, '0')}-${_dateTime.day.toString().padLeft(2, '0')}';
        });
      }
      else{
        setState(() {
          dateTo = '${_dateTime.year}-${_dateTime.month.toString().padLeft(2, '0')}-${_dateTime.day.toString().padLeft(2, '0')}';
        });
      }

      loadData();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: WidgetHelper().appBarWithButton(context,"Laporan Transaksi", (){Navigator.pop(context);},<Widget>[
        isSelected?WidgetHelper().myFilter((){
          setState(() {
            isSelected=false;
            qFocus.unfocus();
          });
        },icon: AntDesign.closecircleo):WidgetHelper().myFilter((){
          setState(() {
            isSelected=true;
            qFocus.requestFocus();
          });
        },icon: AntDesign.search1)
      ]),
      body: Scrollbar(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(isSelected)Padding(
              padding: EdgeInsets.only(left:10.0,top:0.0,right:10,bottom: 5),
              child:TextFormField(
                controller: qController,
                focusNode: qFocus,
                onFieldSubmitted: (e){
                  setState(() {
                    isSelected=!isSelected;
                    isLoading=true;
                  });
                  loadData();
                },
              ),
            ),
            if(!isSelected)Padding(
              padding: EdgeInsets.only(left:10.0,top:5.0),
              child: WidgetHelper().textQ("Pecarian",10,Colors.black,FontWeight.bold),
            ),
            if(!isSelected)Expanded(
              flex:1,
              child: ListView(
                padding: EdgeInsets.all(5.0),
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                    margin: EdgeInsets.only(right:5.0),
                    child:  FlatButton(
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(50.0)),
                        color: Constant().mainColor,
                        padding: EdgeInsets.all(5.0),
                        onPressed: (){_showDatePicker("1");},
                        child:WidgetHelper().textQ(dateFrom,8,Colors.white,FontWeight.bold)
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right:5.0,top:5),
                    child:  WidgetHelper().textQ('s/d',8,Colors.grey,FontWeight.bold),
                  ),
                  Container(
                    margin: EdgeInsets.only(right:5.0),
                    child:  FlatButton(
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(50.0)),
                        color: Constant().mainColor,
                        padding: EdgeInsets.all(5.0),
                        onPressed: (){_showDatePicker("2");},
                        child:WidgetHelper().textQ(dateTo,8,Colors.white,FontWeight.bold)
                    ),
                  ),
                  if(qController.text!='')Container(
                    margin: EdgeInsets.only(right:5.0),
                    child:  FlatButton(
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(50.0)),
                        color: Constant().mainColor,
                        padding: EdgeInsets.all(5.0),
                        onPressed: (){},
                        child:WidgetHelper().textQ(qController.text,8,Colors.white,FontWeight.bold)
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                flex: 19,
                child: isLoading?HistoryTransactionLoading(tot: 10):isNodata?WidgetHelper().noDataWidget(context):RefreshWidget(
                  widget: ListView.builder(
                    controller: controller,
                    itemBuilder: (context,index){
                      var val=historyTransactionModel.result.data[index];
                      return FlatButton(
                        onPressed: (){},
                        padding: EdgeInsets.only(top:0,bottom:0),
                        color: index%2==0?Color(0xFFEEEEEE):Colors.white,
                        child: ListTile(
                          contentPadding: EdgeInsets.only(left:10,right:10,top:10,bottom:10),
                          onTap: (){},
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(AntDesign.paperclip,size: 10),
                                  SizedBox(width: 5.0),
                                  Expanded(
                                    child: WidgetHelper().textQ(val.note, 10,Constant().darkMode,FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(AntDesign.codepen,size: 10),
                                  SizedBox(width: 5.0),
                                  WidgetHelper().textQ(val.kdTrx, 10,Constant().mainColor,FontWeight.bold)
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(AntDesign.calendar,size: 10),
                                  SizedBox(width: 5.0),
                                  WidgetHelper().textQ(FunctionHelper().formateDate(val.createdAt,"ymd"), 10,Colors.grey,FontWeight.bold)
                                ],
                              ),
                            ],
                          ),
                          trailing: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                WidgetHelper().textQ("Rp ${FunctionHelper().formatter.format(int.parse(val.trxIn))} .- ( + )", 10,Constant().mainColor,FontWeight.bold),
                                SizedBox(height:5.0),
                                WidgetHelper().textQ("Rp ${FunctionHelper().formatter.format(int.parse(val.trxOut.split(".")[0]))} .- ( - )", 10,Constant().moneyColor,FontWeight.bold),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: historyTransactionModel.result.data.length,
                  ),
                  callback: (){
                    setState(() {
                      isLoading=true;
                      isNodata=false;
                    });
                    loadData();
                  },
                )
            ),
            if(isLoadmore)Expanded(
                flex: 1,
                child: HistoryTransactionLoading(tot: 1)
            )
          ],
        ),
      ),
    );
  }


}
