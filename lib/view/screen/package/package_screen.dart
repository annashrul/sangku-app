part of '../pages.dart';


class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> with SingleTickerProviderStateMixin  {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          primary: true,
          key:_scaffoldKey,
          appBar: AppBar(
            elevation: 0,
            bottom: TabBar(
              indicatorPadding: EdgeInsets.all(0.0),
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.label,
                indicator: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color:Constant().mainColor,
                        width: 3.0,
                      ),
                    ),
                ),
                tabs: [
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: WidgetHelper().textQ("Aktivasi",14,Constant().mainColor,FontWeight.bold),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: WidgetHelper().textQ("Repeat Order ",14,Constant().mainColor,FontWeight.bold),
                    ),
                  ),
                ]
            ),
            title:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WidgetHelper().textQ("Hai, SangQu",16,Colors.black,FontWeight.bold,letterSpacing: 3.0),
                WidgetHelper().textQ("MB5711868825",12,Colors.black,FontWeight.normal,letterSpacing: 2.0),
              ],
            ),
            leading:Padding(
              padding: EdgeInsets.only(left:20.0,top:10.0,bottom:10.0),
              child:  WidgetHelper().myPress((){},CircleAvatar(
                backgroundImage:NetworkImage('https://img.pngio.com/avatar-icon-png-105-images-in-collection-page-3-avatarpng-512_512.png',scale: 1.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(AntDesign.cloudupload,size: 15,color: Colors.grey),
                ),
              )),
            ),
            actions: <Widget>[
              FlatButton(
                  padding: EdgeInsets.all(0.0),
                  highlightColor:Colors.black38,
                  splashColor:Colors.black38,
                  onPressed: (){
                  },
                  child: Container(
                    padding: EdgeInsets.only(right: 0.0,top:0),
                    child: Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: Icon(
                            AntDesign.shoppingcart,
                            color:Constant().mainColor,
                            size: 28,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.all(Radius.circular(10))),
                          constraints: BoxConstraints(minWidth: 10, maxWidth: 10, minHeight: 10, maxHeight: 10),
                        ),


                      ],
                    ),
                  )
              )
            ],
          ),
          body: Padding(
            padding: EdgeInsets.only(top:10,left:5,right:5),
            child: TabBarView(
                controller: _tabController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Scrollbar(
                    child: PackageWidget(tipe:'1'),
                  ),
                  Scrollbar(
                    child: PackageWidget(tipe:'ro'),
                  ),
                ]
            ),
          ),
        )
    );
  }

  // ignore: non_constant_identifier_names

}
