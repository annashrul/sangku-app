import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/refresh_widget.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/mlm/cart_model.dart';
import 'file:///E:/NETINDO/mobile/sangkuy/lib/model/mlm/package/detail_package_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:sangkuy/provider/cart_provider.dart';
import 'package:sangkuy/view/screen/mlm/cart_screen.dart';
import 'package:sangkuy/view/screen/pages.dart';
import 'package:sangkuy/view/widget/card_widget.dart';
import 'package:sangkuy/view/widget/error_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailPackageScreen extends StatefulWidget {
  final String id;
  final String tipe;
  DetailPackageScreen({this.id,this.tipe});
  @override
  _DetailPackageScreenState createState() => _DetailPackageScreenState();
}

class _DetailPackageScreenState extends State<DetailPackageScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TabController _tabController;
  int _tabIndex = 0,qty=1,stock=0,total=0;
  bool isLoading=false,isError=false;
  DetailPackageModel detailPackageModel;
  String tipe='';
  String param='plus';
  Future loadData()async{
    await loadDetail();
    await loadCart();
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
    else if(res==Constant().errNoData){
      isLoading=false;
      isError=false;
      total = 0;
      setState(() {});
    }
    else{
      CartModel cartModel = res;
      setState(() {
        isLoading=false;
        isError=false;
        tipe = cartModel.result.length>0?cartModel.result[0].type.toString():'';
        total = cartModel.result.length;
      });
    }
  }
  Future loadDetail()async{
    var res = await BaseProvider().getProvider("package/${widget.id}", detailPackageModelFromJson);
    if(res==Constant().errSocket||res==Constant().errTimeout){
      isLoading=false;
      isError=true;
      setState(() {});
    }
    else{
      if(res is DetailPackageModel){
        DetailPackageModel result=res;
        print(result.toJson());
        if(result.status=='success'){
          detailPackageModel = DetailPackageModel.fromJson(result.toJson());
          stock=int.parse(detailPackageModel.result.stock);
          isLoading=false;
          isError=false;
          setState(() {});
        }
        else{
          isLoading=false;
          isError=true;
          setState(() {});
        }
      }
    }
  }
  Future postCart(param)async{
    print(param);
    WidgetHelper().loadingDialog(context);
    var res = await CartProvider().postCart(widget.id,param,widget.tipe,context,(){
      Navigator.pop(context);
    });
    if(res!=null){
      Navigator.pop(context);
      await loadCart();
      WidgetHelper().notifBar(context,"success",'berhasil dimasukan kedalam keranjang');
    }
    // Navigator.pop(context);
    // if(res=='error'){
    //   WidgetHelper().notifBar(context,"failed",Constant().msgConnection);
    // }
    // else if(res=='success'){
    //   await loadCart();
    //   WidgetHelper().notifBar(context,"success",'berhasil dimasukan kedalam keranjang');
    // }
    // else{
    //   WidgetHelper().notifBar(context,"failed",res);
    // }
  }
  Future validate(param)async{
    if(qty<1){
      WidgetHelper().notifBar(context,"failed","qty tidak boleh kurang dari 1");
    }
    else{
      if(tipe==''){
        postCart(param);
        return;
      }
      if(tipe!=widget.tipe){
        WidgetHelper().notifDialog(context,"Informasi !","ada paket ${widget.tipe=='0'?'Aktivasi':'Repeat Order'}. Anda yakin akan melanjutkan transaksi ??", (){
          Navigator.pop(context);
        }, ()async{
          Navigator.pop(context);
          postCart(param);
        });
        return;
      }
      if(tipe==widget.tipe){
        postCart(param);
        return;
      }
      // if(package!=widget.tipe&&package!=null){
      //   WidgetHelper().notifDialog(context,"Informasi !","ada paket ${widget.tipe=='0'?'Aktivasi':'Repeat Order'}. Anda yakin akan melanjutkan transaksi ??", (){
      //     Navigator.pop(context);
      //   }, ()async{
      //     Navigator.pop(context);
      //     postCart();
      //   });
      // }else{
      //   postCart();
      // }
    }
  }
  void addQty(){
    if(qty<stock){
      setState(() {
        qty+=1;
        param='plus';
      });
    }else{
      WidgetHelper().notifBar(context,"failed","stock hanya tersedia $stock lagi");
    }

  }
  void minQty(){
    if(qty>1){
      setState(() {
        qty-=1;
        param='min';

      });
    }
  }
  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _tabIndex = _tabController.index;
      });
    }
  }
  String _platformVersion = 'Unknown';

  Future<void> initPlatformState() async {
    String platformVersion;

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("TYPE PACKAGE ${widget.tipe}");
    _tabController = TabController(length: 2, initialIndex: _tabIndex, vsync: this);
    _tabController.addListener(_handleTabSelection);
    isLoading=true;
    loadData();
  }
  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);

    return Scaffold(
      key: _scaffoldKey,
      body: isLoading?WidgetHelper().loadingWidget(context):buildContent(context),
      bottomNavigationBar: isLoading?Text(''):FlatButton(
        onPressed: (){
          validate(param);
        },
        color: Constant().moneyColor,
        padding:scaler.getPadding(1,0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(AntDesign.shoppingcart,color: Constant().secondDarkColor),
            SizedBox(width:10.0),
            WidgetHelper().textQ("Keranjang", scaler.getTextSize(10), Constant().secondDarkColor, FontWeight.normal),
          ],
        ),
      ),

    );
  }
  Widget buildContent(BuildContext context){
    ScreenScaler scaler = ScreenScaler()..init(context);

    return isLoading?WidgetHelper().loadingWidget(context):isError?ErrWidget(callback:(){}):RefreshWidget(
      widget: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              stretch: true,
              onStretchTrigger: (){
                return;
              },
              brightness:Brightness.dark,
              snap: true,
              floating: true,
              pinned: true,
              automaticallyImplyLeading: false,
              leading: new IconButton(
                icon: new Icon(AntDesign.back, color:Constant().mainColor),
                onPressed: () => Navigator.pop(context,false),
              ),
              actions: <Widget>[
                WidgetHelper().myCart(context, (){
                  if(total>0){
                    WidgetHelper().myPushAndLoad(context,CartScreen(),()=>loadCart());
                  }
                }, total>0?Colors.redAccent:Colors.transparent)
              ],
              // backgroundColor: Theme.of(context).primaryColor,
              expandedHeight: scaler.getHeight(30),
              elevation: 0,
              flexibleSpace: sliderQ(context),
              bottom: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelPadding: EdgeInsets.symmetric(horizontal: 0),
                  labelColor: Colors.black,
                  indicator: BoxDecoration(borderRadius: BorderRadius.circular(50), color:Colors.transparent),
                  tabs: [
                    Tab(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(0), color:_tabIndex==0?Constant().mainColor:Constant().secondColor),
                        child: Align(
                          alignment: Alignment.center,
                          child: WidgetHelper().myText("Deskripsi",scaler.getTextSize(9),color:Colors.white,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(0), color:_tabIndex==1?Constant().mainColor:Constant().secondColor),
                        child: Align(
                          alignment: Alignment.center,
                          child: WidgetHelper().myText("Produk",scaler.getTextSize(9),color:Colors.white,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ]
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Offstage(
                  offstage: 0 != _tabIndex,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding:scaler.getPadding(1,2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  WidgetHelper().textQ("${detailPackageModel.result.title}",scaler.getTextSize(10),Constant().darkMode,FontWeight.bold),
                                  SizedBox(height: 5.0),
                                  WidgetHelper().textQ("Rp ${FunctionHelper().formatter.format(int.parse(detailPackageModel.result.harga))} .-",scaler.getTextSize(10),Constant().moneyColor,FontWeight.bold),
                                ],
                              ),
                              Container(
                                height: scaler.getHeight(5),
                                width: scaler.getWidth(5),
                                child: Image.network(detailPackageModel.result.badge),
                              )
                            ],
                          ),
                        ),
                        ClipPath(
                          clipper: WaveClipperOne(flip: true),
                          child: Container(
                            padding: EdgeInsets.only(bottom:50.0,top:10.0,left:15.0),
                            width: double.infinity,
                            color: Color(0xFFEEEEEE),
                            child:WidgetHelper().textQ("${detailPackageModel.result.deskripsi}",scaler.getTextSize(9),Constant().darkMode,FontWeight.normal,maxLines: 100),
                          ),
                        ),
                        Container(
                          padding:scaler.getPadding(1,2),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  WidgetHelper().textQ("Kategori",scaler.getTextSize(9),Constant().darkMode,FontWeight.normal),
                                  WidgetHelper().textQ("${detailPackageModel.result.kategori}",scaler.getTextSize(9),Colors.grey,FontWeight.normal),
                                ],
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  WidgetHelper().textQ("Point Volume",scaler.getTextSize(9),Constant().darkMode,FontWeight.normal),
                                  WidgetHelper().textQ("${detailPackageModel.result.pointVolume}",scaler.getTextSize(9),Colors.grey,FontWeight.normal),
                                ],
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  WidgetHelper().textQ("Berat",scaler.getTextSize(9),Constant().darkMode,FontWeight.normal),
                                  WidgetHelper().textQ("${detailPackageModel.result.berat}",scaler.getTextSize(9),Colors.grey,FontWeight.normal),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Offstage(
                  offstage: 1 != _tabIndex,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height/1,
                          padding: scaler.getPadding(1, 2),
                          child: detailPackageModel.result.detail.length>0?ListView.separated(
                            padding:EdgeInsets.all(0.0),
                            shrinkWrap: true,
                            primary: false,
                            itemBuilder: (context,index){
                              var val=detailPackageModel.result.detail[index];
                              return Container(
                                padding:scaler.getPadding(0, 1),
                                child: CardWidget(
                                  prefixBadge: Constant().secondColor,
                                  title: val.barang,
                                  description: 'satuan : ${val.satuan}, Qty : ${val.qty}, Berat : ${val.berat}',
                                ),
                              );
                            },
                            separatorBuilder: (context,index){return Divider();},
                            itemCount: detailPackageModel.result.detail.length
                          ):WidgetHelper().noDataWidget(context),
                        )
                      ],
                    ),
                  ),
                ),

              ]),
            )
          ]
      ),
      callback: ()async{
        setState(() {
          isLoading=true;
        });
        await loadData();
      },
    );
  }
  Widget sliderQ(BuildContext context){
    ScreenScaler scaler = ScreenScaler()..init(context);

    return FlexibleSpaceBar(
      stretchModes: [
        StretchMode.zoomBackground,
        StretchMode.blurBackground,
        StretchMode.fadeTitle
      ],
      collapseMode: CollapseMode.parallax,
      background: Builder(
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: CachedNetworkImage(
              imageUrl:detailPackageModel.result.foto,
              width: double.infinity ,
              fit:BoxFit.cover,
              placeholder: (context, url) => Image.network(Constant().noImage, fit:BoxFit.fill,width: double.infinity,),
              errorWidget: (context, url, error) => Image.network(Constant().noImage, fit:BoxFit.fill,width: double.infinity,),
            ),
          );
        },
      ),
    );
  }




}
