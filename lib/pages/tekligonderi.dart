import 'package:enfes_lezzetler/models/kullanici.dart';
import 'package:enfes_lezzetler/services/firestoreServisi.dart';
import 'package:enfes_lezzetler/widgetlar/gonderikarti.dart';
import 'package:flutter/material.dart';

import '../models/gonderi.dart';

class TekliGonderi extends StatefulWidget {
  final String gonderiId;
  final String gonderiSAhibiId;
  const TekliGonderi({Key? key, required this.gonderiId, required this.gonderiSAhibiId}) : super(key: key);

  @override
  State<TekliGonderi> createState() => _TekliGonderiState();
}

class _TekliGonderiState extends State<TekliGonderi> {
  late Gonderi _gonderi;
  late Kullanici _gonderiSahibi;
  bool _yukleniyor=true;

  @override
  void initState() {
    super.initState();
    gonderiGetir();
  }


   gonderiGetir() async {
    Gonderi gonderi = await FirestoreServisi().tekliGonderiGetir(widget.gonderiId, widget.gonderiSAhibiId);
    if (gonderi != null) {
      Kullanici? gonderiSahibi = await FirestoreServisi().kullaniciGetir(gonderi.yayinlayanId);
      setState(() {
        _gonderi = gonderi;
        _gonderiSahibi = gonderiSahibi!;
        _yukleniyor = false;
      });
    }
  }

  /*gonderiGetir()async {
    Gonderi gonderi =await FirestoreServisi().tekliGonderiGetir(widget.gonderiId, widget.gonderiSAhibiId);
    if(_gonderi!=null){
      Kullanici? gonderiSahibi=await FirestoreServisi().kullaniciGetir(gonderi.yayinlayanId);
      //buraya widget.gonderi sahibiId de girilebilirdi.

      setState(() {
        _gonderi=gonderi;
        _gonderiSahibi=gonderiSahibi!;
        _yukleniyor=false;
      });
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Text("Gönderi",style: TextStyle(
          color: Colors.black,
        ),),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: !_yukleniyor ? GonderiKarti(gonderi: _gonderi,yayinlayan: _gonderiSahibi,): Center(child: CircularProgressIndicator())
    );
  }
}
