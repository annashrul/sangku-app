import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/view/screen/auth/sign_in_screen.dart';

class RuleScreen extends StatefulWidget {
  Function() callback;
  RuleScreen({this.callback});
  @override
  _RuleScreenState createState() => _RuleScreenState();
}

class _RuleScreenState extends State<RuleScreen> {
  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);

    return WidgetHelper().wrapperModal(context,"Informasi", Scaffold(
      body: ListView(
        padding: scaler.getPadding(0,2),
        children: [
          Center(
            child: WidgetHelper().textQ('Berita Ketetapan Management SangQu Masa Persiapan',scaler.getTextSize(10), Constant().darkMode, FontWeight.bold,letterSpacing: 2,textAlign: TextAlign.center),
          ),
          Divider(thickness: 2),
          WidgetHelper().textQ('PT Sangkuriang Sinergi Insan adalah perusahaan legal yang mentaati setiap regulasi yang telah ditetapkan oleh pemerintah Republik Indonesia berkaitan dengan pemenuhan aspek legal operasi sebuah perusahaan.',scaler.getTextSize(9), Constant().darkMode, FontWeight.normal,textAlign: TextAlign.left,maxLines: 100),
          SizedBox(height: 5),
          WidgetHelper().textQ('Sehubungan dengan tengah menunggunya proses penyelesaian ijin khusus beroperasinya sebagai perusahaan yang bergerak di bidang network marketing, dengan ini Management PT Sangkuriang Sinergi Insan menyampaikan ketetapan yang harus diikuti oleh setiap calon distributor sebagai berikut:',scaler.getTextSize(9), Constant().darkMode, FontWeight.normal,textAlign: TextAlign.left,maxLines: 100),
          SizedBox(height: 5),
          points(
            "1",
            "Dilarang untuk melakukan transaksi hingga Program sangQu dinyatakan resmi dibuka oleh pihak Management SangQu, segala aktifitas komitment transaksi bersifat individual dan Management SangQu tidak membuka pelayanan transaksi barang / paket hingga waktu yang akan ditetapkan kemudian."
          ),
          SizedBox(height: 5),
          points(
              "2",
              "Calon member dilarang untuk mengupload segala aktifitas yang berkaitan dengan aktifitas di masa persiapan ini di semua platform media social secara terbuka/umum, terkecuali share informasi di media yang bersifat Clossed Grup (tertutup ) dan khusus hanya untuk konsumsi internal."
          ),
          SizedBox(height: 5),
          points(
              "3",
              "Akses login di website & Apps hanya bersifat trial- uji coba, dimana calon member dapat merasakan fitur-fitur fasilitas bisnis yang telah disiapkan oleh Management SangQu dan ditujukan untuk mendapat masukan yang bersifat evaluative pada masa persiapan ini."
          ),
          SizedBox(height: 5),
          points(
              "4",
              "Management SangQu tidak bertanggung jawab atas segala aktifitas individu yang menyatakan dirinya sebagai calon member SangQu dan melalukan tindakan diluar ketentuan yang telah ditetapkan oleh pihak Management Sangqu di masa persiapan ini."
          ),
          SizedBox(height: 5),
          WidgetHelper().textQ('Management sangQu berhak menolak pengajuan keanggotaan program SangQu bilamana terbukti ada aktifitas individu yang melanggar ketentuan yang berakibat pada terganggunya proses persiapan program SangQu.',scaler.getTextSize(9), Constant().darkMode, FontWeight.normal,textAlign: TextAlign.left,maxLines: 100),
          SizedBox(height: 5),
          WidgetHelper().textQ('Atas pengertian dan kerjasama untuk mensukseskan masa-masa persiapan akhir ini, kami Management SangQu mengucapkan banyak terimakasih',scaler.getTextSize(9), Constant().darkMode, FontWeight.normal,textAlign: TextAlign.left,maxLines: 100),
          SizedBox(height: 5),
          WidgetHelper().textQ('Management SangQu',scaler.getTextSize(12), Constant().darkMode, FontWeight.bold,letterSpacing: 2,textAlign: TextAlign.center),
          Divider(thickness: 2),
        ],
      ),
      bottomNavigationBar: FlatButton(
        padding: scaler.getPadding(1.5,5),
        color: Constant().mainColor,
          onPressed:widget.callback,
          child: WidgetHelper().textQ("LANJUT MASUK",scaler.getTextSize(10),Constant().mainColor2,FontWeight.bold)
      ),
    ),isBack: true,callbacklIsBack: ()=>WidgetHelper().myPushRemove(context,SignInScreen()));
  }

  Widget points(num,str){
    ScreenScaler scaler = ScreenScaler()..init(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.all(0),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Constant().mainColor,
              shape: BoxShape.circle
          ),
          child: WidgetHelper().textQ(num,scaler.getTextSize(8),Constant().mainColor2,FontWeight.bold),
        ),
        SizedBox(width: 5,),
        Expanded(
          child: WidgetHelper().textQ(str,scaler.getTextSize(9), Constant().darkMode, FontWeight.normal,textAlign: TextAlign.left,maxLines: 100),
        )
      ],
    );
  }
}
