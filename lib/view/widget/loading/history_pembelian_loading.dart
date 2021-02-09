import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HistoryPembelianLoading extends StatelessWidget {
  final int tot;
  HistoryPembelianLoading({this.tot});
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      primary: false,
      physics: ScrollPhysics(),
      itemCount:this.tot,
      itemBuilder: (context,index){
        return Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          enabled: true,
          child: Padding(
            padding: const EdgeInsets.only(left:0.0,right:0.0,bottom:0.0),
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
      separatorBuilder: (context,index){
        return SizedBox(height: 10.0);
      },
    );
  }

}
