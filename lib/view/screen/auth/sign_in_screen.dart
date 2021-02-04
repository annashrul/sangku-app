import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/config/database_config.dart';
import 'package:sangkuy/helper/table_helper.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/auth/login_model.dart';
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
  ConfigModel configModel;
  var nohpController = TextEditingController();
  final FocusNode nohpFocus = FocusNode();
  DatabaseConfig _db = DatabaseConfig();
  Future loadConfig()async{
    // var res = await BaseProvider().getProvider("auth/config", configModelFromJson);
    // if(res==Constant().errSocket||res==Constant().errTimeout){
    //   isLoading=false;isError=true;
    //   setState(() {});
    // }
    // else{
    //   if(res is ConfigModel){
    //     ConfigModel result=res;
    //     if(result.status=='success'){
    //       configModel = ConfigModel.fromJson(result.toJson());
    //       isLoading=false;isError=false;
    //       print(result.result.type);
    //       setState(() {});
    //     }
    //     else{
    //       isLoading=false;isError=true;
    //       setState(() {});
    //     }
    //   }
    // }
  }
  
  Future login()async{
    // if(nohpController.text==''){
    //   WidgetHelper().notifBar(context,"failed","masukan no handphone anda");
    //   Future.delayed(Duration(seconds: 2));
    //   nohpFocus.requestFocus();
    // }
    // else{
    //   WidgetHelper().loadingDialog(context);
    //   final data={
    //     "uid":"",
    //     "pass":"",
    //     "type":"otp",
    //     "nohp":nohpController.text
    //   };
    //   var res = await BaseProvider().postProvider("auth", data);
    //   Navigator.pop(context);
    //   if(res==Constant().errSocket||res==Constant().errTimeout){
    //     WidgetHelper().notifBar(context,"failed","Terjadi kesalahan koneksi");
    //   }
    //   else{
    //     if(res is General){
    //       General result=res;
    //       WidgetHelper().notifBar(context,"failed",result.msg);
    //     }
    //     else{
    //       var result = LoginModel.fromJson(res);
    //       if(result.status=='success'){
    //         // WidgetHelper().notifBar(context,"success",result.msg);
    //         WidgetHelper().myPush(context, SecureCodeScreen(
    //           callback:(context,isTrue)async{
    //             final data={
    //               "id_user": "${result.result.id.toString()}",
    //               "token": "${result.result.token.toString()}",
    //               "full_name": "${result.result.fullName.toString()}",
    //               "mobile_no": "${result.result.mobileNo.toString()}",
    //               "membership": "${result.result.membership.toString()}",
    //               "referral_code": "${result.result.referralCode.toString()}",
    //               "device_id": "${result.result.deviceId.toString()}",
    //               "status": "${result.result.status.toString()}",
    //               "picture": "${result.result.picture.toString()}",
    //               "is_login":"1",
    //               "onboarding":"1",
    //               "exit_app":"0",
    //             };
    //             await _db.insert(UserTable.TABLE_NAME, data);
    //             // final getUser = await UserHelper().getDataUser("full_name");
    //             WidgetHelper().myPushRemove(context,IndexScreen(currentTab: 2));
    //           },
    //           code:result.result.otp,
    //           param: 'otp',
    //           desc: otpVal?'WhatsApp':'SMS',
    //           data: {
    //             "nomor":"${result.result.mobileNo}",
    //             "type":"${otpVal?'whatsapp':'sms'}",
    //             "nama":"${result.result.fullName}"
    //           },
    //         ));
    //       }
    //       else{
    //         WidgetHelper().notifBar(context,"failed",result.msg);
    //       }
    //     }
    //   }
    // }
    WidgetHelper().myPush(context, SecureCodeScreen(
      callback:(context,isTrue){
        WidgetHelper().myPushRemove(context,IndexScreen(currentTab: 2));
      },
      code:'1234',
      param: 'otp',
      desc: otpVal?'WhatsApp':'SMS',
      data: {
        "nomor":"009823",
        "type":"${otpVal?'WhatsApp':'SMS'}",
        "nama":"acuy"
      },
    ));
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
      backgroundColor: Constant().mainColor,
      key: _scaffoldKey,
      body: isLoading?WidgetHelper().loadingWidget(context):isError?ErrWidget(callback:(){}):Stack(
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
                        WidgetHelper().textQ("No Handphone", 12, Colors.grey[200], FontWeight.normal,letterSpacing: 2.0),
                        SizedBox(height: 10.0),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).focusColor.withOpacity(0.1),
                          ),
                          child: TextFormField(
                            style: TextStyle(letterSpacing:2.0,fontSize:14,fontWeight: FontWeight.normal,fontFamily: Constant().fontStyle,color: Colors.white),
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
                              hintStyle: TextStyle(color: Colors.black, fontSize:12,fontFamily: Constant().fontStyle),
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
                            WidgetHelper().textQ("Kirim otp via ${otpVal?'SMS':'WhatsApp'} ", 12, Colors.grey[200],FontWeight.normal,letterSpacing: 2.0),
                            SizedBox(
                                width: 90,
                                height: 10,
                                child: Switch(
                                  activeColor: Colors.grey[200],
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
                        WidgetHelper().loadingDialog(context);
                        login();
                      },
                      child: WidgetHelper().textQ("MASUK",14,Colors.grey[200],FontWeight.bold),
                      color: Colors.black38,
                      elevation: 0,
                      minWidth: 400,
                      height: 50,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                  ),
                  WidgetHelper().textQ("* Pastikan handphone anda terkoneksi dengan internet", 12, Colors.grey[200], FontWeight.normal)

                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
