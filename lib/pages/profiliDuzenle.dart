import 'dart:io';

import 'package:enfes_lezzetler/models/kullanici.dart';
import 'package:enfes_lezzetler/services/firestoreServisi.dart';
import 'package:enfes_lezzetler/services/storageServisi.dart';
import 'package:enfes_lezzetler/services/yetkilendirmeservisi.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilDuzenle extends StatefulWidget {
  final Kullanici profil;
  const ProfilDuzenle({Key? key, required this.profil}) : super(key: key);

  @override
  State<ProfilDuzenle> createState() => _ProfilDuzenleState();
}

class _ProfilDuzenleState extends State<ProfilDuzenle> {
  var _formKey= GlobalKey<FormState>();
  late String _kullaniciAdi;
  late String _hakkinda;
  File? _secilmisFoto;
  bool _yukleniyor=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Text("Profili Düzenle",style: TextStyle(color: Colors.black),),
        leading: IconButton(icon:Icon(Icons.close,color: Colors.black,),onPressed: ()=>Navigator.pop(context),),
        actions: [
          IconButton(icon:Icon(Icons.check,color: Colors.black,),onPressed: _kaydet,),
        ],
      ),
      body: ListView(
        children: [
          _yukleniyor? LinearProgressIndicator():SizedBox(height: 0.0,),
          _profilFoto(),
          _kullaniciBilgileri(),

        ],
      ),
    );
  }

  _kaydet()async{
    if(_formKey.currentState!.validate()){

      setState(() {
        _yukleniyor=true;
      });
      _formKey.currentState!.save();

      String profilFotoUrl;
      if(_secilmisFoto==null){
        profilFotoUrl=widget.profil.fotoUrl;
      }else{
       profilFotoUrl=await StorageServisi().profilResmiYukle(_secilmisFoto!);

      }

      String aktifKullaniciId=Provider.of<YetkilendirmeServisi>(context,listen: false).aktifKullanici;

      FirestoreServisi().kullaniciGuncelle(
        kullaniciId: aktifKullaniciId,
        kullaniciAdi: _kullaniciAdi,
        hakkinda: _hakkinda,
        fotoUrl: profilFotoUrl,

      );
      setState(() {
        _yukleniyor=false;
      });
      Navigator.pop(context);

    }
  }

  _profilFoto(){
    return Center(
      //iç içe ekleden widgettan dolayı Resim bozulduğu için center içine aldım.
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0,bottom: 20.0),
        child: InkWell(
          onTap: _galeridenSec,
          child: CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 55.0,
            backgroundImage: _secilmisFoto==null? NetworkImage(widget.profil.fotoUrl): FileImage(_secilmisFoto!) as ImageProvider,
          ),
        ),
      ),
    );
  }

  _galeridenSec()async {
    var image=await ImagePicker().pickImage(source: ImageSource.gallery,maxWidth: 800,imageQuality: 80);
    //Resmin boyutu fazla olmaması için kalitesini düşürdüm.
    setState(() {
      _secilmisFoto=File(image!.path);
    });
  }

  _kullaniciBilgileri(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      //horizontal parametresi ile sağdan ve soldan 12 piksel boşluk bırakılmasını sağladım.
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: 20.0,),
            TextFormField(
              initialValue: widget.profil.kullaniciAdi,
              //bilgileri değiştirmeden önce mevcut kullanıcı adı ve hakkında bilgisini
              //profil.dart dosyasından aktarıp initialValue ile açılınca gösterdim.
              decoration: InputDecoration(
                labelText: "Kullanıcı Adı"
              ),
              validator: (girilenDeger){
                if (girilenDeger != null && girilenDeger.trim().length <= 3) {
                  return "Kullanıcı Adı en az 4 karakter olmalıdır";
                }
                return null;
              },
              onSaved: (girilenDeger){
                _kullaniciAdi=girilenDeger!;
              },
            ),
            TextFormField(
              initialValue: widget.profil.hakkinda,
              decoration: InputDecoration(
                  labelText: "Hakkında"
              ),
              validator: (girilenDeger){
                if (girilenDeger != null && girilenDeger.trim().length > 100) {
                  return "100 karakterden fazla olmamalıdır";
                }
                return null;
              },
              onSaved: (girilenDeger){
                _hakkinda=girilenDeger!;
              },
            )
          ],
        ),
      ),
    );
  }
}
