import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:sangkuy/model/mlm/rekapitulasi_model.dart';
import 'package:sangkuy/provider/base_provider.dart';

class IconRenderer extends charts.CustomSymbolRenderer {
  final IconData iconData;

  IconRenderer(this.iconData);

  @override
  Widget build(BuildContext context, {Size size, Color color, bool enabled}) {
    // Lighten the color if the symbol is not enabled
    // Example: If user has tapped on a Series deselecting it.
    if (!enabled) {
      color = color.withOpacity(0.26);
    }

    return new SizedBox.fromSize(
        size: size, child: new Icon(iconData, color: color, size: 12.0));
  }
}
class BarChartHome extends StatefulWidget {
  @override
  _BarChartHomeState createState() => _BarChartHomeState();
}

class _BarChartHomeState extends State<BarChartHome> {
  OrdinalSales ordinalSales;
  RekapitulasiModel rekapitulasiModel;
  List<OrdinalSales> data=[];
  List<OrdinalSales> balanceKanan=[];
  List<OrdinalSales> balanceKiri=[];
  List<OrdinalSales> pertumbuhanKanan=[];
  List<OrdinalSales> pertumbuhanKiri=[];
  List<OrdinalSales> tabunganKanan=[];
  List<OrdinalSales> tabunganKiri=[];
  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');
  Future loadData()async{
    // print(formatter.format(now.subtract(Duration(days: 1))));
    String date='';
    for(var i=1;i<10;i++){
      // if(i==1){
      //   date=formatter.format(now);
      // }else{
      //   date=formatter.format(now.subtract(Duration(days: 30-i)));
      // }
      date=formatter.format(now.subtract(Duration(days: 30-i)));
      print(date);
      var res = await BaseProvider().getProvider('member/rekapitulasi_daily?tgl='+date, rekapitulasiModelFromJson);
      RekapitulasiModel result=res;
      setState(() {
        rekapitulasiModel=res;
        balanceKanan.add(OrdinalSales(date,rekapitulasiModel.result.balanceKanan));
        balanceKiri.add(OrdinalSales(date,rekapitulasiModel.result.balanceKiri));
        pertumbuhanKanan.add(OrdinalSales(date,rekapitulasiModel.result.pertumbuhanKanan));
        pertumbuhanKiri.add(OrdinalSales(date,rekapitulasiModel.result.pertumbuhanKiri));
        tabunganKanan.add(OrdinalSales(date,rekapitulasiModel.result.tabunganKanan));
        tabunganKiri.add(OrdinalSales(date,rekapitulasiModel.result.tabunganKiri));
      });
    }
    print("=================== DATA SERVER  =======================");
    print(balanceKanan);
    print("=================== DATA SERVER  =======================");
    // var res=await BaseProvider().getProvider('member/rekapitulasi_daily?tgl='+formatter.format(now.subtract(Duration(days: 1))), rekapitulasiModelFromJson);
    // if(mounted){
      setState(() {
        // rekapitulasiModel=res;
        isLoading=false;
      });
    //   print("REPOSNSE REKAPITULASU ${rekapitulasiModel.result.toJson()}");
    // }
  }
  bool isLoading=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
    isLoading=true;
  }
  
  @override
  Widget build(BuildContext context) {
    return isLoading?Text(''):new charts.BarChart(
      _createSampleData(),
      animate: true,
      // barGroupingType: charts.BarGroupingType.grouped,
      // behaviors: [new charts.SeriesLegend()],
      // defaultRenderer: new charts.BarRendererConfig(symbolRenderer:IconRenderer(Icons.cloud)),
    );
  }

  /// Create series list with multiple series
  List<charts.Series<OrdinalSales, String>> _createSampleData() {
    return [
      new charts.Series<OrdinalSales, String>(
        seriesColor:charts.ColorUtil.fromDartColor(Color(0xFFffc107)),
        displayName: 'ACUY',
        id: '',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      ),
      new charts.Series<OrdinalSales, String>(
        seriesColor:charts.ColorUtil.fromDartColor(Color(0xFF5d78ff )),
        id: '',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: balanceKiri,
        displayName: 'ACUY',

      ),
      new charts.Series<OrdinalSales, String>(
        seriesColor:charts.ColorUtil.fromDartColor(Constant().mainColor),
        id: '',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: pertumbuhanKanan,
        displayName: 'ACUY',

      ),
      new charts.Series<OrdinalSales, String>(
        seriesColor:charts.ColorUtil.fromDartColor(Colors.green),
        id: '',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: pertumbuhanKiri,
        displayName: 'ACUY',

      ),
      new charts.Series<OrdinalSales, String>(
        seriesColor:charts.ColorUtil.fromDartColor(Colors.green),
        id: '',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: tabunganKanan,
        displayName: 'ACUY',
      ),
      new charts.Series<OrdinalSales, String>(
        seriesColor:charts.ColorUtil.fromDartColor(Colors.green),
        id: '',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: tabunganKiri,
        displayName: 'ACUY',
      )
    ];
  }
}

class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}