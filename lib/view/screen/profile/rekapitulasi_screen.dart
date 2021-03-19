// import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
// import 'package:flutter_date_picker_timeline/flutter_date_picker_timeline.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:horizontal_center_date_picker/date_item.dart';
import 'package:horizontal_center_date_picker/datepicker_controller.dart';
// import 'package:horizontal_date_picker/datepicker_controller.dart';
// import 'package:horizontal_center_date_picker/datepicker_controller.dart';
import 'package:horizontal_center_date_picker/horizontal_date_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/mlm/rekapitulasi_model.dart';
import 'package:sangkuy/provider/base_provider.dart';

class RekapitulasiScreen extends StatefulWidget {
  @override
  _RekapitulasiScreenState createState() => _RekapitulasiScreenState();
}

class _RekapitulasiScreenState extends State<RekapitulasiScreen> {
  DatePickerController _controller = DatePickerController();
  DateTime _selectedValue = DateTime.now();
  bool isLoading=true;
  bool isLoadingFirst=true;
  RekapitulasiModel rekapitulasiModel;
  double sizeFont = 9;
  // DatePickerController
  Future loadData()async{
    var dateFrom=DateFormat('yyyy-MM-dd').format(_selectedValue);
    var res=await BaseProvider().getProvider("member/rekapitulasi_daily?tgl=$dateFrom",rekapitulasiModelFromJson);
    if(res is RekapitulasiModel){
      RekapitulasiModel result=res;
      rekapitulasiModel=result;
      print(rekapitulasiModel.toJson());
      // _controller.animateToDate(_selectedValue);
      _controller.scrollToSelectedItem(true);

      // _scaffoldKey.currentState.setState(() {
      //   isLoading=false;
      // });
      // notifyListeners();

      if(this.mounted){
        setState(() {
          isLoading=false;
          isLoadingFirst=false;
        });
      }
    }
  }


