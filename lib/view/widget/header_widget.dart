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
        // image: DecorationImage(
        //     image: NetworkImage(
        //       'https://images.template.net/wp-content/uploads/2015/08/Premium-Stone-Textured-Dark-Background.png',
        //     ),
        //     alignment: Alignment.topCenter,
        //     fit: BoxFit.fitWidth
        // ),
      ),
      child: Center(
        child: Row(
          children: <Widget>[
            const SizedBox(
              width: 16.0,
            ),
            CircleImage(
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
            WidgetHelper().myCart(context,(){},Colors.redAccent),

          ],
        ),
      ),
    );
  }
}

class CircleImage extends StatelessWidget {
  final String image;
  final double size;
  final double padding;

  const CircleImage({Key key, this.image, this.size, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular((size + padding) / 2),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Image.asset(
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
