part of '../pages.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List data=[
    'https://ecs7.tokopedia.net/img/cache/100-square/attachment/2020/8/28/47197032/47197032_914c9752-19e1-42b0-8181-91ef0629fd8a.png',
    'https://ecs7.tokopedia.net/img/cache/100-square/attachment/2019/10/22/21181130/21181130_907dac9a-c185-43d1-b459-2389f0b6efea.png',
    'https://ecs7.tokopedia.net/img/cache/100-square/attachment/2019/10/22/21181130/21181130_53682a49-5247-4374-82c0-4c2a8d3bdbea.png',
    'https://ecs7.tokopedia.net/img/cache/100-square/attachment/2019/12/13/51829405/51829405_77281743-12fd-402b-b212-67b52516229c.png',
    'https://ecs7.tokopedia.net/img/cache/100-square/attachment/2019/11/15/21181130/21181130_5ee75889-94bc-45d3-9ce6-5ecf466fb385.png',
    'https://ecs7.tokopedia.net/img/cache/100-square/attachment/2019/10/22/21181130/21181130_5e0e4f34-0e41-48c4-baa0-dbf8a5e151d2.png',
    'https://ecs7.tokopedia.net/img/cache/100-square/attachment/2019/11/15/21181130/21181130_a40bc9db-8fd8-426f-985f-9930fe83711a.png',
    'https://ecs7.tokopedia.net/img/cache/100-square/attachment/2020/1/23/47197032/47197032_0de76bd3-0481-4ee2-8c52-9700cbbc3ae7.png',
    'https://ecs7.tokopedia.net/img/cache/100-square/attachment/2020/3/27/41313334/41313334_ed6fac94-00eb-4a37-bd4e-6ecab312e6f2.png',
    'https://ecs7.tokopedia.net/img/cache/100-square/attachment/2019/11/15/21181130/21181130_0653d8df-0bb4-4714-9267-b987298c0420.png'
  ];
  List dataWallet=[
    {'title':"Top Up",'icon':Constant().localIcon+'topup_icon.svg'},
    {'title':"Transfer",'icon':Constant().localIcon+'transfer_icon.svg'},
    {'title':"Penarikan",'icon':Constant().localIcon+'history_icon.svg'},
    // Constant().localIcon+'topup_icon.svg',
    // Constant().localIcon+'transfer_icon.svg',
    // Constant().localIcon+'history_icon.svg',
  ];

  bool isLoadingNews=false,isErrorNews=false,isTokenExpNews=false;
  bool isLoadingRedeem=false,isErrorRedeem=false,isTokenExpRedeem=false;
  bool isLoadingMember=false;
  int poin=0,idxAddress=0;
  String idAddress='';
  ContentModel contentModel;
  ListRedeemModel listRedeemModel;
  DataMemberModel dataMemberModel;
  Future loadData()async{
    setState(() {
      isLoadingMember=true;
      isLoadingRedeem=true;
      isLoadingNews=true;
    });
    loadMember();
    loadRedeem();
    loadNews();
  }
  Future loadMember()async{
    final member = await MemberProvider().getDataMember();
    if(this.mounted)
    setState(() {
      dataMemberModel = member;
      isLoadingMember=false;
      poin=int.parse(dataMemberModel.result.pointRo.split(".")[0]);
    });
  }
  Future loadNews()async{
    var res = await ContentProvider().loadData("page=1");
    if(res=='error' || res=='failed'){
      setState(() {
        isLoadingNews=false;
        isErrorNews=true;
      });
    }
    else if(res==Constant().errExpToken){
      setState(() {
        isLoadingNews=false;
        isErrorNews=false;
        isTokenExpNews=true;
      });
    }
    else{
      if(this.mounted)
      setState(() {
        contentModel = res;
        isLoadingNews=false;
        isErrorNews=false;
        isTokenExpNews=false;
      });
    }
  }
  Future loadRedeem()async{
    var res = await ContentProvider().loadRedeem("page=1");
    if(res=='error' || res=='failed'){
      setState(() {
        isLoadingRedeem=false;
        isErrorRedeem=true;
      });
    }
    else if(res==Constant().errExpToken){
      setState(() {
        isLoadingRedeem=false;
        isErrorRedeem=false;
        isTokenExpRedeem=true;
      });
    }
    else{
      if(this.mounted)
      setState(() {
        listRedeemModel = res;
        isLoadingRedeem=false;
        isErrorRedeem=false;
        isTokenExpRedeem=false;
      });
    }
  }
  Future postRedeem(idBarang)async{
    WidgetHelper().myPush(context,PinScreen(callback: (context,isTrue,pin)async{
      if(isTrue){
        final data={
          "ongkir":"0",
          "layanan_pengiriman":"-",
          "alamat":idAddress,
          "id_barang":idBarang.toString(),
          "pin_member":pin.toString()
        };

        WidgetHelper().loadingDialog(context);
        var res=await BaseProvider().postProvider('transaction/redeem', data);
        Navigator.pop(context);
        if(res==Constant().errTimeout||res==Constant().errSocket){
          WidgetHelper().notifDialog(context,"Informasi",Constant().msgConnection,(){
            WidgetHelper().myPushRemove(context,IndexScreen(currentTab: 2));
          },(){
            postRedeem(idBarang);
          },titleBtn1:"Kembali",titleBtn2: "Coba Lagi");
        }
        else if(res==Constant().errExpToken){
         WidgetHelper().notifOneBtnDialog(context,Constant().titleErrToken,Constant().descErrToken, ()async{
           FunctionHelper().logout(context);
         });
        }
        else{
          print(res);
          if(res is General){
            General result = res;
            print(result);
            if(result.status=='success'){
              WidgetHelper().notifOneBtnDialog(context,Constant().titleMsgSuccessTrx,Constant().descMsgSuccessTrx, ()async{
                WidgetHelper().myPushRemove(context,IndexScreen(currentTab: 2));
              });
            }
            else{
              WidgetHelper().showFloatingFlushbar(context,"failed",result.msg);
            }
          }
        }
      }
    }));
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }


  @override
  Widget build(BuildContext context) {
    return buildContent(context);
  }
  Widget buildContent(BuildContext context){
    return SafeArea(
      child: RefreshWidget(
        widget: DetailScaffold(
            hasPinnedAppBar: true,
            expandedHeight:90,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
              SliverAppBar(
                floating: false,
                pinned: true,
                expandedHeight: 90.0,
                flexibleSpace: HeaderWidget(),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  switch (index) {
                    case 0:
                      return section1(context);
                    case 1:
                      return section2(context);
                    case 2:
                      return Divider(thickness: 10.0,);
                    case 3:
                      return section6(context);
                    case 4:
                      return section3(context);
                    case 5:
                      return section4(context);
                    case 6:
                      return Container();
                    case 7:
                      return Container();
                    case 8:
                      return Container();
                    case 9:
                      return Container();
                    default:
                      return Container();
                  }
                }, childCount: 10),
              ),
            ]
        ),
        callback: (){
          loadData();
        },
      ),
    );
  }
  Widget section2(BuildContext context){
    return Container(
      padding: EdgeInsets.only(left:10.0,right:10.0,bottom:10.0,top:0.0),
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
              itemCount:  dataWallet.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: FlatButton(
                    onPressed: (){
                      if(dataWallet[index]['title']=='Top Up'){
                        WidgetHelper().myPush(context,FormTopupScreen());
                      }
                      if(dataWallet[index]['title']=='Transfer'){
                        WidgetHelper().myPush(context,FormTransferScreen());
                      }
                      if(dataWallet[index]['title']=='Penarikan'){
                        WidgetHelper().myPush(context,FormPenarikanScreen());
                      }
                    },
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                    padding: EdgeInsets.all(10.0),
                    color: Color(0xFFEEEEEE),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          dataWallet[index]['icon'],
                          height: 30,
                          width: 30,
                          color:Constant().secondColor
                        ),
                        SizedBox(height:5.0),
                        WidgetHelper().textQ(dataWallet[index]['title'],12,Constant().secondColor, FontWeight.bold,textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                );
              },
              staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
              mainAxisSpacing: 0.0,
              crossAxisSpacing: 20.0,
            ),
          ),

        ],
      ),
    );
  }
  
  Widget section1(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          isLoadingMember?MemberLoading():Row(
            children: <Widget>[
              CircleImage(
                param: 'network',
                key: Key("profile"),
                image: Constant().avatar,
                size: 50.0,
                padding: 0.0,
              ),
              SizedBox(
                width: 16,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  WidgetHelper().textQ("${dataMemberModel.result.fullName}",10,Constant().darkMode,FontWeight.bold),
                  const SizedBox(
                    height: 2,
                  ),
                  WidgetHelper().textQ("Rp ${FunctionHelper().formatter.format(int.parse(dataMemberModel.result.saldo))} .-",14,Constant().moneyColor,FontWeight.bold),
                  const SizedBox(
                    height: 4,
                  ),
                  WidgetHelper().textQ("${dataMemberModel.result.referralCode}",10,Constant().darkMode,FontWeight.bold),

                ],
              ),
              Flexible(
                flex: 1,
                child: Container(),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  color: Colors.black12,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                    child: Row(
                      children: <Widget>[
                        Image.network(dataMemberModel.result.membershipBadge,width: 16,height: 16),
                        const SizedBox(
                          width: 4,
                        ),
                        WidgetHelper().textQ("${dataMemberModel.result.membership}",10,Constant().darkMode,FontWeight.bold)
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height:10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width/2.2,
                child: FlatButton(
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                  padding: EdgeInsets.only(top:20.0,bottom:20.0,left:10.0),
                  color: Color(0xFFEEEEEE),
                  onPressed: (){},
                  child: Container(
                    padding:EdgeInsets.only(left:0.0),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                            Constant().localIcon+"lainnya_icon.svg",
                            height: 30,
                            width: 30,
                            color:Constant().secondColor
                        ),
                        // Icon(AntDesign.piechart,size:30.0,color: Constant().secondColor,),
                        SizedBox(width:10.0),
                        WidgetHelper().textQ("Pin Aktivasi",12,Constant().secondColor,FontWeight.bold)
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width/2.2,
                child: FlatButton(
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                  padding: EdgeInsets.only(top:20.0,bottom:20.0,left:10.0),
                  color: Color(0xFFEEEEEE),
                  onPressed: (){},
                  child: Container(
                    padding:EdgeInsets.only(left:0.0),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                            Constant().localIcon+"lainnya_icon.svg",
                            height: 30,
                            width: 30,
                            color:Constant().secondColor
                        ),
                        SizedBox(width:10.0),
                        WidgetHelper().textQ("Pin Repeat Order",12,Constant().secondColor,FontWeight.bold)
                      ],
                    ),
                  ),
                ),
              ),

            ],
          )
        ],
      ),
    );
  }
  Widget section3(BuildContext context){
    return Container(
      padding: EdgeInsets.only(top:10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            child: StaggeredGridView.countBuilder(
              shrinkWrap: true,
              primary: false,
              crossAxisCount: 5,
              itemCount:  data.length,
              itemBuilder: (BuildContext context, int index) {
                return WidgetHelper().myPress((){},
                    Container(
                      padding: EdgeInsets.only(left:10.0,right:10.0,bottom: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0),
                              child:CachedNetworkImage(
                                imageUrl:data[index],
                                width: double.infinity ,
                                fit:BoxFit.scaleDown,
                                placeholder: (context, url) => Image.network(Constant().noImage, fit:BoxFit.fill,width: double.infinity,),
                                errorWidget: (context, url, error) => Image.network(Constant().noImage, fit:BoxFit.fill,width: double.infinity,),
                              )
                          ),
                          SizedBox(height:5.0),
                          WidgetHelper().textQ("Pulsa",10,Constant().darkMode, FontWeight.bold,textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                    color: Colors.black38
                );
              },
              staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
              mainAxisSpacing: 20.0,
              crossAxisSpacing: 20.0,
            ),
          ),
          ListTile(
            onTap: (){WidgetHelper().myPush(context,NewsScreen());},
            contentPadding: EdgeInsets.only(left:10.0,right:10.0),
            leading: Icon(AntDesign.profile,size: 30.0,color:Constant().mainColor),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WidgetHelper().textQ("Berita Terbaru",12,Colors.black,FontWeight.bold),
                WidgetHelper().textQ("kumpulan berita terbaru seputar SanQu",10,Colors.grey[400],FontWeight.normal),
              ],
            ),
            trailing: Icon(Icons.arrow_right),
          )
        ],
      ),
    );
  }
  Widget section4(BuildContext context){
    return Container(
      height: 200,
      child: isLoadingNews?AddressLoading(tot: 1):ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: AlwaysScrollableScrollPhysics(),
        primary: true,
        // reverse:true ,
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
        itemCount: contentModel.result.data.length,
        itemBuilder: (context, index) {
          return NewsWidget(contentModel: contentModel,idx: index);
        },separatorBuilder: (context,index){return SizedBox(width: 10);},
      ),
    );
  }
  Widget section6(BuildContext context){
    return  Container(
      padding: EdgeInsets.only(left: 10, right: 10,bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            onTap: (){},
            contentPadding: EdgeInsets.only(left:0.0,right:0.0),
            leading: Icon(AntDesign.chrome,size: 30.0,color:Constant().mainColor),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WidgetHelper().textQ("Poin Anda",10,Constant().secondColor,FontWeight.normal),
                isLoadingMember?WidgetHelper().baseLoading(context,Container(
                  height: 15.0,
                  width:MediaQuery.of(context).size.width/10,
                  color: Colors.white,
                )):WidgetHelper().textQ("${FunctionHelper().formatter.format(poin)} POIN",14,Constant().moneyColor,FontWeight.bold),
              ],
            ),

            trailing: Icon(Icons.arrow_right),
          ),
          WidgetHelper().textQ("Redeem Poin RO Anda Dengan Hadiah - Hadiah Yang Menarik",10,Colors.grey[400],FontWeight.normal),
          SizedBox(height:5.0),
          Container(
            height: 300,
            child: isLoadingRedeem?loadingSecion6(context):ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: AlwaysScrollableScrollPhysics(),
              primary: true,
              padding: EdgeInsets.only(left: 0, right: 0, bottom: 0),
              itemCount: listRedeemModel.result.data.length,
              itemBuilder: (context, index) {
                int stock = int.parse(listRedeemModel.result.data[index].stock);
                int points=int.parse(listRedeemModel.result.data[index].harga);
                Color colorBadge = Constant().moneyColor;
                String status='${FunctionHelper().formatter.format(points)} POIN';
                bool isTrue=true;
                if(poin<points){
                  colorBadge = Constant().secondColor;
                  status='Poin Tidak Cukup';
                  isTrue=false;
                }
                if(stock<1){
                  colorBadge = Constant().darkMode;
                  status='Stock Tidak Tersedia';
                  isTrue=false;
                }
                return Container(
                  child: FlatButton(
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                    padding: EdgeInsets.all(0.0),
                    color: Color(0xFFEEEEEE),
                    onPressed: (){
                      if(isTrue){
                        WidgetHelper().myModal(context, Container(
                          height: MediaQuery.of(context).size.height/1.2,
                          child: AddressScreen(idx: idxAddress,callback: (val,idx){
                            Prefix2.Datum datum = val;
                            setState(() {
                              idxAddress=idx;
                              idAddress=datum.id;
                            });
                            postRedeem(listRedeemModel.result.data[index].id);
                          },),
                        ));
                      }
                    },
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Container(
                          width: (MediaQuery.of(context).size.width - 57) * 0.5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(0),
                                    topRight: Radius.circular(0)),
                                child: Container(
                                  height: 150,
                                  width: double.infinity,
                                  child: CachedNetworkImage(
                                    imageUrl: listRedeemModel.result.data[index].gambar,
                                    width: double.infinity ,
                                    fit:BoxFit.fill,
                                    placeholder: (context, url) => Image.network('https://allrelease.id/wp-content/uploads/2020/03/Telkomsel-Tanggap-Covid-19.jpg', fit:BoxFit.fill,width: double.infinity,),
                                    errorWidget: (context, url, error) => Image.network('https://allrelease.id/wp-content/uploads/2020/03/Telkomsel-Tanggap-Covid-19.jpg', fit:BoxFit.fill,width: double.infinity,),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    WidgetHelper().textQ('Stok barang ${FunctionHelper().formatter.format(stock)}', 10,Constant().darkMode,FontWeight.normal,maxLines:3 ),
                                    SizedBox(height: 14),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                      child: WidgetHelper().textQ('$status', 12,Constant().secondDarkColor,FontWeight.bold,maxLines:3,textAlign: TextAlign.center),
                                      color: colorBadge,
                                      width: double.infinity,
                                    ),
                                    SizedBox(height: 14),
                                    WidgetHelper().textQ('${listRedeemModel.result.data[index].deskripsi}', 10,Constant().darkMode,FontWeight.normal,maxLines:3 ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 6,
                          right: 10,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0)), color:Constant().mainColor),
                            alignment: AlignmentDirectional.center,
                            child: WidgetHelper().textQ('${listRedeemModel.result.data[index].title}', 10,Constant().secondDarkColor,FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },separatorBuilder: (context,index){return SizedBox(width: 10);},
            ),
          )
        ],
      ),
    );
  }
  Widget loadingSecion6(BuildContext context){
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      physics: AlwaysScrollableScrollPhysics(),
      primary: true,
      padding: EdgeInsets.only(left: 0, right: 0, bottom: 0),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          enabled: true,
          child: Padding(
            padding: const EdgeInsets.only(left:0.0,right:0.0,bottom:0.0),
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  width: MediaQuery.of(context).size.width/2,
                  height: MediaQuery.of(context).size.width/1.8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  width: MediaQuery.of(context).size.width/3,
                  height: 5.0,
                  color: Colors.white,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  width: MediaQuery.of(context).size.width/2,
                  height: 20.0,
                  color: Colors.white,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  width: MediaQuery.of(context).size.width/3,
                  height: 5.0,
                  color: Colors.white,
                ),

              ],
            ),
          ),
        );
      },separatorBuilder: (context,index){return SizedBox(width: 10);},
    );
  }
}

