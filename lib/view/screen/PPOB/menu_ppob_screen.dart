import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/data_helper.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/PPOB/menu_ppob_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:sangkuy/view/screen/PPOB/prabayar_screen.dart';

class MenuPPOBScreen extends StatefulWidget {
  @override
  _MenuPPOBScreenState createState() => _MenuPPOBScreenState();
}

class _MenuPPOBScreenState extends State<MenuPPOBScreen> {
  MenuPpobModel menuPpobModel;
  bool isLoading=false;
  Future loadData()async{
    var res=await BaseProvider().getProvider('transaction/produk/kategori', menuPpobModelFromJson);
    if(res is MenuPpobModel){
      MenuPpobModel result=res;
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
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(left:0.0,right:0.0,bottom: 10.0),
            child: WidgetHelper().textQ("Pulsa Reguler & Paket Data", 12, Constant().mainColor,FontWeight.bold),
        ),
        Container(
          height: 100,
          child: isLoading?loading(context):StaggeredGridView.countBuilder(
            padding: EdgeInsets.all(0.0),
            shrinkWrap: true,
            primary: false,
            scrollDirection: Axis.horizontal,
            crossAxisCount: 3,
            itemCount:  menuPpobModel.result.topup.length,
            itemBuilder: (BuildContext context, int index) {
              var val=menuPpobModel.result.topup[index];
              var toArray = val.logo.split(".");
              print(toArray);
              return FlatButton(
                  padding: EdgeInsets.all(10.0),
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(4.0)),
                  color: Color(0xFFEEEEEE),
                  onPressed: (){
                    WidgetHelper().myPush(context,PrabayarScreen(val:val.toJson()));
                  },
                  child: Column(
                    children: [
                      toArray[2]=='svg'?SvgPicture.network(
                        val.logo,
                        fit:BoxFit.contain,
                        height: 50.0,
                        placeholderBuilder: (BuildContext context) => Image.asset(Constant().localAssets+'logo.png', fit:BoxFit.contain),
                      ):CachedNetworkImage(
                        imageUrl:val.logo,
                        width: double.infinity ,
                        height: 50.0,
                        fit:BoxFit.contain,
                        placeholder: (context, url) => Image.asset(Constant().localAssets+'logo.png',fit:BoxFit.contain),
                        errorWidget: (context, url, error) => Image.asset(Constant().localAssets+'logo.png',fit:BoxFit.contain),
                      ),
                      SizedBox(height:5.0),
                      WidgetHelper().textQ(val.title,10,Constant().darkMode, FontWeight.bold,textAlign: TextAlign.center,maxLines: 1),
                    ],
                  )
              );
            },
            staggeredTileBuilder: (int index) => new StaggeredTile.fit(20),
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 0.0,
          ),
        ),
        SizedBox(height:10.0),
        Padding(
          padding: EdgeInsets.only(left:0.0,right:0.0,bottom: 10.0),
          child: WidgetHelper().textQ("Bayar Tagihan", 12, Constant().mainColor,FontWeight.bold),
        ),
        Container(
          height: 100,
          child: isLoading?loading(context):StaggeredGridView.countBuilder(
            padding: EdgeInsets.all(0.0),
            shrinkWrap: true,
            primary: false,
            scrollDirection: Axis.horizontal,
            crossAxisCount: 3,
            itemCount:  menuPpobModel.result.tagihan.length,
            itemBuilder: (BuildContext context, int index) {
              var val=menuPpobModel.result.tagihan[index];
              var toArray = val.logo.split(".");
              print(toArray);
              return FlatButton(
                  padding: EdgeInsets.all(10.0),
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(4.0)),
                  color: Color(0xFFEEEEEE),
                  onPressed: (){},
                  child: Column(
                    children: [
                      toArray[2]=='svg'?SvgPicture.network(
                        val.logo,
                        fit:BoxFit.contain,
                        height: 50.0,
                        placeholderBuilder: (BuildContext context) => Image.asset(Constant().localAssets+'logo.png', fit:BoxFit.contain),
                      ):CachedNetworkImage(
                        imageUrl:val.logo,
                        width: double.infinity ,
                        height: 50.0,
                        fit:BoxFit.contain,
                        placeholder: (context, url) => Image.asset(Constant().localAssets+'logo.png',fit:BoxFit.contain),
                        errorWidget: (context, url, error) => Image.asset(Constant().localAssets+'logo.png',fit:BoxFit.contain),
                      ),
                      SizedBox(height:5.0),
                      WidgetHelper().textQ(val.title,10,Constant().darkMode, FontWeight.bold,textAlign: TextAlign.center,maxLines: 1),
                    ],
                  )
              );
            },
            staggeredTileBuilder: (int index) => new StaggeredTile.fit(20),
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 0.0,
          ),
        ),
        SizedBox(height:10.0),
        Padding(
          padding: EdgeInsets.only(left:0.0,right:0.0,bottom: 10.0),
          child: WidgetHelper().textQ("Pembayaran Lainnya", 12, Constant().mainColor,FontWeight.bold),
        ),
        Container(
          height: 100,
          child: isLoading?loading(context):StaggeredGridView.countBuilder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            primary: false,
            crossAxisCount: 3,
            itemCount:  menuPpobModel.result.lain.length,
            itemBuilder: (BuildContext context, int index) {
              var val=menuPpobModel.result.lain[index];
              var toArray = val.logo.split(".");
              return FlatButton(
                padding: EdgeInsets.all(10.0),
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(4.0)),
                color: Color(0xFFEEEEEE),
                onPressed: (){},
                child: Column(
                    children: [
                      toArray[2]=='svg'?SvgPicture.network(
                        val.logo,
                        fit:BoxFit.contain,
                        height: 50.0,
                        placeholderBuilder: (BuildContext context) => Image.asset(Constant().localAssets+'logo.png', fit:BoxFit.contain),
                      ):CachedNetworkImage(
                        imageUrl:val.logo,
                        width: double.infinity ,
                        height: 50.0,
                        fit:BoxFit.contain,
                        placeholder: (context, url) => Image.asset(Constant().localAssets+'logo.png',fit:BoxFit.contain),
                        errorWidget: (context, url, error) => Image.asset(Constant().localAssets+'logo.png',fit:BoxFit.contain),
                      ),
                      SizedBox(height:5.0),
                      WidgetHelper().textQ(val.title,10,Constant().darkMode, FontWeight.bold,textAlign: TextAlign.center,maxLines: 1),
                    ],
                  )
              );
            },
            staggeredTileBuilder: (int index) => new StaggeredTile.fit(20),
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 0.0,
          ),
        ),

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
