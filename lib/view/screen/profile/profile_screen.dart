part of '../pages.dart';



class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List dataInfo=[];
  List dataSocmed=[
    {}
  ];
  ScrollController controller;
  SiteModel siteModel;
  bool isLoading=true,isLoadingInfo=true;
  InfoTambahanModel infoTambahanModel;
  double height=0;
  Future loadInfo()async{
    var res = await BaseProvider().getProvider('member/tambahan',infoTambahanModelFromJson,context: context,callback: (){
      setState(() {
        isLoadingInfo=true;
      });
      loadInfo();

    });
    if(res is InfoTambahanModel){
      InfoTambahanModel result=res;
      infoTambahanModel=result;
      height=1;
      dataInfo.add({"title":"Bonus Diterima","value":infoTambahanModel.result.bonus});
      dataInfo.add({"title":"Bonus Sponsor","value":infoTambahanModel.result.bonusSponsor});
      dataInfo.add({"title":"Total Withdrawal","value":int.parse(infoTambahanModel.result.withdrawal)});
      if(this.mounted){
        setState(() {});
      }
      isLoadingInfo=false;
    }
  }
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
    loadInfo();
  }
  @override
  Widget build(BuildContext context){
    ScreenScaler scaler = ScreenScaler()..init(context);

    return SafeArea(
      child: RefreshWidget(
        widget: WrapperPageWidget(
          controller: controller,
          children: [
            Container(
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
                      itemCount:  isLoadingInfo?3:dataInfo.length,
                      itemBuilder: (BuildContext context, int index) {
                        return isLoadingInfo?WidgetHelper().baseLoading(context, Container(
                          color:Colors.white,
                          height: 50,
                          width: double.infinity,
                        )):Container(
                          child: FlatButton(
                            onPressed: (){},
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.0)),
                            padding: scaler.getPadding(1,1),
                            color: Constant().mainColor1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    WidgetHelper().textQ(dataInfo[index]['title'],scaler.getTextSize(9),Constant().mainColor2, FontWeight.normal,textAlign: TextAlign.left),
                                    WidgetHelper().textQ("${FunctionHelper().formatter.format(dataInfo[index]['value'])}",scaler.getTextSize(9),Constant().mainColor2, FontWeight.bold,textAlign: TextAlign.left),
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
            isLoadingInfo?Text(''):SizedBox(
                height:scaler.getHeight(infoTambahanModel.result.reward.id!='-'||infoTambahanModel.result.reward.isClaimed?1:0)
            ),
            isLoadingInfo?Text(''):infoTambahanModel.result.reward.id!='-'||infoTambahanModel.result.reward.isClaimed?ListTile(
              contentPadding: scaler.getPadding(0,2),
              trailing: Icon(Ionicons.md_arrow_dropright_circle,color: Constant().mainColor,size: scaler.getTextSize(12)),
              leading: WidgetHelper().baseImage(infoTambahanModel.result.reward.gambar),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WidgetHelper().textQ(infoTambahanModel.result.reward.title,scaler.getTextSize(9),Constant().darkMode,FontWeight.bold),
                  WidgetHelper().textQ(infoTambahanModel.result.reward.caption,scaler.getTextSize(9),Constant().darkMode,FontWeight.normal)
                ],
              ),
              onTap: (){},
            ):Text(''),
            isLoadingInfo?Text(''):SizedBox(
                height:scaler.getHeight(infoTambahanModel.result.reward.id!='-'||infoTambahanModel.result.reward.isClaimed?1:0)
            ),
            Container(
              margin: scaler.getMargin(0,2),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.1), offset: Offset(0, 3), blurRadius: 0)
                ],
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    child: WidgetHelper().titleQ(context,"Laporan","lihat riwayat transaksi anda disini",icon: AntDesign.barschart),
                    padding: scaler.getPadding(1,2),
                  ),
                  section2("Rekapitulasi",(){WidgetHelper().myPush(context,RekapitulasiScreen());},0,iconData: AntDesign.trademark),
                  section2("Pembelian",(){WidgetHelper().myPush(context,HistoryPembelianScreen());},1,iconData: AntDesign.shoppingcart),
                  section2("Transaksi",(){WidgetHelper().myPush(context,HistoryTransactionScreen());},0,iconData: AntDesign.wallet),
                  section2("Deposit",(){WidgetHelper().myPush(context,HistoryDepositScreen());},1,iconData: AntDesign.swapleft),
                  section2("Penarikan",(){WidgetHelper().myPush(context,HistoryWithdrawScreen());},0,iconData: AntDesign.swapright),
                  section2("PPOB",(){WidgetHelper().myPush(context,HistoryPPOBScreen());},1,iconData: AntDesign.folder1),
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
                  Padding(
                    child: WidgetHelper().titleQ(context,"Pengaturan Umum","Atur pengaturan data anda disini",icon: AntDesign.setting),
                    padding: scaler.getPadding(1,2),
                  ),
                  section2("Data Diri",(){},0,iconData: AntDesign.user),
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
        callback: (){
          setState(() {
            isLoadingInfo=true;
            dataInfo=[];
          });
          loadSite();
          loadInfo();
        },
      ),
    );
  }



  Widget section2(String title, Function callback,int idx,{IconData iconData=AntDesign.arrowright}){
    ScreenScaler scaler = ScreenScaler()..init(context);

    return Container(
      color: idx==0?Color(0xFFEEEEEE):Colors.white,
      child: ListTile(
        onTap: ()async{
          await Future.delayed(Duration(milliseconds: 90));
          callback();
        },
        contentPadding:scaler.getPadding(0,2),
        dense: true,
        title: WidgetHelper().textQ("$title",scaler.getTextSize(9),Colors.black,FontWeight.bold,letterSpacing: 2.0),
        trailing: Icon(iconData,color: Colors.grey,size: scaler.getTextSize(12)),
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              btnSocmed(context,"Twitter",AntDesign.twitter,siteModel.result.socialMedia.tw,color: Color(0xFF00acee)),
              SizedBox(width: 10),
              btnSocmed(context,"Facebook",AntDesign.facebook_square,siteModel.result.socialMedia.fb,color: Color(0xFF3b5998)),
              SizedBox(width: 10),
              btnSocmed(context,"Instagram",AntDesign.instagram,siteModel.result.socialMedia.ig,gradient: LinearGradient(
                colors: [
                  Color(0xff8a3ab9),
                  Color(0xfffbad50),
                  Color(0xffcd486b ),
                  Color(0xff4c68d7),
                ],
              )),
              SizedBox(width: 10),
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
      // decoration: BoxDecoration(
      //   // color:  color,
      //   // gradient: gradient
      // ),
      child: InkWell(
        onTap: ()async{
          WidgetHelper().myPush(context,Scaffold(
              appBar: WidgetHelper().appBarWithButton(context,title, (){Navigator.pop(context);},<Widget>[]),
              body: WebViewWidget(val: {"url":url})
          ));
        },
        // color: Color(0xFFFF0000),
        child: Icon(iconData,color: Colors.black),
      ),
    );
  }

}
