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

class _IndexScreenState extends State<IndexScreen> {
  Widget currentScreen;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final PageStorageBucket bucket = PageStorageBucket();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentScreen = HomeScreen();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }
  final List<Widget> screens = [
    HomeScreen(),
    ProductScreen(),
    // ProdukMlmUI(),
    // About(),
    // TestimoniProduk(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          // backgroundColor: Colors.white,
          key: scaffoldKey,
          // appBar:widget.currentTab == 1?null:AppBarNoButton(),
          body: PageStorage(
            child: currentScreen,
            bucket: bucket,
          ),
          floatingActionButton: FloatingActionButton(
            splashColor:Colors.black38,
            backgroundColor: widget.currentTab == 2 ? Constant().mainColor : Colors.white,
            child:widget.currentTab == 2 ? SvgPicture.asset(
              Constant().localIcon+"Icon_Utama_Home_Warna.svg",
              height: 30,
              width: 30,
              color:Colors.white
            ) : SvgPicture.asset(
              Constant().localIcon+"Icon_Utama_Home_Abu.svg",
              height: 30,
              width: 30,
              color:Constant().mainColor
            ),
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
                        minWidth: 40,
                        onPressed: () {
                          setState(() {
                            // currentScreen = ScreenHome(); // if user taps on this dashboard tab will be active
                            widget.currentTab = 0;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            widget.currentTab == 0 ? SvgPicture.asset(
                              Constant().localIcon+"Icon_Utama_Home_Warna.svg",
                              height: 30,
                              width: 30,
                            ) : SvgPicture.asset(
                              Constant().localIcon+"Icon_Utama_Home_Abu.svg",
                              height: 30,
                              width: 30,
                            )
                          ],
                        ),
                      ),
                      MaterialButton(
                        highlightColor:Colors.black38,
                        splashColor:Colors.black38,
                        minWidth: 40,
                        onPressed: () {
                          setState(() {
                            currentScreen = ProductScreen(); // if user taps on this dashboard tab will be active
                            widget.currentTab = 1;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            widget.currentTab == 1 ? SvgPicture.asset(
                              Constant().localIcon+"Icon_Utama_Produk_Warna.svg",
                              height: 30,
                              width: 30,
                            ) : SvgPicture.asset(
                              Constant().localIcon+"Icon_Utama_Produk_abu.svg",
                              height: 30,
                              width: 30,
                            )
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
                            // currentScreen = TestimoniProduk(); // if user taps on this dashboard tab will be active
                            widget.currentTab = 3;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            widget.currentTab == 3 ? SvgPicture.asset(
                              Constant().localIcon+"Icon_Utama_Testimoni_Warna.svg",
                              height: 30,
                              width: 30,
                            ) : SvgPicture.asset(
                              Constant().localIcon+"Icon_Utama_Testimoni_Abu.svg",
                              height: 30,
                              width: 30,
                            )
                          ],
                        ),
                      ),
                      MaterialButton(
                        highlightColor:Colors.black38,
                        splashColor:Colors.black38,
                        minWidth: 40,
                        onPressed: () {
                          setState(() {
                            currentScreen = ProfileScreen(); // if user taps on this dashboard tab will be active
                            widget.currentTab = 4;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            widget.currentTab == 4 ? SvgPicture.asset(
                              Constant().localIcon+"Icon_Utama_Profile_Warna.svg",
                              height: 30,
                              width: 30,
                            ) : SvgPicture.asset(
                              Constant().localIcon+"Icon_Utama_Profile_abu.svg",
                              height: 30,
                              width: 30,
                            )
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
