import 'package:enfes_lezzetler/pages/akis.dart';
import "package:flutter/material.dart";

import '../models/Tarif.dart';
import '../services/tarif_utils.dart';


DbUtils utils = DbUtils();

class TarifListesi extends StatefulWidget {
  @override
  _TarifListesiState createState() => _TarifListesiState();
}

class _TarifListesiState extends State<TarifListesi> {
  List<Tarif> tarifList = [];

  void getData() async {
    await utils.tarifler().then((result) => {
      setState(() {
      tarifList = result;
      })
    });
    print(tarifList);
  }

  void showAlert(String alertTitle, String alertContent) {
    AlertDialog alertDialog;
    alertDialog =
        AlertDialog(title: Text(alertTitle), content: Text(alertContent));
    showDialog(context: context, builder: (_) => alertDialog);
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tarifList.length.toString() + " Tarif Listelendi")),
      body: SingleChildScrollView(
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
                    onTap: () {
                      showAlert("Tarif " + index.toString() + " Tıklandı",
                          "Tarif " + index.toString() + " Tıklandı");
                    },
                    /*onLongPress: () async {
                      await utils.deleteDog(tarifList[index].id).then((value) => {
                        showAlert("Dog " + index.toString() + " deleted",
                            "Dog " + index.toString() + " deleted")
                      });
                      getData();
                    },*/
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Akis()),
                    );
                  },
                  child: Text("Ana Sayfaya Dön")),
            ),
          ],
        ),
      ),
    );
  }
}