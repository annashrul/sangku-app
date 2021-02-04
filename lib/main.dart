import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/config/database_config.dart';
import 'package:sangkuy/helper/table_helper.dart';
import 'package:sangkuy/helper/user_helper.dart';
import 'package:sangkuy/view/screen/auth/sign_in_screen.dart';
import 'package:sangkuy/view/screen/pages.dart';
import 'helper/widget_helper.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final DatabaseConfig _db = new DatabaseConfig();

  @override
  void initState() {
    // TODO: implement initState
    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
    var settings = {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.promptBeforeOpeningPushUrl: true
    };
    OneSignal.shared.init(Constant().oneSignalId, iOSSettings: settings);
    _db.openDB();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarIconBrightness: Brightness.light, statusBarColor: Colors.transparent));
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: Constant().fontStyle,
        primaryColor: Colors.white,
        brightness: Brightness.light,
      ),
      home:  CheckingRoutes(),
    );
  }
}

class CheckingRoutes extends StatefulWidget {
  @override
  _CheckingRoutesState createState() => _CheckingRoutesState();
}

class _CheckingRoutesState extends State<CheckingRoutes> {
  final DatabaseConfig _db = new DatabaseConfig();
  final userHelper=UserHelper();
  Future loadData() async{
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    final users = await _db.readData(UserTable.SELECT);
    if(users.length==0){
      WidgetHelper().myPushRemove(context, IndexScreen(currentTab: 2));

      // WidgetHelper().myPushRemove(context, OnboardingScreen());
    }
    else{
      final onBoarding= await userHelper.getDataUser('onboarding');
      final isLogin= await userHelper.getDataUser('is_login');
      if(onBoarding==null&&isLogin==null){
        WidgetHelper().myPushRemove(context, OnboardingScreen());
      }
      else{
        if(onBoarding=='0'&&isLogin=='0'){
          WidgetHelper().myPushRemove(context, OnboardingScreen());
        }
        else if(onBoarding=='1'&&isLogin=='0'){
          WidgetHelper().myPushRemove(context, SignInScreen());
        }
        else if(onBoarding=='1'&&isLogin=='1'){
          WidgetHelper().myPushRemove(context, IndexScreen(currentTab: 2));
        }
      }
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  WidgetHelper().loadingWidget(context),
    );
  }
}

