
import 'dart:io';

import 'package:enfes_lezzetler/services/firestoreServisi.dart';
import 'package:enfes_lezzetler/services/storageServisi.dart';
import 'package:enfes_lezzetler/services/yetkilendirmeservisi.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Yukle extends StatefulWidget {
  const Yukle({Key? key}) : super(key: key);

  @override
  State<Yukle> createState() => _YukleState();
}

class _YukleState extends State<Yukle> {
    File? dosya;
    bool yukleniyor=false;
    double _inputHeight = 50;
    TextEditingController _aciklamaController=TextEditingController();
     TextEditingController _tarifController = TextEditingController();

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tarifController.addListener(_checkInputHeight);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tarifController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return dosya == null ? yukleButonu() :gonderiFormu();
  }

  Widget yukleButonu(){
    return IconButton(onPressed: (){fotografSec();}, icon: Icon(Icons.file_upload,size: 50.0,));

  }
  
  Widget gonderiFormu(){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Text("Gönderi Oluştur",style: TextStyle(color: Colors.black),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.black,),
          onPressed: (){
            setState(() {
              dosya=null;
            });
          },
        ),
        actions: [
          IconButton(onPressed: _gonderiOlustur,
              icon: Icon(Icons.send),color: Colors.black,)
        ],

      ),
      body: ListView(
        children: [
          yukleniyor ? LinearProgressIndicator(): SizedBox(height: 0.0,),
          AspectRatio(
            aspectRatio: 16.0/9.0,// Resmin Ekrandaki En Boy oranını Ayarladım
              child: Image.file(dosya!,fit: BoxFit.cover,)),
          SizedBox(height: 20.0,),
          TextFormField(
            controller: _aciklamaController,
            decoration: InputDecoration(
              hintText: "Açıklama Ekle",
              contentPadding: EdgeInsets.only(left: 15.0,right: 15.0),
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 15.0,right: 15.0),
              hintText: "Tarif Ekle"
            ),
            controller: _tarifController,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.multiline,
            maxLines: null,
          )

        ],
      ),
    );
  }

  void _gonderiOlustur()async {

      if(!yukleniyor){
        setState(() {
          yukleniyor=true;
        });

        String resimUrl =await StorageServisi().gonderiResmiYukle(dosya!);
        String aktifKullaniciId=Provider.of<YetkilendirmeServisi>(context,listen: false).aktifKullanici;
        await FirestoreServisi().gonderiOlustur(gonderiResmiUrl: resimUrl,yayinlayanId: aktifKullaniciId,aciklama: _aciklamaController.text,tarif: _tarifController.text);
        print("hata 6" );
        setState(() {
          print("Hata 3");
          yukleniyor=false;
          _aciklamaController.clear();
          _tarifController.clear();
          dosya=null;
        });
      }
}

    void _checkInputHeight() async {
      //TextField içersinde yazma işlmei devam ettikçe bir lat satıra inmeyi sağlayan kod
      int count = _tarifController.text.split('\n').length;

      if (count == 0 && _inputHeight == 50.0) {
        return;
      }
      if (count <= 5) {
        var newHeight = count == 0 ? 50.0 : 28.0 + (count * 18.0);
        setState(() {
          _inputHeight = newHeight;
        });
      }
    }


    fotografSec(){
    return showDialog(
        context: context,
        builder: (context){
          return SimpleDialog(
            title: Text("Gönderi Oluştur"),
            children: [
              SimpleDialogOption(
                child: Text("Fotoğraf Çek"),
                onPressed: (){fotoCek();},
              ),
              SimpleDialogOption(
                child: Text("Galeriden Yükle"),
                onPressed: (){galeridenSec();},
              ),
              SimpleDialogOption(
                child: Text("İptal"),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
  }
  fotoCek()async {
    Navigator.pop(context);
    var image=await ImagePicker().pickImage(source: ImageSource.camera,maxWidth: 800,imageQuality: 80);//Resmin boyutu fazla olmaması için kalitesini düşürdüm.
    setState(() {
      dosya=File(image!.path);
    });
  }
  galeridenSec()async {
    Navigator.pop(context);
    var image=await ImagePicker().pickImage(source: ImageSource.gallery,maxWidth: 800,imageQuality: 80);//Resmin boyutu fazla olmaması için kalitesini düşürdüm.
    setState(() {
      dosya=File(image!.path);
    });
  }
}
