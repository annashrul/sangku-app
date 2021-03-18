import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

class RedeemHorizontalLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);

    return Container(
      height: scaler.getHeight(25),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: AlwaysScrollableScrollPhysics(),
        primary: true,
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 0, right: 0, bottom: 0),
        itemCount: 5,
        itemBuilder: (context, index) {
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
                    height: MediaQuery.of(context).size.width/2.5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    width: MediaQuery.of(context).size.width/3,
                    height: 5.0,
                    color: Colors.white,
                  ),
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

                ],
              ),
            ),
          );
        },separatorBuilder: (context,index){return SizedBox(width: 10);},
      ),
    );
  }
}



class RedeemVerticalLoading extends StatelessWidget {
  int total=10;
  RedeemVerticalLoading({this.total});

  @override
  Widget build(BuildContext context) {
    print('bus');
    return new StaggeredGridView.countBuilder(
      primary: false,
      physics: AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 4,
      itemCount: total,
      itemBuilder: (BuildContext context, int index) {
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
                  height: MediaQuery.of(context).size.width/2.5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  width: MediaQuery.of(context).size.width/3,
                  height: 5.0,
                  color: Colors.white,
                ),
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

              ],
            ),
          ),
        );
      },
      staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
      mainAxisSpacing: 15.0,
      crossAxisSpacing: 15.0,
    );
  }
}
