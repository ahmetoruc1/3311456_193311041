

import 'package:enfes_lezzetler/models/kullanici.dart';
import 'package:enfes_lezzetler/pages/hesapOlustur.dart';
import 'package:enfes_lezzetler/services/firestoreServisi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/yetkilendirmeservisi.dart';

class GirisSayfasi extends StatefulWidget {
  const GirisSayfasi({Key? key}) : super(key: key);

  @override
  State<GirisSayfasi> createState() => _GirisSayfasiState();
}

class _GirisSayfasiState extends State<GirisSayfasi> {
  final _formAnahtari=GlobalKey<FormState>();
  final _scaffoldAnahtari=GlobalKey<ScaffoldState>();
  bool yukleniyor=false;
  late String email,sifre;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldAnahtari,
      body: Stack(
        children: [
          _sayfaElemanlari(context),
          _yuklemeAnimasyonu(),
        ],
      )
    );
  }

  Widget _yuklemeAnimasyonu(){
    if(yukleniyor){
      return Center(child: CircularProgressIndicator());
    }
    else{
      return Center();
    }
  }

  Widget _sayfaElemanlari(BuildContext context) {
    return Form(
      key: _formAnahtari,
      child: ListView(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height:335.0,
            decoration: BoxDecoration(
              image: DecorationImage(image:AssetImage("assets/images/Mainpage_Image.png"),
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          SizedBox(height: 10.0,),
          Padding(
            padding: const EdgeInsets.only(left: 10.0,right: 10.0),
            child: TextFormField(
              autocorrect: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  hintText: "E-mail Adresinizi Girin",
                  prefixIcon: Icon(Icons.mail),
                  border: OutlineInputBorder()
              ),
              validator: (girilenDeger){
                if(girilenDeger!.isEmpty){
                  return "E-Mail alanı Boş Bırakılamaz";
                }else if(!girilenDeger.contains("@")){//girilen değerde @ sembolü kontrolü yapıldı.
                  return "Girilen Değer Mail Formatında Olmalı";
                }
                return null;
              },
              onSaved: (girilenDeger)=>email=girilenDeger!,
            ),
          ),
          SizedBox(height: 10.0,),
          Padding(
            padding: const EdgeInsets.only(left: 10.0,right: 10.0),
            child: TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                  hintText: "Şifrenizi Girin",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder()
              ),
              validator: (girilenDeger){
                if(girilenDeger!.isEmpty){
                  return "Şifre alanı Boş Bırakılamaz";
                }
                else if(girilenDeger.trim().length<6){
                  return "Şifre 6 Karakterden Az Olamaz";
                }
                return null;
              },
              onSaved: (girilenDeger)=>sifre=girilenDeger!,
            ),

          ),
          SizedBox(height: 10.0,),
          Padding(padding: const EdgeInsets.only(left: 10.0,right: 10.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => HesapOlustur()));
                    },
                    child: Text(
                      "Hesap Oluştur",
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    )),
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: ElevatedButton(
                    onPressed: _girisYap,
                    child: Text(
                        "Giriş Yap",
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                ),
              ),
            ],
          ),
          ),
          SizedBox(height: 20.0),
          Center(child: Text("veya")),
          SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.only(left: 80.0,right: 80.0),
            child: InkWell(
              onTap: _googleIleGiris,
              child: Container(
                alignment: Alignment.center,
                width: 50.0,
                height: 40.0,
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0,3),

                  )],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  image: DecorationImage(image:AssetImage("assets/images/google_icon.png"),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                child: Text("Google ile Devam et",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                  ),),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Center(child: Text("Şifremi Unuttum")),

        ],
      ),
    );
  }

  void _girisYap() async {
    final _yetkilendirmeServisi = Provider.of<YetkilendirmeServisi>(context, listen: false);

    if(_formAnahtari.currentState!.validate()){
      _formAnahtari.currentState?.save();
      setState(() {
        yukleniyor=true;
      });
      try{
        await _yetkilendirmeServisi.mailileGiris(email, sifre);
      }on FirebaseAuthException catch(hata){
        setState(() {
          yukleniyor=false;
        });
        uyariGoster(hataKodu: hata.code);
      }

    }
  }

  void _googleIleGiris()async {
    final _yetkilendirmeServisi = Provider.of<YetkilendirmeServisi>(context, listen: false);

    setState(() {
      yukleniyor=true;
    });
    try{
      Kullanici? kullanici=await _yetkilendirmeServisi.googleIleGiris();

      if(kullanici !=null){
        Kullanici? firestorekullanici=await FirestoreServisi().kullaniciGetir(kullanici.id);
        if(firestorekullanici ==null){
          FirestoreServisi().kullaniciOlustur(
              id: kullanici?.id,
              email: kullanici?.email,
              kullaniciAdi: kullanici?.kullaniciAdi,
              fotoUrl: kullanici?.fotoUrl
          );
        }
      }
    } on FirebaseAuthException catch(hata){
      setState(() {
        yukleniyor=false;
      });
      uyariGoster(hataKodu: hata.code);
    }

  }

  uyariGoster({hataKodu}) {
    late  String hataMesaji;

    if (hataKodu == "invalid-email") {
      hataMesaji = "Girdiğiniz eposta adresi geçersizdir!";
    } else if (hataKodu == "user-disabled") {
      hataMesaji = "Kullanıcı Engellenmiş!";
      print(hataMesaji);
    } else if (hataKodu == "user-not-found") {
      hataMesaji = "Böyle bir Kullanıcı Bulunmuyor";
    } else if (hataKodu == "wrong-password") {
      hataMesaji = "Girilen şifre Hatalıdır!";
    } else{
      hataMesaji="Tanımlanamayan bir hata oluştu$hataKodu";
    }
    var snackBar = SnackBar(
      content: Text(hataMesaji.toString()),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}
