import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/refresh_widget.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/general_model.dart';
import 'package:sangkuy/model/mlm/history/detail_history_pembelian_model.dart';
import 'package:sangkuy/model/mlm/resi_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:sangkuy/provider/tracking_provider.dart';
import 'package:sangkuy/view/screen/mlm/history/resi_screen.dart';
import 'package:sangkuy/view/screen/mlm/history/success_pembelian_screen.dart';
import 'package:sangkuy/view/screen/pages.dart';
import 'package:sangkuy/view/widget/card_widget.dart';
import 'package:sangkuy/view/widget/detail_scaffold.dart';
import 'package:sangkuy/view/widget/header_widget.dart';
import 'package:sangkuy/view/widget/loading/detail_history_pembelian_loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailHistoryPembelianScreen extends StatefulWidget {
  final String kdTrx;
  DetailHistoryPembelianScreen({this.kdTrx});

  @override
  _DetailHistoryPembelianScreenState createState() => _DetailHistoryPembelianScreenState();
}

class _DetailHistoryPembelianScreenState extends State<DetailHistoryPembelianScreen> {
  DetailHistoryPembelianModel detailHistoryPembelianModel;
  bool isLoading=false,isError=false,isErrToken=false;
  Future loadData()async{
    var res = await BaseProvider().getProvider('transaction/penjualan/report/${widget.kdTrx}',detailHistoryPembelianModelFromJson);
    if(res==Constant().errSocket||res==Constant().errTimeout){
      setState(() {
        isLoading=false;
        isError=true;
      });
    }
    else if(res==Constant().errExpToken){
      setState(() {
        isLoading=false;
        isError=false;
        isErrToken=true;
      });
    }
    else{
      if(res is DetailHistoryPembelianModel){
        DetailHistoryPembelianModel result=res;
        if(result.status=='success'){
          detailHistoryPembelianModel = DetailHistoryPembelianModel.fromJson(result.toJson());
          setState(() {
            isLoading=false;
            isError=false;
            isErrToken=false;
          });
        }
        else{
          setState(() {
            isLoading=false;
            isError=false;
            isErrToken=false;
          });
        }
      }
    }
  }
  int retry=0;
  Future checkingAgain()async{
    await checkResi();
    setState(() {
      retry+=1;
    });
  }
  ResiModel resiModel;
  Future checkResi() async{
    if(detailHistoryPembelianModel.result.resi=='-'){
      WidgetHelper().showFloatingFlushbar(context,"failed","No.Resi belum tersedia");
    }
    else{
      WidgetHelper().loadingDialog(context);
      var res=await TrackingProvider().checkResi(
        // 'JD0099164063',
          detailHistoryPembelianModel.result.resi,
          // 'jnt',
          detailHistoryPembelianModel.result.layananPengiriman.split("|")[0],
          widget.kdTrx
      );
      Navigator.pop(context);
      if(res == 'error'){
        WidgetHelper().notifDialog(context,"Terjadi Kesalahan Server","Mohon maaf server kami sedang dalam masalah", (){Navigator.of(context).pop();},(){Navigator.of(context).pop();});
      }
      else if(res =='failed'){
        if(retry>=3){
          WidgetHelper().notifOneBtnDialog(context, 'Terjadi Kesalahan Server', "Silahkan hubungi admin kami", (){
            WidgetHelper().myPushRemove(context, IndexScreen(currentTab: 2));
          });
        }
        else{
          WidgetHelper().notifDialog(context,"Terjadi Kesalahan","silahkan coba lagi", (){Navigator.pop(context);},(){
            checkingAgain();
          },titleBtn1: "kembali",titleBtn2: "Coba lagi");
        }
      }
      else{
        setState(() {
          resiModel = res;
        });
        WidgetHelper().myPush(context,ResiScreen(resiModel: resiModel));
      }
    }

  }