  @override
  void initState() {
    super.initState();
    loadData();
    initializeDateFormatting('id');
  }
  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isBlock=true;
  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);
    String anying='';
    var now = DateTime.now();
    print(DateFormat.E('id').format(now));
    return Scaffold(
      // key: _scaffoldKey,
        appBar: WidgetHelper().appBarWithButton(context,"Rekapitulasi", (){Navigator.pop(context);},<Widget>[
          isLoadingFirst?Text(''):FlatButton(
              onPressed: (){},
              child: Column(
                children: [
                  WidgetHelper().baseImage(rekapitulasiModel.result.badge,height:scaler.getHeight(3)),
                  WidgetHelper().textQ(rekapitulasiModel.result.membership,scaler.getTextSize(sizeFont),Constant().mainColor2,FontWeight.bold)
                ],
              )
          )
        ]),
        body:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Expanded(
                child: ListView(
                  children: [

                    Container(
                      child: WidgetHelper().titleNoButton(context,Ionicons.ios_timer," ${FunctionHelper().formateDate(_selectedValue, "ymd")}",color: Constant().darkMode,iconSize: 12,fontSize: sizeFont),
                      margin: EdgeInsets.only(left: 10,top:10),
                    ),
                    SizedBox(height: scaler.getHeight(1)),
                    buildItems(context,"Sisa Plafon ", isLoading?'':"Rp ${FunctionHelper().formatter.format(rekapitulasiModel.result.sisaPlafon)} .-"),
                    // SizedBox(height: scaler.getHeight(1)),
                    buildItem(context,"Pertumbuhan","Kiri","${isLoading?'':rekapitulasiModel.result.pertumbuhanKiri}",title2:"Kanan",value2:"${isLoading?'':rekapitulasiModel.result.pertumbuhanKanan}"),
                    SizedBox(height: scaler.getHeight(1)),
                    buildItem(context,"Tabungan","Kiri","${isLoading?'':rekapitulasiModel.result.tabunganKiri}",title2:"Kanan",value2:"${isLoading?'':rekapitulasiModel.result.tabunganKanan}"),
                    SizedBox(height: scaler.getHeight(1)),
                    buildItem(context,"Balance","Kiri","${isLoading?'':rekapitulasiModel.result.balanceKiri}",title2:"Kanan",value2: "${isLoading?'':rekapitulasiModel.result.balanceKanan}"),
                    SizedBox(height: scaler.getHeight(1)),
                    buildItems(context,"Terpasang (T)", isLoading?'':"Rp ${FunctionHelper().formatter.format(rekapitulasiModel.result.hakBonus)} .-"),
                    // SizedBox(height: scaler.getHeight(1)),
                    buildItems(context,"Bonus (T x 20.000) ", isLoading?'':"Rp ${FunctionHelper().formatter.format(rekapitulasiModel.result.nominalBonus)} .-")
                  ],
                )
            )
          ],
        ),
      bottomNavigationBar: Container(

        // alignment: Alignment.center,
        child: HorizontalDatePickerWidget(
          // dateItemComponentList: [DateIt/em.values[DateTime.april]],
          normalTextColor: Colors.white,
          selectedTextColor: Constant().mainColor2,
          normalColor: Constant().greenColor,
          selectedColor: Constant().mainColor,
          startDate: now.subtract(Duration(days: 30)),
          endDate: now,
          selectedDate: now.toLocal(),
          widgetWidth: MediaQuery.of(context).size.width,
          datePickerController: _controller,
          onValueSelected: (date) {
            print('selected = ${date.toIso8601String()}');
            setState(() {
              _selectedValue=date;
              isLoading=true;
            });
            loadData();
          },
        ),
      ),
    );
  }

  Widget buildItem(BuildContext context,String title,String title1, String value1,{String title2, String value2}){
    ScreenScaler scaler = ScreenScaler()..init(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding:scaler.getPadding(0.5,2),
          color: Constant().greyColor,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WidgetHelper().textQ(title,scaler.getTextSize(sizeFont),Constant().greenColor,FontWeight.bold,letterSpacing: 2),
            ],
          ),
        ),
        SizedBox(height:scaler.getHeight(1)),
        Container(
          padding:scaler.getPadding(0,2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: scaler.getWidth(40),
                child:  WidgetHelper().textQ(title1,scaler.getTextSize(sizeFont),Constant().darkMode,FontWeight.bold,letterSpacing: 2),
              ),
              WidgetHelper().textQ(":",scaler.getTextSize(sizeFont),Constant().darkMode,FontWeight.bold),
              SizedBox(width: scaler.getWidth(2)),
              isLoading?_loading(context):WidgetHelper().textQ(value1,scaler.getTextSize(sizeFont),Constant().moneyColor,FontWeight.bold),
            ],
          ),
        ),
        Divider(),
        Container(
          padding:scaler.getPadding(0,2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: scaler.getWidth(40),
                child:  WidgetHelper().textQ(title2,scaler.getTextSize(sizeFont),Constant().darkMode,FontWeight.bold,letterSpacing: 2),
              ),
              WidgetHelper().textQ(":",scaler.getTextSize(sizeFont),Constant().darkMode,FontWeight.bold),
              SizedBox(width:  scaler.getWidth(2)),
              isLoading?_loading(context):WidgetHelper().textQ(value2,scaler.getTextSize(sizeFont),Constant().moneyColor,FontWeight.bold),
            ],
          ),
        ),
      ],
    );
  }
  Widget buildItems(BuildContext context,String title,String value){
    ScreenScaler scaler = ScreenScaler()..init(context);

    return Container(
      padding:scaler.getPadding(0.5,2),
      color: Constant().greyColor,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: scaler.getWidth(40),
            child:  WidgetHelper().textQ(title,scaler.getTextSize(sizeFont),Constant().greenColor,FontWeight.bold,letterSpacing: 2),
          ),
          WidgetHelper().textQ(":",scaler.getTextSize(sizeFont),Constant().darkMode,FontWeight.bold),
          SizedBox(width:  scaler.getWidth(2)),
          isLoading?_loading(context):WidgetHelper().textQ(value,scaler.getTextSize(sizeFont),Constant().moneyColor,FontWeight.bold),
        ],
      ),
    );
  }
  
  Widget _loading(BuildContext context){
    ScreenScaler scaler = ScreenScaler()..init(context);
    return WidgetHelper().baseLoading(context,Container(color: Colors.white,width:scaler.getWidth(10),height:scaler.getHeight(1)));
  }
}


class Counter with ChangeNotifier, DiagnosticableTreeMixin {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('count', count));
  }
}