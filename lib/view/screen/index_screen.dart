part of 'pages.dart';



class IndexScreen extends StatefulWidget {
  int currentTab = 2;
  static const PREFERENCES_IS_FIRST_LAUNCH_STRING = "PREFERENCES_IS_FIRST_LAUNCH_STRING";

  IndexScreen({
    Key key,
    this.currentTab,
  }) : super(key: key);
  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> with TickerProviderStateMixin,AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Widget currentScreen;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final PageStorageBucket bucket = PageStorageBucket();
  int currentPage = 2;
  GlobalKey bottomNavigationKey = GlobalKey();
  PageController controller = PageController();
  int showIdx=0;
  Future checkRoute()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String show = preferences.getString("isShow");
    if(show=="true"){
      setState(() {
        showIdx=1;
      });
    }
    final isToken=await FunctionHelper().checkTokenExp();
    if(isToken){
      return WidgetHelper().notifOneBtnDialog(context,Constant().titleErrToken,Constant().descErrToken,()async{
        await FunctionHelper().logout(context);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkRoute();
    currentScreen = HomeScreen();
    if(widget.currentTab==0){
      currentScreen = RedeemPointScreen(); // if user taps on this dashboard tab will be active
    }
    else if(widget.currentTab==1){
      currentScreen = ProductScreen(); // if user taps on this dashboard tab will be active
    }
    else if(widget.currentTab==3){
      currentScreen = BinaryScreen(); // if user taps on this dashboard tab will be active
    }
    else if(widget.currentTab==4){
      currentScreen = ProfileScreen(); // if user taps on this dashboard tab will be active
    }
    // _pageController = PageController();


  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
    // _pageController.dispose();

  }

  int pageCase=0;
 
  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);
    super.build(context);
    return WillPopScope(
        child: Scaffold(
          key: scaffoldKey,
          body: PageStorage(
            child: ShowCaseWidget(
              onStart: (index, key) async{
                print('onStart: $index');
              },
              onComplete: (index, key)async{
                print('onComplete: $index');
              },
              onFinish: ()async{
                // SharedPreferences preferences=await SharedPreferences.getInstance();
                // preferences.setBool("first_launch", false);
              },
              builder: Builder(builder: (context) => currentScreen),
              autoPlay: true,
              autoPlayDelay: Duration(seconds: 3),
              autoPlayLockEnable: true,
            ),
            // child: currentScreen,
            bucket: bucket,
          ),

          // body:,
          floatingActionButton: FloatingActionButton(
            splashColor:Colors.black38,
            backgroundColor: widget.currentTab == 2 ? Constant().mainColor : Colors.white,
            child:Icon(AntDesign.home,color: widget.currentTab == 2?Colors.white:Constant().secondColor,size: scaler.getTextSize(15)),
            onPressed: () {
              setState(() {
                currentScreen = HomeScreen();
                widget.currentTab = 2;
              });
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 10,
            child: Container(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      MaterialButton(
                        highlightColor:Colors.black38,
                        splashColor:Colors.black38,
                        minWidth: scaler.getWidth(10),
                        onPressed: () {
                          setState(() {
                            currentScreen = RedeemPointScreen(); // if user taps on this dashboard tab will be active
                            widget.currentTab = 0;
                          });
                        },

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(AntDesign.gift,color: widget.currentTab == 0?Constant().mainColor:Constant().secondColor,size:scaler.getTextSize(15)),
                          ],
                        ),
                      ),
                      MaterialButton(
                        highlightColor:Colors.black38,
                        splashColor:Colors.black38,
                        minWidth: scaler.getWidth(10),

                        onPressed: () {
                          setState(() {
                            currentScreen = ProductScreen(); // if user taps on this dashboard tab will be active
                            widget.currentTab = 1;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(AntDesign.shoppingcart,color: widget.currentTab == 1?Constant().mainColor:Constant().secondColor,size:scaler.getTextSize(15)),
                          ],
                        ),
                      )
                    ],
                  ),
                  // Right Tab bar icons
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      MaterialButton(
                        highlightColor:Colors.black38,
                        splashColor:Colors.black38,
                        minWidth: scaler.getWidth(10),

                        onPressed: () {
                          setState(() {
                            currentScreen = BinaryScreen(); // if user taps on this dashboard tab will be active
                            widget.currentTab = 3;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(AntDesign.addusergroup,color: widget.currentTab == 3?Constant().mainColor:Constant().secondColor,size:scaler.getTextSize(15)),
                          ],
                        ),
                      ),
                      MaterialButton(
                        highlightColor:Colors.black38,
                        splashColor:Colors.black38,
                        minWidth: scaler.getWidth(10),

                        onPressed: () {
                          setState(() {
                            currentScreen = ProfileScreen(); // if user taps on this dashboard tab will be active
                            widget.currentTab = 4;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(AntDesign.user,color: widget.currentTab == 4?Constant().mainColor:Constant().secondColor,size:scaler.getTextSize(15)),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        onWillPop: _onWillPop
    );

  }
  Future<bool> _onWillPop() async {
    return (
      WidgetHelper().notifDialog(context,"Informasi !","Kamu yakin akan keluar dari aplikasi ?", (){Navigator.of(context).pop(false);},(){SystemNavigator.pop();})
    ) ?? false;
  }

}


class NavigationProvider with ChangeNotifier {
  // DataMemberModel dataMemberModel;
  // Future loadMember()async{
  //   dataMemberModel = await MemberProvider().getDataMember();
  // }

  String currentNavigation = "index";
  Widget get getNavigation {
    if (currentNavigation == "product") {
      return IndexScreen(currentTab: 1);
    } else if (currentNavigation == "redeem") {
      return IndexScreen(currentTab: 0);
    } else {
      return CheckingRoutes();
    }

  }

  void updateNavigation(String navigation) {
    currentNavigation = navigation;
    notifyListeners();
  }
}


class MailPage extends StatefulWidget {
  @override
  _MailPageState createState() => _MailPageState();
}

class _MailPageState extends State<MailPage> {
  GlobalKey _one = GlobalKey();
  GlobalKey _two = GlobalKey();
  GlobalKey _three = GlobalKey();
  GlobalKey _four = GlobalKey();
  GlobalKey _five = GlobalKey();

  @override
  Widget build(BuildContext context) {
    //Start showcase view after current widget frames are drawn.
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        ShowCaseWidget.of(context)
            .startShowCase([_one, _two, _three, _four, _five]));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 3,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Showcase(
                                  key: _one,
                                  description: 'Tap to see menu options',
                                  child: Icon(
                                    Icons.menu,
                                    color: Colors.black45,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Search email',
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Showcase(
                            key: _two,
                            title: 'Profile',
                            description: 'Tap to see profile',
                            showcaseBackgroundColor: Colors.blueAccent,
                            textColor: Colors.white,
                            shapeBorder: CircleBorder(),
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage('assets/simform.png'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 16, top: 4),
                  child: Text(
                    'PRIMARY',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 8)),
            GestureDetector(
                onTap: () {

                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Showcase(
                    key: _three,
                    description: 'Tap to check mail',
                    disposeOnTap: true,
                    onTargetClick: () {

                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 6, right: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Showcase.withWidget(
                                  key: _four,
                                  height: 50,
                                  width: 140,
                                  shapeBorder: CircleBorder(),
                                  container: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width: 45,
                                        height: 45,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.blue[200],
                                        ),
                                        child: Center(
                                          child: Text('S'),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Your sender\'s profile ',
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.all(10),
                                    child: Container(
                                      width: 45,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.blue[200],
                                      ),
                                      child: Center(
                                        child: Text('S'),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(left: 8)),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Slack',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    Text(
                                      'Flutter Notification',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      'Hi, you have new Notification',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                '1 Jun',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                Icons.star_border,
                                color: Colors.grey,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )),
            MailTile(
              Mail(
                sender: 'Medium',
                sub: 'Showcase View',
                msg: 'Check new showcase View',
                date: '25 May',
                isUnread: false,
              ),
            ),
            MailTile(
              Mail(
                sender: 'Quora',
                sub: 'New Question for you',
                msg: 'Hi, There is new question for you',
                date: '22 May',
                isUnread: false,
              ),
            ),
            MailTile(
              Mail(
                  sender: 'Google',
                  sub: 'Flutter 1.5',
                  msg: 'We have launched Flutter 1.5',
                  date: '20 May',
                  isUnread: true),
            ),
            MailTile(
              Mail(
                  sender: 'Simform',
                  sub: 'Credit card Plugin',
                  msg: 'Check out our credit card plugin',
                  date: '19 May',
                  isUnread: true),
            ),
            MailTile(
              Mail(
                sender: 'Flutter',
                sub: 'Flutter is Future',
                msg: 'Flutter laucnhed for Web',
                date: '18 Jun',
                isUnread: true,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Showcase(
        key: _five,
        title: 'Compose Mail',
        description: 'Click here to compose mail',
        shapeBorder: CircleBorder(),
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            setState(() {
              ShowCaseWidget.of(context)
                  .startShowCase([_one, _two, _three, _four, _five]);
            });
          },
          child: Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class Mail {
  String sender;
  String sub;
  String msg;
  String date;
  bool isUnread;

  Mail({
    this.sender,
    this.sub,
    this.msg,
    this.date,
    this.isUnread,
  });
}

class MailTile extends StatelessWidget {
  final Mail mail;

  MailTile(this.mail);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 6, right: 16, top: 8, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(10),
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue[200],
                  ),
                  child: Center(
                    child: Text(mail.sender[0]),
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 8)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      mail.sender,
                      style: TextStyle(
                        fontWeight:
                        mail.isUnread ? FontWeight.bold : FontWeight.normal,
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      mail.sub,
                      style: TextStyle(
                        fontWeight:
                        mail.isUnread ? FontWeight.bold : FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      mail.msg,
                      style: TextStyle(
                        fontWeight:
                        mail.isUnread ? FontWeight.bold : FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Text(
                mail.date,
                style: TextStyle(
                  fontWeight:
                  mail.isUnread ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              Icon(
                Icons.star_border,
                color: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
