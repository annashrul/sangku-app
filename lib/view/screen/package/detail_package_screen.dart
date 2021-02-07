import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/refresh_widget.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/mlm/detail_package_model.dart';
import 'package:sangkuy/model/mlm/package_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:sangkuy/view/widget/error_widget.dart';

class DetailPackageScreen extends StatefulWidget {
  final String id;
  DetailPackageScreen({this.id});
  @override
  _DetailPackageScreenState createState() => _DetailPackageScreenState();
}

class _DetailPackageScreenState extends State<DetailPackageScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TabController _tabController;
  int _tabIndex = 0;
  bool isLoading=false,isError=false;
  DetailPackageModel detailPackageModel;
  Future loadData()async{
    var res = await BaseProvider().getProvider("package/${widget.id}", detailPackageModelFromJson);
    if(res==Constant().errSocket||res==Constant().errTimeout){
      isLoading=false;
      isError=true;
      setState(() {});
    }
    else{
      if(res is DetailPackageModel){
        DetailPackageModel result=res;
        if(result.status=='success'){
          detailPackageModel = DetailPackageModel.fromJson(result.toJson());
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
  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, initialIndex: _tabIndex, vsync: this);
    _tabController.addListener(_handleTabSelection);
    isLoading=true;
    loadData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: isLoading?WidgetHelper().loadingWidget(context):buildContent(context),
    );
  }
  Widget buildContent(BuildContext context){
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
              // backgroundColor: Theme.of(context).primaryColor,
              expandedHeight: 300,
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
                          child: WidgetHelper().myText("Deskripsi",12,color:Colors.white,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(0), color:_tabIndex==1?Constant().mainColor:Constant().secondColor),
                        child: Align(
                          alignment: Alignment.center,
                          child: WidgetHelper().myText("Produk",12,color:Colors.white,fontWeight: FontWeight.bold),
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
                          padding: EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  WidgetHelper().textQ("${detailPackageModel.result.title}",14,Constant().darkMode,FontWeight.bold),
                                  SizedBox(height: 5.0),
                                  WidgetHelper().textQ("Rp ${FunctionHelper().formatter.format(int.parse(detailPackageModel.result.harga))} .-",12,Constant().moneyColor,FontWeight.bold),
                                ],
                              ),
                              Container(
                                height: 40.0,
                                width: 40.0,
                                child: Image.network(detailPackageModel.result.badge),
                              )
                            ],
                          ),
                        ),
                        // ListTile(
                        //   title: WidgetHelper().textQ("${detailPackageModel.result.title}",14,Constant().darkMode,FontWeight.bold),
                        //   subtitle:WidgetHelper().textQ("Rp ${FunctionHelper().formatter.format(int.parse(detailPackageModel.result.harga))} .-",12,Constant().moneyColor,FontWeight.bold),
                        //   trailing: Column(
                        //     children: [
                        //       CachedNetworkImage(
                        //         height: 40,
                        //         imageUrl:detailPackageModel.result.badge,
                        //         fit:BoxFit.contain,
                        //         placeholder: (context, url) => Image.network(Constant().noImage, fit:BoxFit.fill,width: double.infinity,),
                        //         errorWidget: (context, url, error) => Image.network(Constant().noImage, fit:BoxFit.fill,width: double.infinity,),
                        //       ),
                        //       WidgetHelper().textQ("${detailPackageModel.result.kategori}",10,Constant().darkMode,FontWeight.normal),
                        //     ],
                        //   ),
                        // ),
                        ClipPath(
                          clipper: WaveClipperOne(flip: true),
                          child: Container(
                            padding: EdgeInsets.only(bottom:50.0,top:10.0,left:15.0),
                            width: double.infinity,
                            // color: Theme.of(context).focusColor.withOpacity(0.1),
                            color: Constant().secondColor,
                            child:WidgetHelper().textQ("${detailPackageModel.result.deskripsi}",12,Constant().secondDarkColor,FontWeight.normal,maxLines: 100),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  WidgetHelper().textQ("Kategori",12,Constant().darkMode,FontWeight.normal),
                                  WidgetHelper().textQ("${detailPackageModel.result.kategori}",12,Colors.grey,FontWeight.normal),
                                ],
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  WidgetHelper().textQ("Point Volume",12,Constant().darkMode,FontWeight.normal),
                                  WidgetHelper().textQ("${detailPackageModel.result.pointVolume}",12,Colors.grey,FontWeight.normal),
                                ],
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  WidgetHelper().textQ("Berat",12,Constant().darkMode,FontWeight.normal),
                                  WidgetHelper().textQ("${detailPackageModel.result.berat}",12,Colors.grey,FontWeight.normal),
                                ],
                              )
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
                          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                          child: detailPackageModel.result.detail.length>0?ListView.separated(
                            padding:EdgeInsets.all(0.0),
                            shrinkWrap: true,
                            primary: false,
                            itemBuilder: (context,index){
                              var val=detailPackageModel.result.detail[index];
                              return Container(
                                padding: EdgeInsets.all(15.0),
                                // color: Theme.of(context).focusColor.withOpacity(0.1),
                                // child: ListTile(
                                //
                                //   onTap: (){},
                                //   title: WidgetHelper().textQ(val.barang,12,Constant().darkMode,FontWeight.bold),
                                //   subtitle: WidgetHelper().textQ("Satuan : ${val.satuan}",10,Constant().darkMode,FontWeight.bold),
                                // ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(color:Colors.black,width: 2.0,height:10.0),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        WidgetHelper().textQ(val.barang,12,Constant().darkMode,FontWeight.bold),
                                        WidgetHelper().textQ("Satuan : ${val.satuan}",10,Constant().darkMode,FontWeight.bold),
                                      ],
                                    )
                                  ],
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
            // height: 100,

          );
        },
      ),
    );
  }

}
