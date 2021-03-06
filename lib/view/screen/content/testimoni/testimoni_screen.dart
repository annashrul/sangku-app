
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/refresh_widget.dart';
import 'package:sangkuy/helper/user_helper.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/content/testimoni_model.dart';
import 'package:sangkuy/model/general_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:sangkuy/provider/content_provider.dart';
import 'package:sangkuy/view/screen/content/news/detail_news_screen.dart';
import 'package:sangkuy/view/screen/content/testimoni/my_testimoni_screen.dart';
import 'package:sangkuy/view/screen/mlm/history/resi_screen.dart';
import 'package:sangkuy/view/widget/camera_widget.dart';
import 'package:sangkuy/view/widget/loading/testimoni_loading.dart';
import 'package:sangkuy/view/widget/testimoni_widget.dart';
import 'package:sangkuy/view/widget/web_view_widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
class TestimoniScreen extends StatefulWidget {
  @override
  _TestimoniScreenState createState() => _TestimoniScreenState();
}

class _TestimoniScreenState extends State<TestimoniScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = new GlobalKey<AnimatedListState>();
  bool isLoadingTestimoni=false,isLoadmore=false;
  TestimoniModel testimoniModel;
  int perpage=10,total=0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future loadTestimoni()async{
    var res = await ContentProvider().loadTestimoni("perpage=$perpage");
    if(res==Constant().errNoData){
      isLoadingTestimoni=false;
      isLoadmore=false;
      total=0;
    }
    else{
      if(this.mounted) setState(() {
        testimoniModel = res;
        isLoadingTestimoni=false;
        isLoadmore=false;
        total=testimoniModel.result.total;
      });
    }
    
  }
  ScrollController controller;
  void _scrollListener() {
    if (!isLoadingTestimoni) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        if(perpage<total){
          print('fetch data');
          setState((){
            perpage=perpage+perpage;
            isLoadmore=true;
          });
          loadTestimoni();
        }
      }
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoadingTestimoni=true;
    loadTestimoni();
    controller = new ScrollController()..addListener(_scrollListener);
  }
  @override
  void dispose() {
    super.dispose();
    controller.removeListener(_scrollListener);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: WidgetHelper().appBarWithButton(context,"Testimoni",(){Navigator.pop(context);},<Widget>[
        IconButton(icon: Icon(AntDesign.user), onPressed: (){
          WidgetHelper().myPush(context,MyTestimoniScreen());
        })
      ]),
      body:  isLoadingTestimoni?TestimoniLoading():total>0? RefreshWidget(
        widget: buildContent(context),
        callback: (){
          isLoadingTestimoni=true;
          setState(() {});
          loadTestimoni();
        },
      ):WidgetHelper().noDataWidget(context),
      bottomNavigationBar: isLoadmore?TestimoniLoading(total: 1):Text(''),
    );
  }

  Widget buildContent(BuildContext context){
    return new ListView.separated(
      primary: false,
      controller: controller,
      physics: AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: testimoniModel.result.data.length,
      itemBuilder: (BuildContext context, int index) {
        String desc='';
        var val=testimoniModel.result.data[index];
        int lng=100;
        if(testimoniModel.result.data[index].caption.length>lng){
          desc=testimoniModel.result.data[index].caption.substring(0,lng)+' ..';
        }else{
          desc=testimoniModel.result.data[index].caption;
        }
        return Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              FlatButton(
                color:Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                      ),
                      child: WidgetHelper().baseImage(val.picture,width: double.infinity,fit: BoxFit.contain),
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width/3,
                        ),
                        Icon(FontAwesome.quote_left,size: 10,color: Colors.grey,),
                        Container(
                          width: MediaQuery.of(context).size.width/3,
                        ),
                      ],
                    ),
                    SizedBox(height:10),
                    Padding(
                      padding: EdgeInsets.only(left:10,right:10),
                      child: Center(
                        child: WidgetHelper().textQ(val.caption, 12,Colors.black,FontWeight.bold,maxLines: 12,textAlign: TextAlign.center),
                      )
                    ),
                    SizedBox(height:10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width/3,
                        ),
                        Icon(FontAwesome.quote_left,size: 10,color: Colors.grey,),
                        Container(
                          width: MediaQuery.of(context).size.width/3,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(AntDesign.user,size: 15,color: Colors.grey,),
                          WidgetHelper().textQ(val.writer, 12,Colors.grey,FontWeight.bold,maxLines: 10,textAlign: TextAlign.center)
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.group_work,size: 15,color: Colors.grey,),
                          WidgetHelper().textQ(val.jobs, 12,Colors.grey,FontWeight.bold,maxLines: 10,textAlign: TextAlign.center)
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.timer,size: 15,color: Colors.grey),
                          WidgetHelper().textQ(FunctionHelper().formateDate(val.createdAt, " "), 12,Colors.grey,FontWeight.bold,maxLines: 10,textAlign: TextAlign.center)
                        ],
                      ),
                    ),
                  ],
                ),
                onPressed: (){
                  WidgetHelper().myModal(context,Container(
                      height: MediaQuery.of(context).size.height/1.2,
                      child: ModalDetailTestimoni(val: val.toJson())
                  ));
                  // WidgetHelper().myPush(context,DetailNewsScreen(contentModel:contentModel,idx:index));
                },
                padding: EdgeInsets.all(10.0),
              ),
              val.video!='-'?Positioned(
                top: 0,
                right: 10,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)), color:Constant().mainColor),
                    alignment: AlignmentDirectional.center,
                    child:Icon(AntDesign.videocamera,color: Colors.white)
                ),
              ):Text('')
            ],
          ),
        );
      },
      separatorBuilder: (context,index){return SizedBox(height: 10);},
    );
  }
}




