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

  bool isLoading=false,isError=false,isTokenExp=false;
  ContentModel contentModel;
  Future loadNews()async{
    var res = await ContentProvider().loadData("page=1");
    if(res=='error' || res=='failed'){
      setState(() {
        isLoading=false;
        isError=true;
      });
    }
    else if(res==Constant().errExpToken){
      setState(() {
        isLoading=false;
        isError=false;
        isTokenExp=true;
      });
    }
    else{
      setState(() {
        contentModel = res;
        isLoading=false;
        isError=false;
        isTokenExp=false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading=true;
    loadNews();
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
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: <Widget>[
                            CircleImage(
                              key: Key("profile"),
                              image: Constant().localAssets+"bg_auth.png",
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
                                WidgetHelper().textQ("Annashrul Yusuf",10,Constant().darkMode,FontWeight.bold),
                                const SizedBox(
                                  height: 2,
                                ),
                                WidgetHelper().textQ("Rp 1,000,000 .-",14,Constant().moneyColor,FontWeight.bold),

                                const SizedBox(
                                  height: 4,
                                ),
                                WidgetHelper().textQ("MB5711868825",10,Constant().darkMode,FontWeight.bold),

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
                                      Icon(
                                        Icons.description,
                                        size: 16,
                                        color: Colors.black54,
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        "Silver",
                                        style: TextStyle(color: Colors.black87, fontSize: 10),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    case 1:
                      return Divider(thickness: 10.0,);
                    case 2:
                      return  Container(
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
                            WidgetHelper().myPress((){
                              WidgetHelper().myPush(context,NewsScreen());
                            },ListTile(
                              contentPadding: EdgeInsets.only(left:10.0,right:10.0),
                              leading: Icon(AntDesign.profile,size: 40.0,color:Constant().mainColor),
                              title: WidgetHelper().textQ("Berita Terbaru",12,Colors.black,FontWeight.bold),
                              subtitle:WidgetHelper().textQ("kumpulan berita terbaru seputar SanQu",10,Colors.grey[400],FontWeight.normal),
                              trailing: Icon(AntDesign.doubleright,size:15.0),
                            ))
                          ],
                        ),
                      );
                    case 3:
                      return Container(
                        height: 200,
                        child: isLoading?AddressLoading(tot: 3):ListView.separated(
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
                    case 4:
                      return Container();
                    case 5:
                      return Container();
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
          setState(() {
            isLoading=true;
          });
          loadNews();
        },
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