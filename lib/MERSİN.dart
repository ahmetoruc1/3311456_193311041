import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Mersin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(
        title: Text('Mersin'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 55.0),
            Text(
              "23°C ",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 75.0,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "Parçalı Bulutlu ",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 55.0),
            Container(
                padding: EdgeInsets.all(20.0),
                alignment: Alignment.topRight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.lightBlue.shade600,
                        Colors.lightBlue.shade100,
                      ]),
                ),
                width: MediaQuery.of(context).size.width - 50.0,
                height: 425.0,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text("5 Günlük Hava Tahmini",
                          style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      decoration: BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.circular(10.0),
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.indigo.shade600,
                              Colors.indigo.shade100,
                            ]),
                      ),
                      height: 50,
                      width: 350,
                      alignment: Alignment.center,
                    ),
                    SizedBox(height: 25.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "07.04/Parçalı Bulutlu",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                        Text(
                          "22°C/17°C",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                      ],
                    ),
                    SizedBox(height: 40.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "08.04/Genelde Bulutlu",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                        Text(
                          "23°C/16°C",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                      ],
                    ),
                    SizedBox(height: 40.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "09.04/Genelde Güneşli",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                        Text(
                          "23°C/16°C",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                      ],
                    ),
                    SizedBox(height: 40.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "10.04/Parçalı Bulutlu",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                        Text(
                          "24°C/16°C",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                      ],
                    ),
                    SizedBox(height: 40.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "11.04/Parçalı Bulutlu",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                        Text(
                          "13°C/1°C",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                      ],
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
