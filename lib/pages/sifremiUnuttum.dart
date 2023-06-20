import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/yetkilendirmeservisi.dart';

class SifremiUnuttum extends StatefulWidget {
  const SifremiUnuttum({Key? key}) : super(key: key);

  @override
  State<SifremiUnuttum> createState() => _SifremiUnuttumState();
}

class _SifremiUnuttumState extends State<SifremiUnuttum> {
  final _formAnahtari=GlobalKey<FormState>();
  final _scaffoldAnahtari=GlobalKey<ScaffoldState>();
  bool yukleniyor=false;
  late String email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldAnahtari,
        appBar: AppBar(
          title: Text("Şifremi Sıfırla"),
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
                    SizedBox(height: 30.0,),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: _sifreyiSifirla,
                            child: Text(
                              "Şifremi Sıfırla",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),
                            )),
                      ),
                    ],
                  )),
            )
          ],
        )
    );
  }

  void _sifreyiSifirla() async {
    final _yetkilendirmeServisi = Provider.of<YetkilendirmeServisi>(context, listen: false);
    var _formstate=_formAnahtari.currentState!;

    if(_formstate.validate()){
      _formAnahtari.currentState?.save();
      _formstate.save();
      setState(() {
        yukleniyor=true;
      });
      try{
        _yetkilendirmeServisi.sifremiSifirla(email);
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

    if (hataKodu == "auth/invalid-email") {
      hataMesaji = "Girdiğiniz eposta adresi geçersizdir!";
    } else if (hataKodu == "auth/user-not-found") {
      hataMesaji = "Böyle bir kullanıcı bulunmuyor";
      print(hataMesaji);
    }
    var snackBar = SnackBar(
      content: Text(hataMesaji.toString()),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
