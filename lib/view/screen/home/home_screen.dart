part of '../pages.dart';


class HomeScreen extends StatefulWidget {
  final dynamic dataMember;
  HomeScreen({this.dataMember});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool isLoadingNews=false,isErrorNews=false,isTokenExpNews=false;
  bool isLoadingRedeem=false,isErrorRedeem=false,isTokenExpRedeem=false;
  bool isLoadingMember=false;
  int idxAddress=0;
  String idAddress='';
  ContentModel contentModel;
  ListRedeemModel listRedeemModel;
  Future loadData()async{
    setState(() {
      isLoadingRedeem=true;
      isLoadingNews=true;
    });
    loadRedeem();
    loadNews();
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
    print(widget.dataMember);
    return SafeArea(
      child:  WrapperPageWidget(
        dataMember: widget.dataMember,
        children: [
          Container(
            height: 90,
            child: StaggeredGridView.countBuilder(
              padding: EdgeInsets.all(0.0),
              shrinkWrap: true,
              primary: false,
              scrollDirection: Axis.horizontal,
              crossAxisCount: 2,
              itemCount:  DataHelper.dataProfile.length,
              itemBuilder: (BuildContext context, int index) {
                IconData icon;
                String title='';
                Color color;
                String value='';
                if(index==0){icon=AntDesign.team;title='Sponsor';color=Color(0xFF007bff);value=widget.dataMember['sponsor'];}
                if(index==1){icon=AntDesign.pptfile1;title='SangQuota';color=Color(0xFFffc107);value='${widget.dataMember['plafon']}'.split(".")[0];}
                if(index==2){icon=AntDesign.leftcircleo;title='Reward';color=Color(0xFF28a745);value='${widget.dataMember['left_reward_point']} | ${widget.dataMember['right_reward_point']}';}
                if(index==3){icon=AntDesign.rightcircleo;title='PV Kanan';color=Color(0xFFdc3545);value=widget.dataMember['right_pv'];}
                return Container(
                  child: FlatButton(
                    onPressed: ()async{
                      await MemberProvider().getDataMember();
                    },
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.0)),
                    padding: EdgeInsets.all(10.0),
                    color: Color(0xFFEEEEEE),
                    child: Row(
                      children: [
                        Icon(icon,size: 10.0,color: color),
                        SizedBox(width:5.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WidgetHelper().textQ(title,8,Constant().secondColor, FontWeight.normal,textAlign: TextAlign.left),
                            WidgetHelper().textQ(value,8,Constant().secondColor, FontWeight.normal,textAlign: TextAlign.left),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              staggeredTileBuilder: (int index) => new StaggeredTile.fit(10),
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 0.0,
            ),
          ),
          ChartWidgetHome1(data: widget.dataMember),
          section1(context),
          section2(context),
          Divider(thickness: 10.0),
          section6(context),
          section3(context),
          section4(context)
        ],
        action: HeaderWidget(title: 'HOME',action: WidgetHelper().myNotif(context,(){},Colors.redAccent)),
      ),
    );
  }
  
  
  Widget section1(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: StaggeredGridView.countBuilder(
        shrinkWrap: true,
        primary: false,
        crossAxisCount: 2,
        itemCount:  DataHelper.dataStockist.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(

            child: FlatButton(
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(4.0)),
              padding: EdgeInsets.only(top:10.0,bottom:10.0,left:10.0),
              color: Color(0xFFEEEEEE),
              onPressed: (){
                WidgetHelper().myPush(context,StockistScreen(type:DataHelper.dataStockist[index]['type']));
              },
              child: Container(
                child: Column(
                  children: [
                    SvgPicture.asset(
                        DataHelper.dataStockist[index]['icon'],
                        height: 30,
                        width: 30,
                        color:Constant().secondColor
                    ),
                    SizedBox(height:5.0),
                    WidgetHelper().textQ(DataHelper.dataStockist[index]['title'],12,Constant().secondColor,FontWeight.bold)
                  ],
                ),
              ),
            ),
          );
        },
        staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
        mainAxisSpacing: 0.0,
        crossAxisSpacing: 20.0,
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
              itemCount:  DataHelper.dataWallet.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: FlatButton(
                    onPressed: (){
                      WidgetHelper().myPush(context,FormEwalletScreen(dataMember: widget.dataMember,title:DataHelper.dataWallet[index]['title'].toUpperCase()));
                    },
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(4.0)),
                    padding: EdgeInsets.all(10.0),
                    color: Color(0xFFEEEEEE),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                            DataHelper.dataWallet[index]['icon'],
                            height: 30,
                            width: 30,
                            color:Constant().secondColor
                        ),
                        SizedBox(height:5.0),
                        WidgetHelper().textQ(DataHelper.dataWallet[index]['title'],12,Constant().secondColor, FontWeight.bold,textAlign: TextAlign.center),
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
  Widget section3(BuildContext context){
    return Container(
      padding: EdgeInsets.only(top:10,left:10.0,right:10.0),
      child: MenuPPOBScreen(),
    );
  }
  Widget section4(BuildContext context){
    return Container(
      padding: EdgeInsets.only(top:0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
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
          ),
          Container(
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
          )
        ],
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
                WidgetHelper().textQ("Poin Anda",12,Constant().secondColor,FontWeight.normal),
                isLoadingMember?WidgetHelper().baseLoading(context,Container(
                  height: 15.0,
                  width:MediaQuery.of(context).size.width/10,
                  color: Colors.white,
                )):WidgetHelper().textQ("${FunctionHelper().formatter.format(int.parse(widget.dataMember['point_ro'].split(".")[0]))} POIN",14,Constant().moneyColor,FontWeight.bold),
              ],
            ),
            trailing: Icon(Icons.arrow_right),
          ),
          WidgetHelper().textQ("Redeem Poin RO Anda Dengan Hadiah - Hadiah Yang Menarik",12,Colors.grey,FontWeight.normal),
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
                if(int.parse(widget.dataMember['point_ro'].split(".")[0])<points){
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
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(4.0)),
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
                                    placeholder: (context, url) => Image.asset(Constant().localAssets+"logo.png", fit:BoxFit.cover),
                                    errorWidget: (context, url, error) => Image.asset(Constant().localAssets+"logo.png", fit:BoxFit.cover),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    WidgetHelper().textQ('Stok barang ${FunctionHelper().formatter.format(stock)}', 12,Constant().darkMode,FontWeight.bold),
                                    SizedBox(height: 14),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                      child: WidgetHelper().textQ('$status', 12,Constant().secondDarkColor,FontWeight.bold,maxLines:3,textAlign: TextAlign.center),
                                      color: colorBadge,
                                      width: double.infinity,
                                    ),
                                    SizedBox(height: 14),
                                    WidgetHelper().textQ('${listRedeemModel.result.data[index].deskripsi}', 12,Constant().darkMode,FontWeight.normal,maxLines:3 ),
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
