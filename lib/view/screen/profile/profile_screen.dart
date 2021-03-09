part of '../pages.dart';



class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  
  ScrollController controller;
  SiteModel siteModel;
  bool isLoading=true;
  Future loadSite()async{
    var res = await BaseProvider().getProvider('site/landing',siteModelFromJson);
    if(res is SiteModel){
      SiteModel result=res;
      siteModel=result;
      isLoading=false;
      if(this.mounted){
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadSite();
  }
  @override
  Widget build(BuildContext context){
    return SafeArea(
      child: WrapperPageWidget(
        controller: controller,
        children: [
          Container(
            padding: EdgeInsets.only(left:0.0,right:0.0,bottom:0.0,top:0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: StaggeredGridView.countBuilder(
                    padding: EdgeInsets.all(0.0),
                    shrinkWrap: true,
                    primary: false,
                    crossAxisCount: 3,
                    itemCount:  DataHelper.dataProfile.length,
                    itemBuilder: (BuildContext context, int index) {
                      IconData icon;
                      String title='';
                      Color color;
                      String value='';
                      // if(index==0){icon=AntDesign.team;title='Sponsor';color=Color(0xFF007bff);value=widget.dataMember['sponsor'];}
                      // if(index==1){icon=AntDesign.pptfile1;title='PIN';color=Color(0xFFffc107);value=widget.dataMember['pin'];}
                      // if(index==2){icon=AntDesign.leftcircleo;title='PV Kiri';color=Color(0xFF28a745);value=widget.dataMember['left_pv'];}
                      // if(index==3){icon=AntDesign.rightcircleo;title='PV Kanan';color=Color(0xFFdc3545);value=widget.dataMember['right_pv'];}
                      return Container(
                        child: FlatButton(
                          onPressed: ()async{
                            await MemberProvider().getDataMember();
                          },
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.0)),
                          padding: EdgeInsets.all(10.0),
                          color: Constant().mainColor1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon(icon,size: 10.0,color: color),
                              // SizedBox(width:5.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  WidgetHelper().textQ("Bonus Diterima",9,Constant().mainColor2, FontWeight.normal,textAlign: TextAlign.left),
                                  WidgetHelper().textQ("Rp 3.370.000",10,Constant().mainColor2, FontWeight.bold,textAlign: TextAlign.left),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
                    mainAxisSpacing: 0.0,
                    crossAxisSpacing: 1.0,
                  ),
                ),

              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.1), offset: Offset(0, 3), blurRadius: 0)

                // BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)
              ],
            ),
            child: Column(
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.only(left:10,right:20),
                  leading: Icon(AntDesign.barschart,color:Constant().mainColor),
                  title: WidgetHelper().textQ("Laporan",12,Colors.black,FontWeight.bold),
                ),
                section2("Pembelian",(){WidgetHelper().myPush(context,HistoryPembelianScreen());},0,iconData: AntDesign.shoppingcart),
                section2("Transaksi",(){WidgetHelper().myPush(context,HistoryTransactionScreen());},1,iconData: AntDesign.wallet),
                section2("Deposit",(){WidgetHelper().myPush(context,HistoryDepositScreen());},0,iconData: AntDesign.swapleft),
                section2("Penarikan",(){WidgetHelper().myPush(context,HistoryWithdrawScreen());},1,iconData: AntDesign.swapright),
                section2("PPOB",(){WidgetHelper().myPush(context,HistoryPPOBScreen());},0,iconData: AntDesign.folder1),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.1), offset: Offset(3, 0), blurRadius: 0)
              ],
            ),
            child: Column(
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.only(left:10,right:20),
                  leading: Icon(AntDesign.setting,color:Constant().mainColor),
                  title: WidgetHelper().textQ("Pengaturan Umum",12,Colors.black,FontWeight.bold),
                ),
                section2("Data Diri",(){},0,iconData: AntDesign.user),
                // section2("Keamanan",(){},1,iconData: AntDesign.lock),
                section2("Alamat",(){WidgetHelper().myPush(context,AddressScreen());},1,iconData: Entypo.location),
                section2("Bank",(){WidgetHelper().myPush(context,BankScreen());},0,iconData:AntDesign.bank),
                section2("Privacy Policy",(){
                  if(!isLoading){
                    WidgetHelper().myPush(context,InfoScreen(siteModel:siteModel,title: 'Privacy Policy',));
                  }
                },1,iconData: AntDesign.infocirlceo),
                section2("Terms and Conditions",(){
                  if(!isLoading){
                    WidgetHelper().myPush(context,InfoScreen(siteModel:siteModel,title: 'Terms and Conditions',));
                  }
                },0,iconData: AntDesign.infocirlceo),
                section2("Keluar",()async{
                  WidgetHelper().notifDialog(context,"Informasi !","Kamu yakin akan keluar dari aplikasi ?", (){Navigator.pop(context);}, ()async{
                    await FunctionHelper().logout(context);
                  });
                },1,iconData: AntDesign.logout),
              ],
            ),
          ),
          if(!isLoading)section3(context)
        ],
        title: 'Profile',
        callback: (data){
          print(data);
        },
      ),
    );
  }



  Widget section2(String title, Function callback,int idx,{IconData iconData=AntDesign.arrowright}){
    return FlatButton(
      color: idx==0?Color(0xFFEEEEEE):Colors.white,
      padding: EdgeInsets.all(0.0),
      highlightColor:Colors.black38,
      splashColor:Colors.black38,
      onPressed: ()async{
        await Future.delayed(Duration(milliseconds: 90));
        callback();
        // WidgetHelper().myPush(context,WrapperScreen(currentTab: 0,otherParam: 0));
      },
      child: ListTile(
        contentPadding: EdgeInsets.only(left:20,right:20),
        dense: true,
        title: WidgetHelper().textQ("$title",10,Colors.black,FontWeight.normal,letterSpacing: 2.0),
        trailing: Icon(iconData,color: Colors.grey),
      ),
    );
  }
  
  Widget section3(BuildContext context){
    return Container(
      padding: EdgeInsets.only(left:0),
      margin: EdgeInsets.only(bottom: 100),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              btnSocmed(context,"Twitter",AntDesign.twitter,siteModel.result.socialMedia.tw,color: Color(0xFF00acee)),
              btnSocmed(context,"Facebook",AntDesign.facebook_square,siteModel.result.socialMedia.fb,color: Color(0xFF3b5998)),
              btnSocmed(context,"Instagram",AntDesign.instagram,siteModel.result.socialMedia.ig,gradient: LinearGradient(
                colors: [
                  Color(0xff8a3ab9),
                  Color(0xfffbad50),
                  Color(0xffcd486b ),
                  Color(0xff4c68d7),
                ],
              )),
              btnSocmed(context,"Youtube",AntDesign.youtube,siteModel.result.socialMedia.yt,color: Color(0xFFFF0000)),
            ],
          ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: getWidth(context)/3,
                child: Divider(),
              ),
              WidgetHelper().textQ("Versi ${Constant().versionCode}", 14, Constant().mainColor,FontWeight.bold),
              Container(
                width: getWidth(context)/3,
                child: Divider(),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget btnSocmed(BuildContext context,title,IconData iconData, String url,{Color color,Gradient gradient}){
    return Container(
      decoration: BoxDecoration(
        color:  color,
        gradient: gradient
      ),
      child: FlatButton(
        onPressed: ()async{
          // _launchURL(url);
              // await launch(_url) : throw 'Could not launch $_url';
          WidgetHelper().myPush(context,WebViewWidget(val: {"title":title,"url":url},));
        },
        // color: Color(0xFFFF0000),
        child: Icon(iconData,color: Colors.white),
      ),
    );
  }

}
