import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/refresh_widget.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/content/testimoni_model.dart';
import 'package:sangkuy/model/general_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:sangkuy/provider/content_provider.dart';
import 'package:sangkuy/view/screen/content/news/detail_news_screen.dart';
import 'package:sangkuy/view/screen/mlm/history/resi_screen.dart';
import 'package:sangkuy/view/widget/camera_widget.dart';
import 'package:sangkuy/view/widget/loading/testimoni_loading.dart';
import 'package:sangkuy/view/widget/testimoni_widget.dart';
class TestimoniScreen extends StatefulWidget {
  @override
  _TestimoniScreenState createState() => _TestimoniScreenState();
}

class _TestimoniScreenState extends State<TestimoniScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = new GlobalKey<AnimatedListState>();
  bool isLoadingTestimoni=false,isLoadmore=false;
  TestimoniModel testimoniModel;
  int perpage=10,total=0;
  ScrollController controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future loadTestimoni()async{
    var res = await ContentProvider().loadTestimoni("perpage=$perpage");
    if(this.mounted) setState(() {
      testimoniModel = res;
      isLoadingTestimoni=false;
      isLoadmore=false;
      total=testimoniModel.result.total;
    });
  }
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
        IconButton(icon: Icon(AntDesign.pluscircleo), onPressed: (){
          WidgetHelper().myModal(context,ModalFormTestimoni(val: null,callback: (param){
            if(param=='success'){
              setState(() {
                isLoadingTestimoni=true;
              });
              loadTestimoni();
            }
          }));
        })
      ]),
      body:  isLoadingTestimoni?TestimoniLoading(): RefreshWidget(
        widget: Stack(
          children: <Widget>[
            BuildTimeLine(),
            new ListView.builder(
              controller: controller,
              // physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              shrinkWrap: true,
              itemCount: testimoniModel.result.data.length,
              itemBuilder: (context, index) {
                return  new Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  child: new Row(
                    children: <Widget>[
                      new Padding(
                        padding:
                        new EdgeInsets.symmetric(horizontal: 15.0 - 12.0 / 2),
                        child: new Container(
                          height: 12.0,
                          width: 12.0,
                          decoration: new BoxDecoration(shape: BoxShape.circle, color:Constant().greyColor),
                        ),
                      ),
                      new Expanded(
                        child: TestimoniWidget(testimoniModel: testimoniModel,index:index),
                      ),
                    ],
                  ),
                );
              },
            ),

          ],
        ),
        callback: (){
          isLoadingTestimoni=true;
          setState(() {});
          loadTestimoni();
        },
      ),
      bottomNavigationBar: isLoadmore?TestimoniLoading(total: 1):FlatButton(
          onPressed: (){},
          padding: EdgeInsets.all(17.0),
          color: Constant().moneyColor,
          child: WidgetHelper().textQ("Lihat Testimoni Saya",14,Colors.white,FontWeight.bold)
      ),
    );
  }
}


class ModalFormTestimoni extends StatefulWidget {
  dynamic val;Function(String param) callback;
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
  String img='';

  void validate(BuildContext context){
    if(titleController.text==''){
      titleFocus.requestFocus();
      return WidgetHelper().showFloatingFlushbar(context,"failed",'pekerjaan tidak boleh kosong');
    }
    store(context);
  }

