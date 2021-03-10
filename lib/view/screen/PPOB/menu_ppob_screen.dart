import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/data_helper.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/PPOB/menu_ppob_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:sangkuy/view/screen/PPOB/pascabayar_screen.dart';
import 'package:sangkuy/view/screen/PPOB/prabayar_screen.dart';

class MenuPPOBScreen extends StatefulWidget {
  @override
  _MenuPPOBScreenState createState() => _MenuPPOBScreenState();
}

class _MenuPPOBScreenState extends State<MenuPPOBScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List<Widget> child = [];
  List listArray = [];
  List title = ['TOPUP','TAGIHAN','LAIN'];
  MenuPpobModel menuPpobModel;
  bool isLoading=false;
  Future loadData()async{
    var res=await BaseProvider().getProvider('transaction/produk/kategori', menuPpobModelFromJson);
    if(res is MenuPpobModel){
      MenuPpobModel result=res;
      var mergeArray = result.result.toJson();
      title.forEach((element) {
        mergeArray[element].forEach((val){
          listArray.add(val);
        });
      });

      if(this.mounted){
        setState(() {
          menuPpobModel = result;
          isLoading=false;
        });
      }
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading=true;
    loadData();
  }
  final controller = ScrollController();
  static const double padding = 16;
  static const double spacing = 8;
  static const int crossAxisCount = 3;

  Widget buildItem(BuildContext context){
    return isLoading?loading(context):Container(
      // color: Colors.black,
      padding: EdgeInsets.only(bottom: 10),
      height: MediaQuery.of(context).size.height/4.5,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 2/4,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: listArray.length,
        shrinkWrap: false,
        itemBuilder: (context, index) {
          var val=listArray[index];
          var checkImg = val['logo'].split(".");
          return FlatButton(
              padding: EdgeInsets.all(5.0),
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
              color: Color(0xFFEEEEEE),
              onPressed: (){
                if(val['kategori']==0){
                  WidgetHelper().myPush(context,PrabayarScreen(val:val));
                }else{
                  WidgetHelper().myPush(context,PascabayarScreen(val:val));
                }
              },
              child: Column(
                children: [
                  checkImg[2]=='svg'?SvgPicture.network(
                    val['logo'],
                    fit:BoxFit.contain,
                    height: 30.0,
                    placeholderBuilder: (BuildContext context) => Image.asset(Constant().localAssets+'logo.png', fit:BoxFit.contain),
                  ):CachedNetworkImage(
                    imageUrl:val['logo'],
                    width: double.infinity ,
                    height: 30.0,
                    fit:BoxFit.contain,
                    placeholder: (context, url) => Image.asset(Constant().localAssets+'logo.png',fit:BoxFit.contain),
                    errorWidget: (context, url, error) => Image.asset(Constant().localAssets+'logo.png',fit:BoxFit.contain),
                  ),
                  SizedBox(height:5.0),
                  WidgetHelper().textQ(val['title'].toLowerCase(),10,Constant().darkMode, FontWeight.bold,textAlign: TextAlign.center,maxLines: 1),
                ],
              )
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return builds(context);
  }
  Widget builds(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.only(left:0.0,right:0.0),
          leading: Icon(AntDesign.wallet,color:Constant().mainColor),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WidgetHelper().textQ("Produk PPOB",12,Constant().darkMode,FontWeight.bold),
              WidgetHelper().textQ("Beli pulsa,paket data, bayar tagihan dll",12,Constant().darkMode,FontWeight.normal),
            ],
          ),
          trailing: Icon(Icons.arrow_right),
        ),
        buildItem(context),
        // Container(
        //   child: isLoading?loading(context):Column(
        //     children: child,
        //   ),
        // ),
      ],
    );
  }



  Widget loading(BuildContext context){
    return StaggeredGridView.countBuilder(
      padding: EdgeInsets.all(0.0),
      shrinkWrap: true,
      primary: false,
      crossAxisCount: 5,
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) {
        return WidgetHelper().baseLoading(context,Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              height: 70,
              width: 50,
            ),
            SizedBox(height:5.0),
            Container(
              height: 5,
              width: double.infinity,
              color: Colors.white,
            ),
          ],
        ));
      },
      staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
      mainAxisSpacing: 20.0,
      crossAxisSpacing: 20.0,
    );
  }
}
