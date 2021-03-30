import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:intl/intl.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/general_model.dart';
import 'package:sangkuy/model/mlm/get_payment_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:sangkuy/view/screen/mlm/history/detail_history_pembelian_screen.dart';
import 'package:sangkuy/view/screen/pages.dart';
import 'package:sangkuy/view/screen/wallet/form_ewallet_screen.dart';
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
    await upload(image);
    setState(() {
      retry+=1;
    });
  }
  Future upload(img)async{
    WidgetHelper().loadingDialog(context);
    var res = await BaseProvider().putProvider("transaction/deposit/${widget.kdTrx}", {"bukti":img},context: context);
    if(res!=null){
      Navigator.pop(context);
      WidgetHelper().notifOneBtnDialog(context,Constant().titleMsgSuccessTrx,Constant().descMsgSuccessTrx,(){
        WidgetHelper().myPushRemove(context, IndexScreen(currentTab: 2));
      });
    }

  }
  Future loadPayment()async{
    print("bus");
    var res=await BaseProvider().getProvider("transaction/get_payment/${widget.kdTrx}", getPaymentModelFromJson,context: context,callback: (){
      Navigator.pop(context);
    });
    print(res);
    if(res is GetPaymentModel){
      GetPaymentModel result=res;
      if(this.mounted){
        setState(() {
          getPaymentModel=result;
          isLoading=false;
        });
      }
    }
    else{
      print("else ${getPaymentModel}");
      isLoading=false;
      setState(() {});
    }
  }
  Future cancelTransaksi()async{
    WidgetHelper().loadingDialog(context);
    var res = await BaseProvider().postProvider("transaction/deposit/${widget.kdTrx}", {"status":"2"},context: context,callback: (){
      Navigator.pop(context);
    });
    if(res!=null){
      Navigator.pop(context);
      WidgetHelper().notifDialog(context,"Transaksi Berhasil","Pengajuan transaksi anda berhasil dibatalkan", (){
        WidgetHelper().myPushRemove(context, IndexScreen(currentTab: 2));
      },(){
        WidgetHelper().myPush(context, FormEwalletScreen(title: 'TOP UP'));
      },titleBtn2: "Top Up",titleBtn1: "Home");
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
    ScreenScaler scaler = ScreenScaler()..init(context);
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
        },<Widget>[
          if(!isLoading&&getPaymentModel!=null)
            if(getPaymentModel.result.paymentSlip=='-')
              WidgetHelper().myFilter((){
                WidgetHelper().myModal(context, CameraWidget(
                  callback: (String img,pureImage)async{
                    setState(() {
                      image = img;
                    });
                    await Future.delayed(Duration(seconds: 1));
                    WidgetHelper().notifDialog(context, "Informasi","Gambar berhasil diambil",(){Navigator.pop(context);},(){
                      upload(image);
                    });
                    // upload(image);
                  },
                ));
              },icon: AntDesign.upload, iconColor:Constant().mainColor)
        ]),
        body: isLoading||getPaymentModel==null?WidgetHelper().loadingWidget(context):Scrollbar(child: SingleChildScrollView(
          padding:scaler.getPadding(1, 2),
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
                      width: scaler.getWidth(50),
                      height: scaler.getHeight(10),
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
                SizedBox(height: scaler.getHeight(1)),
                Container(
                  padding:scaler.getPadding(0,0),
                  height: scaler.getHeight(5),
                  child: WavyAnimatedTextKit(
                    textStyle: TextStyle(
                        fontSize:scaler.getTextSize(10),
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
                  padding:scaler.getPadding(1,0),
                  child: WidgetHelper().textQ("Silahkan transfer tepat sebesar :", scaler.getTextSize(10), Colors.black, FontWeight.bold),
                ),
                Padding(
                    padding:scaler.getPadding(0,0),
                    child: Container(
                      child:WidgetHelper().textQ("Rp ${FunctionHelper().formatter.format(int.parse(getPaymentModel.result.grandTotal)+getPaymentModel.result.kdUnique)} .-", scaler.getTextSize(12), Constant().moneyColor, FontWeight.bold),
                    )
                ),
                Padding(
                  padding:scaler.getPadding(1,0),
                  child: WidgetHelper().textQ("Pembayaran dapat dilakukan ke rekening berikut : ", scaler.getTextSize(10), Colors.black, FontWeight.bold,textAlign: TextAlign.center),
                ),
                Container(
                  color: Constant().secondColor,
                  child: ListTile(
                    onTap: (){
                      Clipboard.setData(new ClipboardData(text:getPaymentModel.result.accNo));
                      WidgetHelper().showFloatingFlushbar(context,'success',"No. Rekening berhasil disalin");
                    },
                    leading: WidgetHelper().baseImage(getPaymentModel.result.logo,width: 70,height: 50),
                    // leading: Image.network(getPaymentModel.result.logo,width: 70,height: 50,),
                    title: WidgetHelper().textQ(getPaymentModel.result.accName,scaler.getTextSize(10),Constant().secondDarkColor,FontWeight.bold),
                    subtitle:Row(
                      children: [
                        WidgetHelper().textQ(getPaymentModel.result.accNo,scaler.getTextSize(10),Colors.grey[200],FontWeight.normal),
                        SizedBox(width: 5),
                        Icon(AntDesign.copy1, color: Colors.grey[200], size: 15,),
                      ],
                    ),
                  ),
                ),
                Padding(
                    padding:scaler.getPadding(1,0),
                    child: Container(
                      // padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 10.0),
                        child:WidgetHelper().textQ('VERIFIKASI PENERIMAAN TRANSFER ANDA AKAN DIPROSES SELAMA 5-10 MENIT', scaler.getTextSize(10),Constant().blueColor, FontWeight.bold, textAlign: TextAlign.center,maxLines: 4)
                    )
                ),
                Padding(
                    padding:scaler.getPadding(0,0),
                    child: Container(
                      color: const Color(0xffF4F7FA),
                      padding:scaler.getPadding(1,2),
                      child: RichText(
                        text: TextSpan(
                            text: 'Anda dapat melakukan transfer menggunakan ATM, Mobile Banking atau SMS Banking dengan memasukan kode bank',
                            style: TextStyle(fontSize:  scaler.getTextSize(10),fontFamily:Constant().fontStyle,color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(text: ' ${getPaymentModel.result.bankName} ${getPaymentModel.result.tfCode}',style: TextStyle(color:Colors.green, fontSize:  scaler.getTextSize(10),fontWeight: FontWeight.bold,fontFamily:Constant().fontStyle)),
                              TextSpan(text: ' di depan No.Rekening atas nama',style: TextStyle(fontSize:  scaler.getTextSize(10),fontFamily:Constant().fontStyle)),
                              TextSpan(text: ' ${getPaymentModel.result.accName}',style: TextStyle(color:Colors.green, fontSize:  scaler.getTextSize(10),fontWeight: FontWeight.bold,fontFamily:Constant().fontStyle)),
                            ]
                        ),
                      ),
                    )
                ),
                Padding(
                    padding:scaler.getPadding(1,0),
                    child: Container(
                        color: const Color(0xffF4F7FA),
                        padding:scaler.getPadding(1,2),
                        child:WidgetHelper().textQ('mohon transfer tepat hingga 3 digit terakhir agar tidak menghambat proses verifikasi', scaler.getTextSize(10), Colors.black,FontWeight.normal,textAlign:TextAlign.left)
                    )
                ),
                Padding(
                    padding:scaler.getPadding(0,0),
                    child: Container(
                      color: const Color(0xffF4F7FA),
                      padding:scaler.getPadding(1,2),
                      child: RichText(
                        text: TextSpan(
                            text: 'Pastikan anda transfer sebelum hari ',
                            style: TextStyle(fontSize: scaler.getTextSize(10),fontFamily:Constant().fontStyle,color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(text: FunctionHelper().formateDate(getPaymentModel.result.limitTf,""),style: TextStyle(color:Colors.green, fontSize: scaler.getTextSize(10),fontWeight: FontWeight.bold,fontFamily:Constant().fontStyle)),
                              TextSpan(text: ' atau transaksi anda otomatis dibatalkan oleh sistem. jika sudah melakukan transfer segera upload bukti transfer disini',style: TextStyle(fontSize: scaler.getTextSize(10),fontFamily:Constant().fontStyle)),
                            ]
                        ),
                      ),
                    )
                ),
                SizedBox(height: scaler.getHeight(2)),
                WidgetHelper().textQ("TERIMAKASIH !!!", scaler.getTextSize(12),Constant().mainColor,FontWeight.bold,letterSpacing: 3.0),
              ],
            ),
          ),
        )),
        bottomNavigationBar: FlatButton(
          onPressed: () {
            WidgetHelper().notifDialog(context,"Informasi !","Anda yakin akan membatalkan transaksi ?",(){
              Navigator.pop(context);
            },(){
              cancelTransaksi();
            });
          },
          padding:scaler.getPadding(1.5,0),
          color: Constant().moneyColor,
          child:WidgetHelper().textQ("Batalkan", scaler.getTextSize(10),Constant().secondDarkColor,FontWeight.bold,letterSpacing: 3.0),
        ),
        // bottomNavigationBar: Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Container(
        //       width: MediaQuery.of(context).size.width/3,
        //       child: FlatButton(
        //         onPressed: () {
        //           WidgetHelper().myModal(context, CameraWidget(
        //             callback: (String img)async{
        //               setState(() {
        //                 image = img;
        //               });
        //               upload(image);
        //             },
        //           ));
        //         },
        //         padding: EdgeInsets.symmetric(vertical: 20,horizontal: 0),
        //         color: Constant().moneyColor,
        //         child:WidgetHelper().textQ("upload bukti transfer", 12,Constant().secondDarkColor,FontWeight.bold,letterSpacing: 1.0),
        //       ),
        //     ),
        //     SizedBox(width: 2.0),
        //     Container(
        //       width: MediaQuery.of(context).size.width/3,
        //       child: FlatButton(
        //         onPressed: () {
        //           WidgetHelper().myModal(context, CameraWidget(
        //             callback: (String img)async{
        //               setState(() {
        //                 image = img;
        //               });
        //               upload(image);
        //             },
        //           ));
        //         },
        //         padding: EdgeInsets.symmetric(vertical: 20,horizontal: 0),
        //         color: Constant().moneyColor,
        //         child:WidgetHelper().textQ("Batalkan", 12,Constant().secondDarkColor,FontWeight.bold,letterSpacing: 1.0),
        //       ),
        //     ),
        //   ],
        // ),
      ),
      onWillPop:() async{
        WidgetHelper().showFloatingFlushbar(context,"failed","gunakan tombol kembali yang ada pada aplikasi ini.");
        return false;
      },

    );
  }
}
