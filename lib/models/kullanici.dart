
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



class Kullanici {
  final String id;
  final String? kullaniciAdi;
  final String fotoUrl;
  final String? email;
  final String? hakkinda;


  Kullanici({required this.id, required this.kullaniciAdi, required this.fotoUrl, required this.email,
     this.hakkinda});


  factory Kullanici.dokumandanUret(DocumentSnapshot doc) {

    return Kullanici(
      id : doc.id,
      kullaniciAdi: doc["kullaniciAdi"],
      email: doc["email"],
      fotoUrl: doc["fotoURL"],
      //hakkinda: doc["hakkinda"],
      hakkinda: doc["Hakkında"]
    );
  }

  factory Kullanici.firebasedenUret(User kullanici){


    return Kullanici(
        id: kullanici.uid,
        kullaniciAdi: kullanici.displayName.toString(),
        email: kullanici.email.toString(),
        fotoUrl: kullanici.photoURL.toString(),


    );
  }


}