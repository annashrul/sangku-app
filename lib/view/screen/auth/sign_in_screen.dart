import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/config/database_config.dart';
import 'package:sangkuy/helper/generated_route.dart';
import 'package:sangkuy/helper/table_helper.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/auth/login_model.dart';
import 'package:sangkuy/model/auth/otp_model.dart';
import 'package:sangkuy/model/config_model.dart';
import 'package:sangkuy/model/general_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:sangkuy/provider/member_provider.dart';
import 'package:sangkuy/view/screen/auth/secure_code_screen.dart';
import 'package:sangkuy/view/screen/home_view.dart';
import 'package:sangkuy/view/screen/pages.dart';
import 'package:sangkuy/view/widget/error_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SignInScreen extends StatefulWidget {
  static const String routeName = '/signUp';
  final String referrarCode;
  SignInScreen({Key key, this.referrarCode}) : super(key: key);

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
  int retry=0;
  String pin='';
  Future loadConfig()async{
    var res = await BaseProvider().getProvider("auth/config", configModelFromJson,context: context,callback: (){
      Navigator.pop(context);
      isLoading=true;isError=true;
      retry+=1;
      setState(() {});
      if(retry>3){
        isLoading=false;isError=false;
        setState(() {});
        return WidgetHelper().showFloatingFlushbar(context,"failed","silakan hubungi admin kami");
      }else{
        loadConfig();
      }
    });
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

  Future sendOtp()async{
    if(retry>3){
      return WidgetHelper().showFloatingFlushbar(context,"failed","silakan hubungi admin kami");
    }
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
      var res = await BaseProvider().postProvider("auth/otp", data,context: context);
      Navigator.pop(context);
      if(res is General){
        General result=res;
        WidgetHelper().notifBar(context,"failed",result.msg);
      }
      else{
        var result = OtpModel.fromJson(res);
        if(result.status=='success'){
          if(configModel.result.type=='otp'){
            WidgetHelper().myPush(context, SecureCodeScreen(
              callback:(context,isTrue)async{
                login();
              },
              code:result.result.otpAnying,
              desc: !otpVal?'WhatsApp':'SMS',
              data: data,
            ));
          }
          else{
            WidgetHelper().myPush(context, PinScreen(callback: (context,isTrue,myPin){
              print(pin);
              setState(() {
                pin=myPin;
              });
              login();
            },param:''));
          }

        }
        else{
          WidgetHelper().notifBar(context,"failed",result.msg);
        }
      }
    }
  }
  Future login()async{
    WidgetHelper().loadingDialog(context);
    var status = await OneSignal.shared.getPermissionSubscriptionState();
    String onesignalUserId = status.subscriptionStatus.userId;

    final dataLogin={
      "type":configModel.result.type,
      "nohp":nohpController.text,
      "deviceid":onesignalUserId
    };
    if(configModel.result.type=='uid'){
      dataLogin['pin']=pin;
    }
    print(dataLogin);
    var baseAuth = await BaseProvider().postProvider("auth", dataLogin,context: context);
    Navigator.pop(context);
    if(baseAuth is General){
      General response = baseAuth;
      if(response.msg=='Akun tidak terdaftar.'){
        Navigator.pop(context);
      }

      WidgetHelper().notifBar(context,"failed",response.msg);
    }
    else{
      var loginModel = LoginModel.fromJson(baseAuth);
      if(loginModel.result.isRegister==0){
        WidgetHelper().myPushRemove(context, PinScreen(callback: (context,isTrue,myPin){
          String isPin=myPin;
          WidgetHelper().myPushRemove(context, PinScreen(callback: (context,isTrue,myPin)async{
            if(myPin==isPin){
              WidgetHelper().loadingDialog(context);
              await insertDb(loginModel);
              await MemberProvider().updateMember({'pin':myPin}, context);
              Navigator.pop(context);
              WidgetHelper().myPushRemove(context,IndexScreen(currentTab: 2));
              print('sama');
            }else{
              WidgetHelper().showFloatingFlushbar(context,"failed","pin yang masukan tidak sama");
              print('beda');
            }
          },param:'confirm'));
        },param:'create'));
      }
      else{
        await insertDb(loginModel);
        WidgetHelper().myPushRemove(context,IndexScreen(currentTab: 2));
      }
    }
  }


  Future insertDb(LoginModel loginModel)async{
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
    if(users.length>0){
      await _db.deleteAll(UserTable.TABLE_NAME);
      await _db.insert(UserTable.TABLE_NAME, dataUserToLocal);
    }
    else{
      await _db.insert(UserTable.TABLE_NAME, dataUserToLocal);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    loadConfig();
    isLoading=true;
    super.initState();
  }
  final TextEditingController referralCodeController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    // Firebase.initializeApp()
    // FirebaseApp
    referralCodeController.text = widget.referrarCode ?? '';
    ScreenScaler scaler = ScreenScaler()..init(context);

    return Scaffold(
      // backgroundColor: Constant().mainColor,
      key: _scaffoldKey,
      appBar: WidgetHelper().appBarNoButton(context,"Form Login",<Widget>[]),
      body: isLoading?WidgetHelper().loadingWidget(context):isError?ErrWidget(callback:(){}):Container(
        height: scaler.getHeight(100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: scaler.getHeight(25),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('${Constant().localAssets}bg_auth.png'),
                      fit: BoxFit.contain,
                  )
              ),
            ),
            SizedBox(height: scaler.getHeight(1)),
            Expanded(
              child: ListView(
                padding:scaler.getPadding(0,2),
                children: <Widget>[
                  Container(
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WidgetHelper().textQ("No Handphone", scaler.getTextSize(9),Constant().darkMode, FontWeight.bold,letterSpacing: 2.0),
                        SizedBox(height: scaler.getHeight(1)),
                        Container(
                          width: double.infinity,
                          padding: scaler.getPadding(0,2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).focusColor.withOpacity(0.1),
                          ),
                          child: TextFormField(
                            style: TextStyle(letterSpacing:2.0,fontSize:scaler.getTextSize(10),fontWeight: FontWeight.bold,fontFamily: Constant().fontStyle,color: Constant().darkMode),
                            controller: nohpController,
                            maxLines: 1,
                            autofocus: false,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
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
                        if(configModel.result.type=='otp')SizedBox(height: scaler.getHeight(1)),
                        if(configModel.result.type=='otp')WidgetHelper().myPress((){
                          setState(() {
                            otpVal=!otpVal;
                          });
                        },Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WidgetHelper().textQ("Kirim otp via ${otpVal?'SMS':'WhatsApp'} ", scaler.getTextSize(9), Constant().darkMode,FontWeight.bold,letterSpacing: 2.0),
                            SizedBox(
                                width: scaler.getWidth(20),
                                height: scaler.getHeight(1),
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
                  SizedBox(height: scaler.getHeight(1)),
                  Container(
                    child: MaterialButton(
                      onPressed: (){
                        sendOtp();
                        // WidgetHelper().myPush(context,HomeView());
                        // GeneratedRoute.navigateTo(HomeView.routeName);
                      },
                      child: WidgetHelper().textQ("Masuk",scaler.getTextSize(10),Colors.grey[200],FontWeight.bold),
                      color: Constant().mainColor,
                      elevation: 0,
                      // minWidth: 400,
                      height: scaler.getHeight(4),
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                  ),
                  SizedBox(height: scaler.getHeight(1)),
                  WidgetHelper().textQ("* Pastikan handphone anda terkoneksi dengan internet", scaler.getTextSize(10),Constant().moneyColor, FontWeight.bold)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
