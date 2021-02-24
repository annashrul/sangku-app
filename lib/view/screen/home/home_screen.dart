part of '../pages.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoadingNews=false,isErrorNews=false,isTokenExpNews=false;
  bool isLoadingRedeem=false,isErrorRedeem=false,isTokenExpRedeem=false;
  bool isLoadingMember=false;
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
    var res = await ContentProvider().loadRedeem("page=1&limit=5");
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  dynamic dataMember;
  @override
  Widget build(BuildContext context) {
    print("================================================================");
    print(dataMember);
    print("================================================================");

    return SafeArea(
      child:  WrapperPageWidget(
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
                // if(index==0){icon=AntDesign.team;title='Sponsor';color=Color(0xFF007bff);value='10';}
                // widget.dataMember['plafon']}'.split(".")[0]
                if(index==1&&dataMember!=null){
                  icon=AntDesign.pptfile1;title='SangQuota';color=Color(0xFFffc107);
                  value='Rp '+FunctionHelper().formatter.format(int.parse('${dataMember['plafon']}'.split(".")[0]))+' .-';
                  // value='Rp '+FunctionHelper().formatter.format(int.parse('10000'));
                }
                if(index==2&&dataMember!=null){icon=AntDesign.leftcircleo;title='Reward';color=Color(0xFF28a745);value='kiri ${dataMember['left_reward_point']} | kanan ${dataMember['right_reward_point']}';}
                // if(index==2){icon=AntDesign.leftcircleo;title='Reward';color=Color(0xFF28a745);value='kiri  | kanan ';}
                // if(index==3){icon=AntDesign.rightcircleo;title='PV Kanan';color=Color(0xFFdc3545);value=widget.dataMember['right_pv'];}
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
                          WidgetHelper().textQ(value,10,Color(0xFFffc107), FontWeight.bold,textAlign: TextAlign.left),
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
          Container(
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(AntDesign.checkcircleo,size:10,color: Color(0xFFdc3545),),
                      SizedBox(width:1),
                      WidgetHelper().textQ("pertumbuhan",10,Color(0xFFdc3545),FontWeight.bold),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(AntDesign.checkcircleo,size:10,color: Color(0xFFffc107),),
                      SizedBox(width:1),
                      WidgetHelper().textQ("tabungan",10,Color(0xFFffc107),FontWeight.bold),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(AntDesign.checkcircleo,size:10,color: Color(0xFF5d78ff),),
                      SizedBox(width:1),
                      WidgetHelper().textQ("balance",10,Color(0xFF5d78ff),FontWeight.bold),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(AntDesign.checkcircleo,size:10,color: Constant().mainColor),
                      SizedBox(width:1),
                      WidgetHelper().textQ("terpasang",10,Constant().mainColor,FontWeight.bold),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(AntDesign.checkcircleo,size:10,color:Colors.green),
                      SizedBox(width:1),
                      WidgetHelper().textQ("bonus",10,Colors.green,FontWeight.bold),
                    ],
                  ),
                ),

              ],
            )
          ),
          Container(
            height: 200,
            child: BarChartHome(),
          ),
          SizedBox(height:10),
          section2(context),
          Divider(thickness: 10.0),
          section6(context),
          Divider(thickness: 10.0),
          section3(context),
          Divider(thickness: 10.0),
          section4(context)
        ],
        action: HeaderWidget(title: 'HOME',action: WidgetHelper().myNotif(context,(){},Constant().mainColor2)),
        callback: (data){
          setState(() {
            dataMember=data;
          });
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
                        return WidgetHelper().myPush(context,FormEwalletScreen(dataMember:dataMember,title:DataHelper.dataWallet[index]['title'].toUpperCase()));
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
                WidgetHelper().textQ("Berita Terbaru",12,Constant().darkMode,FontWeight.bold),
                WidgetHelper().textQ("Kumpulan berita terbaru seputar SangQu",12,Constant().darkMode,FontWeight.normal),
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
