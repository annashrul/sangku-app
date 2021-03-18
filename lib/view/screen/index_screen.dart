part of 'pages.dart';



class IndexScreen extends StatefulWidget {
  int currentTab = 2;
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

  Future checkRoute()async{
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


 
  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);
    super.build(context);
    return WillPopScope(
        child: Scaffold(
          key: scaffoldKey,
          body: PageStorage(
            // child: _getPage(currentPage),
            child: currentScreen,
            bucket: bucket,
          ),

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
