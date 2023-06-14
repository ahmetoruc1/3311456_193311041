import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enfes_lezzetler/models/gonderi.dart';
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

  Future<void>gonderiOlustur({gonderiResmiUrl,aciklama,yayinlayanId,tarif}) async {
    print("hata  1");
    await _firestore.collection("gonderiler").doc(yayinlayanId).collection("KullaniciGonderileri").add({
      "gonderiResmiUrl":gonderiResmiUrl,
      "aciklama":aciklama,
      "yayinlayanId":yayinlayanId,
      "tarif":tarif,
      "begeniSayisi":0,
      "oluşturulmaZamanı":zaman
    });
    print("Hata  2");
  }
  Future<List<Gonderi>>gonderiGetir(kullaniciId)async {
    QuerySnapshot snapshot =await _firestore.collection("gonderiler").doc(kullaniciId).collection("KullaniciGonderileri").orderBy("oluşturulmaZamanı",descending: true).get();
    //en son yüklenen gönderinin ilk başta gelmesi için olduşturma zamanının azlamasına bağlı olarak listelenmesini sağladım.
    List<Gonderi>gonderiler=snapshot.docs.map((doc) => Gonderi.dokumandanUret(doc)).toList();
    return gonderiler;
  }
}