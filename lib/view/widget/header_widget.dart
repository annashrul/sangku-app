import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/widget_helper.dart';

class HeaderWidget extends StatelessWidget {
  String title;
  List<Widget> action;
  HeaderWidget({this.title,this.action});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Constant().mainColor1
      ),
      child: Center(
        child: Row(
          children: <Widget>[
            const SizedBox(
              width: 16.0,
            ),
            CircleImage(
              param:'assets',
              image: Constant().localAssets+"logo.png",
              size: 30.0,
              padding: 1.0,
            ),
            const SizedBox(
              width: 10.0,
            ),
            WidgetHelper().textQ("${this.title.toUpperCase()}", 14, Constant().secondDarkColor,FontWeight.bold),
            Flexible(
              child: Container(),
              flex: 1,
            ),
            Wrap(
              children: this.action,
            )
            // WidgetHelper().myCart(context,(){},Colors.redAccent),

          ],
        ),
      ),
    );
  }
}



class CircleImage extends StatelessWidget {
  final String param;
  final String image;
  final double size;
  final double padding;

  const CircleImage({Key key,this.param, this.image, this.size, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular((size + padding) / 2),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: param=='assets'?Image.asset(
            image,
            height: size,
            width: size,
          ):Image.network(
            image,
            height: size,
            width: size,
          ),
        ),
      ),
    );
  }
}

class CircleIcon extends StatelessWidget {
  final IconData icon;

  const CircleIcon({Key key, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(
            icon,
            size: 24,
            color: Colors.black45,
          ),
        ),
      ),
    );
  }
}
