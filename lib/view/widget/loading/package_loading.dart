import 'package:flutter/material.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:shimmer/shimmer.dart';

class PackageLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(top:10.0),
      scrollDirection: Axis.vertical,
      primary: false,
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount:5,
      itemBuilder: (context,index){
        return Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          enabled: true,
          child: Padding(
            padding: const EdgeInsets.only(left:10.0,right:10.0,bottom:0.0),
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  width: MediaQuery.of(context).size.width/2,
                  height: 5.0,
                  color: Colors.white,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  width: MediaQuery.of(context).size.width/3,
                  height: 5.0,
                  color: Colors.white,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height/3,
                  color: Colors.white,
                ),

              ],
            ),
          ),
        );

      },

    );
  }
}

class AddressLoading extends StatelessWidget {
  int tot=5;
  AddressLoading({this.tot});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(top:10.0),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount:tot,
      itemBuilder: (context,index){
        return Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          enabled: true,
          child: Padding(
            padding: const EdgeInsets.only(left:10.0,right:10.0,bottom:0.0),
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  width: MediaQuery.of(context).size.width/2,
                  height: 5.0,
                  color: Colors.white,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  width: MediaQuery.of(context).size.width/3,
                  height: 5.0,
                  color: Colors.white,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height/8,
                  color: Colors.white,
                ),

              ],
            ),
          ),
        );

      },

    );
  }

}

