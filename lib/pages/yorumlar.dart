import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enfes_lezzetler/models/gonderi.dart';
import 'package:enfes_lezzetler/models/kullanici.dart';
import 'package:enfes_lezzetler/models/yorum.dart';
import 'package:enfes_lezzetler/services/firestoreServisi.dart';
import 'package:enfes_lezzetler/services/yetkilendirmeservisi.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class Yorumlar extends StatefulWidget {
  final Gonderi gonderi;
  const Yorumlar({Key? key, required this.gonderi}) : super(key: key);

  @override
  State<Yorumlar> createState() => _YorumlarState();
}

class _YorumlarState extends State<Yorumlar> {
  TextEditingController _yorumController= TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timeago.setLocaleMessages('tr', timeago.TrMessages());
    //Geçen zaman ifadesini türkçe olarak gösterdim.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Text("Yorumlar",style: TextStyle(color: Colors.black),),
        iconTheme: IconThemeData(
          color: Colors.black
        ),
      ),
      body: Column(
        children: [
          _yorumlariGoster(),
          _yorumEkle(),

          //
        ],
      ),
    );
  }
  _yorumlariGoster(){
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirestoreServisi().yorumlariGetir(widget.gonderi.id),
        builder: (context,snapshot){
          if(!snapshot.hasData){
            Center(child: CircularProgressIndicator(),);
          }
          if (snapshot.data?.docs != null) {
            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                Yorum yorum = Yorum.dokumandanUret(snapshot.data?.docs[index] as DocumentSnapshot);
                return _yorumSatiri(yorum);
              },
            );
          } else {
            return Container();
          }

        },
      )
    );

  }

  _yorumSatiri(Yorum yorum){
    return FutureBuilder<Kullanici?>(
      future: FirestoreServisi().kullaniciGetir(yorum.yayinlayanId),
      builder: (context, snapshot) {

        if(!snapshot.hasData){
          return SizedBox(height: 0.0,);
          //Ekranda fotourl ögesi çekilirken beklendiği için anlık hata alıyorudum bunun için başta  CircularProgressIndicator
          //ekledim ancak her yorum için ayrı ayrı çalıştığından boş bir Sizedbox ekledim.
        }

        Kullanici? yayinlayan=snapshot.data;

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: yayinlayan?.fotoUrl?.isNotEmpty ?? false ? NetworkImage(yayinlayan?.fotoUrl ?? ""): Image.asset("assets/images/hayaletProfilFotosu.png") .image,
          ),
          title: RichText(
              text: TextSpan(
                  text:  yayinlayan?.kullaniciAdi,
                  style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.black),
                  children: [
                    TextSpan(
                      text: " "+yorum.icerik,
                      style: TextStyle(fontWeight: FontWeight.normal,fontSize: 14.0),

                    ),
                  ]
              )
          ),
          subtitle: Text(timeago.format(yorum.olusturulmaZamani.toDate(),locale: "tr")),
        );
      }
    );
  }

  _yorumEkle(){
    return ListTile(
      title: TextFormField(
        controller: _yorumController,
        decoration: InputDecoration(
          hintText: "Yorumu Buraya Yazın"
        ),
      ),
      trailing: IconButton(icon:Icon(Icons.send),onPressed: _yorumGonder,),
    );
  }

  void _yorumGonder(){
      String aktifKullaniciId=Provider.of<YetkilendirmeServisi>(context,listen: false).aktifKullanici;

      FirestoreServisi().yorumekle(aktifKullaniciId, widget.gonderi, _yorumController.text);
      _yorumController.clear();
    }

}