class ModalFormTestimoni extends StatefulWidget {
  dynamic val;
  Function(String param) callback;
  ModalFormTestimoni({this.val,this.callback});
  @override
  _ModalFormTestimoniState createState() => _ModalFormTestimoniState();
}

class _ModalFormTestimoniState extends State<ModalFormTestimoni> {
  var titleController = TextEditingController();
  final FocusNode titleFocus = FocusNode();
  var videoController = TextEditingController();
  final FocusNode videoFocus = FocusNode();
  var captionController = TextEditingController();
  final FocusNode captionFocus = FocusNode();
  var imgController = TextEditingController();

  String img='';
  String previewImage='';

  void validate(BuildContext context){
    if(titleController.text==''){
      titleFocus.requestFocus();
      return WidgetHelper().showFloatingFlushbar(context,"failed",'pekerjaan tidak boleh kosong');
    }
    if(captionController.text==''){
      captionFocus.requestFocus();
      return WidgetHelper().showFloatingFlushbar(context,"failed",'pesan testimoni tidak boleh kosong');
    }
    if(videoController.text==''){
      videoFocus.requestFocus();
      return WidgetHelper().showFloatingFlushbar(context,"failed",'link video tidak boleh kosong');
    }
    store(context);
  }

  Future store(BuildContext context)async{
    final data={
      "title":titleController.text,
      "picture":img==''?'-':img,
      "video":videoController.text,
      "caption":captionController.text,
      "type":"1",
      "id_category":"7de638c6-e336-4b53-9beb-0a90f109911e"
    };
    WidgetHelper().loadingDialog(context);
    var res;
    if(widget.val==null){
      res = await BaseProvider().postProvider('content', data,context: context,callback: (){
        Navigator.pop(context);
      });
    }else{
      res = await BaseProvider().putProvider('content/${widget.val['id']}', data,context: context);
    }
    if(res!=null){
      Navigator.pop(context);
      WidgetHelper().notifOneBtnDialog(context,"Berhasil","Data berhasil disimpan", (){
        widget.callback("success");
        Navigator.pop(context);
        Navigator.pop(context);
      });
    }

  }

