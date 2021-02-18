import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/config/database_config.dart';
import 'package:sangkuy/helper/table_helper.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/auth/login_model.dart';
import 'package:sangkuy/model/auth/otp_model.dart';
import 'package:sangkuy/model/config_model.dart';
import 'package:sangkuy/model/general_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:sangkuy/view/screen/auth/secure_code_screen.dart';
import 'package:sangkuy/view/screen/pages.dart';
import 'package:sangkuy/view/widget/error_widget.dart';


class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool otpVal=false,isLoading=false,isError=false;
  var nohpController = TextEditingController();
  final FocusNode nohpFocus = FocusNode();
  DatabaseConfig _db = DatabaseConfig();
  ConfigModel configModel;
  Future loadConfig()async{
    var res = await BaseProvider().getProvider("auth/config", configModelFromJson);
    if(res==Constant().errSocket||res==Constant().errTimeout){
      isLoading=false;isError=true;
      setState(() {});
    }
    else{
      if(res is ConfigModel){
        ConfigModel result=res;
        if(result.status=='success'){
          configModel = ConfigModel.fromJson(result.toJson());
          isLoading=false;isError=false;
          print(result.result.type);
          setState(() {});
        }
        else{
          isLoading=false;isError=true;
          setState(() {});
        }
      }
    }
  }
  Future sendOtp()async{
    if(nohpController.text==''){
      WidgetHelper().notifBar(context,"failed","masukan no handphone anda");
      Future.delayed(Duration(seconds: 2));
      nohpFocus.requestFocus();
    }
    else{
      WidgetHelper().loadingDialog(context);
      final data={
        "nomor":nohpController.text,
        "type":otpVal?"whatsapp":"sms",
      };
      var res = await BaseProvider().postProvider("auth/otp", data);
      Navigator.pop(context);
      if(res==Constant().errSocket||res==Constant().errTimeout){
        WidgetHelper().notifBar(context,"failed","Terjadi kesalahan koneksi");
      }
      else{
        if(res is General){
          General result=res;
          WidgetHelper().notifBar(context,"failed",result.msg);
        }
        else{
          var result = OtpModel.fromJson(res);
          if(result.status=='success'){
            WidgetHelper().myPush(context, SecureCodeScreen(
              callback:(context,isTrue)async{
                login();
              },
              code:result.result.otpAnying,
              param: 'otp',
              desc: !otpVal?'WhatsApp':'SMS',
              data: data,

            ));
          }
          else{
            WidgetHelper().notifBar(context,"failed",result.msg);
          }
        }
      }
    }

  }
  Future login()async{
    WidgetHelper().loadingDialog(context);
    var status = await OneSignal.shared.getPermissionSubscriptionState();
    String onesignalUserId = status.subscriptionStatus.userId;

    final dataLogin={
      "uid":"",
      "type":"otp",
      "nohp":nohpController.text,
      "pass":"",
      "deviceid":onesignalUserId
    };
    var baseAuth = await BaseProvider().postProvider("auth", dataLogin);
    if(baseAuth==Constant().errSocket||baseAuth==Constant().errTimeout){
      Navigator.pop(context);
      WidgetHelper().notifBar(context,"failed","Terjadi kesalahan koneksi");
    }
    else{
      if(baseAuth is General){
        General response = baseAuth;
        Navigator.pop(context);
        WidgetHelper().notifBar(context,"failed",response.msg);
      }
      else{
        var loginModel = LoginModel.fromJson(baseAuth);
        final dataUserToLocal={
          "id_user": "${loginModel.result.id.toString()}",
          "token": "${loginModel.result.token.toString()}",
          "full_name": "${loginModel.result.fullName.toString()}",
          "mobile_no": "${loginModel.result.mobileNo.toString()}",
          "membership": "${loginModel.result.membership.toString()}",
          "referral_code": "${loginModel.result.referralCode.toString()}",
          "device_id": "${loginModel.result.deviceId.toString()}",
          "status": "${loginModel.result.status.toString()}",
          "picture": "${loginModel.result.picture.toString()}",
          "is_login":"1",
          "onboarding":"1",
          "exit_app":"0",
        };
        final users = await _db.readData(UserTable.SELECT);
        if(users.length>1){
          await _db.deleteAll(UserTable.TABLE_NAME);
          await _db.insert(UserTable.TABLE_NAME, dataUserToLocal);
        }else{
          await _db.insert(UserTable.TABLE_NAME, dataUserToLocal);
        }
        Navigator.pop(context);
        WidgetHelper().myPushRemove(context,IndexScreen(currentTab: 2));
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    loadConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Constant().mainColor,
      key: _scaffoldKey,
      appBar: WidgetHelper().appBarNoButton(context,"Form Login",<Widget>[]),
      body: isLoading?WidgetHelper().loadingWidget(context):isError?ErrWidget(callback:(){}):Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('${Constant().localAssets}bg_auth.png'),
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter
                )
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 300),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              // color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.all(23),
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WidgetHelper().textQ("No Handphone", 12,Constant().darkMode, FontWeight.bold,letterSpacing: 2.0),
                        SizedBox(height: 10.0),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).focusColor.withOpacity(0.1),
                          ),
                          child: TextFormField(
                            style: TextStyle(letterSpacing:2.0,fontSize:16,fontWeight: FontWeight.bold,fontFamily: Constant().fontStyle,color: Constant().darkMode),
                            controller: nohpController,
                            maxLines: 1,
                            autofocus: false,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.1)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              // hintStyle: TextStyle(color: Colors.black, fontSize:12,fontFamily: Constant().fontStyle),
                            ),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            focusNode: nohpFocus,
                            onFieldSubmitted: (term){
                              // UserRepository().fieldFocusChange(context, nameFocus, nohpFocus);
                            },
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                        SizedBox(height: 15.0),
                        WidgetHelper().myPress((){setState(() {
                          otpVal=!otpVal;
                        });},Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WidgetHelper().textQ("Kirim otp via ${otpVal?'SMS':'WhatsApp'} ", 12, Constant().darkMode,FontWeight.bold,letterSpacing: 2.0),
                            SizedBox(
                                width: 90,
                                height: 10,
                                child: Switch(
                                  activeColor: Constant().mainColor,
                                  value: otpVal,
                                  onChanged: (value) {
                                    setState(() {
                                      otpVal = value;
                                    });
                                  },
                                )
                            ),
                            // SizedBox(height:typeOtp==false?5.0:0.0),
                          ],
                        ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20,bottom: 10),
                    child: MaterialButton(
                      onPressed: (){
                        // WidgetHelper().loadingDialog(context);
                        sendOtp();
                      },
                      child: WidgetHelper().textQ("MASUK",14,Colors.grey[200],FontWeight.bold),
                      color: Constant().mainColor,
                      elevation: 0,
                      minWidth: 400,
                      height: 50,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                  ),
                  WidgetHelper().textQ("* Pastikan handphone anda terkoneksi dengan internet", 12,Constant().moneyColor, FontWeight.bold)

                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
