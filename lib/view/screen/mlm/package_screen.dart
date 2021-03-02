part of '../pages.dart';


class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> with SingleTickerProviderStateMixin,AutomaticKeepAliveClientMixin  {
  @override
  bool get wantKeepAlive => true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  TabController _tabController;
  bool isLoading=false,isError=false,isErrToken;
  int total=0;
  String tipe='';
  String fullName='',picture='', referralCode='';
  Future loadMember()async{
    final name=await UserHelper().getDataUser("full_name");
    final img=await UserHelper().getDataUser("picture");
    final ref=await UserHelper().getDataUser("referral_code");
    setState(() {
      fullName=name;
      picture=img;
      referralCode=ref;
    });
  }
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
    else if(res==Constant().errNoData){
      isLoading=false;
      isError=false;
      isErrToken=false;
      total = 0;
      setState(() {});
    }
    else if(res is General){
      isLoading=false;
      isError=false;
      isErrToken=false;
      total = 0;
      setState(() {});
    }
    else{
      if(this.mounted){
        CartModel cartModel=res;
        setState(() {
          isLoading=false;
          isError=false;
          total = cartModel.result.length;
          tipe = cartModel.result.length>0?cartModel.result[0].type.toString():'';
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
  Future postCart(id,qty,type)async{
    final package=await FunctionHelper().isPackage();
    print("SESSION $package");
    print("VARIABLE $tipe");
    print("PARAMETER $type");
    if(tipe==''){
      WidgetHelper().loadingDialog(context);
      handleSubmit(id,'plus',tipe);
      return;
    }
    if(tipe!=type){
      WidgetHelper().notifDialog(context,"Informasi !","ada paket ${type=='1'?'Aktivasi':'Repeat Order'}. Anda yakin akan melanjutkan transaksi ??", (){
        Navigator.pop(context);
      }, ()async{
        Navigator.pop(context);
        WidgetHelper().loadingDialog(context);
        handleSubmit(id,'plus',type);
      });
      return;
    }
    if(tipe==type){
      WidgetHelper().loadingDialog(context);
      handleSubmit(id,'plus',tipe);
      return;
    }

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCart();
    loadMember();
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
    super.build(context);
    Map<String, dynamic> row = {
      'Aktivasi':'Aktivasi',
      'Repeat Order':'Repeat Order',
    };
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          primary: true,
          key:_scaffoldKey,
          appBar: WidgetHelper().appBarWithTab(context,_tabController, fullName,row,_tabIndex==0?"Aktivasi":"Repeat Order",(idx){
            setState(() {lbl = idx;});
          },leading:Padding(
            padding: EdgeInsets.all(8.0),
            child:  CircleImage(
              param: 'network',
              key: Key("packageScreen"),
              image: picture,
              size: 50.0,
              padding: 0.0,
            ),
          ),description:referralCode,widget: [
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
                      print(tipe);
                      if(tipe==''){
                        loadCart();
                      }
                      else{
                        postCart(id, qty,tipe);
                      }
                    }),
                  ),
                  Scrollbar(
                    child: PackageWidget(tipe:'ro',callback: (id,qty,tipe){
                      if(tipe==''){
                        loadCart();
                      }
                      else{
                        postCart(id, qty,tipe);
                      }
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
