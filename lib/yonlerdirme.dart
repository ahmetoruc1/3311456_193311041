import 'package:enfes_lezzetler/models/kullanici.dart';
import 'package:enfes_lezzetler/pages/anasayfa.dart';
import 'package:enfes_lezzetler/pages/giri%C5%9Fsayfasi.dart';
import 'package:enfes_lezzetler/services/yetkilendirmeservisi.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Yonlendirme extends StatelessWidget {
  const Yonlendirme({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _yetkilendirmeServisi = Provider.of<YetkilendirmeServisi>(context, listen: false);
    return StreamBuilder(
      stream: _yetkilendirmeServisi.durumTakipcisi,
        builder: (context,snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if(snapshot.hasData){
          Kullanici? aktifKullanici=snapshot.data;
          _yetkilendirmeServisi.aktifKullanici= aktifKullanici!.id;
          return Anasayfa();
        }else{
          return GirisSayfasi();
        }

    }
    );
  }
}
