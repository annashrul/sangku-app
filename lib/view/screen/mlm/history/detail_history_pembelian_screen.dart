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
    if(detailHistoryPembelianModel.result.resi=='-'){
      WidgetHelper().showFloatingFlushbar(context,"failed","No.Resi belum tersedia");
    }
    else{
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
  Widget btn(BuildContext context,Function callback,title,Color color,{IconData icon}){
    return FlatButton(
      onPressed:callback,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
        decoration: BoxDecoration(
            color: color
        ),
        child: Row(
          children: [
            Icon(icon,color: Constant().secondDarkColor),
            SizedBox(width:10.0),
            WidgetHelper().textQ(title, 14, Constant().secondDarkColor, FontWeight.normal),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    print(widget.kdTrx);
    if(!isLoading){
      var val=detailHistoryPembelianModel.result;
      print(val.layananPengiriman);
      if(val.layananPengiriman.split("|")[0]=='COD'&&val.status!=4){
        btnBottom=Container(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          color: Constant().moneyColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              btn(context,(){doneTrx();},"Selesai",Constant().mainColor,icon: AntDesign.checkcircleo)
            ],
          ),
        );
      }

      if(val.layananPengiriman.split("|")[0]!='COD'&&val.status!=4){
        btnBottom=Container(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          color: Constant().moneyColor,
          child: FlatButton(
              onPressed: () {
              },
              padding: EdgeInsets.only(left:0),
              color: Constant().moneyColor,
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: ()=>checkResi(),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                      decoration: BoxDecoration(
                          color: Constant().secondColor
                      ),
                      child: Row(
                        children: [
                          Icon(AntDesign.checkcircleo,color: Constant().secondDarkColor),
                          SizedBox(width:10.0),
                          WidgetHelper().textQ("Lacak Resi", 14, Constant().secondDarkColor, FontWeight.normal),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: ()=>doneTrx(),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                      decoration: BoxDecoration(
                          color: Constant().secondColor
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
              )
            // child:Text("abus")
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
      body: buildContent(context),
      bottomNavigationBar:isLoading?Text(''):btnBottom,
    );
  }
  Widget buildContent(BuildContext context){
    return  isLoading?DetailHistoryPembelianLoading():Container(
      padding:EdgeInsets.only(top: 10.0, bottom: 0.0, left: 0.0, right: 0.0),
      child: RefreshWidget(
        widget: ListView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          primary: true,
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left:10,right:10),
              child: buildDetailPembelian(context),
            ),
            Container(
              child: Divider(color: Colors.grey[200]),
            ),
            Padding(
              padding: EdgeInsets.only(left:10,right:10),
              child: buildItem(context),
            ),
            Padding(
              padding: EdgeInsets.only(left:10,right:10),
              child: buildPengiriman(context),
            ),
            SizedBox(height:10),
            Padding(
              padding: EdgeInsets.only(left:10,right:10),
              child: buildInfoPembayaran(context),
            ),
          ],
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

  Widget buildDetailPembelian(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        buildDesc(context, 'Tanggal Pembelian',""),
        SizedBox(height:5.0),
        buildDesc(context, "${FunctionHelper().formateDate(detailHistoryPembelianModel.result.createdAt, '')} ","",titleFontWeight: FontWeight.bold),
        Divider(),
        buildDesc(context, 'Status','',widget: WidgetHelper().myStatus(context,detailHistoryPembelianModel.result.status)),
        Divider(),
        buildDesc(context, 'No.Invoice',detailHistoryPembelianModel.result.kdTrx),

      ],
    );
  }

  Widget buildItem(BuildContext context){
    return Column(
      children: [
        WidgetHelper().titleNoButton(context, AntDesign.shoppingcart, 'Ringkasan Belanja',color:  Constant().mainColor),
        ListView.builder(
          padding: EdgeInsets.all(0.0),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: detailHistoryPembelianModel.result.detail.length,
          itemBuilder: (context,key){
            var valDet=detailHistoryPembelianModel.result.detail;
            return ListTile(
              contentPadding: EdgeInsets.all(0.0),
              leading: WidgetHelper().baseImage(valDet[key].foto,height:50,width: 50,fit: BoxFit.contain),
              title: WidgetHelper().textQ(valDet[key].paket,12,Constant().darkMode,FontWeight.bold),
              subtitle: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WidgetHelper().textQ("${valDet[key].qty} Item",12,Constant().darkMode,FontWeight.normal),
                  SizedBox(width: 20.0),
                  WidgetHelper().textQ("${FunctionHelper().formatter.format(int.parse('${valDet[key].price}'))}",12,Constant().moneyColor,FontWeight.normal),
                ],
              ),
              trailing: IconButton(icon: Icon(Icons.arrow_drop_down), onPressed: (){
                WidgetHelper().myModal(context, Container(
                  height: MediaQuery.of(context).size.height/1.2,
                  child: ModalPinPackage(detailHistoryPembelianModel: detailHistoryPembelianModel,idx: key,title: valDet[key].paket),
                ));
              }),
            );
          },
        ),
      ],
    );
  }

  Widget buildPengiriman(BuildContext context){
    return Column(
      children: [
        WidgetHelper().titleNoButton(context, AntDesign.form, 'Detail Pengiriman',color:  Constant().mainColor),
        SizedBox(height:10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildDesc(context, 'Nama Toko', '${Constant().siteName}'),
            Divider(),
            buildDesc(context, 'Layanan Pengiriman',detailHistoryPembelianModel.result.layananPengiriman),
            Divider(),
            buildDesc(context, 'No.Resi',"${detailHistoryPembelianModel.result.layananPengiriman.split("|")[0]=='COD'?'-':detailHistoryPembelianModel.result.resi=="-"?"Belum ada No.Resi":detailHistoryPembelianModel.result.resi}"),
            detailHistoryPembelianModel.result.resi=="-"?Container():GestureDetector(
              onTap: () {
                Clipboard.setData(new ClipboardData(text: detailHistoryPembelianModel.result.resi));
                WidgetHelper().showFloatingFlushbar(context,"success","No.Resi berhasil disalin");
              },
              child:buildDesc(context, '',"Salin No.Resi",descColor: Constant().greenColor),
            ) ,
            Divider(),
            buildDesc(context,detailHistoryPembelianModel.result.mainAddress.toLowerCase(),'',titleFontWeight: FontWeight.bold),
            // WidgetHelper().textQ(detailHistoryPembelianModel.result.mainAddress.toLowerCase(),10.0,Constant().darkMode,FontWeight.normal),
          ],
        ),
      ],
    );
  }

  Widget buildInfoPembayaran(BuildContext context){
    return Column(
      children: [
        WidgetHelper().titleNoButton(context, AntDesign.infocirlceo, 'Informasi Pembayaran',color:  Constant().mainColor),
        SizedBox(height:10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildDesc(context, 'Metode Pembayaran',detailHistoryPembelianModel.result.metodePembayaran),
            Divider(),
            buildDesc(context, 'Total Belanja',"Rp ${FunctionHelper().formatter.format(int.parse(detailHistoryPembelianModel.result.subtotal))} .-",descColor: Constant().moneyColor),
            Divider(),
            buildDesc(context, 'Total Ongkos Kirim',"Rp ${FunctionHelper().formatter.format(int.parse(detailHistoryPembelianModel.result.ongkir))} .-",descColor: Constant().moneyColor),
            Divider(),
            buildDesc(context, 'Total Pembayaran',"Rp ${FunctionHelper().formatter.format(int.parse(detailHistoryPembelianModel.result.grandTotal))} .-",descColor: Constant().moneyColor),

          ],
        ),
      ],
    );
  }

  Widget buildDesc(BuildContext context,String title, String desc,{FontWeight titleFontWeight=FontWeight.normal,Color titleColor=Colors.black,Color descColor=Colors.black,Widget widget}){
    print(widget);
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: WidgetHelper().textQ(title,12.0,titleColor,titleFontWeight,maxLines: 3),
          ),
          widget==null?WidgetHelper().textQ(desc,12.0,descColor,FontWeight.bold):widget,
        ],
      ),
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
      // height: MediaQuery.of(context).size.height/1.2,
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
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  color: Constant().mainColor,
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,color: Colors.white,size: 20),
                    SizedBox(width: 5),
                    Expanded(child: WidgetHelper().textQ("Daftar PIN ${widget.title} ( ${ widget.detailHistoryPembelianModel.result.detail[widget.idx].listPin[0].type==0?'Aktivasi':'Repeat Order'} )",10,Colors.white, FontWeight.normal))
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
                    return  Container(
                      color: index%2==0?Color(0xFFEEEEEE):Colors.white,
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WidgetHelper().textQ(val.kode,10,Constant().darkMode,FontWeight.bold),
                            SizedBox(height:5),
                            WidgetHelper().textQ("Exp : ${DateFormat.yMMMMEEEEd('id').format(val.expDate)}",10,Constant().moneyColor,FontWeight.normal),
                          ],
                        ),
                        trailing: FlatButton(
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            color: color,
                            child: WidgetHelper().textQ(status,10,Constant().secondDarkColor, FontWeight.bold),
                          ),
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
