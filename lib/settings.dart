import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vupy/bottomAll.dart';
import 'package:vupy/main.dart';
import 'package:vupy/widgets/url.dart';

const vupycolor = const Color(0xFFE7002B);
const white = const Color(0xFFFFFFFF);

class Settings extends StatefulWidget {
  Settings({
    Key key, 
    this.navcolor, 
    this.btn, 
    this.returnPage = 0,
    this.dark,

  }) : super(key: key);

  final Color navcolor;
  final Color btn;
  final int returnPage;
  final bool dark;

  @override
  State createState() => _Settings();
}

class _Settings extends State<Settings> {
  Color c = Color.fromRGBO(255, 255, 255, 1);
  Color cp = Color(0xffffffff);
  
  Color btncp = Color(0xffffffff);
  Color btnc = Color.fromRGBO(255, 255, 255, 1);

  Color differ = Color(0xffffffff);
  Color differBtn = Color(0xffffffff);

  List colorsR;

  String url = URL().getUrl();
  String body;

  bool dark = true;

  void gets() async {
    if (widget.navcolor != null) {
      c = widget.navcolor;
      cp = widget.navcolor;
      dark = widget.dark;
      if (cp.computeLuminance() > 0.673) {
        differ = Colors.black;
      } else {
        differ = Colors.white;
      }
    }

    if (widget.btn != null) {
      btnc = widget.btn;
      btncp = widget.btn;
      if (btncp.computeLuminance() > 0.673) {
        differBtn = Colors.black;
      } else {
        differBtn = Colors.white;
      }
    }

    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    gets();
    super.initState();
  }

  void styles() async {
    var prefs = await SharedPreferences.getInstance();

    var uri = Uri.parse(url + "/workserver/changeSty/");
    var request = new http.MultipartRequest("POST", uri);

    request.fields['api'] = prefs.getString("api") ?? '';
    request.fields['user'] = (prefs.getInt('userid') ?? 0).toString();
    request.fields['private'] = (-1).toString();
    if (body != null) {
      request.fields['bodycolorRGB'] = body;
    }

    if (dark == true) {
      request.fields['dark'] = (1).toString();
      prefs.setInt("dark", 1);

      if (body != null) {
      
        prefs.setStringList("body", [
          "31",
          "31",
          "31"
        ]);
      }


    }

    else{
      request.fields['dark'] = (0).toString();
      prefs.setInt("dark", 0);

      if (body != null) {
        prefs.setStringList("body", [
          "230",
          "236",
          "240"
        ]);
      }
    }

    var colorCodeRBGA = "rgba(" +
      cp.red.toString() +
      "," +
      cp.green.toString() +
      "," +
      cp.blue.toString() +
      ",1)";

    request.fields['navcolor'] = colorCodeRBGA;

    colorCodeRBGA = "rgba(" +
      btncp.red.toString() +
      "," +
      btncp.green.toString() +
      "," +
      btncp.blue.toString() +
      ",1)";

    request.fields['themecolor'] = colorCodeRBGA;
    
    prefs.setStringList(
        "color", [cp.red.toString(), cp.green.toString(), cp.blue.toString()]);
      
    prefs.setStringList(
        "colorbtn", [btncp.red.toString(), btncp.green.toString(), btncp.blue.toString()]);
        
    var response = await request.send();
      if (response.statusCode == 200) {
        if (this.mounted) {
          setState(() {});
        }
      }
  }

  void changeColor(Color color) {
    setState(() {
      c = color;
    });
  }

  void changeColorBtn(Color color) {
    setState(() {
      btnc = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cp,
        centerTitle: true,
        title: Text('Configurações', style: TextStyle(color: differ)),
        leading: IconButton(
          icon: Icon(IconData(0xe913, fontFamily: "icomoon"), color: differ),
          onPressed: () {
            styles();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MyHomePage(
                  page: widget.returnPage,
                )
              )
            );
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xffC1C6C9),width: 2),
                borderRadius: BorderRadius.circular(100)
              ),
              child: CircleAvatar(
                backgroundColor: cp,
              ),
            ),
            title: Text("Trocar cor do menu"),
            onTap: (){
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Escolha um cor!'),
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: c,
                        onColorChanged: changeColor,
                        enableLabel: true,
                        displayThumbColor: false,
                        enableAlpha: false,
                        pickerAreaHeightPercent: 0.8,
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: const Text('Trocar'),
                        onPressed: () async {
                          if (this.mounted) {
                            setState(() {
                              cp = c;
                              if (c.computeLuminance() > 0.673) {
                                differ = Colors.black;
                              } else {
                                differ = Colors.white;
                              }
                            });
                          }
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),

          ListTile(
            leading: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xffC1C6C9),width: 2),
                borderRadius: BorderRadius.circular(100)
              ),
              child: CircleAvatar(
                backgroundColor: btncp,
              ),
            ),
            title: Text("Trocar cor dos botoẽs"),
            onTap: (){
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Escolha um cor!'),
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: btnc,
                        onColorChanged: changeColorBtn,
                        enableLabel: true,
                        displayThumbColor: false,
                        enableAlpha: false,
                        pickerAreaHeightPercent: 0.8,
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: const Text('Trocar'),
                        onPressed: () async {
                          if (this.mounted) {
                            setState(() {
                              btncp = btnc;
                              if (btnc.computeLuminance() > 0.673) {
                                differBtn = Colors.black;
                              } else {
                                differBtn = Colors.white;
                              }
                            });
                          }
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),

          ListTile(
            title: Text("Modo dark"),
            leading: Switch(
              value: dark,
              onChanged: (v){
                if (this.mounted) {
                  setState(() {
                    dark = v;
                    if (v == true) {
                      body = "rgba(31,31,31,1)";
                      cp = Color.fromRGBO(40, 40, 40, 1);
                      differ = Colors.white;
                    }
                    else{
                      body = "rgba(230, 236, 240,1)";
                      cp = Color.fromRGBO(255, 255, 255, 1);
                      differ = Colors.black;
                    }

                  });
                }
              },
              activeColor: btncp,
              activeTrackColor: btncp,
            ),
          ),

          ListTile(
            onTap: (){
              showDialog(
                context: context,
                builder: (context){
                  return AlertDialog(
                    title: Text("Deseja sair da conta."),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      // crossAxisAlignment: croa,
                      children: <Widget>[
                        MaterialButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

                          child: Text("Sim", style: TextStyle(color: differBtn)),
                          onPressed: () async {
                            var prefs = await SharedPreferences.getInstance();
                            prefs.clear();
                            navigatorKey.currentState.pushNamedAndRemoveUntil("/log", (Route r) => false);
                            // print("object");
                            // Navigator.pushReplacementNamed(context, "/log");
                          },
                          color: btncp,
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          child: Text("Não", style: TextStyle(color: differBtn)),
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          color: btncp,
                        ),
                      ],
                    ),
                  );
                }
              );
            },
            title: Text("Sair da conta."),
            leading: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xffC1C6C9),width: 2),
                borderRadius: BorderRadius.circular(100)
              ),
              child: CircleAvatar(
                backgroundColor: Color(0x01000001),
                foregroundColor: Colors.blueGrey,
                child: Icon(IconData(0xe98f, fontFamily: "icomoon")),
              ),
            ),
          )
        ],
      )
    );
  }
}
