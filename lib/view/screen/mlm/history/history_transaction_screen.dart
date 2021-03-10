import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/filter_date_helper.dart';
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
  bool isLoading=false,isLoadmore=false,isNodata=false,isError=false;
  int perpage=20,total=0;
  String dateFrom='',dateTo='',q='';
  bool isSelected=false;
  Future loadData()async{
    String url='transaction/history?page=1&perpage=$perpage';
    if(dateFrom!=''&&dateTo!=''){
      url+='&datefrom=$dateFrom&dateto=$dateTo';
    }
    if(q!=''){
      url+='&q=$q';
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
    dateFrom=FunctionHelper().formatReportDate()['dateFrom'];
    dateTo=FunctionHelper().formatReportDate()['dateTo'];
    controller = new ScrollController()..addListener(_scrollListener);
    isLoading=true;
    loadData();
    initializeDateFormatting('id');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: WidgetHelper().appBarWithFilter(context,"Laporan transaksi",  (){Navigator.pop(context);}, (param){
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
      body: Scrollbar(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(dateFrom!=''||dateTo!=''||q!='')Expanded(
              flex:1,
              child: ListView(
                padding: EdgeInsets.all(5.0),
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
                            child:WidgetHelper().textQ(dateFrom+' s/d '+dateTo,8,Colors.white,FontWeight.bold),
                          ),
                          Positioned(
                              right: 0,
                              top: 0,
                              child: Icon(AntDesign.closecircleo,size: 10,color:Constant().greyColor)
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
                              child:WidgetHelper().textQ(q,8,Colors.white,FontWeight.bold)
                          ),
                          Positioned(
                              right: 0,
                              top: 0,
                              child: Icon(AntDesign.closecircleo,size: 10,color:Constant().greyColor)
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


class FilterSearch extends StatefulWidget {
  Function(String q) callback;
  FilterSearch({this.callback});
  @override
  _FilterSearchState createState() => _FilterSearchState();
}

class _FilterSearchState extends State<FilterSearch> {
  var qController = TextEditingController();
  final FocusNode qFocus = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    qFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height/2,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
      ),
      child:Column(
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
          Padding(
            padding: EdgeInsets.only(left:10.0,top:0.0,right:10,bottom: 5),
            child:TextFormField(
              textInputAction: TextInputAction.search,
              // keyboardType: Keyboard,
              decoration: InputDecoration(
                hintText: 'Tulis sesuatu disini ...'
              ),
              maxLines: 3,
              controller: qController,
              focusNode: qFocus,
              onFieldSubmitted: (e){
                widget.callback(e);
                Navigator.pop(context);
              },
            ),
          )

        ],
      ),
    );
  }
}
