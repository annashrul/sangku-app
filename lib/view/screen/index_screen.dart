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
  DataMemberModel dataMemberModel;
  dynamic dataMember;
  bool isLoadingMember=false;
  Future rebuildData()async{
    final member = await MemberProvider().getDataMember();
    dataMemberModel=member;
    return dataMemberModel.result.toJson();
  }
  Future loadMember()async{
    final member = await MemberProvider().getDataMember();
    if(this.mounted)
      setState(() {
        dataMemberModel = member;
        isLoadingMember=false;
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentScreen = WidgetHelper().loadingWidget(context);
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      isLoadingMember=true;
      await loadMember();
      currentScreen = HomeScreen(dataMember:dataMemberModel.result.toJson());
      print("BUILD BERES");
    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        child: Scaffold(
          key: scaffoldKey,
          body: PageStorage(
            child: RefreshWidget(
              widget: currentScreen,
              callback: (){
                WidgetsBinding.instance.addPostFrameCallback((_)async{
                  isLoadingMember=true;
                  await loadMember();
                  if(widget.currentTab==2){
                    currentScreen = HomeScreen(dataMember:dataMemberModel.result.toJson());
                  }
                  if(widget.currentTab==4){
                    currentScreen = ProfileScreen(dataMember:dataMemberModel.result.toJson());
                  }
                  print("BUILD BERES");
                });
              },
            ),
            bucket: bucket,
          ),
          floatingActionButton: FloatingActionButton(
            splashColor:Colors.black38,
            backgroundColor: widget.currentTab == 2 ? Constant().mainColor : Colors.white,
            child:Icon(AntDesign.home,color: widget.currentTab == 2?Colors.white:Constant().secondColor,size: 30.0),
            onPressed: () {
              setState(() {
                currentScreen = HomeScreen(dataMember: dataMemberModel.result.toJson());
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
                            currentScreen = ProductScreen(dataMember:dataMemberModel.result.toJson()); // if user taps on this dashboard tab will be active
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
                            // currentScreen = TestimoniProduk(); // if user taps on this dashboard tab will be active
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
                            currentScreen = ProfileScreen(dataMember:dataMemberModel.result.toJson()); // if user taps on this dashboard tab will be active
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
