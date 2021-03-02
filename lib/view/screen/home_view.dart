import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sangkuy/helper/dynamic_link_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


class HomeView extends StatefulWidget {
  static const String routeName = '/home';
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String welcome='';
  String refer='';
  Future getLink()async{
    final ref = await DynamicLinksApi().createReferralLink('1234567');
    setState(() {
      refer = ref.toString();
    });
  }
  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLink();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Tutorial Referral System')),
      body: Column(
        children: [
          FlatButton(
            color: Colors.green,
            onPressed: (){
              _launchURL(welcome);
            },
            child: Text('welcome'),
          ),
          FlatButton(
            color: Colors.green,
            onPressed: (){
              _launchURL(refer);
            },
            child: Text('referral'),
          ),
        ],
      ),

    );
  }
}



class CreateReferralCode extends StatefulWidget {
  CreateReferralCode(this._builder);

  final Widget Function(String referralCode) _builder;

  @override
  State<StatefulWidget> createState() => _CreateReferralCode();
}

class _CreateReferralCode extends State<CreateReferralCode> {
  String _referralCode;

  var referralCodeGenerator = Random();



  void setReferralCode() {
    if (mounted) {
      setState(() {
        var id = referralCodeGenerator.nextInt(92143543) + 09451234356;
        var randomCode = "Ref-${id.toString().substring(0, 8)}";
        _referralCode = randomCode;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setReferralCode();
    // getLink();
  }

  @override
  Widget build(BuildContext context) {
    return widget._builder(_referralCode);
  }
}
