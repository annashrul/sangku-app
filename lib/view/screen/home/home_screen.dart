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
    var res=await BaseProvider().getProvider("content/berita?page=1&perpage=10", contentModelFromJson,context: context,callback: (){
      setState(() {
        isLoadingNews=false;
      });
      loadNews();
    });
    if(res is ContentModel){
      ContentModel result=res;
      contentModel = result;
      isLoadingNews=false;
      if(this.mounted) setState(() {});
    }

  }
  Future loadRedeem()async{
    var res=await BaseProvider().getProvider("redeem/barang?page=1&perpage=5", listRedeemModelFromJson,context: context,callback: (){
      setState(() {
        isLoadingRedeem=false;
      });
      loadRedeem();
    });
    if(res is ListRedeemModel){
      ListRedeemModel result=res;
      listRedeemModel = result;
      isLoadingRedeem=false;
      if(this.mounted) setState(() {});
    }
  }
  Future loadTestimoni()async{
    var res=await BaseProvider().getProvider("content/testimoni?page=1&perpage=$perpageTestimoni", testimoniModelFromJson,context: context,callback: (){
      setState(() {
        isLoadingRedeem=false;
      });
      loadTestimoni();
    });
    if(res is TestimoniModel){
      TestimoniModel result=res;
      testimoniModel = result;
      isLoadingTestimoni=false;
      isLoadmoreTestimoni=false;
      totalTestimoni=testimoniModel.result.total;
      if(this.mounted) setState(() {});
    }


    // var res = await ContentProvider().loadTestimoni("perpage=$perpageTestimoni");
    // testimoniModel = res;
    // isLoadingTestimoni=false;
    // totalTestimoni=testimoniModel.result.total;
    // isLoadmoreTestimoni=false;
    // if(this.mounted) setState(() {});
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
    return SafeArea(
      child:  RefreshWidget(
        widget:WrapperPageWidget(
          children: [
            Container(
              // height:50,
              padding: EdgeInsets.only(left:0),
              child: StaggeredGridView.countBuilder(
                shrinkWrap: true,
                primary: false,
                padding: EdgeInsets.only(top:10),
                // scrollDirection: Axis.horizontal,
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
                    padding: EdgeInsets.only(top:10,bottom: 10),
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
                            WidgetHelper().textQ(title,10,Color(0xFFffc107), FontWeight.normal,textAlign: TextAlign.left),
                            WidgetHelper().textQ(value,12,Color(0xFFffc107), FontWeight.bold,textAlign: TextAlign.left),
                          ],
                        ),
                        // SizedBox(width:7.5),
                      ],
                    ),
                  );
                },
                staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
                mainAxisSpacing: 10.0,
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
            SizedBox(height:10),
            section2(context),
            Divider(thickness: 10.0),
            section6(context),
            Divider(thickness: 10.0),
            section3(context),
            Divider(thickness: 10.0),
            section4(context),
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
                      if(DataHelper.dataWallet[index]['type']=='h'){
                        return WidgetHelper().myPush(context,HistoryTransactionScreen());
                      }
                      if(DataHelper.dataWallet[index]['type']!=''){
                        return WidgetHelper().myPush(context,StockistScreen(type:DataHelper.dataWallet[index]['type']));
                      }else{
                        return WidgetHelper().myPush(context,FormEwalletScreen(title:DataHelper.dataWallet[index]['title'].toUpperCase()));
                      }

                    },
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(4.0)),
                    padding: EdgeInsets.all(10.0),
                    // color: Color(0xFFEEEEEE),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                            DataHelper.dataWallet[index]['icon'],
                            height: 30,
                            width: 30,
                            color:Constant().mainColor1
                        ),
                        SizedBox(height:5.0),
                        WidgetHelper().textQ(DataHelper.dataWallet[index]['title'],12,Constant().darkMode, FontWeight.bold,textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                );
              },
              staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
              mainAxisSpacing: 0.0,
              crossAxisSpacing: 0.0,
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
  static const double padding = 16;
  static const double spacing = 8;
  static const int crossAxisCount = 2;

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
            leading: Icon(AntDesign.profile,color:Constant().mainColor),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WidgetHelper().textQ("Berita Terbaru",12,Constant().darkMode,FontWeight.bold),
                WidgetHelper().textQ("Kumpulan berita terbaru seputar SangQu",12,Constant().darkMode,FontWeight.normal),
              ],
            ),
            trailing: Icon(Icons.arrow_right),
          ),
          Container(
            height: MediaQuery.of(context).size.height/2,
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
              padding: EdgeInsets.only(left: 10, right: 15, bottom: 10),
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
    return  Container(
      padding: EdgeInsets.only(left: 10, right: 10,bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            onTap: (){WidgetHelper().myPush(context,IndexScreen(currentTab: 0));},
            contentPadding: EdgeInsets.only(left:0.0,right:0.0),
            leading: Icon(AntDesign.chrome,color:Constant().mainColor),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WidgetHelper().textQ("Poin Anda",12,Constant().darkMode,FontWeight.bold),
                dataMember==null?WidgetHelper().baseLoading(context,Container(
                  height: 15.0,
                  width:MediaQuery.of(context).size.width/10,
                  color: Colors.white,
                )):WidgetHelper().textQ("${FunctionHelper().formatter.format(int.parse(dataMember['point_ro'].split(".")[0]))} POIN",14,Constant().moneyColor,FontWeight.bold),
                // )):WidgetHelper().textQ("${FunctionHelper().formatter.format(int.parse('0'))} POIN",14,Constant().moneyColor,FontWeight.bold),
              ],
            ),
            trailing: Icon(Icons.arrow_right),
          ),
          WidgetHelper().textQ("Silahkan Redeem Poin RO Anda Dengan Hadiah - Hadiah Dibawah Ini !",12,Constant().darkMode,FontWeight.normal),
          SizedBox(height:5.0),
          Container(
            height: 240,
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          trailing: Icon(Icons.arrow_right),
          onTap: (){WidgetHelper().myPush(context,TestimoniScreen());},
          contentPadding: EdgeInsets.only(left:10.0,right:10.0),
          leading: Icon(AntDesign.star,color:Constant().mainColor),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WidgetHelper().textQ("Apa Kata Mereka",12,Constant().darkMode,FontWeight.bold),
              WidgetHelper().textQ("Kata mereka tentang SangQu",12,Constant().darkMode,FontWeight.normal),
            ],
          ),

        ),

        isLoadingTestimoni?TestimoniLoading():
        Container(
          padding: EdgeInsets.only(left:0),
          height: MediaQuery.of(context).size.height/1.8,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2/2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            scrollDirection: Axis.horizontal,
            physics: AlwaysScrollableScrollPhysics(),
            primary: true,
            // reverse:true ,
            padding: EdgeInsets.only(left: 10, right: 15, bottom: 10),


            // scrollDirection: Axis.horizontal,
            // physics: AlwaysScrollableScrollPhysics(),
            // primary: true,
            shrinkWrap: true,
            // padding: EdgeInsets.only(left: 0, right: 0, bottom: 0),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: WidgetHelper().baseImage(val.picture,width: double.infinity,fit: BoxFit.contain,height: 150),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 5, 5, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Icon(FontAwesome.quote_left,size: 10,color: Colors.grey,),
                                      ),
                                      SizedBox(height: 5),
                                      Center(
                                        child: WidgetHelper().textQ(val.caption, 12,Colors.black,FontWeight.normal,maxLines: 2,textAlign: TextAlign.center),
                                      ),
                                      SizedBox(height: 5),
                                      Center(
                                        child: Icon(FontAwesome.quote_left,size: 10,color: Colors.grey,),
                                      ),
                                      // SizedBox(height: 5),
                                      // Center(
                                      //   child: Row(
                                      //     mainAxisAlignment: MainAxisAlignment.start,
                                      //     crossAxisAlignment: CrossAxisAlignment.center,
                                      //     children: [
                                      //       Icon(AntDesign.user,size: 15,color: Colors.grey,),
                                      //       WidgetHelper().textQ(val.writer, 12,Colors.grey,FontWeight.normal,maxLines: 10,textAlign: TextAlign.center)
                                      //     ],
                                      //   ),
                                      // ),
                                      // SizedBox(height: 5),
                                      // Center(
                                      //   child: Row(
                                      //     mainAxisAlignment: MainAxisAlignment.start,
                                      //     crossAxisAlignment: CrossAxisAlignment.center,
                                      //     children: [
                                      //       Icon(Icons.group_work,size: 15,color: Colors.grey,),
                                      //       WidgetHelper().textQ(val.jobs, 12,Colors.grey,FontWeight.normal,maxLines: 10,textAlign: TextAlign.center)
                                      //     ],
                                      //   ),
                                      // ),
                                      // SizedBox(height: 5),
                                      // Center(
                                      //   child: Row(
                                      //     mainAxisAlignment: MainAxisAlignment.start,
                                      //     crossAxisAlignment: CrossAxisAlignment.center,
                                      //     children: [
                                      //       Icon(Icons.timer,size: 15,color: Colors.grey),
                                      //       WidgetHelper().textQ(FunctionHelper().formateDate(val.createdAt, " "), 12,Colors.grey,FontWeight.normal,maxLines: 10,textAlign: TextAlign.center)
                                      //     ],
                                      //   ),
                                      // ),
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
                      right: 10,
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)), color:Constant().mainColor),
                          alignment: AlignmentDirectional.center,
                          child:Icon(AntDesign.videocamera,color: Colors.white)
                      ),
                    ):Text('')
                  ],
                ),
              );
            }
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
