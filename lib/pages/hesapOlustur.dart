import 'package:enfes_lezzetler/models/kullanici.dart';
import 'package:enfes_lezzetler/models/path%20provider/file_utils.dart';
import 'package:enfes_lezzetler/services/firestoreServisi.dart';
import 'package:enfes_lezzetler/services/yetkilendirmeservisi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HesapOlustur extends StatefulWidget {
  const HesapOlustur({Key? key}) : super(key: key);

  @override
  State<HesapOlustur> createState() => _HesapOlusturState();
}

class _HesapOlusturState extends State<HesapOlustur> {
  final _formAnahtari=GlobalKey<FormState>();
  final _scaffoldAnahtari=GlobalKey<ScaffoldState>();
  bool yukleniyor=false;
  late String kullaniciAdi,email,sifre;
  final sifreController =TextEditingController();
  String fileContents ="Veri Yok";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldAnahtari,
        appBar: AppBar(
          title: Text("Hesap Oluştur"),
        ),
        body: ListView(
          children: [
            yukleniyor ? LinearProgressIndicator() : SizedBox(height: 0.0),
            SizedBox(height: 20.0,),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                  key: _formAnahtari,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            hintText: "Kullanıcı Adınızı Giriniz",
                            labelText: "Kullanıcı Adı",
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder()
                        ),
                        validator: (girilenDeger){
                          if(girilenDeger!.isEmpty){
                            return "Kullanıcı Adı alanı Boş Bırakılamaz";
                          }else if(girilenDeger.trim().length<4 || girilenDeger.trim().length>10){
                            return "Şifre en az 4 en fazla 10 karakter olabilir";
                          }
                          return null;
                        },
                        onSaved: (girilenDeger)=>kullaniciAdi=girilenDeger!,
                      ),
                      SizedBox(height: 10.0,),
                      TextFormField(
                        autocorrect: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            hintText: "E-mail Adresinizi Girin",
                            labelText: "Mail",
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
                      SizedBox(height: 10.0,),
                      TextFormField(
                        controller: sifreController,
                        obscureText: true,
                        decoration: InputDecoration(
                            hintText: "Şifrenizi Girin",
                            labelText: "Şifre",
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
                      SizedBox(height: 30.0,),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: _kullaniciolustur,
                            child: Text(
                              "Hesap Oluştur",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),
                            )),
                      ),
                      SizedBox(height: 20.0,),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                                onPressed: (){
                                  FileUtils.saveToFile(sifreController.text);
                                },
                                child: Text(
                                  "Şifre Kaydet",
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
                              onPressed: (){
                                FileUtils.readFromFile().then((value) {
                                  setState(() {
                                    fileContents=value;
                                  });
                                });
                              },
                              child: Text(
                                "Şifre Göster",
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
                      SizedBox(height: 15.0,),
                      Text(fileContents)
                    ],
                  )),
            )
          ],
        )
    );
  }

  void _kullaniciolustur() async {

    final _yetkilendirmeServisi = Provider.of<YetkilendirmeServisi>(context, listen: false);
    var _formstate=_formAnahtari.currentState!;

    if(_formstate.validate()){
      _formAnahtari.currentState?.save();
      _formstate.save();
      setState(() {
        yukleniyor=true;
      });
      try{
        Kullanici? kullanici=await _yetkilendirmeServisi.mailileKayit(email, sifre);
        if(kullanici!=null){


          FirestoreServisi().kullaniciOlustur(id: kullanici.id,email: email,kullaniciAdi: kullaniciAdi);

        }
        Navigator.pop(context);
      }on FirebaseAuthException catch(hata){
        setState(() {
          yukleniyor=false;
        });
        uyariGoster(hataKodu: hata.code);

      }
    }

  }

  uyariGoster({hataKodu}) {
    late  String hataMesaji;

    if (hataKodu == "invalid-email") {
      hataMesaji = "Girdiğiniz eposta adresi geçersizdir!";
    } else if (hataKodu == "email-already-in-use") {
      hataMesaji = "Girdiğiniz eposta adresi zaten kayıtlıdır!";
      print(hataMesaji);
    } else if (hataKodu == "weak-password") {
      hataMesaji = "Girilen şifre çok zayıf!";
    } else if (hataKodu == "operation-not-allowed") {
      hataMesaji = "işlem onaylanmadı!";
    }
    var snackBar = SnackBar(
      content: Text(hataMesaji.toString()),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


}
