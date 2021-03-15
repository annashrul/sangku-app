import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:sangkuy/helper/widget_helper.dart';

class CardWidget extends StatelessWidget {
  final Color prefixBadge;
  final Color suffixBadge;
  final IconData icon;
  final IconData suffixIcon;
  final Color iconColor;
  final Color suffixIconColor;
  final String title;
  final String description;
  final Function onTap;
  final Color backgroundColor;
  final Color titleColor;
  final Color descriptionColor;
  const CardWidget({
    Key key,
    this.prefixBadge,
    this.suffixBadge,
    this.icon,
    this.iconColor,
    this.title,
    this.description,
    this.suffixIcon,
    this.suffixIconColor,
    this.onTap,
    this.backgroundColor,
    this.descriptionColor,
    this.titleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
     ScreenScaler scaler = ScreenScaler()..init(context);

    return Container(
      // padding: EdgeInsets.only(top:10,bottom: 10),
      color: Colors.transparent,
      child: InkWell(
        onTap: this.onTap,
        child: Card(
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
          elevation: 0.0,
          color: (this.backgroundColor != null) ? this.backgroundColor : Colors.transparent,
          margin: const EdgeInsets.all(0.0),
          child: Row(
            children: <Widget>[
              (this.prefixBadge != null) ? Container(
                width: scaler.getWidth(1),
                height: scaler.getHeight(5),
                decoration: BoxDecoration(
                    color: this.prefixBadge,
                    borderRadius: new BorderRadius.circular(10.0)
                ),

              ) : Container(),
              (this.icon != null) ? Container(
                margin: const EdgeInsets.all(5.0),
                width: 50.0,
                height: 50.0,
                child: Icon(
                  this.icon,
                  color: (this.iconColor != null)
                      ? this.iconColor
                      : Colors.black,
                ),
              ) : Container(margin: const EdgeInsets.only(left: 20.0),),
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      (this.title != null) ? Container(child:WidgetHelper().textQ(title, scaler.getTextSize(9), (this.titleColor != null) ? this.titleColor : Colors.black, FontWeight.bold)): Container(),
                      SizedBox(height: 5.0),
                      (this.description != null)? Container(child:WidgetHelper().textQ(description,  scaler.getTextSize(9), (this.descriptionColor != null) ? this.descriptionColor : Colors.grey, FontWeight.normal)) : Container(),
                    ],
                  ),
                ),
              ),
              (this.suffixIcon != null)
                  ? Container(
                margin: const EdgeInsets.only(right: 10.0),
                child: Icon(this.suffixIcon,size: scaler.getTextSize(12),
                    color: (this.suffixIconColor != null)
                        ? this.suffixIconColor
                        : Colors.black),
              )
                  : Container(),
              (this.suffixBadge != null)
                  ? Container(
                width: scaler.getWidth(1),
                height: scaler.getHeight(5),
                color: this.suffixBadge,
              )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