  Future store(BuildContext context)async{
    final data={
      "title":titleController.text,
      "picture":img,
      "video":videoController.text,
      "caption":captionController.text,
      "type":"1",
      "id_category":"7de638c6-e336-4b53-9beb-0a90f109911e"
    };
    WidgetHelper().loadingDialog(context);
    var res = await BaseProvider().postProvider('content', data,context: context);
    Navigator.pop(context);
    if(res is General){
      General result=res;
      WidgetHelper().showFloatingFlushbar(context,"failed",result.msg);
    }else{
      WidgetHelper().notifOneBtnDialog(context,"Berhasil","Data berhasil disimpan", (){
        widget.callback("success");
        Navigator.pop(context);
        Navigator.pop(context);
        // Navigator.pop(context);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoController.text='-';
  }

  @override
  Widget build(BuildContext context) {
    return  buildContent(context);
  }

  Widget buildContent(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height/1.2,
      padding: EdgeInsets.only(top:10.0,left:0,right:0),
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),topRight:Radius.circular(10.0) ),
      ),
      // color: Colors.white,
      child: Column(
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
            leading: InkWell(
              onTap: ()=>Navigator.pop(context),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Center(child: Icon(AntDesign.back, color:Theme.of(context).hintColor),),
              ),
            ),
            title: WidgetHelper().textQ("${widget.val==null?'Tambah':'Ubah'} Testimoni",14, Theme.of(context).hintColor, FontWeight.bold),
            trailing: InkWell(
                onTap: ()async{
                  validate(context);
                },
                child: Container(
                  padding: EdgeInsets.all(7.0),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Constant().secondColor,Constant().secondColor]),
                      borderRadius: BorderRadius.circular(6.0),
                      boxShadow: [BoxShadow(color: Color(0xFF6078ea).withOpacity(.3),offset: Offset(0.0, 8.0),blurRadius: 8.0)]
                  ),
                  child: WidgetHelper().textQ("Simpan",14,Colors.white,FontWeight.bold),
                )
            ),
          ),
          Divider(),
          SizedBox(height:10.0),
          Expanded(
            child: ListView(
              children: [
                Container(
                    padding: EdgeInsets.all(10.0),
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WidgetHelper().textQ("Pekerjaan",12,Constant().darkMode, FontWeight.bold),
                        SizedBox(height:5.0),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFEEEEEE),
                            borderRadius: BorderRadius.all(
                                Radius.circular(10.0)
                            ),
                          ),
                          padding: EdgeInsets.only(left:10.0,right:10.0),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            style: TextStyle(color:Constant().darkMode,fontSize:14,fontFamily: Constant().fontStyle,fontWeight: FontWeight.bold),
                            controller: titleController,
                            focusNode: titleFocus,
                            autofocus: false,
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none,),
                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none,),
                                hintStyle: TextStyle(color:Constant().darkMode,fontSize: 14,fontFamily: Constant().fontStyle,fontWeight: FontWeight.bold)
                            ),
                            onFieldSubmitted: (_){
                              WidgetHelper().fieldFocusChange(context, titleFocus,captionFocus);
                            },
                          ),
                        ),
                        SizedBox(height:10.0),
                        WidgetHelper().textQ("Testimoni",12,Constant().darkMode, FontWeight.bold),
                        SizedBox(height:5.0),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFEEEEEE),
                            borderRadius: BorderRadius.all(
                                Radius.circular(10.0)
                            ),
                          ),
                          padding: EdgeInsets.only(left:10.0,right:10.0),
                          child: TextFormField(
                            maxLines: 8,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            style: TextStyle(color:Constant().darkMode,fontSize:14,fontFamily: Constant().fontStyle,fontWeight: FontWeight.bold),
                            controller: captionController,
                            focusNode: captionFocus,
                            autofocus: false,
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none,),
                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none,),
                                hintStyle: TextStyle(color:Constant().darkMode,fontSize: 14,fontFamily: Constant().fontStyle,fontWeight: FontWeight.bold)
                            ),
                            onFieldSubmitted: (_){
                              WidgetHelper().fieldFocusChange(context, captionFocus,videoFocus);
                              // WidgetHelper().
                              // WidgetHelper().fieldFocusChange(context, titleFocus,receiverFocus);
                            },
                          ),
                        ),
                        SizedBox(height:10.0),
                        WidgetHelper().textQ("Gambar",12,Constant().darkMode, FontWeight.bold),
                        SizedBox(height:5.0),
                        InkWell(
                          onTap: (){
                            WidgetHelper().myModal(context, CameraWidget(
                              callback: (String imgs)async{
                                setState(() {
                                  img = imgs;
                                });
                                Navigator.pop(context);
                                // upload(image);
                              },
                            ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFEEEEEE),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10.0)
                              ),
                            ),
                            width: double.infinity,
                            padding: EdgeInsets.only(left:10.0,right:10.0,top:20,bottom:20),
                            child: WidgetHelper().textQ(img,12,Constant().darkMode,FontWeight.bold),
                          ),
                        ),
                        SizedBox(height:10.0),
                        WidgetHelper().textQ("Video",12,Constant().darkMode, FontWeight.bold),
                        SizedBox(height:5.0),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFEEEEEE),
                            borderRadius: BorderRadius.all(
                                Radius.circular(10.0)
                            ),
                          ),
                          padding: EdgeInsets.only(left:10.0,right:10.0),
                          child: TextFormField(
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                            style: TextStyle(color:Constant().darkMode,fontSize:14,fontFamily: Constant().fontStyle,fontWeight: FontWeight.bold),
                            controller: videoController,
                            focusNode: videoFocus,
                            autofocus: false,
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none,),
                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none,),
                                hintStyle: TextStyle(color:Constant().darkMode,fontSize: 14,fontFamily: Constant().fontStyle,fontWeight: FontWeight.bold)
                            ),
                            onFieldSubmitted: (_){
                              // WidgetHelper().fieldFocusChange(context, titleFocus,receiverFocus);
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left:0.0,right:0.0),
                          child: RichText(
                            text: TextSpan(
                                text: 'Isi dengan URL video, apabila URL tersebut diambil dari YouTube, pastikan URL tersebut merupakan',
                                style: TextStyle(fontSize: 12,fontFamily:Constant().fontStyle,color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: ' embed URL . \n',style: TextStyle(color:Colors.green, fontSize: 12,fontWeight: FontWeight.bold,fontFamily:Constant().fontStyle),
                                      recognizer:  TapGestureRecognizer()..onTap  = () {
                                        WidgetHelper().myPush(context,WebViewWidget(val:{"title":"Cara memasukan link youtube","url":"https://support.google.com/youtube/answer/171780?hl=id"}));
                                      }
                                  ),
                                  TextSpan(
                                    text: 'Biarkan kosong atau isi dengan tanda (-) jika tidak akan mengikutsertakan video',style: TextStyle(color:Colors.red, fontSize: 12,fontWeight: FontWeight.bold,fontFamily:Constant().fontStyle),
                                  ),
                                  // TextSpan(text: ' di depan No.Rekening atas nama',style: TextStyle(fontSize: 12,fontFamily:Constant().fontStyle)),
                                  // TextSpan(text: ' ${getPaymentModel.result.accName}',style: TextStyle(color:Colors.green, fontSize: 12,fontWeight: FontWeight.bold,fontFamily:Constant().fontStyle)),
                                ]
                            ),
                          ),
                        )
                      ],
                    )
                ),


              ],
            ),
          )
        ],
      ),
    );
  }

}

