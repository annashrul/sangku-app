import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/general_model.dart';
import 'package:sangkuy/model/mlm/get_payment_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:sangkuy/view/screen/mlm/history/detail_history_pembelian_screen.dart';
import 'package:sangkuy/view/screen/pages.dart';
import 'package:sangkuy/view/widget/camera_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SuccessPembelianScreen extends StatefulWidget {
  final String kdTrx;
  SuccessPembelianScreen({this.kdTrx});
  @override
  _SuccessPembelianScreenState createState() => _SuccessPembelianScreenState();
}

class _SuccessPembelianScreenState extends State<SuccessPembelianScreen> {
  String url = '',image='';
  int retry=0;
  GetPaymentModel getPaymentModel;
  bool isLoading=false;
  Future uploadAgain()async{
    print('upload deui');
    await upload(image);
    setState(() {
      retry+=1;
    });
    print("RETRY $retry");
  }
  Future upload(img)async{
    WidgetHelper().loadingDialog(context);
    var res = await BaseProvider().putProvider("transaction/deposit/${widget.kdTrx}", {"bukti":img});
    print("REPSONSE $img");
    print("REPSONSE ${widget.kdTrx}");
    if(res == '${Constant().errTimeout}'|| res=='${Constant().errSocket}'){
      Navigator.pop(context);
      WidgetHelper().notifDialog(context,"Terjadi Kesalahan Server","Mohon maaf server kami sedang dalam masalah", (){},(){});
    }
    else{
      print(res);
      if(res is General){
        General result = res;
        print(result.status);
        Navigator.pop(context);
        if(retry>=3){
          WidgetHelper().notifDialog(context,"Terjadi Kesalahan Server","Silahkan Hubungi admin", (){
            WidgetHelper().myPushRemove(context, IndexScreen(currentTab: 2));
          },(){
            WidgetHelper().myPushRemove(context, IndexScreen(currentTab: 2));
          },titleBtn1: "kembali",titleBtn2: "home");
        }
        else{
          WidgetHelper().notifDialog(context,"Terjadi Kesalahan","${result.msg}", (){
            Navigator.pop(context);
          },(){
            Navigator.pop(context);
            uploadAgain();
          },titleBtn1: "kembali",titleBtn2: "Coba lagi");
        }

      }
      else{
        Navigator.pop(context);
        WidgetHelper().notifDialog(context,"Transaksi Berhasil","Terimakasih telah melakukan transaksi disini", (){
          WidgetHelper().myPushRemove(context, IndexScreen(currentTab: 2));
        },(){
          WidgetHelper().myPush(context, DetailHistoryPembelianScreen(kdTrx: widget.kdTrx));
        },titleBtn2: "home",titleBtn1: "detail pembelian");
      }
    }
  }
  Future loadPayment()async{
    var res=await BaseProvider().getProvider("transaction/get_payment/SU5WL1NMLzIxMDIxNy8wMDM=", getPaymentModelFromJson);
    if(res is GetPaymentModel){
      GetPaymentModel result=res;
      if(this.mounted){
        setState(() {
          getPaymentModel=result;
          isLoading=false;
        });
      }
    }
  }
  var hari  = DateFormat.d().format( DateTime.now().add(Duration(days: 3)));
  var bulan = DateFormat.M().format( DateTime.now());
  var tahun = DateFormat.y().format( DateTime.now());


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading=true;
    loadPayment();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.kdTrx);
    final key = new GlobalKey<ScaffoldState>();
    return WillPopScope(
      child: Scaffold(
        key: key,
        appBar: WidgetHelper().appBarWithButton(context,"Transaksi Berhasil", ()async{
          // WidgetHelper().myPushRemove(context,IndexScreen(currentTab: 2));
          SharedPreferences pres=await SharedPreferences.getInstance();
          if(pres.getString("isDetailPembelian")=='true'){
            Navigator.pop(context);
          }
          else{
            pres.remove('isDetailPembelian');
            WidgetHelper().myPushRemove(context,IndexScreen(currentTab: 2));
          }
        },<Widget>[]),
        body: isLoading?WidgetHelper().loadingWidget(context):SingleChildScrollView(
          padding: EdgeInsets.only(top:10,bottom:10),
          child: Container(
            alignment: AlignmentDirectional.center,
            padding: EdgeInsets.symmetric(horizontal: 0),
            // height: MediaQuery.of(context).size.height/100.0*60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [
                            Theme.of(context).accentColor,
                            Theme.of(context).accentColor.withOpacity(0.2),
                          ])),
                      child: Icon(
                        Icons.check,
                        color: Theme.of(context).primaryColor,
                        size: 70,
                      ),
                    ),
                    Positioned(
                      right: -30,
                      bottom: -50,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(150),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -20,
                      top: -50,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(150),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.only(left:10,right:10),
                  height: 50,
                  child: WavyAnimatedTextKit(
                    textStyle: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Constant().mainColor,
                        fontFamily: Constant().fontStyle
                    ),
                    text: [
                      "Transaksi Berhasil",
                      "Transaksi Anda Akan Segera Kami Proses",
                    ],
                    isRepeatingAnimation: true,
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 8.0),
                  child: WidgetHelper().textQ("Silahkan transfer tepat sebesar :", 12, Colors.black, FontWeight.bold),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 10.0),
                    child: Container(
                      child:WidgetHelper().textQ("Rp ${FunctionHelper().formatter.format(int.parse(getPaymentModel.result.grandTotal)+getPaymentModel.result.kdUnique)} .-", 18, Constant().moneyColor, FontWeight.bold),
                    )
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 10.0),
                  child: WidgetHelper().textQ("Pembayaran dapat dilakukan ke rekening berikut : ", 12, Colors.black, FontWeight.bold,textAlign: TextAlign.center),
                ),
                Container(
                  color: Constant().secondColor,
                  child: ListTile(
                    onTap: (){
                      Clipboard.setData(new ClipboardData(text:getPaymentModel.result.accNo));
                      WidgetHelper().showFloatingFlushbar(context,'success',"No. Rekening berhasil disalin");
                    },
                    leading: Image.network(getPaymentModel.result.logo,width: 70,height: 50,),
                    title: WidgetHelper().textQ(getPaymentModel.result.accName,12,Constant().secondDarkColor,FontWeight.bold),
                    subtitle:Row(
                      children: [
                        WidgetHelper().textQ(getPaymentModel.result.accNo,12,Colors.grey[200],FontWeight.normal),
                        SizedBox(width: 5),
                        Icon(AntDesign.copy1, color: Colors.grey[200], size: 15,),
                      ],
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 10.0),
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 10.0),
                        child:WidgetHelper().textQ('VERIFIKASI PENERIMAAN TRANSFER ANDA AKAN DIPROSES SELAMA 5-10 MENIT', 12,Constant().blueColor, FontWeight.bold, textAlign: TextAlign.center,maxLines: 4)
                    )
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 8.0),
                    child: Container(
                      color: const Color(0xffF4F7FA),
                      padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 8.0),
                      child: RichText(
                        text: TextSpan(
                            text: 'Anda dapat melakukan transfer menggunakan ATM, Mobile Banking atau SMS Banking dengan memasukan kode bank',
                            style: TextStyle(fontSize: 12,fontFamily:Constant().fontStyle,color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(text: ' ${getPaymentModel.result.bankName} ${getPaymentModel.result.tfCode}',style: TextStyle(color:Colors.green, fontSize: 12,fontWeight: FontWeight.bold,fontFamily:Constant().fontStyle)),
                              TextSpan(text: ' di depan No.Rekening atas nama',style: TextStyle(fontSize: 12,fontFamily:Constant().fontStyle)),
                              TextSpan(text: ' ${getPaymentModel.result.accName}',style: TextStyle(color:Colors.green, fontSize: 12,fontWeight: FontWeight.bold,fontFamily:Constant().fontStyle)),
                            ]
                        ),
                      ),
                    )
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 8.0),
                    child: Container(
                        color: const Color(0xffF4F7FA),
                        padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 8.0),
                        child:WidgetHelper().textQ('mohon transfer tepat hingga 3 digit terakhir agar tidak menghambat proses verifikasi', 12, Colors.black,FontWeight.normal,textAlign:TextAlign.left)
                    )
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 10.0),
                    child: Container(
                      color: const Color(0xffF4F7FA),
                      padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 10.0),
                      child: RichText(
                        text: TextSpan(
                            text: 'Pastikan anda transfer sebelum hari ',
                            style: TextStyle(fontSize: 12,fontFamily:Constant().fontStyle,color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(text: FunctionHelper().formateDate(getPaymentModel.result.limitTf,""),style: TextStyle(color:Colors.green, fontSize: 12,fontWeight: FontWeight.bold,fontFamily:Constant().fontStyle)),
                              TextSpan(text: ' atau transaksi anda otomatis dibatalkan oleh sistem. jika sudah melakukan transfer segera upload bukti transfer disini atau di halaman riwayat topup',style: TextStyle(fontSize: 12,fontFamily:Constant().fontStyle)),
                            ]
                        ),
                      ),
                    )
                ),
                SizedBox(height: 25),
                WidgetHelper().textQ("TERIMAKASIH !!!", 20,Constant().mainColor,FontWeight.bold,letterSpacing: 3.0),
              ],
            ),
          ),
        ),
        bottomNavigationBar: FlatButton(
          onPressed: () {
            WidgetHelper().myModal(context, CameraWidget(
              callback: (String img)async{
                setState(() {
                  image = img;
                });
                upload(image);
              },
            ));
          },
          padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
          color: Constant().moneyColor,
          child:WidgetHelper().textQ("UPLOAD BUKTI TRANSFER", 12,Constant().secondDarkColor,FontWeight.bold,letterSpacing: 3.0),
        ),
      ),
      onWillPop:() async{
        WidgetHelper().showFloatingFlushbar(context,"failed","gunakan tombol kembali yang ada pada aplikasi ini.");
        return false;
      },

    );
  }
}
