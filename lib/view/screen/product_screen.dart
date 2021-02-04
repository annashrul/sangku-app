part of 'pages.dart';


class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            // backgroundColor: Constant().mainColor,
            // toolbarHeight: 50.0,
            elevation: 0,
            bottom: TabBar(
                // labelStyle: TextStyle(fontSize:14,fontFamily:Constant().fontStyle,fontWeight: FontWeight.bold),
                // unselectedLabelStyle: TextStyle(fontSize:14,fontFamily:Constant().fontStyle,fontWeight: FontWeight.bold),
                // labelColor:Colors.white,
                // unselectedLabelColor: Colors.grey[200],
                indicatorSize: TabBarIndicatorSize.label,
                indicator: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color:Constant().mainColor,
                        width: 3.0,
                      ),
                    ),
                ),
                tabs: [
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: WidgetHelper().textQ("Aktivasi",14,Constant().mainColor,FontWeight.bold),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: WidgetHelper().textQ("Repeat Order ",14,Constant().mainColor,FontWeight.bold),
                    ),
                  ),
                ]
            ),
            title:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WidgetHelper().textQ("Hai, SangQu",16,Colors.black,FontWeight.bold,letterSpacing: 3.0),
                WidgetHelper().textQ("MB5711868825",12,Colors.black,FontWeight.normal,letterSpacing: 2.0),
              ],
            ),
            leading:Padding(
              padding: EdgeInsets.only(left:20.0,top:10.0,bottom:10.0),
              child:  WidgetHelper().myPress((){},CircleAvatar(
                backgroundImage:NetworkImage('https://img.pngio.com/avatar-icon-png-105-images-in-collection-page-3-avatarpng-512_512.png',scale: 1.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(AntDesign.cloudupload,size: 15,color: Colors.grey),
                ),
              )),
            ),
            actions: <Widget>[
              FlatButton(
                  padding: EdgeInsets.all(0.0),
                  highlightColor:Colors.black38,
                  splashColor:Colors.black38,
                  onPressed: (){
                  },
                  child: Container(
                    padding: EdgeInsets.only(right: 0.0,top:0),
                    child: Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: Icon(
                            AntDesign.shoppingcart,
                            color:Constant().mainColor,
                            size: 28,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.all(Radius.circular(10))),
                          constraints: BoxConstraints(minWidth: 10, maxWidth: 10, minHeight: 10, maxHeight: 10),
                        ),


                      ],
                    ),
                  )
              )
            ],
          ),
          body: TabBarView(children: [
            Scrollbar(
              child: AktivasiProduct(context),
            ),
            Scrollbar(
              child: AktivasiProduct(context,isBadge: false),
            ),
          ]),
        )
    );
  }

  // ignore: non_constant_identifier_names
  Widget AktivasiProduct(BuildContext context,{bool isBadge=true}){
    return ListView.separated(
      itemCount: 10,
      itemBuilder: (context,index){
        return WidgetHelper().myPress((){},Container(
          padding: EdgeInsets.only(left:10,right:10,bottom: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.all(0.0),
                title: WidgetHelper().textQ("Paket Executive",12,Constant().darkMode,FontWeight.bold),
                subtitle:WidgetHelper().textQ("Rp 1,500,000 .-",12,Constant().mainColor,FontWeight.bold),
                trailing: isBadge?CachedNetworkImage(
                  imageUrl:'http://ptnetindo.com:6694/badge/executive.png',
                  fit:BoxFit.contain,
                  placeholder: (context, url) => Image.network(Constant().noImage, fit:BoxFit.fill,width: double.infinity,),

                  errorWidget: (context, url, error) => Image.network(Constant().noImage, fit:BoxFit.fill,width: double.infinity,),
                ):Text(''),
              ),
              CachedNetworkImage(
                imageUrl:'http://ptnetindo.com:6694/images/package/package_2101254631MjFJ.png',
                // height: 150,
                width: double.infinity,
                fit:BoxFit.fill,
                placeholder: (context, url) => Image.network(Constant().noImage, fit:BoxFit.fill,width: double.infinity,),
                errorWidget: (context, url, error) => Image.network(Constant().noImage, fit:BoxFit.fill,width: double.infinity,),
              ),
              WidgetHelper().textQ("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean a lorem vitae mauris malesuada tincidunt nec vel tellus. Sed eu feugiat nulla. Nulla non leo eu est rhoncus tincidunt. Aliquam erat volutpat. Morbi commodo enim euismod egestas egestas. Nam pretium rutrum tortor, vel dictum urna suscipit at. Curabitur a placerat dolor, id eleifend quam. Aliquam erat volutpat. Nulla facilisi. Aliquam vitae massa ornare, vulputate ligula sit amet, euismod neque. Nullam sed ex ut dui mattis bibendum sit amet non ex. Phasellus a mi nec massa convallis lobortis id sed dolor. In volutpat sagittis mattis. Sed sagittis libero vel molestie porttitor. Aenean tempor nisi nec erat imperdiet convallis nec quis mauris. Donec eu vulputate risus.",10,Constant().darkMode,FontWeight.normal,maxLines: 10),
              SizedBox(height:10),
              MaterialButton(
                onPressed: (){
                  WidgetHelper().loadingDialog(context);
                  // login();
                },
                child: WidgetHelper().textQ("Keranjang",14,Colors.grey[200],FontWeight.bold),
                color: Color(0xFFFA591D),
                elevation: 0,
                minWidth: 400,
                height: 50,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
              ),
            ],
          ),
        ));
      },
      separatorBuilder: (context,index){
        return Divider(height: 1.0);
      },
    );
  }

}
