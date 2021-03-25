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
      print(infoTambahanModel.toJson());
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

  dynamic dataUser;

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
            isLoadingInfo?Text(''):SizedBox(height:scaler.getHeight(infoTambahanModel.result.reward.id!='-'&&!infoTambahanModel.result.reward.isClaimed?1:0)),
            isLoadingInfo?Text(''):infoTambahanModel.result.reward.id!='-'&&!infoTambahanModel.result.reward.isClaimed?ListTile(
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
              onTap: (){
                WidgetHelper().myModal(context,RewardScreen(infoTambahanModel: infoTambahanModel));
              },
            ):Text(''),
            isLoadingInfo?Text(''):SizedBox(height:scaler.getHeight(infoTambahanModel.result.reward.id!='-'&&!infoTambahanModel.result.reward.isClaimed?1:0)),
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
                    child: WidgetHelper().titleQ(context,"Laporan","Lihat riwayat transaksi anda disini",icon: AntDesign.barschart),
                    padding: scaler.getPadding(1,2),
                  ),
                  section2("SangQuota",(){WidgetHelper().myPush(context,HistoryPlafonScreen());},0,iconData: AntDesign.linechart),
                  section2("Rekapitulasi",(){WidgetHelper().myPush(context,RekapitulasiScreen());},1,iconData: AntDesign.trademark),
                  section2("Pembelian",(){WidgetHelper().myPush(context,HistoryPembelianScreen());},0,iconData: AntDesign.shoppingcart),
                  section2("Transaksi",(){WidgetHelper().myPush(context,HistoryTransactionScreen());},1,iconData: AntDesign.wallet),
                  section2("Deposit",(){WidgetHelper().myPush(context,HistoryDepositScreen());},0,iconData: AntDesign.swapleft),
                  section2("Penarikan",(){WidgetHelper().myPush(context,HistoryWithdrawScreen());},1,iconData: AntDesign.swapright),
                  section2("PPOB",(){WidgetHelper().myPush(context,HistoryPPOBScreen());},0,iconData: AntDesign.folder1),
                  section2("Redeem",(){WidgetHelper().myPush(context,HistoryRedeemScreen());},1,iconData:Ionicons.ios_gift),
                  section2("Reward",(){WidgetHelper().myPush(context,HistoryRewardScreen());},0,iconData:Ionicons.ios_medal),
                ],
              ),
            ),
            Container(
              margin: scaler.getMargin(1,2),
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
                  section2("Data Diri",(){WidgetHelper().myPush(context,FormProfileScreen(val: dataUser));},0,iconData: AntDesign.user),
                  section2("Testimoni",(){WidgetHelper().myPush(context,MyTestimoniScreen());},1,iconData:AntDesign.star),
                  section2("Alamat",(){WidgetHelper().myPush(context,AddressScreen());},0,iconData: Entypo.location),
                  section2("Bank",(){WidgetHelper().myPush(context,BankScreen());},1,iconData:AntDesign.bank),
                  section2("Privacy Policy",(){
                    if(!isLoading){
                      WidgetHelper().myPush(context,InfoScreen(siteModel:siteModel,title: 'Privacy Policy',));
                    }
                  },0,iconData:AntDesign.lock),
                  section2("Terms and Conditions",(){
                    if(!isLoading){
                      WidgetHelper().myPush(context,InfoScreen(siteModel:siteModel,title: 'Terms and Conditions',));
                    }
                  },1,iconData: AntDesign.infocirlceo),
                  section2("Keluar",()async{
                    WidgetHelper().notifDialog(context,"Informasi !","Kamu yakin akan keluar dari aplikasi ?", (){Navigator.pop(context);}, ()async{
                      await FunctionHelper().logout(context);
                    });
                  },0,iconData: AntDesign.logout),
                ],
              ),
            ),
            if(!isLoading)section3(context)
          ],
          title: 'Profile',
          callback: (data){
            setState(() {
              dataUser=data;
            });
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
    return FlatButton(
      padding: scaler.getPadding(0,0),
      onPressed:()=>callback,
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
    ScreenScaler scaler = ScreenScaler()..init(context);

    return Container(
      padding: EdgeInsets.only(left:0),
      margin: EdgeInsets.only(bottom: scaler.getHeight(4)),
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


class RewardScreen extends StatefulWidget {
  InfoTambahanModel infoTambahanModel;
  RewardScreen({this.infoTambahanModel});
  @override
  _RewardScreenState createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  AddressModel addressModel;
  bool isLoading=true;
  String idAddress='';
  int total=0;
  Future loadAddress()async{
    var res = await BaseProvider().getProvider("alamat?page=1&perpage=10", addressModelFromJson,context: context,callback: (){
      Navigator.pop(context);
    });
    if(res==Constant().errNoData){
      total=0;
      isLoading = false;
      WidgetHelper().notifDialog(context,"Informasi","anda belum mempunyai alamat",(){Navigator.pop(context);},(){
        WidgetHelper().myPush(context,AddressScreen());
      },titleBtn2: "buat alamat");
      setState(() {});
    }
    else if(res is AddressModel){
      if (this.mounted) {
        setState(() {
          total=1;
          addressModel = res;
          isLoading = false;
        });
      }
    }

  }

  Future checkout(BuildContext context)async{
    
    if(idAddress==''){
      return WidgetHelper().showFloatingFlushbar(context,"failed","silahkan pilih alamat anda");
    }
    WidgetHelper().myPush(context,PinScreen(callback: (context,isTrue,pin)async{
      final data={
        "pin_member":pin.toString(),
        "alamat":idAddress,
        "id_barang":widget.infoTambahanModel.result.reward.id
      };
      WidgetHelper().loadingDialog(context);
      final res=await BaseProvider().postProvider('transaction/claim/reward', data,context: context,callback: (){
        Navigator.of(context).pop();
      });
      if(res!=null){
        Navigator.pop(context);
        WidgetHelper().notifOneBtnDialog(context,"Transaksi Berhasil","barang reward anda berhasil di claim.",(){
          WidgetHelper().myPushRemove(context,IndexScreen(currentTab: 2));
        });
      }

    }));
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAddress();
  }

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);
    return Container(
      height: scaler.getHeight(70),
      child: isLoading?WidgetHelper().loadingWidget(context):total<1?WidgetHelper().noDataWidget(context):Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height:scaler.getHeight(1)),
          Center(
            child: Container(
              padding: EdgeInsets.only(top:10.0),
              width: 50,
              height: 10.0,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius:  BorderRadius.circular(10.0),
              ),
            ),
          ),
          SizedBox(height:scaler.getHeight(1)),
          Padding(
            padding: scaler.getPadding(1,2),
            child: WidgetHelper().titleNoButton(context, AntDesign.infocirlceo, 'Barang reward anda',color: Constant().mainColor1,iconSize: 12,),
          ),
          ListTile(
            contentPadding: scaler.getPadding(0,2),
            leading: WidgetHelper().baseImage(widget.infoTambahanModel.result.reward.gambar),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WidgetHelper().textQ(widget.infoTambahanModel.result.reward.title,scaler.getTextSize(9),Constant().darkMode,FontWeight.bold),
                WidgetHelper().textQ(widget.infoTambahanModel.result.reward.caption,scaler.getTextSize(9),Constant().darkMode,FontWeight.normal,maxLines: 3)
              ],
            ),
            onTap: (){
              // WidgetHelper().myModal(context,RewardScreen(infoTambahanModel: infoTambahanModel));
            },
          ),

          Padding(
            padding: scaler.getPadding(1,2),
            child: WidgetHelper().titleNoButton(context, AntDesign.infocirlceo, 'Pilih Alamat',color: Constant().mainColor1,iconSize: 12),
          ),
          Expanded(
              flex: 1,
              child: ListView.separated(
                padding: scaler.getPadding(0,2),
                addRepaintBoundaries: true,
                primary: false,
                shrinkWrap: true,
                itemCount: addressModel.result.data.length,
                itemBuilder: (context,index){
                  var val=addressModel.result.data[index];
                  return CardWidget(
                    onTap:(){
                      setState(() {
                        idAddress=val.id;
                      });
                    },
                    titleColor: Constant().darkMode,
                    prefixBadge: Constant().mainColor,
                    // title: val.title,
                    description: val.mainAddress,
                    descriptionColor: Constant().darkMode,
                    suffixIcon:AntDesign.checkcircleo,
                    suffixIconColor: idAddress==val.id?Constant().mainColor:Colors.transparent,
                    backgroundColor:Constant().greyColor,
                  );
                },
                separatorBuilder: (_,i){return(Text(''));},
              )
          ),
          FlatButton(
              padding: scaler.getPadding(1.3,0),
              color: Constant().moneyColor,
              onPressed: (){
                checkout(context);
                // postRedeem();
                // handleSubmit();
                // checkingAccount();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(AntDesign.checkcircleo,color: Colors.white,size: scaler.getTextSize(12),),
                  SizedBox(width: 10.0),
                  WidgetHelper().textQ("CHECKOUT", scaler.getTextSize(10),Colors.white,FontWeight.bold)
                ],
              )
          )
        ],
      ),
    );
  }
}
