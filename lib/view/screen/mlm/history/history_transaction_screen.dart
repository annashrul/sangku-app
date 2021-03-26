import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
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
import 'package:sangkuy/view/widget/ringkasan_history_widget.dart';

class HistoryTransactionScreen extends StatefulWidget {
  @override
  _HistoryTransactionScreenState createState() => _HistoryTransactionScreenState();
}

class _HistoryTransactionScreenState extends State<HistoryTransactionScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController controller;
  HistoryTransactionModel historyTransactionModel;
  bool isLoading=false,isLoadmore=false;
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
    var res = await BaseProvider().getProvider(url,historyTransactionModelFromJson,context: context,callback: (){Navigator.pop(context);});
    print(res);
    if(res is HistoryTransactionModel){
      HistoryTransactionModel result=res;
      historyTransactionModel = HistoryTransactionModel.fromJson(result.toJson());
      isLoading=false;
      isLoadmore=false;
      total=historyTransactionModel.result.total;
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
      appBar: WidgetHelper().appBarWithFilter(context,"Laporan transaksi",  (){Navigator.pop(context);},(param){
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
        WidgetHelper().myModal(context,RingkasanHistoryTransaction(val: historyTransactionModel.result.summary.toJson()));
      }),
      body:Column(
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
                widget: buildItem(context),
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
  
  Widget buildItem(BuildContext context){
    ScreenScaler scaler = ScreenScaler()..init(context);
    return ListView.builder(
      padding: scaler.getPadding(0,0),
      controller: controller,
      itemBuilder: (context,index){
        var val=historyTransactionModel.result.data[index];
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
                    WidgetHelper().textQ("Rp ${FunctionHelper().formatter.format(int.parse(val.trxIn))} .- ( + )", scaler.getTextSize(9),Constant().moneyColor,FontWeight.bold),
                  ],
                ),
                SizedBox(height: scaler.getHeight(0.5)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    WidgetHelper().titleNoButton(context, AntDesign.calendar,FunctionHelper().formateDate(val.createdAt,"ymd"),iconSize: 10,color: Constant().darkMode,fontWeight: FontWeight.normal),
                    WidgetHelper().textQ("Rp ${FunctionHelper().formatter.format(int.parse(val.trxOut.split(".")[0]))} .- ( - )", scaler.getTextSize(9),Constant().moneyColor,FontWeight.bold),                                ],
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
      itemCount: historyTransactionModel.result.data.length,
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


class RingkasanHistoryTransaction extends StatefulWidget {
  final dynamic val;
  RingkasanHistoryTransaction({this.val});
  @override
  _RingkasanHistoryTransactionState createState() => _RingkasanHistoryTransactionState();
}

class _RingkasanHistoryTransactionState extends State<RingkasanHistoryTransaction> {
  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);
    print(widget.val);
    return Container(
      height: scaler.getHeight(50),
      child: WidgetHelper().wrapperModal(context,"Ringkasan",ListView(
        padding: scaler.getPadding(0,2),
        children: [
          RingkasanHistoryWidget(title:"Saldo Awal",desc:"Rp ${FunctionHelper().formatter.format(int.parse(widget.val['saldo_awal']))}"),
          Divider(thickness: 2,height: scaler.getHeight(2),),
          RingkasanHistoryWidget(title:"Saldo Masuk",desc:"Rp ${FunctionHelper().formatter.format(int.parse(widget.val['trx_in']))}"),
          Divider(thickness: 2,height: scaler.getHeight(2),),
          RingkasanHistoryWidget(title:"Saldo Keluar",desc:"Rp ${FunctionHelper().formatter.format(int.parse(widget.val['trx_out']))}"),
          Divider(thickness: 2,height: scaler.getHeight(2),),
          RingkasanHistoryWidget(title:"Saldo Saat Ini",desc:"Rp ${FunctionHelper().formatter.format(int.parse(widget.val['trx_in'])-int.parse(widget.val['trx_out']))}"),
        ],
      )),
    );
  }
}
