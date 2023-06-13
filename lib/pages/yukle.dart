
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Yukle extends StatefulWidget {
  const Yukle({Key? key}) : super(key: key);

  @override
  State<Yukle> createState() => _YukleState();
}

class _YukleState extends State<Yukle> {
    File? dosya;
  @override
  Widget build(BuildContext context) {
    return dosya == null ? yukleButonu() :gonderiFormu();
  }

  Widget yukleButonu(){
    return IconButton(onPressed: (){fotografSec();}, icon: Icon(Icons.file_upload,size: 50.0,));

  }
  
  Widget gonderiFormu(){
    return Center(child: Text("Yuklenen resim ve text alanları gelecek"));
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
