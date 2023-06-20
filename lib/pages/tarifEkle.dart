import "package:flutter/material.dart";
import 'package:sqflite/sqflite.dart';
import '../models/Tarif.dart';
import '../services/tarif_utils.dart';
import 'tarifListesi.dart';

DbUtils utils = DbUtils();

void main() {
  runApp(TarifEkle());
}

class TarifEkle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController tarifnameController = TextEditingController();
  TextEditingController yayinlayannameController = TextEditingController();

  late Future<Database> database;

  List<Tarif> tarifList = [];

  _onPressedUpdate() async {
    final tarif = Tarif(
      tarifname: tarifnameController.text,
      yayinlayanName: yayinlayannameController.text,
    );
    utils.updateTarif(tarif);
    tarifList = await utils.tarifler();
    //print(dogList);
    getData();
  }

  _onPressedAdd() async {
    final tarif = Tarif(
      tarifname: tarifnameController.text,
      yayinlayanName: yayinlayannameController.text,
    );
    utils.insertTarif(tarif);
    tarifList = await utils.tarifler();
    //print(dogList);
    getData();
  }

  _deleteTarifTable() {
    utils.deleteTable();
    tarifList = [];
    getData();
  }

  void getData() async {
    await utils.tarifler().then((result) => {
      setState(() {
        tarifList = result;
      })
    });
    print(tarifList);
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: tarifnameController,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Tarif Adı'
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: yayinlayannameController,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Yayınlayan Adı'
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: _onPressedAdd, child: Text("Tarif Gir")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: _onPressedUpdate, child: Text("Tarif Güncelle")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: _deleteTarifTable,
                    child: Text("Tarif Tablosunu Sil")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TarifListesi()),
                      );
                    },
                    child: Text("Tarif Listesi")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      getData();
                    },
                    child: Text("Listeyi Temizle")),
              ),
              Text(tarifList.length.toString()),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: tarifList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(tarifList[index].tarifname),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}