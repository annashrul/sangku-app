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


  @override
  Widget build(BuildContext context) {
    return RefreshWidget(
      widget: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              stretch: true,
              onStretchTrigger: (){
                return;
              },
              brightness:Brightness.dark,
              backgroundColor:Colors.white,
              snap: true,
              floating: true,
              pinned: true,
              automaticallyImplyLeading: false,
              expandedHeight: 150,
              elevation: 0,
              flexibleSpace: sliderQ(context),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Offstage(
                  offstage: false,
                  child: Container(

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          children: [
                            Container(
                              child: StaggeredGridView.countBuilder(
                                shrinkWrap: true,
                                primary: false,
                                crossAxisCount: 5,
                                itemCount:  data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return WidgetHelper().myPress(
                                          (){},
                                      Container(
                                        padding: EdgeInsets.all(10.0),
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
                                mainAxisSpacing: 0.0,
                                crossAxisSpacing: 20.0,
                              ),
                            ),
                            ClipPath(
                                clipper: ArcClipper(),
                                child: Container(
                                  height:50.0,
                                  color:Colors.grey[200],
                                )
                            )
                          ],
                          alignment: Alignment.topCenter,
                        ),
                        WidgetHelper().myPress((){},ListTile(
                          contentPadding: EdgeInsets.only(left:10.0,right:10.0),
                          leading: Icon(AntDesign.profile,size: 40.0,color:Constant().mainColor),
                          title: WidgetHelper().textQ("Berita Terbaru",12,Colors.black,FontWeight.bold),
                          subtitle:WidgetHelper().textQ("kumpulan berita terbaru seputar SanQu",10,Colors.grey[400],FontWeight.normal),
                          trailing: Icon(AntDesign.doubleright,size:15.0),
                        ))

                      ],
                    ),
                  ),
                ),

              ]),
            )
          ]
      ),
      callback: (){},
    );
  }
  Widget sliderQ(BuildContext context){
    return FlexibleSpaceBar(
      stretchModes: [
        StretchMode.zoomBackground,
        StretchMode.blurBackground,
        StretchMode.fadeTitle
      ],

      collapseMode: CollapseMode.parallax,
      background:  Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          CarouselSlider(
              options: CarouselOptions(
                viewportFraction: 1.0,
                height: 150,
                onPageChanged: (index,reason) {
                  print(index);
                  setState(() {
                    // _current=index;
                  });
                },
              ),
              items:<Widget>[
                Builder(
                  builder: (BuildContext context) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                      child:Image.network(
                        'https://ecs7.tokopedia.net/img/banner/2021/2/1/34631992/34631992_3b1c99e8-70b9-43e1-b225-4deeb3e37556.jpg',
                        fit: BoxFit.fill,
                        width:
                        MediaQuery.of(context).size.width,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),

                      ),
                    );
                  },
                )
              ]
          ),
          Positioned(
            top: 130,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Container(
                    width: 20.0,
                    height: 3.0,
                    margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        color:Theme.of(context).hintColor
                      ),
                  )
                ]
            ),
          )
        ],
      ),
    );
  }

}
