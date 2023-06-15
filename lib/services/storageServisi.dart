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

}