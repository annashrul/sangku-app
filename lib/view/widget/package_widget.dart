import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/refresh_widget.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/mlm/package_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:sangkuy/provider/cart_provider.dart';
import 'package:sangkuy/view/screen/mlm/detail_package_screen.dart';
import 'package:sangkuy/view/widget/loading/package_loading.dart';
import 'package:shimmer/shimmer.dart';

import 'error_widget.dart';

class PackageWidget extends StatefulWidget {
  final String tipe;
  final Function(String id,int qty,String tipe) callback;
  PackageWidget({this.tipe,this.callback});
  @override
  _PackageWidgetState createState() => _PackageWidgetState();
}

class _PackageWidgetState extends State<PackageWidget> with SingleTickerProviderStateMixin {
  int perpage=10;
  int total=0;
  ScrollController controller;
  bool isLoadmore=false;
  bool isLoading=false,isError=false;
  PackageModel packageModel;
  Future loadData()async{
    var res = await BaseProvider().getProvider("package?page=1&tipe=${widget.tipe}&perpage=$perpage", packageModelFromJson);
    if(res==Constant().errSocket||res==Constant().errTimeout){
      isLoading=false;
      isError=true;
      isLoadmore=false;
      setState(() {});
    }
    else{
      if(res is PackageModel){
        PackageModel result=res;
        if(result.status=='success'){
          packageModel = PackageModel.fromJson(result.toJson());
          total=result.result.total;
          isLoading=false;
          isError=false;
          isLoadmore=false;
          setState(() {});
        }
        else{
          isLoading=false;
          isError=true;
          isLoadmore=false;
          setState(() {});
        }
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
    controller = new ScrollController()..addListener(_scrollListener);
    isLoading=true;
    loadData();
  }


  @override
  Widget build(BuildContext context) {
    return isLoading?PackageLoading():isError?ErrWidget(callback:(){}):packageModel.result.data.length>0?RefreshWidget(
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
                  WidgetHelper().myPush(context,DetailPackageScreen(id:val.id,tipe: widget.tipe));
                },Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Visibility(
                        child: Container(
                          child: ListTile(
                            contentPadding: EdgeInsets.all(0.0),
                            title: WidgetHelper().textQ(val.title,12,Constant().darkMode,FontWeight.bold),
                            subtitle:WidgetHelper().textQ("Rp ${FunctionHelper().formatter.format(int.parse(val.harga))} .-",12,Constant().moneyColor,FontWeight.bold),
                            trailing: widget.tipe=='1'?CachedNetworkImage(
                              imageUrl:val.badge,
                              fit:BoxFit.contain,
                              placeholder: (context, url) => Image.network(Constant().noImage, fit:BoxFit.fill,width: double.infinity,),

                              errorWidget: (context, url, error) => Image.network(Constant().noImage, fit:BoxFit.fill,width: double.infinity,),
                            ):Text(''),
                          ),
                        ),
                        visible: false,
                      ),
                      CachedNetworkImage(
                        imageUrl:val.foto,
                        // height: 150,
                        width: double.infinity,
                        fit:BoxFit.cover,
                        placeholder: (context, url) => Image.network(Constant().noImage, fit:BoxFit.fill,width: double.infinity,),
                        errorWidget: (context, url, error) => Image.network(Constant().noImage, fit:BoxFit.fill,width: double.infinity,),
                      ),
                      SizedBox(height:10),

                      WidgetHelper().textQ(val.deskripsi,12,Constant().darkMode,FontWeight.normal,maxLines: 10,textAlign: TextAlign.justify),
                      SizedBox(height:10),
                      MaterialButton(
                        onPressed:(){
                          widget.callback(val.id,1,widget.tipe);
                        },
                        child: WidgetHelper().textQ("Keranjang",14,Colors.grey[200],FontWeight.bold),
                        color: Constant().secondColor,
                        elevation: 0,
                        minWidth: 400,
                        height: 50,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                      ),
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
              child:Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                enabled: true,
                child: Padding(
                  padding: const EdgeInsets.only(left:10.0,right:10.0,bottom:2.0),
                  child:Container(
                    width: double.infinity,
                    height: 8.0,
                    color: Colors.white,
                  ),
                ),
              )
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

