import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/content/testimoni_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:sangkuy/provider/content_provider.dart';
import 'package:sangkuy/view/widget/header_widget.dart';
import 'package:sangkuy/view/widget/loading/testimoni_loading.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class TestimoniWidget extends StatefulWidget {
  TestimoniModel testimoniModel;
  int index;
  TestimoniWidget({this.testimoniModel,this.index});
  @override
  _TestimoniWidgetState createState() => _TestimoniWidgetState();
}

class _TestimoniWidgetState extends State<TestimoniWidget> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return buildContent(context);
  }

  Widget buildContent(BuildContext context){
    return FlatButton(
      padding: EdgeInsets.only(right:15.0),
      onPressed: (){
        WidgetHelper().myModal(context,Container(
          height: MediaQuery.of(context).size.height/1.5,
          child: DetailScreen(
            img: widget.testimoniModel.result.data[widget.index].picture,
          ),
        ));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.all(0.0),
            trailing: IconButton(color:widget.testimoniModel.result.data[widget.index].video=='-'?Colors.transparent:Colors.grey,icon: Icon(AntDesign.videocamera), onPressed: (){
              WidgetHelper().myModal(context,VideoTestimoni(video: widget.testimoniModel.result.data[widget.index].video));
            }),

            leading: Container(
              child: WidgetHelper().baseImage(widget.testimoniModel.result.data[widget.index].foto,width: 40,height: 40),
              decoration: BoxDecoration(
                shape: BoxShape.circle
              ),
            ),
            title: WidgetHelper().textQ(widget.testimoniModel.result.data[widget.index].writer,14,Constant().darkMode,FontWeight.bold),
            subtitle: WidgetHelper().textQ(widget.testimoniModel.result.data[widget.index].jobs, 12, Constant().darkMode,FontWeight.normal),
          ),
          WidgetHelper().textQ(widget.testimoniModel.result.data[widget.index].caption,12,Constant().darkMode,FontWeight.normal,maxLines: 10,textAlign: TextAlign.left),
          SizedBox(height: 5.0),
          Align(
            alignment: Alignment.bottomRight,
            child:WidgetHelper().textQ(FunctionHelper().formateDate(widget.testimoniModel.result.data[widget.index].createdAt, "ymd"), 12, Constant().darkMode,FontWeight.normal),
          ),
          SizedBox(height: 5.0),
          WidgetHelper().baseImage(widget.testimoniModel.result.data[widget.index].picture),

        ],
      ),
    );
  }



}

class DetailScreen extends StatelessWidget {
  String img;
  DetailScreen({this.img});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: WidgetHelper().baseImage(img),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}


class VideoTestimoni extends StatefulWidget {
  String video;
  VideoTestimoni({this.video});
  @override
  _VideoTestimoniState createState() => _VideoTestimoniState();
}

class _VideoTestimoniState extends State<VideoTestimoni> {

  YoutubePlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.video),
      flags: YoutubePlayerFlags(
        autoPlay: false,
      ),
    );

  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top:10.0,left:0,right:0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),topRight:Radius.circular(10.0) ),
      ),
      // color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.only(top:0.0),
              width: 50,
              height: 10.0,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius:  BorderRadius.circular(10.0),
              ),
            ),
          ),
          ListTile(
            dense:true,
            contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
            trailing: InkWell(
              onTap: ()=>Navigator.pop(context),
              child: IconButton(icon: Icon(AntDesign.close), onPressed:(){Navigator.pop(context);}),
            ),
          ),
          SizedBox(height:10.0),
          YoutubePlayer(controller: _controller),
        ],
      ),
    );
  }
}

