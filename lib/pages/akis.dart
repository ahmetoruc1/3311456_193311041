import 'package:enfes_lezzetler/models/kullanici.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/gonderi.dart';
import '../services/firestoreServisi.dart';
import '../services/yetkilendirmeservisi.dart';
import '../widgetlar/SilinmeyenFutureBuilder.dart';
import '../widgetlar/gonderikarti.dart';

class Akis extends StatefulWidget {
  const Akis({Key? key}) : super(key: key);

  @override
  State<Akis> createState() => _AkisState();
}

class _AkisState extends State<Akis> {
  List<Gonderi> _gonderiler=[];

  _akisgonderileriGetir()async {
    String aktifKullaniciId=Provider.of<YetkilendirmeServisi>(context,listen: false).aktifKullanici;
    List<Gonderi>gonderiler=await FirestoreServisi().akisGonderileriniGetir(aktifKullaniciId);
    setState(() {
      _gonderiler=gonderiler;
    });
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _akisgonderileriGetir();
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Enfes Lezzetler"),
      centerTitle: true,),
      body: ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: _gonderiler.length,
          itemBuilder: (context,index){
            Gonderi gonderi=_gonderiler[index];
            return SilinmeyenFutureBuilder(
              //Ekranda oluşan builder da gönderi kaydırırken gönderinin ekran dışına çıkınca widget ağacından çıktığını
              //ve geri gelindiğinde tekrar eklendiğini bu sebeple ekranda sayfa değiştirince kalınan yerden değil
              //en baştan başlandığını görüp bu işlemi gerçekleştirdim.
                future: FirestoreServisi().kullaniciGetir(gonderi.yayinlayanId),
                builder: (context,snapshot){
                  if(!snapshot.hasData){
                    return SizedBox();
                  }
                  Kullanici? gonderiSahibi=snapshot.data;
                  return GonderiKarti(gonderi: gonderi,yayinlayan: gonderiSahibi,);
                });
          }),
    );
  }
}