  Future doneTrx()async{
    WidgetHelper().loadingDialog(context);
    var res=await BaseProvider().putProvider('transaction/done/${widget.kdTrx}', {});
    Navigator.pop(context);
    if(res is General){
      General result=res;
      WidgetHelper().showFloatingFlushbar(context,"failed",result.msg);
    }
    else{
      WidgetHelper().notifOneBtnDialog(context,Constant().titleMsgSuccessTrx,Constant().descMsgSuccessTrx,(){
        WidgetHelper().myPushRemove(context,IndexScreen(currentTab: 2));
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading=true;
    loadData();
    initializeDateFormatting('id');


  }
  Widget btnBottom;

  @override
  Widget build(BuildContext context) {
    print(widget.kdTrx);
    if(!isLoading){
      if(detailHistoryPembelianModel.result.metodePembayaran=='transfer'){
        btnBottom=Container(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          color: Constant().moneyColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FlatButton(
                onPressed: (){
                  checkResi();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                  decoration: BoxDecoration(
                      color: Constant().secondColor
                  ),
                  child: Row(
                    children: [
                      Icon(AntDesign.eyeo,color: Constant().secondDarkColor),
                      SizedBox(width:10.0),
                      WidgetHelper().textQ("Lacak Resi", 14, Constant().secondDarkColor, FontWeight.normal),
                    ],
                  ),
                ),
              ),
              if(detailHistoryPembelianModel.result.status!=4)
              FlatButton(
                onPressed: (){
                  print(detailHistoryPembelianModel.result.metodePembayaran.split("|"));
                  print(detailHistoryPembelianModel.result.resi);
                  if(detailHistoryPembelianModel.result.metodePembayaran.split("|")[0]=='COD'){
                    doneTrx();
                  }else if(detailHistoryPembelianModel.result.resi=='-'){
                    WidgetHelper().showFloatingFlushbar(context,"failed","maaf no resi belum tersedia");
                  }
                  else{
                    WidgetHelper().notifDialog(context,"Informasi","apakah barang anda sudah sampai",(){
                      Navigator.pop(context);
                    },(){
                      doneTrx();
                    },titleBtn1: 'Belum',titleBtn2: 'sudah');
                  }


                },
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                    decoration: BoxDecoration(
                        color: Constant().mainColor
                    ),
                    child: Row(
                      children: [
                        Icon(AntDesign.checkcircleo,color: Constant().secondDarkColor),
                        SizedBox(width:10.0),
                        WidgetHelper().textQ("Selesai", 14, Constant().secondDarkColor, FontWeight.normal),
                      ],
                    ),
                  ),
              )
            ],
          ),
        );
      }
      else{
        btnBottom=Container(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          color: Constant().moneyColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FlatButton(
                onPressed: (){
                  doneTrx();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                  decoration: BoxDecoration(
                      color: Constant().secondColor
                  ),
                  child: Row(
                    children: [
                      Icon(AntDesign.eyeo,color: Constant().secondDarkColor),
                      SizedBox(width:10.0),
                      WidgetHelper().textQ("Selesai", 14, Constant().secondDarkColor, FontWeight.normal),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }
    }

    return Scaffold(
      appBar: WidgetHelper().appBarWithButton(context,"Detail Pembelian",(){Navigator.pop(context);},<Widget>[
        isLoading?Text(''):(detailHistoryPembelianModel.result.metodePembayaran!='saldo') ?FlatButton(
            padding: EdgeInsets.all(0.0),
            highlightColor:Colors.black38,
            splashColor:Colors.black38,
            onPressed:()async{
              SharedPreferences pres=await SharedPreferences.getInstance();
              pres.setString("isDetailPembelian", "true");
              WidgetHelper().myPush(context, SuccessPembelianScreen(kdTrx: widget.kdTrx));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Icon(AntDesign.upload, color:Constant().mainColor, size: 28,),
            ),
        ):Text('')
      ]),
      body: RefreshWidget(
        widget: isLoading?DetailHistoryPembelianLoading():buildContent(context),
        callback: (){
          setState(() {
            isLoading=true;
          });
          loadData();
        },
      ),
      bottomNavigationBar:isLoading?Text(''):btnBottom,
    );
  }

  Widget buildContent(BuildContext context){

    return  SingleChildScrollView(
      primary: true,
      scrollDirection: Axis.vertical,
      child: Container(
        padding:EdgeInsets.only(top: 20.0, bottom: 0.0, left: 15.0, right: 15.0),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          WidgetHelper().textQ("Status",12.0,Constant().darkMode,FontWeight.normal),
                          WidgetHelper().myStatus(context,detailHistoryPembelianModel.result.status),
                        ],
                      ),
                      Divider(),
                      SizedBox(height: 0.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          WidgetHelper().textQ("Tanggal Pembelian",12.0,Constant().darkMode,FontWeight.normal),
                          WidgetHelper().textQ("${DateFormat.yMMMMEEEEd('id').format(detailHistoryPembelianModel.result.createdAt)} ${DateFormat.Hms().format(detailHistoryPembelianModel.result.createdAt)}",10.0,Constant().secondColor,FontWeight.normal),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          WidgetHelper().textQ("No.Invoice",12.0,Constant().darkMode,FontWeight.normal),
                          WidgetHelper().textQ("${detailHistoryPembelianModel.result.kdTrx}",10.0,Constant().secondColor,FontWeight.normal),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Divider(color: Colors.grey[200]),
                ),
                Container(
                  child: ListTile(
                    contentPadding: EdgeInsets.all(0.0),
                    leading: Icon(AntDesign.shoppingcart,color: Constant().mainColor),
                    title: WidgetHelper().textQ("Ringkasan Belanja",14.0,Constant().mainColor,FontWeight.bold),
                  ),
                ),
                Wrap(
                  spacing: 0,
                  runSpacing: 0,
                  children: [
                    buildItem(context),
                  ],
                ),

                Container(
                  child: ListTile(
                    contentPadding: EdgeInsets.all(0.0),
                    leading: Icon(AntDesign.form,color: Constant().mainColor),
                    title: WidgetHelper().textQ("Detail Pengiriman",14.0,Constant().mainColor,FontWeight.bold),
                  ),
                ),

                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          WidgetHelper().textQ("Nama Toko",12.0,Constant().darkMode,FontWeight.normal),
                          WidgetHelper().textQ("${Constant().siteName}",10.0,Constant().secondColor,FontWeight.normal),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          WidgetHelper().textQ("Layanan Pengiriman",12.0,Constant().darkMode,FontWeight.normal),
                          WidgetHelper().textQ("${detailHistoryPembelianModel.result.layananPengiriman}",10.0,Constant().secondColor,FontWeight.normal),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          WidgetHelper().textQ("No.Resi",12.0,Constant().darkMode,FontWeight.normal),
                          WidgetHelper().textQ("${detailHistoryPembelianModel.result.resi=="-"?"Belum ada No.Resi":detailHistoryPembelianModel.result.resi}",10.0,Constant().secondColor,FontWeight.normal),
                        ],
                      ),
                      detailHistoryPembelianModel.result.resi=="-"?Container():GestureDetector(
                        onTap: () {
                          Clipboard.setData(new ClipboardData(text: detailHistoryPembelianModel.result.resi));
                        },
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            WidgetHelper().textQ("",12.0,Constant().secondColor,FontWeight.bold),
                            WidgetHelper().textQ("Salin No.Resi",12.0,Constant().secondColor,FontWeight.bold),
                          ],
                        ),
                      ) ,

                      Divider(),
                      WidgetHelper().textQ(detailHistoryPembelianModel.result.mainAddress,10.0,Constant().darkMode,FontWeight.normal),
                    ],
                  ),
                ),

                Container(
                  child: ListTile(
                    contentPadding: EdgeInsets.all(0.0),
                    leading: Icon(AntDesign.infocirlceo,color: Constant().mainColor),
                    title: WidgetHelper().textQ("Informasi Pembayaran",14.0,Constant().mainColor,FontWeight.bold),
                  ),
                ),

                Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          WidgetHelper().textQ("Metode Pembayaran",12.0,Constant().darkMode,FontWeight.normal),
                          WidgetHelper().textQ(detailHistoryPembelianModel.result.metodePembayaran,10.0,Constant().secondColor,FontWeight.normal),
                        ],
                      ),
                      Divider(),
                      SizedBox(height: 0.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          WidgetHelper().textQ("Total Belanja",12.0,Constant().darkMode,FontWeight.normal),
                          WidgetHelper().textQ("Rp ${FunctionHelper().formatter.format(int.parse(detailHistoryPembelianModel.result.subtotal))} .-",12.0,Constant().moneyColor,FontWeight.bold),
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          WidgetHelper().textQ("Total Ongkos Kirim",12.0,Constant().darkMode,FontWeight.normal),
                          WidgetHelper().textQ("Rp ${FunctionHelper().formatter.format(int.parse(detailHistoryPembelianModel.result.ongkir))} .-",12.0,Constant().moneyColor,FontWeight.bold),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:EdgeInsets.only(top: 0.0, bottom: 10.0),
                  child: Divider(),
                ),
                Container(
                  padding:EdgeInsets.only(top: 0.0, bottom: 10.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          WidgetHelper().textQ("Total Pembayaran",12.0,Constant().darkMode,FontWeight.normal),
                          WidgetHelper().textQ("Rp ${FunctionHelper().formatter.format(int.parse(detailHistoryPembelianModel.result.grandTotal))} .-",12.0,Constant().moneyColor,FontWeight.bold),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );

  }

  Widget buildItem(BuildContext context){
    var width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.only(left: 0,right:0,top:0,bottom:0),
      width:  width / 1,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: detailHistoryPembelianModel.result.detail.length,
        itemBuilder: (context,key){
          var valDet=detailHistoryPembelianModel.result.detail;
          return Padding(
            padding: EdgeInsets.only(left:0,right:0,top:0),
            child: Container(
              color: key%2==0?Color(0xFFEEEEEE):Colors.white70,
              child: ListTile(
                contentPadding: EdgeInsets.all(0.0),
                leading: Image.network(valDet[key].foto,height:50,width: 50,fit: BoxFit.contain),
                title: WidgetHelper().textQ(valDet[key].paket,12,Colors.black87,FontWeight.normal),
                subtitle: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WidgetHelper().textQ("${valDet[key].qty} ITEM",10,Colors.grey,FontWeight.normal),
                      SizedBox(width: 20.0),
                      WidgetHelper().textQ("${FunctionHelper().formatter.format(int.parse('${valDet[key].price}'))}",10,Constant().moneyColor,FontWeight.normal),
                  ],
                ),
                trailing: IconButton(icon: Icon(Icons.arrow_drop_down), onPressed: (){
                  WidgetHelper().myModal(context, Container(
                    height: MediaQuery.of(context).size.height/1.2,
                    child: ModalPinPackage(detailHistoryPembelianModel: detailHistoryPembelianModel,idx: key,title: valDet[key].paket),
                  ));
                }),
              ),
            ),
          );
        },
      ),
      // color: Colors.white,
    );
  }



}


