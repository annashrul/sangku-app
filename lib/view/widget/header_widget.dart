import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/widget_helper.dart';

class HeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Constant().secondColor
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
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                // color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 2, 8, 2),
                  child: Row(
                    children: <Widget>[
                      ColorizeAnimatedTextKit(
                        onTap: () {
                          print("Tap Event");
                        },
                        text: [
                          "ASSALAMUAIKUM",
                          "ANNASHRUL YUSUF",
                          "DI APLIKASI SANQU",
                        ],
                        textStyle: TextStyle(
                          fontSize: 18.0,
                          color: Constant().secondDarkColor,
                          fontWeight: FontWeight.bold,
                          letterSpacing:3.0,
                        ),
                        colors: [
                          Constant().secondDarkColor,
                          Colors.blue,
                          Colors.yellow,
                          Colors.red,
                        ],
                        textAlign: TextAlign.start,
                      )
                      // WidgetHelper().textQ("SangQu App", 18, Constant().secondDarkColor,FontWeight.bold,letterSpacing: 3.0),
                    ],
                  ),
                ),
              ),
            ),
            Flexible(
              child: Container(),
              flex: 1,
            ),
            FlatButton(
                padding: EdgeInsets.all(0.0),
                highlightColor:Colors.black38,
                splashColor:Colors.black38,
                onPressed:(){},
                child: Container(
                  padding: EdgeInsets.only(right: 0.0,top:0),
                  child: Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Icon(AntDesign.bells, color:Constant().mainColor, size: 28,),
                      ),
                      Container(
                        decoration: BoxDecoration(color:Colors.redAccent, borderRadius: BorderRadius.all(Radius.circular(10))),
                        constraints: BoxConstraints(minWidth: 10, maxWidth: 10, minHeight: 10, maxHeight: 10),
                      ),
                    ],
                  ),
                )
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
