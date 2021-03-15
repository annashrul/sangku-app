import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/secure_code_helper.dart';
import 'package:sangkuy/helper/user_helper.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/auth/otp_model.dart';
import 'package:sangkuy/model/general_model.dart';
import 'package:sangkuy/provider/base_provider.dart';


class SecureCodeScreen extends StatefulWidget {
  final Function(BuildContext context, bool isTrue) callback;
  String code;
  final String desc;
  final Map<String, Object> data;
  // final Widget child;

  SecureCodeScreen({this.callback,this.code,this.desc,this.data});
  @override
  _SecureCodeScreenState createState() => _SecureCodeScreenState();
}

class _SecureCodeScreenState extends State<SecureCodeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var cek;
  Future cekOtp() async{
    setState(() {
      cek = widget.code.split('');
    });
    print("############## OTP ABI = $cek #######################");
  }
  int timeCounter = 0;
  bool timeUpFlag = false;
  Timer timer;
  _timerUpdate() {
    timer = Timer(const Duration(seconds: 1), () async {
      setState(() {
        timeCounter--;
      });
      if (timeCounter != 0)
        _timerUpdate();
      else
        timeUpFlag = true;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }

  @override
  void initState() {
    super.initState();
    timeCounter = 10;
    _timerUpdate();
  }
  bool isLoadingReOtp=false;
  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      bottomNavigationBar:!timeUpFlag?Container(
        color: Constant().moneyColor,
        child: FlatButton(
            padding: scaler.getPadding(1.5,0),
            onPressed: ()async{
              WidgetHelper().showFloatingFlushbar(context,"failed","proses pengiriman otp sedang berlangsung");
            },
            child: WidgetHelper().textQ("$timeCounter DETIDetikK", scaler.getTextSize(10),Colors.white,FontWeight.bold,letterSpacing: 3.0)
        ),
      ):Container(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        color: Constant().mainColor,
        child: FlatButton(
            padding: EdgeInsets.all(20.0),
            onPressed: ()async{
              print(widget.data);
              WidgetHelper().loadingDialog(context);
              var res = await BaseProvider().postProvider("auth/otp", widget.data);
              if(res==Constant().errSocket||res==Constant().errTimeout){
                Navigator.pop(context);
                setState(() {
                  timeUpFlag=true;
                });
                WidgetHelper().showFloatingFlushbar(context,"failed",Constant().msgConnection);
              }
              else{
                if(res is General){
                  setState(() {
                    timeUpFlag=true;
                  });
                  Navigator.pop(context);
                  General result=res;
                  WidgetHelper().notifBar(context,"failed",result.msg);
                }
                else{
                  var result = OtpModel.fromJson(res);
                  if(result.status=='success'){
                    Navigator.pop(context);
                    if(timeUpFlag){
                      setState(() {
                        timeUpFlag=!timeUpFlag;
                        timeCounter=10;
                        widget.code = result.result.otpAnying;
                      });
                      _timerUpdate();
                    }
                    else{
                      print('false');
                    }
                  }
                  else{
                    setState(() {
                      timeUpFlag=true;
                    });
                    Navigator.pop(context);
                    WidgetHelper().notifBar(context,"failed",result.msg);
                  }
                }
              }
            },
            child: WidgetHelper().textQ("${!timeUpFlag ?'$timeCounter DETIK':'KIRIM ULANG OTP'}", 14,Colors.white,FontWeight.bold, letterSpacing: 3.0)
        ),
      ),
      body: SecureCodeHelper(
          showFingerPass: false,
          forgotPin: '',
          title: "Keamanan",
          passLength: 4,
          bgImage: "assets/images/bg.jpg",
          borderColor:  Constant().mainColor,
          showWrongPassDialog: true,
          wrongPassContent: "OTP Tidak Sesuai",
          wrongPassTitle: "Opps!",
          wrongPassCancelButtonText: "Batal",
          deskripsi: 'Masukan Kode OTP Yang Kami Kirim Melalui Pesan ${widget.desc} Untuk Melanjutkan Ke Halaman Berikutnya ${Constant().showCode?widget.code:''}',
          passCodeVerify: (passcode) async {
            print(passcode);
            print(widget.code.split(''));
            var code = widget.code.split('');
            for (int i = 0; i < code.length; i++) {
              if (passcode[i] != int.parse(code[i])) {
                return false;
              }
            }
            return true;
          },
          onSuccess: () async{
            widget.callback(context,true);
          }
      )

    );
  }
}


class PinScreen extends StatefulWidget {
  Function(BuildContext context, bool isTrue,String pin) callback;
  String param;
  PinScreen({this.callback,this.param});
  @override
  _PinScreenState createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  String pin='';
  
  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);
    String desc='';
    if(widget.param=='create'){
      desc='Silahkan ubah pin demi keamanan bertransaksi anda';
    }else if(widget.param=='confirm'){
      desc='KONFIRMASI PIN';
    }
    else{
      desc='Masukan PIN Anda demi keamanan bertransaksi';
    }
    return Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        bottomNavigationBar:widget.param==null||widget.param==''?FlatButton(
            padding: scaler.getPadding(1.5,0),
            color: Constant().moneyColor,
            onPressed: ()async{
              
            },
            child: WidgetHelper().textQ("Lupa Pin", scaler.getTextSize(10),Colors.white,FontWeight.bold)
        ):Text(''),
        body: SecureCodeHelper(
            showFingerPass: false,
            title: "Keamanan",
            passLength: 6,
            bgImage: "assets/images/bg.jpg",
            borderColor:  Constant().mainColor,
            showWrongPassDialog: true,
            wrongPassContent: "PIN Tidak Sesuai",
            wrongPassTitle: "Opps!",
            wrongPassCancelButtonText: "Batal",
            deskripsi:desc,
            passCodeVerify: (passcode) async {
              print(passcode);
              String code='';
              for (int i = 0; i < 6; i++) {
                code+= passcode[i].toString();
              }
              setState(() {
                pin=code;
              });
              return true;
            },
            onSuccess: () async{
              widget.callback(context,true,pin);
            }
        )

    );
  }

}
