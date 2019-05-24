import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

const vupycolor = Color(0xFFE7002A);

class Createpage extends StatefulWidget {
    @override
    State createState() => _Createpage();
}

class _Createpage extends State<Createpage>{

    final email = TextEditingController();
    final nome = TextEditingController();
    final userS = TextEditingController();
    final password1 = TextEditingController();
    final password2 = TextEditingController();

    int iduser;
    String apicad;

    Future<String> cadastro(String url, Map body) async {

        var jsona = {};
        jsona["user"] = body["user"];
        jsona["pass"] = body["pass"];
        jsona["nome"] = body["nome"];
        jsona["email"] = body["email"];


        var r = await http.post(Uri.encodeFull(url),body:json.encode(jsona));
        var resposta = json.decode(r.body);
        if (resposta["resposta"][0] == "ok") {
            iduser = resposta["resposta"][1];
            apicad = resposta['resposta'][2];
            return "ok";
        }
        else{
            print(resposta['resposta']);
            List<Widget> errors = new List<Widget>();
            for(var i in resposta['resposta']){
                errors.add(Text(i));
            }
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
            return "no";
        }
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
                                decoration: InputDecoration(
                                    labelText: 'Nome'
                                ),
                            ),
                            Divider(
                                color: Color(0x00FFFFFF)
                            ),
                            TextFormField(
                                controller: email,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    labelText: 'Email'
                                ),
                            ),
                            Divider(
                                color: Color(0x00FFFFFF)
                            ),
                            TextField(
                                controller: userS,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    labelText: 'Usuário'
                                ),
                            ),
                            Divider(
                                color: Color(0x00FFFFFF)
                            ),
                            TextField(
                                controller: password1,
                                keyboardType: TextInputType.text,
                                obscureText: true,
                                decoration: InputDecoration(
                                    labelText: 'Senha'
                                ),
                            ),
                            Divider(
                                color: Color(0x00FFFFFF)
                            ),
                            TextField(
                                controller: password2,
                                keyboardType: TextInputType.text,
                                obscureText: true,
                                decoration: InputDecoration(
                                    labelText: 'Confirmar'
                                ),
                            ),
                            Divider(
                                color: Color(0x00FFFFFF)
                            ),
                            ButtonTheme(
                                height: 50.0,
                                minWidth: 400.0,
                                child: RaisedButton(
                                    onPressed: () async {
                                        if (password1.text == "" || userS.text == "" || password2.text == "" || email.text == "" || nome.text == "") {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                    return AlertDialog(
                                                        content: Text("Os campos não podem ser vazios"),
                                                    );
                                                },
                                            );
                                        }
                                        else{
                                            if(password1.text != password2.text){
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                        return AlertDialog(
                                                            content: Text("As senhas não conferem"),
                                                        );
                                                    },
                                                );
                                            }
                                            else{
                                                var data = new Map<String, dynamic>();
                                                data["user"] = userS.text;
                                                data["pass"] = password1.text;
                                                data['nome'] = nome.text;
                                                data['email'] = email.text;

                                                var i = await cadastro('http://201.76.95.46:80/workserver/signup/',data);
                                                if (i == "ok") {
                                                    var prefs = await SharedPreferences.getInstance();
                                                    prefs.setInt('userid', iduser);
                                                    prefs.setString("api",apicad);

                                                    Navigator.pushReplacementNamed(context,"/vupy");

                                                }
                                                else if(i == "no"){
                                                    print("no");

                                                }
                                                else{
                                                    print("error");
                                                }
                                            }
                                        }

                                    },
                                    child: Text(
                                        "Cadastrar",
                                        style: TextStyle(color: Colors.white)
                                    ),
                                    color: vupycolor,
                                )
                            ),
                        ],
                    ),
                ),
            ),
        );
    }
}