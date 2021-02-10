part of '../pages.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  DataMemberModel dataMemberModel;
  bool isLoadingMember=false;
  Future loadMember()async{
    final member = await MemberProvider().getDataMember();
    if(this.mounted)
      setState(() {
        dataMemberModel = member;
        isLoadingMember=false;
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoadingMember=true;
    loadMember();
  }
  @override
  Widget build(BuildContext context){
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
                      return isLoadingMember?MemberLoading():Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: <Widget>[
                            CircleImage(
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
                      );
                    case 1:
                      return Divider(thickness: 10.0,);
                    case 2:
                      return  Container(
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.1), offset: Offset(0, 3), blurRadius: 0)

                            // BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)
                          ],
                        ),
                        child: ListView(
                          shrinkWrap: true,
                          primary: false,
                          children: <Widget>[
                            ListTile(
                              contentPadding: EdgeInsets.only(left:20,right:20),
                              leading: Icon(AntDesign.barschart,color:Constant().mainColor),
                              title: WidgetHelper().textQ("Laporan",12,Colors.black,FontWeight.bold),
                            ),
                            section2("Pembelian",(){WidgetHelper().myPush(context,HistoryPembelianScreen());},0,iconData: AntDesign.shoppingcart),
                            section2("Transaksi",(){},1,iconData: AntDesign.wallet),
                            section2("Deposit",(){},0,iconData: AntDesign.swapleft),
                            section2("Penarikan",(){},1,iconData: AntDesign.swapright),


                          ],
                        ),
                      );
                    case 3:
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.1), offset: Offset(3, 0), blurRadius: 0)
                          ],
                        ),
                        child: ListView(
                          shrinkWrap: true,
                          primary: false,
                          children: <Widget>[
                            ListTile(
                              contentPadding: EdgeInsets.only(left:20,right:20),
                              leading: Icon(AntDesign.setting,color:Constant().mainColor),
                              title: WidgetHelper().textQ("Pengaturan Umum",12,Colors.black,FontWeight.bold),
                            ),
                            section2("Data Diri",(){},0,iconData: AntDesign.user),
                            section2("Keamanan",(){},1,iconData: AntDesign.lock),
                            section2("Alamat",(){WidgetHelper().myPush(context,AddressScreen());},0,iconData: Entypo.location),
                            section2("Kebijakan & Keamanan",(){},1,iconData: AntDesign.infocirlceo),
                            section2("Keluar",()async{
                              WidgetHelper().notifDialog(context,"Informasi !","Kamu yakin akan keluar dari aplikasi ?", (){Navigator.pop(context);}, ()async{
                                await FunctionHelper().logout(context);
                              });
                            },0,iconData: AntDesign.logout),
                          ],
                        ),
                      );

                    default:
                      return Container();
                  }

                }, childCount: 4),
              ),
            ]
        ),
        callback: (){
          setState(() {
            isLoadingMember=true;
          });
          loadMember();
        },
      )
    );
  }



  Widget section1({IconData iconData=AntDesign.arrowright}){
    return Expanded(
      child: FlatButton(
        highlightColor:Colors.black38,
        splashColor:Colors.black38,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        onPressed: () {
          // Navigator.of(context).pushNamed('/Tabs', arguments: 4);
        },
        child: Column(
          children: <Widget>[
            Icon(AntDesign.wallet,color: Colors.grey),
            SizedBox(height: 5.0),
            WidgetHelper().textQ("Rp 1,000,000 .-",10,Colors.black,FontWeight.normal,letterSpacing: 1.0,textAlign: TextAlign.center)
          ],
        ),
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

}
