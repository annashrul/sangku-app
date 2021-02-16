part of '../pages.dart';



class ProfileScreen extends StatefulWidget {
  final dynamic dataMember;
  ProfileScreen({this.dataMember});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List dataWallet=[
    {'title':"Sponsor",'icon':AntDesign.addusergroup},
    {'title':"PIN",'icon':AntDesign.chrome},
    {'title':"PV Kiri",'icon':AntDesign.left},
    {'title':"PV Kanan",'icon':AntDesign.right},
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context){
    return SafeArea(
      child: WrapperPageWidget(
        dataMember: widget.dataMember,
        children: [
          Container(
            padding: EdgeInsets.only(left:0.0,right:0.0,bottom:0.0,top:0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: StaggeredGridView.countBuilder(
                    padding: EdgeInsets.all(0.0),
                    shrinkWrap: true,
                    primary: false,
                    crossAxisCount: 4,
                    itemCount:  dataWallet.length,
                    itemBuilder: (BuildContext context, int index) {
                      IconData icon;
                      String title='';
                      Color color;
                      String value='';
                      if(index==0){icon=AntDesign.team;title='Sponsor';color=Color(0xFF007bff);value=widget.dataMember['sponsor'];}
                      if(index==1){icon=AntDesign.pptfile1;title='PIN';color=Color(0xFFffc107);value=widget.dataMember['pin'];}
                      if(index==2){icon=AntDesign.leftcircleo;title='PV Kiri';color=Color(0xFF28a745);value=widget.dataMember['left_pv'];}
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
                              Icon(icon,size: 15.0,color: color),
                              SizedBox(width:5.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  WidgetHelper().textQ(title,10,Constant().secondColor, FontWeight.normal,textAlign: TextAlign.center),
                                  WidgetHelper().textQ(value,12,Constant().secondColor, FontWeight.bold,textAlign: TextAlign.center),
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
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
                  contentPadding: EdgeInsets.only(left:10,right:20),
                  leading: Icon(AntDesign.barschart,color:Constant().mainColor),
                  title: WidgetHelper().textQ("Laporan",12,Colors.black,FontWeight.bold),
                ),
                section2("Pembelian",(){WidgetHelper().myPush(context,HistoryPembelianScreen());},0,iconData: AntDesign.shoppingcart),
                section2("Transaksi",(){WidgetHelper().myPush(context,HistoryTransactionScreen());},1,iconData: AntDesign.wallet),
                section2("Deposit",(){WidgetHelper().myPush(context,HistoryDepositScreen());},0,iconData: AntDesign.swapleft),
                section2("Penarikan",(){WidgetHelper().myPush(context,HistoryWithdrawScreen());},1,iconData: AntDesign.swapright),
                section2("PPOB",(){WidgetHelper().myPush(context,HistoryPPOBScreen());},0,iconData: AntDesign.folder1),
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
            child: ListView(
              shrinkWrap: true,
              primary: false,
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.only(left:10,right:20),
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
          )
        ],
        action: HeaderWidget(title: 'PROFILE',action: WidgetHelper().myNotif(context,(){},Colors.redAccent)),
      ),
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
