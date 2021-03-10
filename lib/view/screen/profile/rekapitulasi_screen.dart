import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  RekapitulasiModel rekapitulasiModel;
  Future loadData()async{
    var dateFrom=DateFormat('yyyy-MM-dd').format(_selectedValue);
    var res=await BaseProvider().getProvider("member/rekapitulasi_daily?tgl=$dateFrom",rekapitulasiModelFromJson);
    if(res is RekapitulasiModel){
      RekapitulasiModel result=res;
      rekapitulasiModel=result;
      print(rekapitulasiModel.toJson());
      isLoading=false;
      _controller.animateToDate(_selectedValue);

      if(this.mounted){
        setState(() {});
      }
    }
  }


  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WidgetHelper().appBarWithButton(context,"Rekapitulasi ${FunctionHelper().formateDate(_selectedValue, "ymd")}", (){Navigator.pop(context);},<Widget>[]),
        body:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DatePicker(
              DateTime.now().subtract(Duration(days: 20)),
              width: 60,
              height: 80,
              controller: _controller,
              initialSelectedDate: DateTime.now(),
              selectionColor:Constant().mainColor,
              selectedTextColor:Constant().mainColor2,
              locale: "id_ID",

              // inactiveDates: [
              //   DateTime.now().add(Duration(days: 360)),
              // ],
              onDateChange: (date) {
                setState(() {
                  _selectedValue = date;
                  isLoading=true;
                });
                loadData();
                // _controller.
                // print(DateFormat.yMd('id').format(_selectedValue));
              },
            ),
            Expanded(
                child: ListView(
                  children: [
                    buildItem(context,"PERTUMBUHAN","KIRI","${isLoading?'':rekapitulasiModel.result.pertumbuhanKiri}",title2:"KANAN",value2:"${isLoading?'':rekapitulasiModel.result.pertumbuhanKanan}"),
                    SizedBox(height: 10),
                    buildItem(context,"TABUNGAN","KIRI","${isLoading?'':rekapitulasiModel.result.tabunganKiri}",title2:"KANAN",value2:"${isLoading?'':rekapitulasiModel.result.tabunganKanan}"),
                    SizedBox(height: 10),
                    buildItem(context,"BALANCE","KIRI","${isLoading?'':rekapitulasiModel.result.balanceKiri}",title2:"KANAN",value2: "${isLoading?'':rekapitulasiModel.result.balanceKanan}"),
                    SizedBox(height: 10),
                    buildItems(context,"TERPASANG (T)", isLoading?'':"Rp ${FunctionHelper().formatter.format(rekapitulasiModel.result.hakBonus)} .-"),
                    SizedBox(height: 10),
                    buildItems(context,"BONUS (T x 20.000) ", isLoading?'':"Rp ${FunctionHelper().formatter.format(rekapitulasiModel.result.nominalBonus)} .-")
                  ],
                )
            )
          ],
        )
    );
  }

  Widget buildItem(BuildContext context,String title,String title1, String value1,{String title2, String value2}){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(top:10,bottom: 10,left:15,right:15),
          color: Constant().greyColor,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WidgetHelper().textQ(title,14,Constant().greenColor,FontWeight.bold),
            ],
          ),
        ),
        SizedBox(height:10),
        Container(
          padding: EdgeInsets.only(left:15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              isLoading?WidgetHelper().baseLoading(context,Container(color: Colors.white,width: 150,height: 15)):Container(
                width: 150,
                child:  WidgetHelper().textQ(title1,14,Constant().darkMode,FontWeight.bold),
              ),
              WidgetHelper().textQ(":",14,Constant().darkMode,FontWeight.bold),
              SizedBox(width: 10),
              isLoading?WidgetHelper().baseLoading(context,Container(color: Colors.white,width: 150,height: 15)):WidgetHelper().textQ(value1,14,Constant().darkMode,FontWeight.bold),
            ],
          ),
        ),
        Divider(),
        Container(
          padding: EdgeInsets.only(left:15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              isLoading?WidgetHelper().baseLoading(context,Container(color: Colors.white,width: 150,height: 15)):Container(
                width: 150,
                child:  WidgetHelper().textQ(title2,14,Constant().darkMode,FontWeight.bold),
              ),
              WidgetHelper().textQ(":",14,Constant().darkMode,FontWeight.bold),
              SizedBox(width: 10),
              isLoading?WidgetHelper().baseLoading(context,Container(color: Colors.white,width: 150,height: 15)):WidgetHelper().textQ(value2,14,Constant().darkMode,FontWeight.bold),
            ],
          ),
        ),
      ],
    );
  }
  Widget buildItems(BuildContext context,String title,String value){
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top:10,bottom: 10,left:15,right:15),
          color: Constant().greyColor,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left:0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 150,
                      child:  WidgetHelper().textQ(title,14,Constant().greenColor,FontWeight.bold),
                    ),
                    WidgetHelper().textQ(":",14,Constant().darkMode,FontWeight.bold),
                    SizedBox(width: 10),
                    isLoading?WidgetHelper().baseLoading(context,Container(color: Colors.white,width: 150,height: 15)):WidgetHelper().textQ(value,14,Constant().darkMode,FontWeight.bold),
                  ],
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }
}