class ModalPinPackage extends StatefulWidget {
  DetailHistoryPembelianModel detailHistoryPembelianModel;
  int idx;
  String title;
  ModalPinPackage({this.detailHistoryPembelianModel,this.idx,this.title});
  @override
  _ModalPinPackageState createState() => _ModalPinPackageState();
}

class _ModalPinPackageState extends State<ModalPinPackage> {
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeDateFormatting('id');

  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height/1.2,
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
          SizedBox(height: 20.0),
          Padding(
            padding: EdgeInsets.all(10),
            child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Constant().mainColor,
                  // border: Border.all(color:SiteConfig().accentDarkColor)
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,color: Colors.white),
                    SizedBox(width: 5),
                    WidgetHelper().textQ("Daftar PIN ${widget.title}",12,Colors.white, FontWeight.bold)
                  ],
                )
            ),
          ),
          Expanded(
            child: Scrollbar(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: widget.detailHistoryPembelianModel.result.detail[widget.idx].listPin.length,
                  itemBuilder: (context,index){
                    var val=widget.detailHistoryPembelianModel.result.detail[widget.idx].listPin[index];
                    String status='';Color color;
                    if(val.status==0){status='tersedia';color=Constant().mainColor;}
                    if(val.status==1){status='dibeli';color=Constant().secondColor;}
                    if(val.status==2){status='digunakan';color=Constant().darkMode;}
                    if(val.status==3){status='pending';color=Constant().moneyColor;}
                    return ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(0.0),
                        width: 10.0,
                        height: 60.0,
                        color:Constant().secondColor,
                      ),
                      title: WidgetHelper().textQ(val.kode,12,Constant().darkMode,FontWeight.bold),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WidgetHelper().textQ("${val.type==0?"AKTIVASI":"REPEAT ORDER"}",10,Constant().darkMode,FontWeight.normal),
                          WidgetHelper().textQ("Expired : ${DateFormat.yMMMMEEEEd('id').format(val.expDate)}",10,Constant().darkMode,FontWeight.normal),

                        ],
                      ),
                      trailing: FlatButton(
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          color: color,
                          child: WidgetHelper().textQ(status,10,Constant().secondDarkColor, FontWeight.bold),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {return Divider(height: 1);},
                )
            ),
          )
        ],
      ),
    );
  }
}
