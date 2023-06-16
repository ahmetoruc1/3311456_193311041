import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageServisi{
  late String resimId;
   Reference _storage=FirebaseStorage.instanceFor().ref();
   //instante metodu kaldırılmış

   Future<String>gonderiResmiYukle(File resimDosyasi) async {
     resimId=Uuid().v4();
     UploadTask yuklemeYoneticisi=_storage.child("resimler/gonderiler/gönderi_$resimId.jpg").putFile(resimDosyasi);
     TaskSnapshot snapshot=await yuklemeYoneticisi;
     String yuklenenResimUrl=await snapshot.ref.getDownloadURL();
     return yuklenenResimUrl;

   }

  Future<String>profilResmiYukle(File resimDosyasi) async {
    resimId=Uuid().v4();
    UploadTask yuklemeYoneticisi=_storage.child("resimler/profil/profil_$resimId.jpg").putFile(resimDosyasi);
    TaskSnapshot snapshot=await yuklemeYoneticisi;
    String yuklenenResimUrl=await snapshot.ref.getDownloadURL();
    return yuklenenResimUrl;

  }
  gonderiResmiSil(String gonderiResmiUrl){
     RegExp arama=RegExp(r"gonderi_.+\.jpg");
     //gonderi_ ile storage a kaydettiğim belgedenin 36 adet herhangi bir ifade aldıktan sonra .jpg ile biten bölümünü elde ettim.
    var eslesme=arama.firstMatch(gonderiResmiUrl);
    String? dosyaAdi=eslesme![0];
    if(dosyaAdi!=null){
      _storage.child("resimler/gonderiler/$dosyaAdi").delete();
    }
  }

}