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
  
  RekapitulasiModel rekapitulasiModel;
  List data=[];
  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');
  Future loadData()async{
    // print(formatter.format(now.subtract(Duration(days: 1))));
    String date='';
    for(var i=1;i<6;i++){
      if(i==1){
        date=formatter.format(now);
      }else{
        date=formatter.format(now.subtract(Duration(days: i-1)));
      }
      print(date);
      var res = await BaseProvider().getProvider('member/rekapitulasi_daily?tgl='+date, rekapitulasiModelFromJson);
      RekapitulasiModel result=res;
      // setState(() {
      //   rekapitulasiModel=res;
      //   data.add({
      //     "tgl":"$date",
      //     "balanceKanan":rekapitulasiModel.result.balanceKanan,
      //     "balanceKiri":rekapitulasiModel.result.balanceKiri,
      //     "pertumbuhanKanan":rekapitulasiModel.result.pertumbuhanKanan,
      //     "pertumbuhanKiri":rekapitulasiModel.result.pertumbuhanKiri,
      //     "tabunganKanan":rekapitulasiModel.result.tabunganKanan,
      //     "tabunganKiri":rekapitulasiModel.result.tabunganKiri,
      //     "terpasang":rekapitulasiModel.result.hakBonus,
      //     "bonus":(rekapitulasiModel.result.hakBonus*rekapitulasiModel.result.nominalBonus),
      //   });
      // });
      print(result.result.toJson());
    }
    print("=================== DATA SERVER  =======================");

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
    final desktopSalesData = [
      new OrdinalSales("${formatter.format(now)}", 5),
      new OrdinalSales('${formatter.format(now.subtract(Duration(days: 1)))}', 25),
      new OrdinalSales('${formatter.format(now.subtract(Duration(days: 2)))}', 100),
      new OrdinalSales('${formatter.format(now.subtract(Duration(days: 3)))}', 75),
      new OrdinalSales('${formatter.format(now.subtract(Duration(days: 4)))}', 75),
    ];

    final tabletSalesData = [
      new OrdinalSales('2021-02-24', 25),
      new OrdinalSales('2021-02-23', 50),
      new OrdinalSales('2021-02-22', 10),
      new OrdinalSales('2021-02-21', 20),
      new OrdinalSales('2021-02-20', 20),
    ];

    final mobileSalesData = [
      new OrdinalSales('2021-02-24', 10),
      new OrdinalSales('2021-02-23', 15),
      new OrdinalSales('2021-02-22', 50),
      new OrdinalSales('2021-02-21', 45),
      new OrdinalSales('2021-02-20', 45),
    ];

    final otherSalesData = [
      new OrdinalSales('2021-02-24', 20),
      new OrdinalSales('2021-02-23', 35),
      new OrdinalSales('2021-02-22', 15),
      new OrdinalSales('2021-02-21', 10),
      new OrdinalSales('2021-02-20', 10),
    ];
    final mobileSalesData1 = [
      new OrdinalSales('2021-02-24', 10),
      new OrdinalSales('2021-02-23', 15),
      new OrdinalSales('2021-02-22', 50),
      new OrdinalSales('2021-02-21', 45),
      new OrdinalSales('2021-02-20', 45),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        seriesColor:charts.ColorUtil.fromDartColor(Color(0xFFdc3545)),
        id: '',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: desktopSalesData,
        displayName: 'ACUY'
      ),
      new charts.Series<OrdinalSales, String>(
        seriesColor:charts.ColorUtil.fromDartColor(Color(0xFFffc107)),
        displayName: 'ACUY',
        id: '',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: tabletSalesData,


      ),
      new charts.Series<OrdinalSales, String>(
        seriesColor:charts.ColorUtil.fromDartColor(Color(0xFF5d78ff )),
        id: '',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: mobileSalesData,
        displayName: 'ACUY',

      ),
      new charts.Series<OrdinalSales, String>(
        seriesColor:charts.ColorUtil.fromDartColor(Constant().mainColor),
        id: '',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: otherSalesData,
        displayName: 'ACUY',

      ),
      new charts.Series<OrdinalSales, String>(
        seriesColor:charts.ColorUtil.fromDartColor(Colors.green),
        id: '',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: mobileSalesData1,
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