  Future handleDetail()async{
    if(widget.val!=null){
      setState(() {
        titleController.text=widget.val['jobs'];
        videoController.text=widget.val['video'];
        captionController.text=widget.val['caption'];
        previewImage=widget.val['picture'];
      });
    }
  }
  File pureImg;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoController.text='-';
    handleDetail();
  }

  @override
  Widget build(BuildContext context) {
    return  buildItem(context);
  }

  Widget buildItem(BuildContext context){
    ScreenScaler scaler = ScreenScaler()..init(context);
    return Container(
      height: scaler.getHeight(90),
      child: WidgetHelper().wrapperModal(context,"${widget.val==null?'Tambah':'Ubah'} Testimoni",Scrollbar(
          child: ListView(
            padding: scaler.getPadding(0,2),
            children: [
              WidgetHelper().myForm(
                  context,
                  "Pekerjaan",
                  titleController,
                  focusNode: titleFocus,
                  onSubmit: (_){WidgetHelper().fieldFocusChange(context, titleFocus,captionFocus);}
              ),
              SizedBox(height: scaler.getHeight(1)),
              WidgetHelper().myForm(
                context,
                "Testimoni",
                captionController,
                focusNode: captionFocus,
                maxLine: 8,
              ),
              SizedBox(height: scaler.getHeight(1)),
              WidgetHelper().myForm(
                  context,
                  "Gambar",
                  imgController,
                  isRead: true,
                  onTap: (){
                    WidgetHelper().myModal(context, CameraWidget(
                      callback: (String imgs,pureImage)async{
                        await Future.delayed(Duration(seconds: 1));
                        WidgetHelper().notifDialog(context, "Informasi","Gambar berhasil diambil",(){Navigator.pop(context);},(){
                          setState(() {
                            pureImg=pureImage;
                            imgController.text = imgs;
                          });
                          Navigator.pop(context);
                          Navigator.pop(context);
                        });
                        // Navigator.pop(context);
                        // upload(image);
                      },
                    ));
                  }
              ),
              SizedBox(height: scaler.getHeight(1)),
              WidgetHelper().myForm(
                context,
                "Video",
                videoController,
                focusNode: videoFocus,
                textInputAction: TextInputAction.done,
              ),
              SizedBox(height: scaler.getHeight(0.5)),
              RichText(
                text: TextSpan(
                    text: 'Isi dengan URL video, apabila URL tersebut diambil dari YouTube, pastikan URL tersebut merupakan',
                    style: TextStyle(fontSize: scaler.getTextSize(8),fontFamily:Constant().fontStyle,color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: ' embed URL . \n',style: TextStyle(color:Colors.green, fontSize:  scaler.getTextSize(8),fontWeight: FontWeight.bold,fontFamily:Constant().fontStyle),
                          recognizer:  TapGestureRecognizer()..onTap  = () {
                            WidgetHelper().myPush(context,Scaffold(
                                appBar: WidgetHelper().appBarWithButton(context,'Cara memasukan link youtube', (){Navigator.pop(context);},<Widget>[]),
                                body: WebViewWidget(val: {"url":'https://support.google.com/youtube/answer/171780?hl=id'})
                            ));

                            // WidgetHelper().myPush(context,WebViewWidget(val:{"title":"Cara memasukan link youtube","url":"https://support.google.com/youtube/answer/171780?hl=id"}));
                          }
                      ),
                      TextSpan(
                        text: 'Biarkan kosong atau isi dengan tanda (-) jika tidak akan mengikutsertakan video',style: TextStyle(color:Colors.red, fontSize:  scaler.getTextSize(8),fontWeight: FontWeight.bold,fontFamily:Constant().fontStyle),
                      ),
                    ]
                ),
              ),
              SizedBox(height: scaler.getHeight(1)),
              pureImg!=null?new Image.file(pureImg,width: MediaQuery.of(context).size.width/1,height: MediaQuery.of(context).size.height/2,filterQuality: FilterQuality.high):widget.val!=null?WidgetHelper().baseImage(previewImage):Text('')

            ],
          )
      ),isCallack: true,callack: (){validate(context);}),
    );
  }


}


class ModalDetailTestimoni extends StatefulWidget {
  dynamic val;
  ModalDetailTestimoni({this.val});
  @override
  _ModalDetailTestimoniState createState() => _ModalDetailTestimoniState();
}

