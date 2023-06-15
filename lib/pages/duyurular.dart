import 'package:enfes_lezzetler/models/kullanici.dart';
import 'package:enfes_lezzetler/pages/profil.dart';
import 'package:enfes_lezzetler/pages/tekligonderi.dart';
import 'package:enfes_lezzetler/services/firestoreServisi.dart';
import 'package:enfes_lezzetler/services/yetkilendirmeservisi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/duyuru.dart';

class Duyurular extends StatefulWidget {
  const Duyurular({Key? key}) : super(key: key);

  @override
  State<Duyurular> createState() => _DuyurularState();
}

class _DuyurularState extends State<Duyurular> {
  List<Duyuru>? _duyurular;
  late String _aktifKullaniciId;
  bool _yukleniyor=true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _aktifKullaniciId=Provider.of<YetkilendirmeServisi>(context,listen: false).aktifKullanici;
    duyurulariGetir();
  }

  duyurulariGetir() async{
    List<Duyuru> duyurular=await FirestoreServisi().duyurulariGetir(_aktifKullaniciId);
    if (mounted) {
      //Duyuruları getirme işlemi uzun sürebileceğinden sayfanın değiştirilmemiş olduğundan emin olmak için ekledim.
      setState(() {
        _duyurular=duyurular;
        _yukleniyor=false;
      });
    }
  }

  duyurulariGoster(){

    if(_yukleniyor){
      print("_yukleniyor HATASI");
      return Center(child: CircularProgressIndicator());
    }
    if(_duyurular==null){
      print("NULL HATASI");
      return Center(child: Text("Duyurular Yüklenirken hata oluştu"));
    }
    if(_duyurular!.isEmpty){
      print("isEmpty HATASI");
      return Center(child: Text("Hiç duyurunuz yok"));
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: ListView.builder(
          itemCount: _duyurular!.length,
          itemBuilder: (context,index){
            Duyuru? duyuru=_duyurular![index];
            return duyuruSatiri(duyuru);
          }),
    );

  }

  duyuruSatiri(Duyuru duyuru){
    String mesaj=mesajOlustur(duyuru.aktiviteTipi);
    return FutureBuilder(
        future: FirestoreServisi().kullaniciGetir(duyuru.aktiviteYapanId),
        builder: (context,snapshot){
          if(!snapshot.hasData){
            return SizedBox(height: 0.0,);
          }
          Kullanici? aktiviteYapan=snapshot.data;

          return ListTile(
            leading: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Profil(profilSahibi: duyuru.aktiviteYapanId)));
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(aktiviteYapan!.fotoUrl),
              ),
            ),
            title: RichText(
              text: TextSpan(
                recognizer: TapGestureRecognizer()..onTap=(){
                  //..onTap() ifadesi bir üst ifadedeki nesneye referans verir
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Profil(profilSahibi: duyuru.aktiviteYapanId)));

            },
                text: "${aktiviteYapan.kullaniciAdi}",
                style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: " $mesaj",style: TextStyle(fontWeight: FontWeight.normal)
                    )
                  ]
              ),
            ),
            trailing: gonderiGorsel(duyuru.aktiviteTipi, duyuru.gonderiFoto,duyuru.gonderiId),
          );
        });

  }

  gonderiGorsel(String aktiviteTipi,String gonderifoto,String gonderiId){
      if(aktiviteTipi=="takip"){
        return null;
      }else if(aktiviteTipi=="beğeni"|| aktiviteTipi=="yorum"){
        return GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>TekliGonderi(gonderiId: gonderiId,gonderiSAhibiId: _aktifKullaniciId,)));
              //Gonderi sahibiId akt,f kullancı ıd ye eşit çünkü duyurular sayfasındakiler aktif kullanıcıya ait.
            },
            child: Image.network(gonderifoto,width: 50.0,height: 50.0, fit: BoxFit.cover,));
      }
  }

  mesajOlustur(String aktiviteTipi){
      if(aktiviteTipi=="beğeni"){
        return "gönderini beğendi";
      }else if(aktiviteTipi=="takip"){
        return "seni takip etti";
      }else if (aktiviteTipi=="yorum"){
        return "gönderine yorum yaptı";
      }
      return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Text("Duyurular",style: TextStyle(
          color: Colors.black,
        ),),
      ),
      body: duyurulariGoster(),
    );
  }
}
