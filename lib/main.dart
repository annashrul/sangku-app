import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/config/database_config.dart';
import 'package:sangkuy/helper/table_helper.dart';
import 'package:sangkuy/helper/user_helper.dart';
import 'package:sangkuy/view/screen/auth/sign_in_screen.dart';
import 'package:sangkuy/view/screen/pages.dart';
import 'package:sangkuy/view/widget/detail_scaffold.dart';
import 'package:sangkuy/view/widget/header_widget.dart';
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarIconBrightness: Brightness.dark, statusBarColor: Colors.black12));
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: Colors.white,
        // accentColor: Colors.redAccent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: Constant().fontStyle,
        // primaryColor: Colors.white,
        // brightness: Brightness.dark,
      ),
      // home:  ExHome(),
      home:  CheckingRoutes(),
    );
  }
}


class ExHome extends StatefulWidget {
  @override
  _ExHomeState createState() => _ExHomeState();
}

class _ExHomeState extends State<ExHome> {
  List data=[
    'https://ecs7.tokopedia.net/img/cache/100-square/attachment/2020/8/28/47197032/47197032_914c9752-19e1-42b0-8181-91ef0629fd8a.png',
    'https://ecs7.tokopedia.net/img/cache/100-square/attachment/2019/10/22/21181130/21181130_907dac9a-c185-43d1-b459-2389f0b6efea.png',
    'https://ecs7.tokopedia.net/img/cache/100-square/attachment/2019/10/22/21181130/21181130_53682a49-5247-4374-82c0-4c2a8d3bdbea.png',
    'https://ecs7.tokopedia.net/img/cache/100-square/attachment/2019/12/13/51829405/51829405_77281743-12fd-402b-b212-67b52516229c.png',
    'https://ecs7.tokopedia.net/img/cache/100-square/attachment/2019/11/15/21181130/21181130_5ee75889-94bc-45d3-9ce6-5ecf466fb385.png',
    'https://ecs7.tokopedia.net/img/cache/100-square/attachment/2019/10/22/21181130/21181130_5e0e4f34-0e41-48c4-baa0-dbf8a5e151d2.png',
    'https://ecs7.tokopedia.net/img/cache/100-square/attachment/2019/11/15/21181130/21181130_a40bc9db-8fd8-426f-985f-9930fe83711a.png',
    'https://ecs7.tokopedia.net/img/cache/100-square/attachment/2020/1/23/47197032/47197032_0de76bd3-0481-4ee2-8c52-9700cbbc3ae7.png',
    'https://ecs7.tokopedia.net/img/cache/100-square/attachment/2020/3/27/41313334/41313334_ed6fac94-00eb-4a37-bd4e-6ecab312e6f2.png',
    'https://ecs7.tokopedia.net/img/cache/100-square/attachment/2019/11/15/21181130/21181130_0653d8df-0bb4-4714-9267-b987298c0420.png'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: RefreshIndicator(
            onRefresh: () {},
            child: DetailScaffold(
                hasPinnedAppBar: true,
                expandedHeight:90,
                slivers: <Widget>[
                  SliverAppBar(
                    floating: false,
                    pinned: true,
                    expandedHeight: 90.0,
                    flexibleSpace: HeaderWidget(),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      switch (index) {
                        case 0:
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: <Widget>[
                                CircleImage(
                                  key: Key("profile"),
                                  image: Constant().localAssets+"bg_auth.png",
                                  size: 50.0,
                                  padding: 0.0,
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Jung Kook",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      "Rp 15,000",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "Usage limit Rp 0",
                                      style: TextStyle(color: Colors.black26, fontSize: 11),
                                    ),
                                  ],
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Container(),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    color: Colors.black12,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.description,
                                            size: 16,
                                            color: Colors.black54,
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            "Silver",
                                            style: TextStyle(color: Colors.black87, fontSize: 10),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        case 1:
                          return Container(
                            height: 76,
                            color: Colors.white,
                            child: ListView.separated(
                                padding: EdgeInsets.only(left: 8, right: 8),
                                separatorBuilder: (context, index) => const SizedBox(
                                  width: 4,
                                ),
                                scrollDirection: Axis.horizontal,
                                itemCount: 10,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: Container(
                                      width: 150,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "KUOTA",
                                              style: TextStyle(fontSize: 12, color: Colors.black54),
                                            ),
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            Text(
                                              "10 MB",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            Text(
                                              "12 april",
                                              style: TextStyle(color: Colors.black45, fontSize: 11),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          );
                        case 2:
                          return  Container(

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Stack(
                                  children: [
                                    Container(
                                      child: StaggeredGridView.countBuilder(
                                        shrinkWrap: true,
                                        primary: false,
                                        crossAxisCount: 5,
                                        itemCount:  data.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return WidgetHelper().myPress(
                                                  (){},
                                              Container(
                                                padding: EdgeInsets.all(10.0),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 0),
                                                        child:CachedNetworkImage(
                                                          imageUrl:data[index],
                                                          width: double.infinity ,
                                                          fit:BoxFit.scaleDown,
                                                          placeholder: (context, url) => Image.network(Constant().noImage, fit:BoxFit.fill,width: double.infinity,),
                                                          errorWidget: (context, url, error) => Image.network(Constant().noImage, fit:BoxFit.fill,width: double.infinity,),
                                                        )
                                                    ),
                                                    SizedBox(height:5.0),
                                                    WidgetHelper().textQ("Pulsa",10,Constant().darkMode, FontWeight.bold,textAlign: TextAlign.center),
                                                  ],
                                                ),
                                              ),
                                              color: Colors.black38
                                          );
                                        },
                                        staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
                                        mainAxisSpacing: 0.0,
                                        crossAxisSpacing: 20.0,
                                      ),
                                    ),
                                    ClipPath(
                                        clipper: ArcClipper(),
                                        child: Container(
                                          height:50.0,
                                          color:Colors.grey[200],
                                        )
                                    )
                                  ],
                                  alignment: Alignment.topCenter,
                                ),
                                WidgetHelper().myPress((){},ListTile(
                                  contentPadding: EdgeInsets.only(left:10.0,right:10.0),
                                  leading: Icon(AntDesign.profile,size: 40.0,color:Constant().mainColor),
                                  title: WidgetHelper().textQ("Berita Terbaru",12,Colors.black,FontWeight.bold),
                                  subtitle:WidgetHelper().textQ("kumpulan berita terbaru seputar SanQu",10,Colors.grey[400],FontWeight.normal),
                                  trailing: Icon(AntDesign.doubleright,size:15.0),
                                ))

                              ],
                            ),
                          );
                        case 3:
                          return Container();
                        case 4:
                          return Container();
                        case 5:
                          return Container();
                        case 6:
                          return Container();
                        case 7:
                          return Container();
                        case 8:
                          return Container();
                        case 9:
                          return Container();
                        default:
                          return Container();
                      }

                    }, childCount: 10),
                  ),
                ]
            ),
          ),
        ),
      ),
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
      WidgetHelper().myPushRemove(context, OnboardingScreen());
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

