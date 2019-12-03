import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?key=f6085370";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.yellow,
      primaryColor: Colors.yellow,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(),
      ),
    ),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar, euro;

  void realChanged(String text) {
    double real = double.parse(text);
    dolarController.text = (real / this.dolar).toStringAsFixed(2);
    euroController.text = (real / this.euro).toStringAsFixed(2);
  }

  void dolarChanged(String text) {
    double dolar = double.parse(text);
    double real = dolar * this.dolar;

    realController.text = real.toStringAsFixed(2);
    euroController.text = (real / this.euro).toStringAsFixed(2);
  }

  void euroChanged(String text) {
    double euro = double.parse(text);
    double real = euro * this.euro;
    realController.text = real.toStringAsFixed(2);
    dolarController.text = (real / this.dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        title: Text("Conversor"),
        backgroundColor: Colors.red[900],
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return _buildMessage("Carregando Dados...", Colors.yellow);
            default:
              if (snapshot.hasError) {
                return _buildMessage(
                    "Erro ao carregar dados...", Colors.yellow);
              } else {
                this.dolar =
                    snapshot.data["results"]["currencies"]["USD"]["buy"];
                this.euro =
                    snapshot.data["results"]["currencies"]["EUR"]["buy"];

                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.monetization_on,
                        size: 150.0,
                        color: Colors.yellow,
                      ),
                      Divider(),
                      // buildTextField(
                      //     "Real", "R\$", realController, realChanged),
                      // buildTextField(
                      //     "Dolar", "US\$", realController, dolarChanged),
                      // buildTextField("Euro", "€", realController, dolarChanged),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Real",
                          prefixText: "R\$ ",
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      Divider(),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Dolar",
                          prefixText: "US\$ ",
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                      Divider(),
                      TextField(
                        style: TextStyle(color: Colors.yellow),
                        decoration: InputDecoration(
                          labelText: "Euro",
                          prefixText: "€ ",
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                  ),
                );
              }
          }
        },
      ),
    );
  }

  Widget _buildMessage(String text, Color color) {
    return Center(
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 25.0),
        textAlign: TextAlign.center,
      ),
    );
  }

  buildTextField(
      String label, String prefix, TextEditingController textEditingController, Function onChanged) {
    TextField(
      decoration: InputDecoration(
        labelText: label + " ",
        prefixText: prefix,
        labelStyle: TextStyle(color: Colors.white),
      ),
      keyboardType: TextInputType.number,
    );
  }

  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }
}
