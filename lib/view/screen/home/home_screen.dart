part of '../pages.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin  {
  @override
  bool get wantKeepAlive => true;
  final GlobalKey<AnimatedListState> _listKey = new GlobalKey<AnimatedListState>();
  int perpageTestimoni=6,totalTestimoni=0;
  bool isLoadingNews=false;
  bool isLoadingRedeem=false;
  bool isLoadingMember=false;
  bool isLoadingTestimoni=false,isLoadmoreTestimoni=false;
  TestimoniModel testimoniModel;
  ContentModel contentModel;
  ListRedeemModel listRedeemModel;

  Future loadData()async{
    isLoadingRedeem=true;
    isLoadingNews=true;
    isLoadingTestimoni=true;
    if(this.mounted) setState(() {});
    loadRedeem();
    loadNews();
    loadTestimoni();
  }
  Future loadNews()async{
    var res=await BaseProvider().getProvider("content/berita?page=1&perpage=10", contentModelFromJson);
    if(res is ContentModel){
      ContentModel result=res;
      contentModel = result;
      isLoadingNews=false;
      if(this.mounted) setState(() {});
    }

  }
  Future loadRedeem()async{
    var res=await BaseProvider().getProvider("redeem/barang?page=1&perpage=5", listRedeemModelFromJson);
    if(res is ListRedeemModel){
      ListRedeemModel result=res;
      listRedeemModel = result;
      isLoadingRedeem=false;
      if(this.mounted) setState(() {});
    }
  }
  Future loadTestimoni()async{
    var res=await BaseProvider().getProvider("content/testimoni?page=1&perpage=$perpageTestimoni", testimoniModelFromJson);
    if(res is TestimoniModel){
      TestimoniModel result=res;
      testimoniModel = result;
      isLoadingTestimoni=false;
      isLoadmoreTestimoni=false;
      totalTestimoni=testimoniModel.result.total;
      if(this.mounted) setState(() {});
    }
  }
  String refer='';
  Future getLink()async{
    final ref = await DynamicLinksApi().createReferralLink('1234567');
    setState(() {
      refer = ref.toString();
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();

  }
  @override
  void dispose() {
    super.dispose();
  }
  dynamic dataMember;
  @override
  Widget build(BuildContext context) {
    print("================================================================");
    print(dataMember);
    print("================================================================");
    super.build(context);
    ScreenScaler scaler = ScreenScaler()..init(context);

    return SafeArea(
      child:  RefreshWidget(
        widget:WrapperPageWidget(
          children: [
            Container(
              child: StaggeredGridView.countBuilder(
                padding: EdgeInsets.all(0.0),
                shrinkWrap: true,
                primary: false,
                crossAxisCount: 3,
                itemCount: DataHelper.dataProfile.length,
                itemBuilder: (context,index){
                  IconData icon;
                  String title='';
                  Color color;
                  String value='';
                  if(index==0&&dataMember!=null){icon=AntDesign.team;title='Sponsor';color=Color(0xFF007bff);value=dataMember['sponsor'];}
                  if(index==1&&dataMember!=null){
                    icon=AntDesign.pptfile1;title='SangQuota';color=Color(0xFFffc107);
                    value='Rp '+FunctionHelper().formatter.format(int.parse('${dataMember['plafon']}'.split(".")[0]))+' .-';
                  }
                  if(index==2&&dataMember!=null){icon=AntDesign.leftcircleo;title='Reward';color=Color(0xFF28a745);value='kiri ${dataMember['left_reward_point']} | kanan ${dataMember['right_reward_point']}';}
                  return dataMember==null?WidgetHelper().baseLoading(context,Container(
                    color: Colors.white,
                    height: 50,
                    width: double.infinity,
                  )):Container(
                    padding: scaler.getPadding(1,1),
                    decoration: BoxDecoration(
                      color:Color(0xFF732044),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            WidgetHelper().textQ(title,scaler.getTextSize(8),Color(0xFFffc107), FontWeight.normal,textAlign: TextAlign.left),
                            SizedBox(height: scaler.getHeight(0.3)),
                            WidgetHelper().textQ(value,scaler.getTextSize(8),Color(0xFFffc107), FontWeight.bold,textAlign: TextAlign.left),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
                mainAxisSpacing: 0.0,
                crossAxisSpacing: 1.0,
              ),
            ),
            dataMember!=null?ChartWidgetHome1(data:dataMember):WidgetHelper().baseLoading(context,Container(
              padding: EdgeInsets.only(left:20.0),
              child: Row(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left:20.0),
                    child: Column(
                      children: [
                        Container(
                            height: 10,
                            width: 100,
                            color: Colors.white
                        ),
                        SizedBox(height:10),
                        Container(
                            height: 10,
                            width: 100,
                            color: Colors.white
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
            if(dataMember!=null)SizedBox(height: scaler.getHeight(0)),
            section2(context),
            Divider(thickness:scaler.getHeight(1)),
            section6(context),
            Divider(thickness:scaler.getHeight(1)),
            section3(context),
            Divider(thickness:scaler.getHeight(1)),
            section4(context),
            Divider(thickness:scaler.getHeight(1)),
            testimoni(context),

          ],
          title:'Home',
          callback: (data){
            setState(() {
              dataMember=data;
            });
          },
        ),
        callback: (){
          setState(() {});
          loadData();
        },
      ),
    );
  }
  Widget section2(BuildContext context){
    ScreenScaler scaler = ScreenScaler()..init(context);
    return Container(
      padding: scaler.getPadding(0,0),
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
                      if(DataHelper.dataWallet[index]['type']=='h'){
                        return WidgetHelper().myPush(context,HistoryTransactionScreen());
                      }
                      if(DataHelper.dataWallet[index]['type']!=''){
                        // return WidgetHelper().myPush(context,StockistScreen(type:DataHelper.dataWallet[index]['type']));
                        return WidgetHelper().myPush(context,PinAktivasiScreen());
                      }else{
                        return WidgetHelper().myPush(context,FormEwalletScreen(title:DataHelper.dataWallet[index]['title'].toUpperCase()));
                      }

                    },
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(4.0)),
                    padding: EdgeInsets.all(0.0),
                    // color: Color(0xFFEEEEEE),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                            DataHelper.dataWallet[index]['icon'],
                            height: scaler.getHeight(3),
                            width: scaler.getWidth(10),
                            color:Constant().mainColor1
                        ),
                        SizedBox(height:5.0),
                        WidgetHelper().textQ(DataHelper.dataWallet[index]['title'],scaler.getTextSize(9),Constant().darkMode, FontWeight.bold,textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                );
              },
              staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 0.0,
            ),
          ),
        ],
      ),
    );
  }
  Widget section3(BuildContext context){
    ScreenScaler scaler = ScreenScaler()..init(context);
    return Container(
      padding: scaler.getPadding(1,2),
      child: MenuPPOBScreen(),
    );
  }
  static const double padding = 16;
  static const double spacing = 8;
  static const int crossAxisCount = 2;

  Widget section4(BuildContext context){
    ScreenScaler scaler = ScreenScaler()..init(context);

    return Container(
      padding: EdgeInsets.only(top:0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: scaler.getPadding(1,2),
            child: WidgetHelper().titleQ(
              context,
              'Berita Terbaru',
              'Kumpulan berita terbaru seputar SangQu',
              icon: Ionicons.ios_paper,
              param: 'with',
              callback:(){WidgetHelper().myPush(context,NewsScreen());}
            ),
          ),

          Container(
            height: scaler.getHeight(50),
            child: isLoadingNews?AddressLoading(tot: 1):GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 2/2,
                mainAxisSpacing: spacing,
                crossAxisSpacing: spacing,
              ),
              scrollDirection: Axis.horizontal,
              physics: AlwaysScrollableScrollPhysics(),
              primary: true,
              // reverse:true ,
              padding: scaler.getPadding(0,2),
              itemCount: contentModel.result.data.length,
              itemBuilder: (context, index) {
                return NewsWidget(contentModel: contentModel,idx: index);
              },
            ),
          )
        ],
      ),
    );
  }
  Widget section6(BuildContext context){
    ScreenScaler scaler = ScreenScaler()..init(context);
    return  Container(
      padding: scaler.getPadding(1,2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          WidgetHelper().titleQ(
            context,
            'Poin Anda',
            dataMember==null?"":"${FunctionHelper().toRp(int.parse(FunctionHelper().rmTitik(dataMember['point_ro'], 0)))} poin",
            icon: Ionicons.logo_chrome,
            param: 'with',
            callback:(){WidgetHelper().myPush(context,IndexScreen(currentTab: 0));},
            colorDesc: Constant().moneyColor,
            fontWeight: FontWeight.bold
          ),
          SizedBox(height:scaler.getHeight(1)),
          WidgetHelper().textQ("Silahkan Redeem Poin RO Anda Dengan Hadiah - Hadiah Dibawah Ini !",scaler.getTextSize(9),Constant().darkMode,FontWeight.normal),
          SizedBox(height:scaler.getHeight(0.5)),
          Container(
            height: scaler.getHeight(25),
            child: isLoadingRedeem||dataMember==null?RedeemHorizontalLoading():ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: AlwaysScrollableScrollPhysics(),
              primary: true,
              padding: EdgeInsets.only(left: 0, right: 0, bottom: 0),
              itemCount: listRedeemModel.result.data.length,
              itemBuilder: (context, index) {
                return RedeemWidget(data:listRedeemModel.result.data[index].toJson()..addAll({'point_ro':dataMember['point_ro']}));
              },separatorBuilder: (context,index){return SizedBox(width: 10);},
            ),
          )
        ],
      ),
    );
  }
  Widget testimoni(BuildContext context){
    ScreenScaler scaler = ScreenScaler()..init(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: scaler.getPadding(1,2),
          child: WidgetHelper().titleQ(
            context,
            'Apa Kata Mereka',
            "Kata mereka tentang SangQu",
            icon: AntDesign.star,
            param: 'with',
            callback:(){WidgetHelper().myPush(context,TestimoniScreen());},
          ),
        ),
        isLoadingTestimoni?TestimoniLoading():
        Container(
          height: scaler.getHeight(25),
          child:ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: AlwaysScrollableScrollPhysics(),
            primary: true,
            padding:scaler.getPadding(0,2),
            shrinkWrap: true,
            itemCount: testimoniModel.result.data.length,
            itemBuilder: (context, index) {
              var val=testimoniModel.result.data[index];
              return FlatButton(
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                padding: EdgeInsets.all(0.0),
                onPressed: (){
                  WidgetHelper().myModal(context,Container(
                      height: MediaQuery.of(context).size.height/1.2,
                      child: ModalDetailTestimoni(val: val.toJson())
                  ));
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
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              height: scaler.getHeight(12),
                              width: double.infinity,
                              child: WidgetHelper().baseImage(val.picture,fit: BoxFit.cover),
                            ),
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Icon(FontAwesome.quote_left,size: 10,color: Colors.grey,),
                                      ),
                                      SizedBox(height:scaler.getHeight(0.5)),
                                      Center(
                                        child: WidgetHelper().textQ(val.caption, scaler.getTextSize(9),Colors.black,FontWeight.normal,maxLines: 4,textAlign: TextAlign.center),
                                      ),
                                      SizedBox(height:scaler.getHeight(0.5)),
                                      Center(
                                        child: Icon(FontAwesome.quote_left,size: 10,color: Colors.grey,),
                                      ),

                                    ],
                                  ),
                                )

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    val.video!='-'?Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                          padding: scaler.getPadding(0,2),
                          // decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)), color:Constant().mainColor),
                          alignment: AlignmentDirectional.center,
                          child:Icon(AntDesign.videocamera,color:Constant().mainColor,size: scaler.getTextSize(10))
                      ),
                    ):Text('')
                  ],
                ),
              );
            },separatorBuilder: (context,index){return SizedBox(width: 10);},
          ),
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
