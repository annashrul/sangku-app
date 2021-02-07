import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/secure_code_helper.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/auth/otp_model.dart';
import 'package:sangkuy/model/general_model.dart';
import 'package:sangkuy/provider/base_provider.dart';


class SecureCodeScreen extends StatefulWidget {
  final Function(BuildContext context, bool isTrue) callback;
  String code;
  final String param;
  final String desc;
  final Map<String, Object> data;
  // final Widget child;

  SecureCodeScreen({this.callback,this.code,this.param,this.desc,this.data});
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
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      bottomNavigationBar:!timeUpFlag?FlatButton(
          color: Constant().mainDarkColor,
          onPressed: ()async{
            WidgetHelper().showFloatingFlushbar(context,"failed","proses pengiriman otp sedang berlangsung");
          },
          child: WidgetHelper().textQ("$timeCounter detik", 12,Colors.white,FontWeight.bold)
      ):FlatButton(

          color: Constant().mainColor,
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
          child: WidgetHelper().textQ("${!timeUpFlag ?'$timeCounter detik':'kirim ulang otp'}", 12,Colors.white,FontWeight.bold)
      ),
      body: widget.param=='otp'?SecureCodeHelper(
          showFingerPass: false,
          forgotPin: 'Lupa OTP ? Klik Disini',
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
      ):SecureCodeHelper(
          showFingerPass: true,
          forgotPin: 'Lupa PIN ? Klik Disini',
          title: "Keamanan",
          passLength: 4,
          bgImage: "assets/images/bg.jpg",
          borderColor: Colors.black,
          showWrongPassDialog: true,
          wrongPassContent: "Pin Tidak Sesuai",
          wrongPassTitle: "Opps!",
          wrongPassCancelButtonText: "Batal",
          deskripsi: 'Masukan PIN Anda Untuk Melanjutkan Ke Halaman Berikutnya',
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
      ),

    );
  }
}
