import 'package:enfes_lezzetler/pages/profil.dart';
import 'package:enfes_lezzetler/services/firestoreServisi.dart';
import 'package:flutter/material.dart';

import '../models/kullanici.dart';

class Ara extends StatefulWidget {
  const Ara({Key? key}) : super(key: key);

  @override
  State<Ara> createState() => _AraState();
}

class _AraState extends State<Ara> {
  TextEditingController _aramaController=TextEditingController();
   Future<List<Kullanici>>? _aramaSonucu;
  //late Future<List<Kullanici>> _aramaSonucu;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarOlurstur(),
      body: _aramaSonucu ==null ?aramaYok(): sonuclariGetir()
    );
  }

  AppBar _appBarOlurstur(){
    return AppBar(
      titleSpacing: 0.0,//appbar title arasındaki boşluk 0.0 ayarlandı
      backgroundColor: Colors.grey[100],
      title: TextFormField(
        onFieldSubmitted: (girilenDeger){

          setState(() {
            _aramaSonucu=FirestoreServisi().kullaniciAra(girilenDeger);
          });

        },
        controller: _aramaController,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search,size: 30.0,),
          suffixIcon: IconButton(icon:Icon(Icons.clear),onPressed: (){
            setState(() {
              _aramaSonucu=null;
            });
            _aramaController.clear();
          }),
          border: InputBorder.none,
          fillColor: Colors.white,
          filled: true,
          hintText: "Kullanıcı Ara",
          contentPadding: EdgeInsets.only(top: 16.0)//hinttext ortalandı
        ),
      ),
    );
  }

  Widget aramaYok(){
    return Center(child: Text("Kullanıcı Ara"));
  }


  Widget sonuclariGetir() {
    return FutureBuilder<List<Kullanici>>(
      future: _aramaSonucu,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data!.length > 0) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Kullanici kullanici = snapshot.data![index];
              return kullaniciSatiri(kullanici);
            },
          );
        } else {
          return Center(child: Text("Bu arama için sonuç bulunamadı."));
        }
      },
    );
  }

  kullaniciSatiri(Kullanici kullanici){
    return GestureDetector(
      onTap:() {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Profil(profilSahibi: kullanici.id)));
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(kullanici.fotoUrl),
        ),
        title: Text(kullanici.kullaniciAdi.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
      ),
    );

  }




}

