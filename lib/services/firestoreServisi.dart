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

  void kullaniciGuncelle({String? kullaniciId,String? kullaniciAdi,String? fotoUrl = "",String? hakkinda}){
    _firestore.collection("kullanıcılar").doc(kullaniciId).update({
      "kullaniciAdi":kullaniciAdi,
      "Hakkında":hakkinda,
      "fotoURL":fotoUrl,

    });
  }
  Future<List<Kullanici>>kullaniciAra(String kelime)async {
    QuerySnapshot snapshot =await _firestore.collection("kullanıcılar").where("kullaniciAdi" ,isGreaterThanOrEqualTo: kelime).get();
    List<Kullanici> kullanicilar=snapshot.docs.map((doc) => Kullanici.dokumandanUret(doc)).toList();
    return kullanicilar;


  }
  void takipET({String? aktifKullaniciId,String? profilSahibiId}){
    _firestore.collection("takipciler").doc(profilSahibiId).collection("KullanicininTakipcileri").doc(aktifKullaniciId).set({});
    _firestore.collection("takipedilenler").doc(aktifKullaniciId).collection("KullanicininTakipleri").doc(profilSahibiId).set({});

  }
  void takiptenCik({String? aktifKullaniciId,String? profilSahibiId}){
    //profil sahibinin  takipçiler koleksiyonundan dokümanın silinmesi
    _firestore.collection("takipciler").doc(profilSahibiId).collection("KullanicininTakipcileri").doc(aktifKullaniciId).get().then((DocumentSnapshot doc) => {
      //gonderiBegeniKaldir metodundaki gibi future ın tamamlanmasını bekleyip değişkene aktardıktan sonra işlem yapmak yerine
      //future tipindeki objelerde kullanılan then metodu ile tamamlanan futuredan sonra işlem yapmasını sağladım.
      if(doc.exists){
        doc.reference.delete()
      }
    });

    //aktif kullanıcının takip edilenler koleksiyonundan dokümanın silinmesi
    _firestore.collection("takipedilenler").doc(aktifKullaniciId).collection("KullanicininTakipleri").doc(profilSahibiId).get().then((DocumentSnapshot doc) => {
      //gonderiBegeniKaldir metodundaki gibi future ın tamamlanmasını bekleyip değişkene aktardıktan sonra işlem yapmak yerine
      //future tipindeki objelerde kullanılan then metodu ile tamamlanan futuredan sonra işlem yapmasını sağladım.
      if(doc.exists){
        doc.reference.delete()
      }
    });
  }

  Future<bool>takipKontrol({String? aktifKullaniciId,String? profilSahibiId})async {
    DocumentSnapshot doc=await _firestore.collection("takipedilenler").doc(aktifKullaniciId).collection("KullanicininTakipleri").doc(profilSahibiId).get();
    if(doc.exists){
      return true;
    }
    return false;
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
    await _firestore.collection("gonderiler").doc(yayinlayanId).collection("KullaniciGonderileri").add({
      "gonderiResmiUrl":gonderiResmiUrl,
      "aciklama":aciklama,
      "yayinlayanId":yayinlayanId,
      "tarif":tarif,
      "begeniSayisi":0,
      "oluşturulmaZamanı":zaman
    });
  }
  Future<List<Gonderi>>gonderiGetir(kullaniciId)async {
    QuerySnapshot snapshot =await _firestore.collection("gonderiler").doc(kullaniciId).collection("KullaniciGonderileri").orderBy("oluşturulmaZamanı",descending: true).get();
    //en son yüklenen gönderinin ilk başta gelmesi için olduşturma zamanının azlamasına bağlı olarak listelenmesini sağladım.
    List<Gonderi>gonderiler=snapshot.docs.map((doc) => Gonderi.dokumandanUret(doc)).toList();
    return gonderiler;
  }

  
  Future<void>gonderiBegen(Gonderi gonderi,String aktifkullaniciId) async {
    DocumentReference docRef= _firestore.collection("gonderiler").doc(gonderi.yayinlayanId).collection("KullaniciGonderileri").doc(gonderi.id);
    DocumentSnapshot doc= await docRef.get();

    if(doc.exists){
      Gonderi gonderi=Gonderi.dokumandanUret(doc);
      int yenibegeniSayisi=gonderi.begeniSayisi+1;
       docRef.update({
        "begeniSayisi":yenibegeniSayisi
      });
      //Begenilen gönderi, begeniler koleksiyonuna eklenir
      _firestore.collection("begeniler").doc(gonderi.id).collection("gonderiBegenileri").doc(aktifkullaniciId).set({});
      //İşlemin tamamlanmasını beklemeyi gerektirecek bir şey olmadığından await yazılmadı.

    }
  }

  Future<void>gonderiBegeniKaldir(Gonderi gonderi,String aktifkullaniciId) async {
    DocumentReference docRef = _firestore.collection("gonderiler").doc(
        gonderi.yayinlayanId).collection("KullaniciGonderileri").doc(
        gonderi.id);
    DocumentSnapshot doc = await docRef.get();

    if (doc.exists) {
      Gonderi gonderi = Gonderi.dokumandanUret(doc);
      int yenibegeniSayisi = gonderi.begeniSayisi - 1;
      docRef.update({
        "begeniSayisi": yenibegeniSayisi
      });
      //Begenisi kaldırılan gonderiyi begeniler koleksiyonundan sil
      DocumentSnapshot docBegeni=await _firestore.collection("begeniler").doc(gonderi.id).collection("gonderiBegenileri").doc(aktifkullaniciId).get();
      if(docBegeni.exists){
        docBegeni.reference.delete();
      }


    }
  }
  Future<bool>begeniVarmi(Gonderi gonderi,String aktifkullaniciId)async{
    DocumentSnapshot docBegeni=await _firestore.collection("begeniler").doc(gonderi.id).collection("gonderiBegenileri").doc(aktifkullaniciId).get();
    if(docBegeni.exists){
      return true;
    }else {
      return false;
    }
  }

  Stream<QuerySnapshot>yorumlariGetir(String gonderiId){
    return _firestore.collection("yorumlar").doc(gonderiId).collection("gonderiYorumlari").orderBy("olusturulmaZamani",descending: true).snapshots();

  }
  yorumekle(String aktifKullaniciId,Gonderi gonderi,String icerik){
    _firestore.collection("yorumlar").doc(gonderi.id).collection("gonderiYorumlari").add({
      "icerik":icerik,
      "yayinlayanId":aktifKullaniciId,
      "olusturulmaZamani":zaman,

    });
    //add() metodu future nesnesi döndürmesine rağmen await, future eklemedim çünkü programın bir yorum ekleme işlemini beklemem gerekmiyor
    //program arka planda onları hallediyor
    
  }

}