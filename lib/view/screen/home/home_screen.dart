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
         WidgetHelper().notifOneBtnDialog(context,"Sesi anda sudah berakhir","Silahkan login ulang untuk melanjutkan proses ini", ()async{
           FunctionHelper().logout(context);
         });
        }
        else{
          print(res);
          if(res is General){
            General result = res;
            print(result);
            if(result.status=='success'){
              WidgetHelper().notifOneBtnDialog(context,"Transaksi Berhasil","Terimakasih Telah Melakukan Transaksi disini", ()async{
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
                      return Divider(thickness: 10.0,);
                    case 2:
                      return  section2(context);
                    case 3:
                      return Divider(thickness: 10.0,);
                    case 4:
                      return section5(context);
                    case 5:
                      return Divider(thickness: 10.0,);
                    case 6:
                      return section3(context);
                    case 7:
                      return section4(context);
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

  
  Widget section1(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          isLoadingMember?WidgetHelper().baseLoading(context,ClipRRect(
            borderRadius: BorderRadius.circular((50.0 + 0.0) / 2),
            child: Container(
              height: 50.0,
              width: 50.0,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(0.0),
              ),
            ),
          )):CircleImage(
            param: 'network',
            key: Key("profile"),
            image: dataMemberModel.result.picture,
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
              isLoadingMember?WidgetHelper().baseLoading(context,Container(
                height: 10.0,
                width: 100.0,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(0.0),
                ),
              )):WidgetHelper().textQ("${dataMemberModel.result.fullName}",10,Constant().darkMode,FontWeight.bold),
              const SizedBox(
                height: 2,
              ),
              isLoadingMember?WidgetHelper().baseLoading(context,Container(
                height: 10.0,
                width: 100.0,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(0.0),
                ),
              )):WidgetHelper().textQ("Rp ${FunctionHelper().formatter.format(int.parse(dataMemberModel.result.saldo))} .-",14,Constant().moneyColor,FontWeight.bold),
              const SizedBox(
                height: 4,
              ),
              isLoadingMember?WidgetHelper().baseLoading(context,Container(
                height: 10.0,
                width: 100.0,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(0.0),
                ),
              )):WidgetHelper().textQ("${dataMemberModel.result.referralCode}",10,Constant().darkMode,FontWeight.bold),

            ],
          ),
          Flexible(
            flex: 1,
            child: Container(),
          ),
          isLoadingMember?WidgetHelper().baseLoading(context,Container(
            height: 20.0,
            width: 50.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.all(0.0),
            ),
          )):ClipRRect(
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
    );
  }
  Widget section2(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width/2.2,
            child: FlatButton(
              padding: EdgeInsets.all(10.0),
              color: Color(0xFFEEEEEE),
              onPressed: (){},
              child: Container(
                padding:EdgeInsets.only(top:10.0,bottom:10.0),
                child: Row(
                  children: [
                    Icon(AntDesign.chrome,color: Constant().mainColor,),
                    SizedBox(width:10.0),
                    WidgetHelper().textQ("PIN RO",12,Constant().darkMode,FontWeight.bold,letterSpacing: 2.0)
                  ],
                ),
              ),
            ),
          ),
        Container(
          width: MediaQuery.of(context).size.width/2.2,
          child: FlatButton(
            padding: EdgeInsets.all(10.0),
            color: Color(0xFFEEEEEE),
            onPressed: (){},
            child: Container(
              padding:EdgeInsets.only(top:10.0,bottom:10.0),
              child: Row(
                children: [
                  Icon(AntDesign.chrome,color: Constant().mainColor,),
                  SizedBox(width:10.0),
                  WidgetHelper().textQ("PIN AKTIVASI",12,Constant().darkMode,FontWeight.bold,letterSpacing: 2.0)
                ],
              ),
            ),
          ),
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
            leading: Icon(AntDesign.profile,size: 40.0,color:Constant().mainColor),
            title: WidgetHelper().textQ("Berita Terbaru",12,Colors.black,FontWeight.bold),
            subtitle:WidgetHelper().textQ("kumpulan berita terbaru seputar SanQu",10,Colors.grey[400],FontWeight.normal),
            trailing: Icon(AntDesign.doubleright,size:15.0),
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
  Widget section5(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          onTap: (){},
          contentPadding: EdgeInsets.only(left:10.0,right:10.0),
          leading: Icon(AntDesign.chrome,size: 40.0,color:Constant().mainColor),
          title: WidgetHelper().textQ("Poin Anda",10,Constant().secondColor,FontWeight.normal),
          subtitle:isLoadingMember?WidgetHelper().baseLoading(context,Container(
            height: 15.0,
            width:MediaQuery.of(context).size.width/10,
            color: Colors.white,
          )):WidgetHelper().textQ("${FunctionHelper().formatter.format(poin)} POIN",14,Constant().moneyColor,FontWeight.bold),
          trailing: Icon(AntDesign.doubleright,size:15.0),
        ),
        Padding(
          padding: EdgeInsets.only(left:10.0,bottom:10.0),
          child: WidgetHelper().textQ("Redeem Poin RO Anda Dengan Hadiah - Hadiah Yang Menarik",10,Constant().secondColor,FontWeight.normal),
        ),
        isLoadingRedeem?NewsLoading():new StaggeredGridView.countBuilder(
          primary: false,
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 4,
          itemCount: listRedeemModel.result.data.length,
          itemBuilder: (BuildContext context, int index) {
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
            return WidgetHelper().myPress((){
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
            },Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(6),
                            topRight: Radius.circular(6),
                          ),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: listRedeemModel.result.data[index].gambar,
                          width: double.infinity ,
                          fit:BoxFit.fill,
                          placeholder: (context, url) => Image.network('https://allrelease.id/wp-content/uploads/2020/03/Telkomsel-Tanggap-Covid-19.jpg', fit:BoxFit.fill,width: double.infinity,),
                          errorWidget: (context, url, error) => Image.network('https://allrelease.id/wp-content/uploads/2020/03/Telkomsel-Tanggap-Covid-19.jpg', fit:BoxFit.fill,width: double.infinity,),
                        ),
                      ),
                      SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                        child: WidgetHelper().textQ('Stok barang ${FunctionHelper().formatter.format(stock)}', 10,Constant().darkMode,FontWeight.normal,maxLines:3 ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                        child: WidgetHelper().textQ('$status', 12,Constant().secondDarkColor,FontWeight.bold,maxLines:3,textAlign: TextAlign.center),
                        color: colorBadge,
                        width: double.infinity,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: WidgetHelper().textQ('${listRedeemModel.result.data[index].deskripsi}', 10,Constant().darkMode,FontWeight.normal,maxLines:3 ),
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
            ));
          },
          staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
          mainAxisSpacing: 15.0,
          crossAxisSpacing: 15.0,
        )
      ],
    );
  }
  
  
}

double getWidth(BuildContext context){
  return MediaQuery.of(context).size.width;
}

double getHeight(BuildContext context){
  return MediaQuery.of(context).size.height;
}