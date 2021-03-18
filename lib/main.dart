import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/config/database_config.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/generated_route.dart';
import 'package:sangkuy/helper/get_it_setup.dart';
import 'package:sangkuy/helper/table_helper.dart';
import 'package:sangkuy/helper/user_helper.dart';
import 'package:sangkuy/model/dynamic_link_model.dart';
import 'package:sangkuy/view/screen/auth/sign_in_screen.dart';
import 'package:sangkuy/view/screen/pages.dart';
import 'package:showcaseview/showcase_widget.dart';
import 'helper/widget_helper.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setUpGetIt();


  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final DatabaseConfig _db = new DatabaseConfig();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String link='';



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
    // checkTokenExp();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarIconBrightness: Brightness.dark));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: DynamicLinkModel()),
        // ChangeNotifierProvider.value(value: WelcomeLinkModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          backgroundColor: Colors.white,
          primaryColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: Constant().fontStyle,
        ),
        navigatorKey: GeneratedRoute.navigatorKey,
        initialRoute: CheckingRoutes.routeName,
        onGenerateRoute: GeneratedRoute.onGenerate,
      ),
    );
  }
}



class CheckingRoutes extends StatefulWidget {
  static const String routeName = '/start';

  @override
  _CheckingRoutesState createState() => _CheckingRoutesState();
}

class _CheckingRoutesState extends State<CheckingRoutes> {
  final DatabaseConfig _db = new DatabaseConfig();
  final userHelper=UserHelper();
  // Future checkTokenExp()async{
  //   final token = await UserHelper().getDataUser('token');
  //   Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
  //   bool isTokenExpired = JwtDecoder.isExpired(token);
  //   print("####################### PAYLOAD TOKEN $isTokenExpired ########################################");
  //   if(isTokenExpired){
  //     WidgetHelper().notifOneBtnDialog(context,Constant().titleErrToken,Constant().descErrToken,()async{
  //       await FunctionHelper().logout(context);
  //     });
  //   }
  // }
  Future loadData() async{
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    final users = await _db.readData(UserTable.SELECT);
    print("###################USER LENGTH###########################");
    print(users);
    print("##############################################");
    if(users.length<1){
      WidgetHelper().myPushRemove(context, OnboardingScreen());
    }
    else{
      final onBoarding= await userHelper.getDataUser('onboarding');
      final isLogin= await userHelper.getDataUser('is_login');
      if(onBoarding==null&&isLogin==null||onBoarding=='0'&&isLogin=='0'){
        WidgetHelper().myPushRemove(context, OnboardingScreen());
      }
      else{
        if(onBoarding=='1'&&isLogin=='0'){
          WidgetHelper().myPushRemove(context, SignInScreen());
        }
        else if(onBoarding=='1'&&isLogin=='1'){
          final isToken=await FunctionHelper().checkTokenExp();
          if(isToken){
            WidgetHelper().notifOneBtnDialog(context,Constant().titleErrToken,Constant().descErrToken,()async{
              await FunctionHelper().logout(context);
            });
          }
          else{
            WidgetHelper().myPushRemove(context, IndexScreen(currentTab: 2));
          }
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
      // body:  ShowCaseWidget(
      //   onStart: (index, key) {
      //     print('onStart: $index, $key');
      //   },
      //   onComplete: (index, key) {
      //     print('onComplete: $index, $key');
      //   },
      //   builder: Builder(builder: (context) => MailPage()),
      //   autoPlay: true,
      //   autoPlayDelay: Duration(seconds: 3),
      //   autoPlayLockEnable: true,
      // ),
      body:  WidgetHelper().loadingWidget(context),
    );
  }



}

