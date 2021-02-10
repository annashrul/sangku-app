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
  String img='',name='',referralCode='';
  bool isLoadingMember=false;
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
      if(this.mounted){
        setState(() {
          isLoading=false;
          isError=false;
          total = cartModel.result.length;
        });
      }
    }
  }
  Future handleSubmit(id,qty,tipe)async{
    var res = await CartProvider().postCart(id,qty.toString(),tipe);
    Navigator.pop(context);
    print(res);
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
  Future postCart(id,qty,tipe)async{
    final package=await FunctionHelper().isPackage();
    if(package!=tipe&&package!=null){
      WidgetHelper().notifDialog(context,"Informasi !","ada paket ${tipe=='1'?'Aktivasi':'Repeat Order'}. Anda yakin akan melanjutkan transaksi ??", (){
        Navigator.pop(context);
      }, ()async{
        Navigator.pop(context);
        WidgetHelper().loadingDialog(context);
        handleSubmit(id,qty,tipe);
      });
    }else{
      WidgetHelper().loadingDialog(context);
      handleSubmit(id,qty,tipe);
    }

  }
  Future loadDataMember()async{
    final picture = await UserHelper().getDataUser('picture');
    final fullName = await UserHelper().getDataUser('full_name');
    final referral = await UserHelper().getDataUser('referral_code');
    setState(() {
      img=picture;
      name=fullName;
      referralCode=referral;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoadingMember=true;
    loadDataMember();
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
          appBar: WidgetHelper().appBarWithTab(context,_tabController, name,row,_tabIndex==0?"Aktivasi":"Repeat Order",(idx){
            setState(() {lbl = idx;});
          },leading:Padding(
            padding: EdgeInsets.all(8.0),
            child:  CircleImage(
              param: 'network',
              key: Key("packageScreen"),
              image: img,
              size: 50.0,
              padding: 0.0,
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

  // ignore: non_constant_identifier_names

}
