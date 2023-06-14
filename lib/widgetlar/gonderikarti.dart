import 'package:enfes_lezzetler/models/kullanici.dart';
import 'package:flutter/material.dart';

import '../models/gonderi.dart';

class GonderiKarti extends StatefulWidget {
  final Gonderi gonderi;
  final Kullanici? yayinlayan;


  const GonderiKarti({Key? key, required this.gonderi, required this.yayinlayan}) : super(key: key);

  @override
  State<GonderiKarti> createState() => _GonderiKartiState();
}

class _GonderiKartiState extends State<GonderiKarti> {
  int _begeniSayisi=0;
  bool _begendin=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _begeniSayisi=widget.gonderi.begeniSayisi;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child:Column(
        children: [
          _gonderiBasligi(),
          _gonderiResmi(),
          _gonderiAlt(),
        ],
      )
    );
  }

    Widget _gonderiBasligi(){
      var foto=widget.yayinlayan?.fotoUrl;
      return Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: ListTile(
          leading: CircleAvatar(

            backgroundColor: Colors.blue,
            backgroundImage: widget.yayinlayan?.fotoUrl?.isNotEmpty ?? false ? NetworkImage(widget.yayinlayan?.fotoUrl ?? ""): Image.asset("assets/images/hayaletProfilFotosu.png") .image,
            //eğer kullanıcının profil resmi yoksa CircleAvatar içersinde assetsdeki hayalet resim gösterilsin
          ),
          title: Text(widget.yayinlayan?.kullaniciAdi ?? "",style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold),),
          trailing: IconButton(icon:Icon(Icons.more_vert),onPressed: null,),
          contentPadding: EdgeInsets.all(0.0), //listitle ın default paddingini kapattım


        ),
      );
      
    }

    Widget _gonderiResmi(){
    return Image.network(
      widget.gonderi.gonderiResmiUrl,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      fit: BoxFit.cover,
    );
    }

    _gonderiAlt(){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
              onPressed: _begeniDegistir,
              icon: !_begendin ? Icon(Icons.favorite_border,size: 30.0) :Icon(Icons.favorite,size: 30.0,color: Colors.red,)
          ),
          IconButton(onPressed: null, icon: Icon(Icons.comment,size: 30.0)),
        ],
      ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text("$_begeniSayisi beğeni",style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
        ),
        SizedBox(height: 2.0,),
        widget.gonderi.tarif.isNotEmpty ?Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: RichText(
              text: TextSpan(
                text: widget.yayinlayan?.kullaniciAdi ?? "",
                style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.black),
                children: [
                  TextSpan(
                    text: " "+widget.gonderi.tarif,style: TextStyle(fontWeight: FontWeight.normal,fontSize: 14.0),

                  ),
                ]
              )
          ),
        ): SizedBox(height: 0.0,)
      ],
    );
    }

    void _begeniDegistir(){
    if(_begendin){
      //Kullanıcı Gönderiyi beğenmiş durumda, beğeniyi kaldıracak kodlar
      setState(() {
        _begendin=false;
        _begeniSayisi=_begeniSayisi -1;
      });

    }else{
      //Kullanıcı gönderiyi beğenmemiş,beğeniyi ekleyecek kodlar

      setState(() {
        _begendin=true;
        _begeniSayisi=_begeniSayisi + 1;
      });

    }
  }


}
