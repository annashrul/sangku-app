part of '../pages.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 7),
        child:Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.1), offset: Offset(3, 3), blurRadius: 0)
                ],
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: FlatButton(
                      highlightColor:Colors.black38,
                      splashColor:Colors.black38,
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                      onPressed: () {
                        // Navigator.of(context).pushNamed('/Tabs', arguments: 4);
                      },
                      child: ListTile(
                        leading: Icon(AntDesign.wallet,color: Colors.grey,size: 50.0,),
                        title: WidgetHelper().textQ("Saldo Anda",12,Colors.black,FontWeight.normal),
                        subtitle:  WidgetHelper().textQ("Rp 20,000,000 .-",14,Constant().mainColor,FontWeight.bold),
                      ),
                    ),
                  )

                ],
              ),
            ),
            Container(
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
                    leading: Icon(AntDesign.barschart,color:Colors.grey),
                    title: WidgetHelper().textQ("Laporan",12,Colors.black,FontWeight.bold),
                  ),
                  section2("Pembelian",(){},iconData: AntDesign.shoppingcart),
                  section2("Transaksi",(){},iconData: AntDesign.wallet),
                  section2("Transfer",(){},iconData: AntDesign.swap),
                  section2("Deposit",(){},iconData: AntDesign.swapleft),
                  section2("Penarikan",(){},iconData: AntDesign.swapright),


                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.1), offset: Offset(3, 0), blurRadius: 0)

                  // BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.1), offset: Offset(0, 3), blurRadius: 0)

                  // BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)
                ],
              ),
              child: ListView(
                shrinkWrap: true,
                primary: false,
                children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.only(left:20,right:20),
                    leading: Icon(AntDesign.setting,color:Colors.grey),
                    title: WidgetHelper().textQ("Pengaturan Umum",12,Colors.black,FontWeight.bold),
                  ),
                  section2("Data Diri",(){},iconData: AntDesign.user),
                  section2("Keamanan",(){},iconData: AntDesign.lock),
                  section2("FAQ",(){},iconData: AntDesign.questioncircleo),
                  section2("Kebijakan & Keamanan",(){},iconData: AntDesign.infocirlceo),
                  section2("Alamat",(){
                    WidgetHelper().myPush(context,AddressScreen());
                  },iconData: Entypo.location),
                  section2("Keluar",()async{
                    await FunctionHelper().logout(context);
                  },iconData: AntDesign.logout),

                ],
              ),
            )
          ],
        ),
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

  Widget section2(String title, Function callback,{IconData iconData=AntDesign.arrowright}){
    return FlatButton(
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
