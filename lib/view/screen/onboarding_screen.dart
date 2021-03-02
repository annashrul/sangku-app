
part of 'pages.dart';

class OnboardingScreen extends StatefulWidget {
  static const String routeName = '/onbording';
  final String referrarCode;
  OnboardingScreen({Key key, this.referrarCode}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _current = 0;
  List resOnboarding=[];

  Future loadOnboarding()async{
    final res = await UserHelper().getDataUser("name");
    resOnboarding.add({"image": '${Constant().localAssets}onboarding0.png', "description": 'Don\'t cry because it\'s over, smile because it happened.'});
    resOnboarding.add({"image": '${Constant().localAssets}onboarding1.png', "description": 'Be yourself, everyone else is already taken.'});
    setState(() {});
  }


  @override
  void initState() {
    loadOnboarding();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.96),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20, top: 50),
              child: FlatButton(
                onPressed: () {
                  WidgetHelper().myPushRemove(context,SignInScreen());
                },
                child:WidgetHelper().textQ("Lewati",14.0,Colors.white,FontWeight.bold),
                color: Constant().mainColor,
                shape: StadiumBorder(),
              ),
            ),
            CarouselSlider(
              options: CarouselOptions(
                height: 500.0,
                viewportFraction: 1.0,
                onPageChanged: (index,reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
              items: resOnboarding.map((e){
                return Builder(
                  builder: (BuildContext context) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Image.asset(
                            e['image'],
                            width: 500,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width/100.0*75,
                          padding: const EdgeInsets.only(right: 20),
                          child:WidgetHelper().textQ(e['description'],14.0,Colors.black,FontWeight.bold),
                        ),
                      ],
                    );
                  },
                );
              }).toList(),
            ),
            Container(
              width: MediaQuery.of(context).size.width/100.0*75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: resOnboarding.map((e){
                  return Container(
                    width: 25.0,
                    height: 3.0,
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        color: _current == resOnboarding.indexOf(e)
                            ? Theme.of(context).hintColor.withOpacity(0.8)
                            : Theme.of(context).hintColor.withOpacity(0.2)),
                  );
                }).toList(),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width/100.0*75,
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: FlatButton(
                padding: EdgeInsets.symmetric(horizontal: 35, vertical: 12),
                onPressed: () {
                  WidgetHelper().myPushRemove(context,SignInScreen());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    WidgetHelper().textQ("Masuk",14.0,Colors.white,FontWeight.bold),

                    // RichText(text: TextSpan(style:TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily:SiteConfig().fontStyle,fontSize: 14), children: [TextSpan(text:'Sign up')])),
                    Icon(
                      Icons.arrow_forward,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
                color: Constant().mainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.only(
                    topLeft: Radius.circular(50),
                    bottomLeft: Radius.circular(50),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
