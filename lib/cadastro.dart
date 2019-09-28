import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vupy/widgets/url.dart';

const vupycolor = Color(0xFFE7002A);

class Createpage extends StatefulWidget {
  @override
  State createState() => _Createpage();
}

class _Createpage extends State<Createpage> {
  final email = TextEditingController();
  final nome = TextEditingController();
  final userS = TextEditingController();
  final password1 = TextEditingController();
  final password2 = TextEditingController();

  int iduser;
  String apicad, url = URL().getUrl();

  void cadastro(String url, Map body) async {
    var jsona = {};
    jsona["user"] = body["user"];
    jsona["pass"] = body["pass"];
    jsona["nome"] = body["nome"];
    jsona["email"] = body["email"];

    var r = await http.post(Uri.encodeFull(url), body: json.encode(jsona));
    var resposta = json.decode(r.body);

    

    List<Widget> errors = new List<Widget>();
    for (var i in resposta['resposta']) {
      errors.add(Text(i));
    }

    password1.text = "";
    password2.text = "";
    userS.text = "";
    email.text = "";
    nome.text = "";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            child: Wrap(
              children: errors,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: new EdgeInsets.all(32.0),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: nome,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: 'Nome'),
              ),
              Divider(color: Color(0x00FFFFFF)),
              TextFormField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              Divider(color: Color(0x00FFFFFF)),
              TextField(
                controller: userS,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: 'Usuário'),
              ),
              Divider(color: Color(0x00FFFFFF)),
              TextField(
                controller: password1,
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Senha'),
              ),
              Divider(color: Color(0x00FFFFFF)),
              TextField(
                controller: password2,
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Confirmar'),
              ),
              Divider(color: Color(0x00FFFFFF)),
              ButtonTheme(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  height: 50.0,
                  minWidth: 400.0,
                  child: RaisedButton(
                    onPressed: () async {
                      if (password1.text == "" ||
                          userS.text == "" ||
                          password2.text == "" ||
                          email.text == "" ||
                          nome.text == "") {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text("Os campos não podem ser vazios"),
                            );
                          },
                        );
                      } else {
                        if (password1.text != password2.text) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text("As senhas não conferem"),
                              );
                            },
                          );
                        } else {
                          var data = new Map<String, dynamic>();
                          data["user"] = userS.text;
                          data["pass"] = password1.text;
                          data['nome'] = nome.text;
                          data['email'] = email.text;

                          cadastro(
                              url + '/workserver/signup/', data);
                        }
                      }
                    },
                    child: Text("Cadastrar",
                        style: TextStyle(color: Colors.white)),
                    color: vupycolor,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
