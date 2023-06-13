import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enfes_lezzetler/models/kullanici.dart';

class FirestoreServisi{
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  final DateTime zaman =DateTime.now();

  Future<void>kullaniciOlustur({id,email,kullaniciAdi,fotoUrl=""})async {
    await _firestore.collection("kullanıcılar").doc(id).set({
      "kullaniciAdi": kullaniciAdi,
      "email": email,
      "fotoURL":fotoUrl,
      "Hakkında":"",
      "oluşturulmaZamanı":zaman
    }

    );
  }

  Future<Kullanici?> kullaniciGetir(id) async {
    //print(id+"sdsadsdsd");
    DocumentSnapshot doc = await _firestore.collection("kullanıcılar").doc(id).get();
    //print(doc.id);
    if(doc.exists){
      //print("Deneme");

      Kullanici kullanici = Kullanici.dokumandanUret(doc);
      //print("Deneme2");

      return kullanici;
    }
    return null;
  }
  
  Future<int>takipciSayisi(kullaniciId)async {
    QuerySnapshot snapshot=await _firestore.collection("takipciler").doc(kullaniciId).collection("KullanicininTakipcileri").get();
    return snapshot.docs.length;
  }

  Future<int>takipEdilenSayisi(kullaniciId)async {
    QuerySnapshot snapshot=await _firestore.collection("takipedilenler").doc(kullaniciId).collection("KullanicininTakipleri").get();
    return snapshot.docs.length;
  }
}