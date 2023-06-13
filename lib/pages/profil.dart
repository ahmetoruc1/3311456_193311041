import 'package:enfes_lezzetler/models/kullanici.dart';
import 'package:enfes_lezzetler/services/firestoreServisi.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/yetkilendirmeservisi.dart';

class Profil extends StatefulWidget {
  final String profilSahibi;
  const Profil({Key? key, required this.profilSahibi}) : super(key: key);

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  int _gonderiSayisi=0;
  int _takipci=0;
  int _takipEdilen=0;

  _takipciSayisiGetir()async {
    int takipciSayisi=await FirestoreServisi().takipciSayisi(widget.profilSahibi);
    setState(() {
      _takipci=takipciSayisi;
    });
  }
  _takipEdilenSayisiGetir()async {
    int takipEdilenSayisi=await FirestoreServisi().takipEdilenSayisi(widget.profilSahibi);
    setState(() {
      _takipEdilen=takipEdilenSayisi;
    });
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _takipciSayisiGetir();
    _takipEdilenSayisiGetir();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Profil",
        style: TextStyle(
          color: Colors.black
        ),),
        backgroundColor: Colors.grey[100],
        actions: [
          IconButton(onPressed: _cikisYap, icon: Icon(Icons.exit_to_app,color: Colors.black,))
        ],
      ),
      body: FutureBuilder(
        future: FirestoreServisi().kullaniciGetir(widget.profilSahibi),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator());

          }
          return ListView(
            children: [
              _profilDetaylari(snapshot.data),//as Kullanici?
            ],
          );
        }
      ),
    );
  }

  void _cikisYap(){
    Provider.of<YetkilendirmeServisi>(context, listen: false).cikisYap();
  }

  Widget _profilDetaylari(Kullanici? profildata){
    var fotoUrl=profildata?.fotoUrl ?? "";
    //Fotourl null olabileceği için koşul ifadesinde kullanılamazdı bu değer sayesinde kullanılabildi
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[300],
                radius: 50.0,
                backgroundImage: fotoUrl.isNotEmpty ? NetworkImage(profildata!.fotoUrl):
                AssetImage("assets/images/hayaletProfilFotosu.png") as ImageProvider,

              ),



              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _sosyalSayac("Gönderiler", _gonderiSayisi),
                    _sosyalSayac("Takipçi", _takipci),
                    _sosyalSayac("Takip", _takipEdilen),

                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 10.0,),
          Text(profildata?.kullaniciAdi ?? "",
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold
          ),),
          SizedBox(height: 5.0,),
          Text(profildata?.hakkinda ?? ""),
          SizedBox(height: 25.0,),
          _profiliDuzenle()

        ],
      ),
    );
  }

 Widget _profiliDuzenle(){
    return Container(
      width: double.maxFinite,
      child: OutlinedButton(onPressed: (){}, child: Text(
        "Profili Düzenle",style: TextStyle(
        color: Colors.black
      ),
      ),
      ),
    );

  }

Widget _sosyalSayac(String baslik, int sayi){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(sayi.toString(),
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: 2.0,),
        Text(baslik,
          style: TextStyle(
              fontSize: 15.0,
          ),
        ),

      ],
    );
}

}