import 'package:cloud_firestore/cloud_firestore.dart';

class Gonderi{
  final String id;
  final String gonderiResmiUrl;
  final String aciklama;
  final String yayinlayanId;
  final int begeniSayisi;
  final String tarif;

  Gonderi({required this.id, required this.gonderiResmiUrl, required this.aciklama,
    required this.yayinlayanId, required this.begeniSayisi, required this.tarif});


  factory Gonderi.dokumandanUret(DocumentSnapshot doc) {

    return Gonderi(
        id : doc.id,
      gonderiResmiUrl: doc["gonderiResmiUrl"],
      aciklama: doc["aciklama"],
      yayinlayanId: doc["yayinlayanId"],
      begeniSayisi: doc["begeniSayisi"],
      tarif: doc["tarif"]
    );
  }

}