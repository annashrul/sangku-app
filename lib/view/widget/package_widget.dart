import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/refresh_widget.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/mlm/package/package_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:sangkuy/view/screen/mlm/detail_package_screen.dart';
import 'package:sangkuy/view/widget/error_widget.dart';
import 'package:sangkuy/view/widget/loading/package_loading.dart';


class PackageWidget extends StatefulWidget {
  final String tipe;
  final Function(String id,int qty,String tipe) callback;
  // const ProductScreen({Key key}) : super(key: key);

  const PackageWidget({Key key,this.tipe,this.callback}) : super(key: key);
  @override
  _PackageWidgetState createState() => _PackageWidgetState();
}

class _PackageWidgetState extends State<PackageWidget> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  int perpage=10;
  int total=0;
  ScrollController controller;
  bool isLoadmore=false;
  bool isLoading=false,isError=false,isErrToken=false;
  PackageModel packageModel;
  Future loadData()async{
    var res = await BaseProvider().getProvider("package?page=1&tipe=${widget.tipe}&perpage=$perpage",packageModelFromJson,context: context,callback: (){});
    if(res is PackageModel){
      PackageModel result=res;
      if(result.status=='success'){
        if(this.mounted){
          setState(() {
            packageModel = PackageModel.fromJson(result.toJson());
            total=result.result.total;
            isLoading=false;
            isError=false;
            isLoadmore=false;
          });
        }
      }
      else{
        isLoading=false;
        isError=true;
        isLoadmore=false;
        setState(() {});
      }
    }
  }
  void _scrollListener() {
    if (!isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        print('fetch data');
        if(perpage<total){
          setState((){
            perpage = perpage+perpage;
            isLoadmore=true;
          });
          loadData();
        }
      }
    }
  }
  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    isLoading=false;
    isLoadmore=false;
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(this.mounted){
      controller = new ScrollController()..addListener(_scrollListener);
      isLoading=true;
      loadData();
    }
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return isLoading?PackageLoading():isError?ErrWidget(callback:(){setState(() {
      isLoading=true;
    });loadData();}):isErrToken?Text(''):packageModel.result.data.length>0?RefreshWidget(
      widget: Column(
        children: [
          Expanded(
            flex: 9,
            child: ListView.separated(
              padding: EdgeInsets.only(left:10,right:10,bottom: 10.0),
              shrinkWrap: true,
              controller: controller,
              scrollDirection: Axis.vertical,
              itemCount: packageModel.result.data.length,
              itemBuilder: (context,index){
                var val = packageModel.result.data[index];
                return WidgetHelper().myPress((){
                  WidgetHelper().myPushAndLoad(context, DetailPackageScreen(id:val.id,tipe: widget.tipe=='1'?'0':'1'), (){
                    widget.callback(val.id,1,'');
                  });
                  // WidgetHelper().myPush(context,DetailPackageScreen(id:val.id,tipe: widget.tipe=='1'?'0':'1'));
                },Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.all(0.0),
                        title: WidgetHelper().textQ(val.title,12,Constant().darkMode,FontWeight.bold),
                        subtitle:WidgetHelper().textQ("Rp ${FunctionHelper().formatter.format(int.parse(val.harga))} .-",12,Constant().moneyColor,FontWeight.bold),
                        trailing: widget.tipe=='1'? WidgetHelper().baseImage(val.badge,width: 40):Text(''),
                      ),
                      WidgetHelper().baseImage(val.foto,width: double.infinity,fit: BoxFit.cover),

                      SizedBox(height:10),
                      WidgetHelper().textQ(val.deskripsi,12,Constant().darkMode,FontWeight.normal,maxLines: 10,textAlign: TextAlign.justify),
                      SizedBox(height:10),
                      FlatButton(
                        padding: EdgeInsets.all(10.0),
                        color: Constant().moneyColor,
                        onPressed: (){
                          widget.callback(val.id,1,widget.tipe=='1'?'0':'1');
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(AntDesign.shoppingcart,color: Constant().secondDarkColor),
                            SizedBox(width:10.0),
                            WidgetHelper().textQ("Keranjang", 12, Constant().secondDarkColor, FontWeight.normal),
                          ],
                        ),
                      )

                    ],
                  ),
                ));
              },
              separatorBuilder: (context,index){
                return SizedBox(height:5.0);
              },
            ),
          ),
          isLoadmore?Expanded(
              flex: 1,
              child:WidgetHelper().baseLoading(context, Padding(
                padding: const EdgeInsets.only(left:10.0,right:10.0,bottom:2.0),
                child:Container(
                  width: double.infinity,
                  height: 8.0,
                  color: Colors.white,
                ),
              ))
          ):Text('')
        ],
      ),
      callback: ()async{
        setState(() {
          isLoading=true;
        });
        await loadData();
      },
    ):WidgetHelper().noDataWidget(context);
  }
}

