import 'package:enfes_lezzetler/services/yetkilendirmeservisi.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:enfes_lezzetler/yonlerdirme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//void main() => runApp(MyApp());


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDyXC9MI24ge-A2FMOUDzN3ignmvRXDrUA",
      appId: "1:1093695342864:web:7a4753f00e732c6f813d95",
      messagingSenderId: "1093695342864",
      projectId: "enfes-lezzetler",
    ),
  );
  //initialize etmeden ve main'i asenkeron yapmadan firebase e erişilemedi.

  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<YetkilendirmeServisi>(
      create: (_)=>YetkilendirmeServisi(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Yonlendirme(),
      ),
    );
  }
}


