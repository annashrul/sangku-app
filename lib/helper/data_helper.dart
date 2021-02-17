import 'package:flutter_icons/flutter_icons.dart';
import 'package:sangkuy/config/constant.dart';

class DataHelper{
  static List dataPPOB=[
    'https://ecs7.tokopedia.net/img/cache/100-square/attachment/2020/8/28/47197032/47197032_914c9752-19e1-42b0-8181-91ef0629fd8a.png',
    'https://ecs7.tokopedia.net/img/cache/100-square/attachment/2019/10/22/21181130/21181130_907dac9a-c185-43d1-b459-2389f0b6efea.png',
    'https://ecs7.tokopedia.net/img/cache/100-square/attachment/2019/10/22/21181130/21181130_53682a49-5247-4374-82c0-4c2a8d3bdbea.png',
    'https://ecs7.tokopedia.net/img/cache/100-square/attachment/2019/12/13/51829405/51829405_77281743-12fd-402b-b212-67b52516229c.png',
    'https://ecs7.tokopedia.net/img/cache/100-square/attachment/2019/11/15/21181130/21181130_5ee75889-94bc-45d3-9ce6-5ecf466fb385.png',
    'https://ecs7.tokopedia.net/img/cache/100-square/attachment/2019/10/22/21181130/21181130_5e0e4f34-0e41-48c4-baa0-dbf8a5e151d2.png',
    'https://ecs7.tokopedia.net/img/cache/100-square/attachment/2019/11/15/21181130/21181130_a40bc9db-8fd8-426f-985f-9930fe83711a.png',
    'https://ecs7.tokopedia.net/img/cache/100-square/attachment/2020/1/23/47197032/47197032_0de76bd3-0481-4ee2-8c52-9700cbbc3ae7.png',
    'https://ecs7.tokopedia.net/img/cache/100-square/attachment/2020/3/27/41313334/41313334_ed6fac94-00eb-4a37-bd4e-6ecab312e6f2.png',
    'https://ecs7.tokopedia.net/img/cache/100-square/attachment/2019/11/15/21181130/21181130_0653d8df-0bb4-4714-9267-b987298c0420.png'
  ];
  static List dataWallet=[
    {'title':"Top Up",'icon':Constant().localIcon+'topup_icon.svg'},
    {'title':"Transfer",'icon':Constant().localIcon+'transfer_icon.svg'},
    {'title':"Penarikan",'icon':Constant().localIcon+'history_icon.svg'},
  ];
  static List dataStockist=[
    {'title':"PIN Aktivasi",'icon':Constant().localIcon+'lainnya_icon.svg',"type":"1"},
    {'title':"PIN Repeat Order",'icon':Constant().localIcon+'lainnya_icon.svg',"type":"ro"},
  ];
  static List filterStockist=[
    {"kode":"1","value": "TERSEDIA"},
    {"kode":"0","value": "TELAH DIAKTIVASI"},
    {"kode":"3","value": "TERPAKAI"},
    {"kode":"4","value": "DI TRANSFER"},
  ];
  static List filterHistoryDeposit=[
    {"kode":"","value": "Semua"},
    {"kode":"0","value": "Pending"},
    {"kode":"1","value": "Selesai"},
    {"kode":"2","value": "Batal"},
  ];
  static var filterHistoryPembelian=[
    {"kode":"","value": "Semua"},
    {"kode":"0","value": "Menunggu Pembayaran"},
    {"kode":"1","value": "Dikemas"},
    {"kode":"2","value": "Dikirim"},
    {"kode":"3","value": "Selesai"},
    {"kode":"4","value": "Dibatalkan"},
  ];
  static List dataProfile=[
    {'title':"Sponsor",'icon':AntDesign.addusergroup},
    {'title':"PIN",'icon':AntDesign.chrome},
    {'title':"PV Kiri",'icon':AntDesign.left},
    {'title':"PV Kanan",'icon':AntDesign.right},
  ];

}