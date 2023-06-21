

import 'package:enfes_lezzetler/models/gonderi.dart';
import 'package:enfes_lezzetler/models/kullanici.dart';
import 'package:enfes_lezzetler/pages/profiliDuzenle.dart';
import 'package:enfes_lezzetler/services/firestoreServisi.dart';
import 'package:enfes_lezzetler/widgetlar/gonderikarti.dart';
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
  List<Gonderi>_gonderiler=[];
  String gonderiStili="liste";
  late String _aktifKullaniciId;
  late Kullanici _profilSahibi;
  bool _takipEdildi=false;

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

  _gonderileriGetir()async {
    List<Gonderi>gonderiler=await FirestoreServisi().gonderiGetir(widget.profilSahibi);
    setState(() {
      _gonderiler=gonderiler;
      _gonderiSayisi=_gonderiler.length;
    });
  }
  _takipKontrol()async{
    bool takipVarMi=await FirestoreServisi().takipKontrol(aktifKullaniciId: _aktifKullaniciId, profilSahibiId: widget.profilSahibi);
    setState(() {
      _takipEdildi=takipVarMi;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _takipciSayisiGetir();
    _takipEdilenSayisiGetir();
    _gonderileriGetir();
    _aktifKullaniciId=Provider.of<YetkilendirmeServisi>(context,listen: false).aktifKullanici;
    _takipKontrol();
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
          widget.profilSahibi==_aktifKullaniciId ?IconButton(onPressed: _cikisYap, icon: Icon(Icons.exit_to_app,color: Colors.black,)):SizedBox(height: 0.0,)
        ],
        iconTheme: IconThemeData(
          color: Colors.black
        ),
      ),
      body: FutureBuilder(
          future: FirestoreServisi().kullaniciGetir(widget.profilSahibi),
          builder: (context, snapshot) {
            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator());

            }
            _profilSahibi=snapshot.data!;
            return ListView(
              children: [
                _profilDetaylari(snapshot.data),//as Kullanici?
                _gonderileriGoster(snapshot.data),
              ],
            );
          }
      ),
    );
  }
  Widget _gonderileriGoster(Kullanici? profilData){

    if(gonderiStili=="liste"){
      return ListView.builder(
        shrinkWrap: true,
          primary: false,
          itemCount: _gonderiler.length,
          itemBuilder: (context,index){
            return GonderiKarti(gonderi: _gonderiler[index],yayinlayan: profilData,);
          });

    }else{
      List<GridTile> grid=[];
      _gonderiler.forEach((gonderi) {
        grid.add(_gridOlustur(gonderi));
      });
      return GridView.count(
        physics: NeverScrollableScrollPhysics(), //ekranda hem listview hem de gridview'in kaydrıma özelliği olduğundan gridviewinkini kapattım.
        crossAxisCount: 3,//yan yana 3 tane ızgara gösterilsin
        shrinkWrap: true, //Ekranda Gridview nesnesinin tamamen kaplı olmaması için ihtiyacı kadar alanı kullansın diye ekledim
        mainAxisSpacing: 2.0,//yatay boşluk
        crossAxisSpacing: 2.0, //dikey boşluk

        children: grid, //liste içinde gönderidiğim için [] ni kaldırdım.
      );


    }

  }
  GridTile _gridOlustur(Gonderi gonderi){
    return GridTile(child: Image.network(gonderi.gonderiResmiUrl,fit: BoxFit.cover,));
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
                AssetImage("assets/images/hayaletProfilFotosu.png") as ImageProvider<Object>?,

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
          widget.profilSahibi==_aktifKullaniciId ? _profiliDuzenle(): _takipButonu(),

        ],
      ),
    );
  }

  Widget _takipButonu(){
    return _takipEdildi?_takiptenCikButonu():_takipEtButonu();
  }

  Widget _takiptenCikButonu(){
    return Container(
      width: double.maxFinite,
      child: OutlinedButton(onPressed: (){
        FirestoreServisi().takiptenCik(aktifKullaniciId: _aktifKullaniciId, profilSahibiId: widget.profilSahibi);
        setState(() {
          _takipEdildi=false;
          _takipci=_takipci-1;
        });

      }, child: Text(
        "Takipten Çık",style: TextStyle(
          color: Colors.black
      ),
      ),
      ),
    );

  }

  Widget _takipEtButonu(){
    return Container(
      width: double.maxFinite,
      child: ElevatedButton(onPressed: (){
        FirestoreServisi().takipET(aktifKullaniciId: _aktifKullaniciId,profilSahibiId: widget.profilSahibi);
        setState(() {
          _takipEdildi=true;
          _takipci=_takipci+1;
        });

      }, child: Text(
        "Takip Et",style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
      ),
      ),
      ),
    );

  }

  Widget _profiliDuzenle(){
    return Container(
      width: double.maxFinite,
      child: OutlinedButton(onPressed: (){
        Navigator.push(context as BuildContext, MaterialPageRoute(builder: (context)=>ProfilDuzenle(profil: _profilSahibi,)));
      }, child: Text(
        "Profili Düzenle",style: TextStyle(
          color: Colors.black,
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
