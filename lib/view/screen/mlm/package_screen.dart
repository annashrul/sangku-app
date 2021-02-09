part of '../pages.dart';


class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> with SingleTickerProviderStateMixin  {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  TabController _tabController;
  bool isLoading=false,isError=false,isErrToken;
  int total=0;
  Future loadCart()async{
    var res=await CartProvider().getCart();
    if(res=='error'){
      isLoading=false;
      isError=true;
      setState(() {});
    }
    else if(res=='failed'){
      isLoading=false;
      isError=true;
      setState(() {});
    }
    else if(res==Constant().errExpToken){
      isLoading=false;
      isError=false;
      isErrToken=true;
      WidgetHelper().notifOneBtnDialog(context,"Terjadi Kesalahan","Sesi anda sudah habis, silahkan login ulang.",()async{
        await FunctionHelper().logout(context);
      },titleBtn1: "Login");
      setState(() {});
    }
    else{
      CartModel cartModel=res;
      setState(() {
        isLoading=false;
        isError=false;
        total = cartModel.result.length;
      });
    }
  }
  Future postCart(id,qty,tipe)async{
    WidgetHelper().loadingDialog(context);
    var res = await CartProvider().postCart(id,qty.toString(),tipe);
    Navigator.pop(context);
    if(res=='error'){
      WidgetHelper().notifBar(context,"failed",Constant().msgConnection);
    }
    else if(res=='success'){
      WidgetHelper().notifBar(context,"success",'berhasil dimasukan kedalam keranjang');
      await loadCart();
    }
    else{
      WidgetHelper().notifBar(context,"failed",res);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCart();
    _tabController = TabController(length: 2, initialIndex: _tabIndex, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }
  int _tabIndex=0;
  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      print(_tabController.indexIsChanging);
      setState(() {
        _tabIndex = _tabController.index;
      });
    }
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  String lbl='';
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> row = {
      'Aktivasi':'Aktivasi',
      'Repeat Order':'Repeat Order',
    };
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          primary: true,
          key:_scaffoldKey,
          appBar: WidgetHelper().appBarWithTab(context,_tabController, 'SangQu',row,_tabIndex==0?"Aktivasi":"Repeat Order",(idx){
            setState(() {lbl = idx;});
          },leading:Padding(
            padding: EdgeInsets.all(8.0),
            child:  CircleAvatar(
              // radius:20.0,
              backgroundImage:NetworkImage('https://img.pngio.com/avatar-icon-png-105-images-in-collection-page-3-avatarpng-512_512.png',scale: 1.0),
            ),
          ),description:'MB5711868825',widget: [
            WidgetHelper().myCart(context, (){if(total>0){WidgetHelper().myPushAndLoad(context,CartScreen(),()=>loadCart());}}, total>0?Colors.redAccent:Colors.transparent)
          ]),
          body: Padding(
            padding: EdgeInsets.only(top:0,left:5,right:5),
            child: TabBarView(
                controller: _tabController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Scrollbar(
                    child: PackageWidget(tipe:'1',callback: (id,qty,tipe){
                      postCart(id, qty,tipe);
                    }),
                  ),
                  Scrollbar(
                    child: PackageWidget(tipe:'ro',callback: (id,qty,tipe){
                      postCart(id, qty,tipe);
                    },),
                  ),
                ]
            ),
          ),
        )
    );
  }
   Widget app(BuildContext context){
      return AppBarNoButton(
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
      ),widget: [
        FlatButton(
            padding: EdgeInsets.all(0.0),
            highlightColor:Colors.black38,
            splashColor:Colors.black38,
            onPressed: (){
              if(total>0){
                WidgetHelper().myPushAndLoad(context,CartScreen(),()=>loadCart());
              }
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
                    decoration: BoxDecoration(color: total>0?Colors.redAccent:Colors.transparent, borderRadius: BorderRadius.all(Radius.circular(10))),
                    constraints: BoxConstraints(minWidth: 10, maxWidth: 10, minHeight: 10, maxHeight: 10),
                  ),


                ],
              ),
            )
        )
      ],);
   }

  // ignore: non_constant_identifier_names

}
