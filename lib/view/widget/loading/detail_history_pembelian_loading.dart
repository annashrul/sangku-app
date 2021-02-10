import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DetailHistoryPembelianLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      enabled: true,
      child: Padding(
        padding: const EdgeInsets.only(left:10.0,right:10.0,top:10.0,bottom:0.0),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildHalf(context),
            buildHalf(context),
            buildHalf(context),
            buildHalf(context),
            buildFull(context),
            buildHalf(context),
            buildHalf(context),
            buildHalf(context),
            buildHalf(context),
            buildFull(context),
            buildHalf(context),
            buildHalf(context),
            buildHalf(context),
            buildHalf(context),
            buildFull(context),
            buildHalf(context),
            buildHalf(context),
            buildHalf(context),
            buildHalf(context),
            buildFull(context),

          ],
        ),
      ),
    );
  }

  Widget buildHalf(BuildContext context){
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      width: MediaQuery.of(context).size.width/1,
      height: 5.0,
      color: Colors.white,
    );
  }
  Widget buildFull(BuildContext context){
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      width: double.infinity,
      height: MediaQuery.of(context).size.height/8,
      color: Colors.white,
    );
  }

}
