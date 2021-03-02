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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentScreen = HomeScreen(key: PageStorageKey('pageHome'),);
    // _pageController = PageController();


  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
    // _pageController.dispose();

  }


  // @override
  // Widget build(context) {
  //   super.build(context);
  //   return Scaffold(
  //     extendBody: true,
  //     body: PageView(
  //       onPageChanged: (int page){
  //         print(page);
  //       },
  //       controller: controller,
  //       children: [
  //         currentScreen
  //       ],
  //     ),
  //     bottomNavigationBar: FluidNavBar(
  //       icons: [
  //         FluidNavBarIcon(
  //             icon: AntDesign.gift,
  //             backgroundColor:Constant().mainColor,
  //             extras: {"label": "redeem"}),
  //         FluidNavBarIcon(
  //             icon: AntDesign.shoppingcart,
  //             backgroundColor:Constant().mainColor,
  //             extras: {"label": "produk"}),
  //         FluidNavBarIcon(
  //             icon:AntDesign.home,
  //             backgroundColor:Constant().mainColor,
  //             extras: {"label": "home"}),
  //         FluidNavBarIcon(
  //             icon: AntDesign.addusergroup,
  //             backgroundColor:Constant().mainColor,
  //             extras: {"label": "binary"}),
  //         FluidNavBarIcon(
  //             icon: AntDesign.user,
  //             backgroundColor:Constant().mainColor,
  //             extras: {"label": "profil"}),
  //       ],
  //       onChange: _handleNavigationChange,
  //       style: FluidNavBarStyle(
  //         barBackgroundColor: Constant().mainColor,
  //           iconSelectedForegroundColor:Colors.white,
  //           iconUnselectedForegroundColor: Colors.white
  //       ),
  //       scaleFactor: 1.0,
  //       defaultIndex: 2,
  //       itemBuilder: (icon, item) => Semantics(
  //         label: icon.extras["label"],
  //         child: item,
  //       ),
  //     ),
  //   );
  // }
  //
  // void _handleNavigationChange(int index) {
  //   switch (index) {
  //     case 0:
  //       currentScreen = RedeemPointScreen();
  //       break;
  //     case 1:
  //       currentScreen = ProductScreen();
  //       break;
  //     case 2:
  //       currentScreen = HomeScreen();
  //       break;
  //     case 3:
  //       currentScreen = BinaryScreen();
  //       break;
  //     case 4:
  //       currentScreen = ProfileScreen();
  //       break;
  //   }
  //   currentScreen = AnimatedSwitcher(
  //     switchInCurve: Curves.easeOut,
  //     switchOutCurve: Curves.easeIn,
  //     duration: Duration(milliseconds: 500),
  //     child: currentScreen,
  //   );
  //   if(this.mounted)setState(() {});
  // }
  @override
  Widget build(BuildContext context) {
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
            child:Icon(AntDesign.home,color: widget.currentTab == 2?Colors.white:Constant().secondColor,size: 30.0),
            onPressed: () {
              setState(() {
                currentScreen = HomeScreen(key: PageStorageKey('pageHome'));
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
                        minWidth: 40,
                        onPressed: () {
                          setState(() {
                            currentScreen = RedeemPointScreen(key: PageStorageKey('pageRedeemPoint')); // if user taps on this dashboard tab will be active
                            widget.currentTab = 0;
                          });
                        },

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(AntDesign.gift,color: widget.currentTab == 0?Constant().mainColor:Constant().secondColor,size: 30.0),
                          ],
                        ),
                      ),
                      MaterialButton(
                        highlightColor:Colors.black38,
                        splashColor:Colors.black38,
                        minWidth: 40,
                        onPressed: () {
                          setState(() {
                            currentScreen = ProductScreen(key: PageStorageKey('pageProduct')); // if user taps on this dashboard tab will be active
                            widget.currentTab = 1;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(AntDesign.shoppingcart,color: widget.currentTab == 1?Constant().mainColor:Constant().secondColor,size: 30.0),
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
                        minWidth: 40,
                        onPressed: () {
                          setState(() {
                            currentScreen = BinaryScreen(key: PageStorageKey('pageBinary')); // if user taps on this dashboard tab will be active
                            widget.currentTab = 3;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(AntDesign.addusergroup,color: widget.currentTab == 3?Constant().mainColor:Constant().secondColor,size: 30.0),
                          ],
                        ),
                      ),
                      MaterialButton(
                        highlightColor:Colors.black38,
                        splashColor:Colors.black38,
                        minWidth: 40,
                        onPressed: () {
                          setState(() {
                            currentScreen = ProfileScreen(key: PageStorageKey('pageProfile')); // if user taps on this dashboard tab will be active
                            widget.currentTab = 4;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(AntDesign.user,color: widget.currentTab == 4?Constant().mainColor:Constant().secondColor,size: 30.0),
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
  DataMemberModel dataMemberModel;
  Future loadMember()async{
    dataMemberModel = await MemberProvider().getDataMember();
  }

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
