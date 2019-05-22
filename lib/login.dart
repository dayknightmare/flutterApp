import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

const vupycolor = Color(0xFFE7002A);

class Loginpage extends StatefulWidget {
    @override
    State createState() => _Loginpage();
}
class _Loginpage extends State<Loginpage>{

    final password = TextEditingController();
    final userF = TextEditingController();

    int iduser;
    String apicad;

    Future<String> login(String url, Map body) async {

        var jsona = {};
        jsona["user"] = body["user"];
        jsona["pass"] = body["pass"];

        var r = await http.post(Uri.encodeFull(url),body:json.encode(jsona));
        var resposta = json.decode(r.body);
        if (resposta["resposta"][0] == "ok") {
            iduser = resposta["resposta"][2];
            apicad = resposta['resposta'][3];
            return "ok";
        }
        else{
            return "no";
        }
    }

    @override
    Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
        padding: new EdgeInsets.all(32.0),
        child: SingleChildScrollView(
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        TextFormField(
                            controller: userF,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                labelText: 'Usuário'
                            ),
                        ),
                        Divider(
                            color: Color(0x00FFFFFF)
                        ),
                        TextFormField(
                            controller: password,
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            decoration: InputDecoration(
                                labelText: 'Senha'
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

                                    if (password.text == "" || userF.text == "") {
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
                                        var data = new Map<String, dynamic>();
                                        data["user"] = userF.text;
                                        data["pass"] = password.text;

                                        var i = await login('http://201.76.95.46:80/workserver/',data);
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
                                },
                                child: Text(
                                    "Login",
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