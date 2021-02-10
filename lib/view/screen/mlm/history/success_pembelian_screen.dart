import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/general_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:sangkuy/view/screen/mlm/history/detail_history_pembelian_screen.dart';
import 'package:sangkuy/view/screen/pages.dart';
import 'package:sangkuy/view/widget/camera_widget.dart';

class SuccessPembelianScreen extends StatefulWidget {
  final String kdTrx;
  SuccessPembelianScreen({this.kdTrx});
  @override
  _SuccessPembelianScreenState createState() => _SuccessPembelianScreenState();
}

class _SuccessPembelianScreenState extends State<SuccessPembelianScreen> {
  String url = '',image='';
  int retry=0;
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



  @override
  Widget build(BuildContext context) {
    final key = new GlobalKey<ScaffoldState>();
    return WillPopScope(
      child: Scaffold(
        key: key,
        appBar: WidgetHelper().appBarWithButton(context,"Transaksi Berhasil", (){
          WidgetHelper().myPushRemove(context,IndexScreen(currentTab: 2));
        },<Widget>[]),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Container(
            alignment: AlignmentDirectional.center,
            padding: EdgeInsets.symmetric(horizontal: 30),
            height: MediaQuery.of(context).size.height/100.0*60,
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
                  height: 50,
                  child: WavyAnimatedTextKit(
                    textStyle: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Constant().mainColor,
                        fontFamily: Constant().fontStyle

                    ),
                    text: [
                      "Transaksi Berhasil",
                      "Pesanan Akan Segera Kami Proses",
                    ],
                    isRepeatingAnimation: true,
                  ),
                ),
                // WidgetHelper().textQ("Transaksi Berhasil !!!", 20,Constant().mainColor,FontWeight.bold,letterSpacing: 3.0),
                // SizedBox(height: 15),
                // WidgetHelper().textQ("Pesanan anda akan segera kami proses", 14,Constant().darkMode,FontWeight.bold,letterSpacing: 1.0),
                Divider(),
                WidgetHelper().textQ("Silahkan upload bukti transfer dibawah ini", 14,Constant().darkMode,FontWeight.bold,letterSpacing: 1.0),
                SizedBox(height: 25),
                WidgetHelper().textQ("TERIMAKASIH !!!", 20,Constant().mainColor,FontWeight.bold,letterSpacing: 3.0),
                SizedBox(height: 50),
                FlatButton(
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
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  color: Constant().moneyColor,
                  shape: StadiumBorder(),
                  child:WidgetHelper().textQ("UPLOAD BUKTI TRANSFER", 12,Constant().secondDarkColor,FontWeight.bold,letterSpacing: 3.0),
                ),

              ],
            ),
          ),
        ),
      ),
      onWillPop:() async{
        WidgetHelper().showFloatingFlushbar(context,"failed","gunakan tombol kembali yang ada pada aplikasi ini.");
        return false;
      },

    );
  }
}
