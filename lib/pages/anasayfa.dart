import 'package:enfes_lezzetler/pages/akis.dart';
import 'package:enfes_lezzetler/pages/ara.dart';
import 'package:enfes_lezzetler/pages/duyurular.dart';
import 'package:enfes_lezzetler/pages/profil.dart';
import 'package:enfes_lezzetler/pages/yukle.dart';
import 'package:enfes_lezzetler/services/yetkilendirmeservisi.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({Key? key}) : super(key: key);

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  int _aktifSayfaNo=0;
  late PageController sayfakumandasi;
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sayfakumandasi=PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    sayfakumandasi.dispose();//Anasayfadan çıkış yapılırsa controllerın bellekte gereksiz yer tutmaması için
  }
  @override
  Widget build(BuildContext context) {
     String aktifkullaniciId= Provider.of<YetkilendirmeServisi>(context, listen: false).aktifKullanici;

    return Scaffold(
      body: PageView(//İçersine eklenen Widegetların hepsini ayrı bri sayfa olrak gösterir.
        controller: sayfakumandasi,//Navigationbarda seçilen ögenin sayfa değiştirmesi için kullanıldı.
        onPageChanged: (acilanSayfaNo){//sayfanın hem ekran kaydırıldığında hem widget seçildiğinde değişmesi için
          setState(() {
            _aktifSayfaNo=acilanSayfaNo;
          });
        },
        children: [
          Akis(),
          Ara(),
          Yukle(),
          Duyurular(),
          Profil(profilSahibi: aktifkullaniciId,)
        ],

      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _aktifSayfaNo,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: "Akış"),
          BottomNavigationBarItem(icon: Icon(Icons.explore),label: "Keşfet"),
          BottomNavigationBarItem(icon: Icon(Icons.file_upload),label: "Yükle"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications),label: "Duyurular",),
          BottomNavigationBarItem(icon: Icon(Icons.person),label: "Profil"),
        ],
        onTap: (secilenSayfaNo){
          setState(() {
            _aktifSayfaNo=secilenSayfaNo;
            sayfakumandasi.jumpToPage(secilenSayfaNo);
          });
        },
      ),
    );
  }
}
