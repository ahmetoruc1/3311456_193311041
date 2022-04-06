import 'package:flutter/material.dart';
import 'ADANA.dart';
import 'AFYONKARAHİSAR.dart';
import 'ANTALYA.dart';
import 'BURSA.dart';
import 'İZMİR.dart';
import 'KONYA.dart';
import 'MERSİN.dart';
import 'ŞANLIURFA.dart';
import 'ISTANBUL.dart';
import 'ANKARA.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hava Durumu',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: IllerinAdlari(),
    );
  }
}

class IllerinAdlari extends StatefulWidget {
  @override
  _IllerinAdlariState createState() => _IllerinAdlariState();
}

class _IllerinAdlariState extends State<IllerinAdlari> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.indigo[300]
        ,
        appBar: AppBar(
          title: Text("Hava Durumu"),
        ),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                MaterialButton(
                  child: Text(
                    "İSTANBUL",
                    style: TextStyle(fontSize: 25.0),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Istanbul()));
                  },
                  padding: EdgeInsets.all(20),
                  textColor: Colors.black,
                ),
                MaterialButton(
                  child: Text(
                    "ANKARA",
                    style: TextStyle(fontSize: 25.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => Ankara()));
                  },
                  padding: EdgeInsets.all(20.0),
                  textColor: Colors.black,
                ),
                MaterialButton(
                  child: Text(
                    "İZMİR",
                    style: TextStyle(fontSize: 25.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => Izmir()));
                  },
                  padding: EdgeInsets.all(20.0),
                  textColor: Colors.black,
                ),
                MaterialButton(
                  child: Text(
                    "ANTALYA",
                    style: TextStyle(fontSize: 25.0),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Antalya()));
                  },
                  padding: EdgeInsets.all(20.0),
                  textColor: Colors.black,
                ),
                MaterialButton(
                  child: Text(
                    "KONYA",
                    style: TextStyle(fontSize: 25.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => Konya()));
                  },
                  padding: EdgeInsets.all(20.0),
                  textColor: Colors.black,
                ),
                MaterialButton(
                  child: Text(
                    "ADANA",
                    style: TextStyle(fontSize: 25.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => Adana()));
                  },
                  padding: EdgeInsets.all(20.0),
                  textColor: Colors.black,
                ),
                MaterialButton(
                  child: Text(
                    "BURSA",
                    style: TextStyle(fontSize: 25.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => Bursa()));
                  },
                  padding: EdgeInsets.all(20.0),
                  textColor: Colors.black,
                ),
                MaterialButton(
                  child: Text(
                    "AFYONKARAHİSAR",
                    style: TextStyle(fontSize: 25.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => Afyon()));
                  },
                  padding: EdgeInsets.all(20.0),
                  textColor: Colors.black,
                ),
                MaterialButton(
                  child: Text(
                    "ŞANLIURFA",
                    style: TextStyle(fontSize: 25.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => Urfa()));
                  },
                  padding: EdgeInsets.all(20.0),
                  textColor: Colors.black,
                ),
                MaterialButton(
                  child: Text(
                    "MERSİN",
                    style: TextStyle(fontSize: 25.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => Mersin()));
                  },
                  textColor: Colors.black,
                ),
              ],
            )));
  }
}
