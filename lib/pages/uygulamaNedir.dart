import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class UygulamaNedir extends StatefulWidget {
  @override
  _UygulamaNedirState createState() => _UygulamaNedirState();
}

class _UygulamaNedirState extends State<UygulamaNedir> {
  String _filePath = "";

  Future<String> get _localDevicePath async {
    final _devicePath = await getApplicationDocumentsDirectory();
    return _devicePath.path;
  }

  Future<File> _localFile({required String path, required String type}) async {
    String _path = await _localDevicePath;

    var _newPath = await Directory("$_path/$path").create();
    return File("${_newPath.path}/Enfes-Lezzetler.$type");
  }

  Future _downloadSamplePDF() async {
    final _response = await http.get(Uri.parse(
        "https://www.pta.org/docs/default-source/files/programs/pta-connected/connect-safely/instagram_final.pdf"));
    if (_response.statusCode == 200) {
      final _file = await _localFile(path: "Enfes Lezzetler Tanıtım", type: "pdf");
      final _saveFile = await _file.writeAsBytes(_response.bodyBytes);
      print("Dosya yazma işlemi tamamlandı. Dosyanın yolu: ${_saveFile.path}");
      setState(() {
        _filePath = _saveFile.path;
      });
    } else {
      print(_response.statusCode);
    }
  }

  Future _downloadSampleVideo() async {
    final _response = await http
        .get(Uri.parse("https://samplelib.com/lib/download/mp4/sample-5s.mp4"));
    if (_response.statusCode == 200) {
      final _file = await _localFile(
        path: "mp4s",
        type: "mp4",
      );
      final _saveFile = await _file.writeAsBytes(_response.bodyBytes);
      print("Dosya yazma işlemi tamamlandı. Dosyanın yolu: ${_saveFile.path}");
      setState(() {
        _filePath = _saveFile.path;
      });
    } else {
      print(_response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.file_download),
              label: Text("Örnek Pdf İndir"),
              onPressed: () {
                _downloadSamplePDF();
              },
            ),
            TextButton.icon(
              icon: Icon(Icons.file_download),
              label: Text("Örnek Video İndir"),
              onPressed: () {
                _downloadSampleVideo();
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_filePath),
            ),
            TextButton.icon(
              icon: Icon(Icons.tv),
              label: Text("İndirilen Dosyayı Göster"),
              onPressed: () async {
                final _openFile = await OpenFilex.open(_filePath);
                print(_openFile);
              },
            ),
          ],
        ),
      ),
    );
  }
}