double getWidth(BuildContext context){
  return MediaQuery.of(context).size.width;
}

double getHeight(BuildContext context){
  return MediaQuery.of(context).size.height;
}

class InfoCard extends StatelessWidget {
  final Function onpress;
  final String imgpath;
  final String title;
  final String desc;
  final String textbutton;

  const InfoCard({
    Key key,
    this.title,
    this.desc,
    this.imgpath,
    this.textbutton,
    this.onpress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double radius = 8.0;
    return GestureDetector(
      onTap: onpress,
      child: Container(
        decoration: BoxDecoration(
          // color: Colors.redAccent,
          color: Colors.black12,
          // boxShadow: [
          //   BoxShadow(
          //       offset: Offset(0, 3),
          //       color: Colors.black.withOpacity(0.15),
          //       blurRadius: 8)
          // ],
          borderRadius: BorderRadius.circular(radius),
        ),
        width: (MediaQuery.of(context).size.width - 57) * 0.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(radius)),
              child: Container(
                height: 83,
                width: double.infinity,
                child: Image.network(
                  imgpath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(9, 13, 9, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  SizedBox(height: 14),
                  Text(
                    desc,
                    style: TextStyle(fontSize: 12, color: Constant().darkMode),
                  ),
                  SizedBox(
                    height: 28,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      textbutton,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Constant().mainDarkColor),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