class _ModalDetailTestimoniState extends State<ModalDetailTestimoni> {
  YoutubePlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.val['video']!='-'){
      _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(widget.val['video']),
        flags: YoutubePlayerFlags(
          // hideControls: true,
          autoPlay: false,
        ),
      );
    }
    print(widget.val);

  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper().appBarWithButton(context,widget.val['writer'],(){Navigator.pop(context);},<Widget>[]),
      body: ListView(
        children: [
          widget.val['video']!='-'?YoutubePlayer(controller: _controller):WidgetHelper().baseImage(widget.val['picture']),
          SizedBox(height:10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width/3,
              ),
              Icon(FontAwesome.quote_left,size: 10,color: Colors.grey,),
              Container(
                width: MediaQuery.of(context).size.width/3,
              ),
            ],
          ),
          SizedBox(height:10),
          Padding(
            padding: EdgeInsets.only(left:10,right:10),
            child: WidgetHelper().textQ(widget.val['caption'], 12,Colors.black,FontWeight.bold,maxLines: 12,textAlign: TextAlign.center),
          ),
          SizedBox(height:10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width/3,
              ),
              Icon(FontAwesome.quote_left,size: 10,color: Colors.grey,),
              Container(
                width: MediaQuery.of(context).size.width/3,
              ),
            ],
          ),
          SizedBox(height:10),
          ListTile(
            contentPadding: EdgeInsets.only(left:10),
            leading: Icon(Icons.work),
            title: WidgetHelper().textQ(widget.val['jobs'], 12,Colors.black,FontWeight.bold,maxLines: 12),
          ),
          ListTile(
            contentPadding: EdgeInsets.only(left:10,top: 0),
            leading: Icon(Icons.timer),
            title: WidgetHelper().textQ(FunctionHelper().formateDate(DateTime.parse(widget.val['created_at']), " "), 12,Colors.black,FontWeight.bold,maxLines: 12),
          )
        ],
      ),
    );
  }



}


class ModalOptionTestimoni extends StatefulWidget {
  dynamic val;
  Function(String param) callback;
  ModalOptionTestimoni({this.val,this.callback});
  @override
  _ModalOptionTestimoniState createState() => _ModalOptionTestimoniState();
}

class _ModalOptionTestimoniState extends State<ModalOptionTestimoni> {
  Future delete(BuildContext context)async{
    print(widget.val);
    WidgetHelper().loadingDialog(context);
    var res=await BaseProvider().deleteProvider("content/${widget.val['id']}",generalFromJson,context: context);
    Navigator.pop(context);
    print(res);
    if(res!=null){
      WidgetHelper().notifOneBtnDialog(context,"Berhasil","Data berhasil dihapus", (){
        widget.callback("success");
        Navigator.pop(context);
        Navigator.pop(context);
      });
      // Navigator.pop(context);
      // widget.callback('success');
    }
  }
  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);
    return Container(
      height: scaler.getHeight(30),
      child: WidgetHelper().wrapperModal(context,"",ListView(
        padding: scaler.getPadding(0,2),
        children: [
          ListTile(
            contentPadding: EdgeInsets.all(0),
            onTap: (){
              WidgetHelper().notifDialog(context,"Informasi !","Anda yakin akan menghapus data ini ?",(){
                Navigator.pop(context);
              },(){
                Navigator.pop(context);
                delete(context);
              });
              // widget.callback('success');
            },
            leading: Icon(Ionicons.ios_trash),
            title: WidgetHelper().textQ("Hapus", scaler.getTextSize(9),Constant().darkMode,FontWeight.bold),
          ),
          ListTile(
            contentPadding: EdgeInsets.all(0),
            onTap: (){

              WidgetHelper().myModal(context,Container(
                  height: MediaQuery.of(context).size.height/1.2,
                  child: ModalFormTestimoni(val: widget.val,callback: (String param){
                    if(param=='success'){
                      widget.callback('success');
                      Navigator.pop(context);
                    }
                  })
              ));
            },
            leading: Icon(AntDesign.edit),
            title: WidgetHelper().textQ("Edit", scaler.getTextSize(9),Constant().darkMode,FontWeight.bold),
          )
        ],
      )),
    );
  }
}
