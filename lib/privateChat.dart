import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:vupy/settings.dart';

class PrivateChatVupy extends StatefulWidget {
  PrivateChatVupy({Key key, this.id, this.name, this.image}) : super(key: key);

  final int id;
  final String name;
  final String image;
  @override
  State createState() => _PrivateChatVupy();
}

class _PrivateChatVupy extends State<PrivateChatVupy> {
  var gnpTime, fail = 0;

  int id, myId, ids;

  String name, myname, image, api, url = "http://179.233.213.76", filter;
  String style = "https://vupytcc.pythonanywhere.com/static/img/user.png";

  TextEditingController publ = TextEditingController();
  TextEditingController emojicon = new TextEditingController();

  File filec;

  List<File> file = [];
  List talks = [];
  List imageF = [];
  List duoemojis = [];
  List emojis = [];

  bool _visible = false;

  void ftCamera() async {
    filec = await ImagePicker.pickImage(source: ImageSource.gallery);
    file.add(filec);
    imageF.add(filec.path);
    if (this.mounted) {
      setState(() {});
    }
  }

  void ftGaleria() async {
    filec = await ImagePicker.pickImage(source: ImageSource.gallery);

    file.add(filec);
    // imageF = file.path;
    imageF.add(filec.path);
    if (this.mounted) {
      setState(() {});
    }
  }

  void gnc() async {
    var jsona = {};
    if (myId != null || ids != null) {
      jsona["user"] = myId;
      jsona["id"] = ids;
      jsona["api"] = api;
      jsona['userfr'] = id;

      var r = await http.post(Uri.encodeFull(url + "/workserver/gnc/"),
          body: json.encode(jsona));
      var resposta = json.decode(r.body);
      var i;
      if (resposta["resposta"] != "error") {
        if (resposta["resposta"].length > 0) {
          for (i = 0; i < resposta["resposta"].length; i++) {
            ids = resposta["resposta"][i][0];
            talks.insert(0, resposta["resposta"][i]);
            if (this.mounted) {
              setState(() {});
            }
          }
          if (i + 1 >= resposta["resposta"].length) {
            if (fail == 0) {
              gnpTime = new Timer(const Duration(seconds: 2), gnc);
            }
          }
        } else {
          if (fail == 0) {
            gnpTime = new Timer(const Duration(seconds: 2), gnc);
          }
        }
      }
    }
  }

  void portToprivate() async {
    if (imageF.length > 0 || publ.text != '') {
      var uri = Uri.parse(url + "/workserver/postprivatechat/");
      var request = new http.MultipartRequest("POST", uri);
      request.fields['name1'] = myname;
      request.fields['api'] = api;
      request.fields['user1'] = myId.toString();
      request.fields['user2'] = id.toString();

      if (publ.text != "") {
        request.fields['msg'] = publ.text;
      }
      if (imageF.length > 0) {
        var stream =
            new http.ByteStream(DelegatingStream.typed(file[0].openRead()));
        var length = await file[0].length();
        var multipartFile = new http.MultipartFile('img', stream, length,
            filename: basename(file[0].path));
        request.files.add(multipartFile);
      }
      var response = await request.send();
      publ.text = "";
      print(response.statusCode);
      if (file.length > 0) {
        file.removeAt(0);
        imageF.removeAt(0);
        if (file.length > 0) {
          portToprivate();
        }
      }
    }
  }

  void getP() async {
    var prefs = await SharedPreferences.getInstance();
    myId = prefs.getInt('userid') ?? 0;
    api = prefs.getString("api") ?? '';
    var jsona = {};
    jsona["user"] = myId;
    jsona["api"] = api;
    jsona["id"] = id;
    var r = await http.post(
        Uri.encodeFull(url + "/workserver/getPrivateTalks/"),
        body: json.encode(jsona));
    var resposta = json.decode(r.body);
    ids = resposta['id'];
    myname = resposta['name'];
    if (resposta['style'] != "") {
      style = url + "/media/" + resposta['style'];
    }
    talks.addAll(resposta['respostaT']);
    duoemojis =
        json.decode(await rootBundle.loadString('assets/json/finish.json'));
    emojis.addAll(duoemojis);
    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    gnpTime = null;
    fail = 1;
    super.dispose();
  }

  @override
  void initState() {
    id = widget.id;
    name = widget.name;
    image = widget.image;
    emojicon.addListener(() {
      filter = emojicon.text;
      if (this.mounted) {
        setState(() {
          emojis.clear();
          if (filter != null || filter != "") {
            for (var i = 0; i < duoemojis.length; i++) {
              if (duoemojis[i]['name'].contains(filter)) {
                emojis.add(duoemojis[i]);
              }
            }
          } else {
            emojis.addAll(duoemojis);
          }
        });
      }
    });
    getP();
    gnpTime = new Timer(const Duration(seconds: 2), gnc);
    super.initState();
  }

  void addEmoji(int index) {
    this.publ.text += emojis[index]['emoji'];
  }

  Future<bool> will() {
    if (_visible) {
      _visible = false;
      if (this.mounted) {
        setState(() {});
      }
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Container(
              decoration: BoxDecoration(
                  border: new Border.all(
                    width: 0.0,
                    color: const Color(0x00000000),
                  ),
                  borderRadius: new BorderRadius.circular(50.0),
                  image: DecorationImage(
                    image: NetworkImage(style),
                    fit: BoxFit.contain,
                  ))),
          onPressed: () async {
            await gnpTime.cancel();
            fail = 1;
            Navigator.pushReplacementNamed(context, "/bottom");
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.height * 0.7829,
                    height: imageF.length > 0
                        ? _visible == true
                            ? MediaQuery.of(context).size.height * 0.61 - 250
                            : MediaQuery.of(context).size.height * 0.61
                        : _visible == true
                            ? MediaQuery.of(context).size.height * 0.7829 - 250
                            : MediaQuery.of(context).size.height * 0.7829,
                    child: CustomScrollView(
                      reverse: true,
                      semanticChildCount: talks.length,
                      slivers: <Widget>[
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return Container(
                                  padding: talks[index][2] == id
                                      ? EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.32,
                                        )
                                      : EdgeInsets.only(
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.32,
                                        ),
                                  margin: const EdgeInsets.only(
                                      top: 10.0, left: 5.0, right: 5.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        decoration: new BoxDecoration(
                                          color: talks[index][2] == id
                                              ? Color(0Xff347cd5)
                                              : Color(0Xffe6ecf0),
                                          border: new Border.all(
                                            width: 0.0,
                                            color: const Color(0x00000000),
                                          ),
                                          borderRadius:
                                              new BorderRadius.circular(5.0),
                                          boxShadow: [
                                            new BoxShadow(
                                              color: const Color(0x23000000),
                                              blurRadius: 3.0,
                                            )
                                          ],
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            talks[index][3] != ""
                                                ? Image.network(
                                                    url + talks[index][3],
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                  )
                                                : Container(),
                                            talks[index][4] != ""
                                                ? Container(
                                                    margin: EdgeInsets.only(
                                                        left: 6, right: 6),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        talks[index][4],
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          height: 1.4,
                                                          color: talks[index]
                                                                      [2] ==
                                                                  id
                                                              ? Colors.white
                                                              : Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 6,
                                                  bottom: 6,
                                                  right: 6,
                                                  top: 8),
                                              child: Align(
                                                alignment: talks[index][2] == id
                                                    ? Alignment.centerRight
                                                    : Alignment.centerLeft,
                                                child: Text(
                                                  talks[index][5],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 13,
                                                    color: talks[index][2] == id
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ));
                            },
                            childCount: talks.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              imageF.length > 0
                  ? Container(
                      margin: EdgeInsets.only(top: 5),
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      color: Color(0xFFededed),
                      child: Stack(
                        children: <Widget>[
                          CustomScrollView(
                            scrollDirection: Axis.horizontal,
                            semanticChildCount: imageF.length,
                            slivers: <Widget>[
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                "Deseja remover essa imagem antes de enviar.",
                                                textAlign: TextAlign.center,
                                              ),
                                              titleTextStyle: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black),
                                              content: SingleChildScrollView(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: <Widget>[
                                                    MaterialButton(
                                                      child: Text("Sim"),
                                                      color: vupycolor,
                                                      textColor: Colors.white,
                                                      onPressed: () {},
                                                    ),
                                                    MaterialButton(
                                                      child: Text("Não"),
                                                      color: vupycolor,
                                                      textColor: Colors.white,
                                                      onPressed: () {},
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        height: 80,
                                        margin: EdgeInsets.only(right: 5),
                                        width: 100,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image:
                                                FileImage(File(imageF[index])),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  childCount: imageF.length,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  : Container(),
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 45,
                      decoration: new BoxDecoration(
                        color: vupycolor,
                        border: new Border.all(
                          width: 0.0,
                          color: const Color(0x00000000),
                        ),
                        borderRadius: new BorderRadius.circular(100.0),
                      ),
                      child: new IconButton(
                        padding: new EdgeInsets.all(0.0),
                        color: vupycolor,
                        icon: Icon(IconData(0xe9dc, fontFamily: "icomoon"),
                            size: 16.0, color: Colors.white),
                        onPressed: () {
                          _visible = true;
                          if (this.mounted) {
                            setState(() {});
                          }
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      width: MediaQuery.of(context).size.width - 165,
                      height: 50,
                      child: TextFormField(
                        controller: publ,
                        keyboardType: TextInputType.multiline,
                        maxLines: 20,
                        style: TextStyle(fontSize: 15.0),
                        decoration: new InputDecoration(
                          hintText: 'Digite aqui...',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 45,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: new BoxDecoration(
                        color: vupycolor,
                        border: new Border.all(
                          width: 0.0,
                          color: const Color(0x00000000),
                        ),
                        borderRadius: new BorderRadius.circular(100.0),
                      ),
                      child: new IconButton(
                        padding: new EdgeInsets.all(0.0),
                        color: vupycolor,
                        icon: Icon(IconData(0xe92b, fontFamily: "icomoon"),
                            size: 16.0, color: Colors.white),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: SingleChildScrollView(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      ButtonTheme(
                                          child: RaisedButton(
                                        onPressed: () {
                                          ftGaleria();
                                          Navigator.pop(context);
                                        },
                                        child: Text("Galeria",
                                            style: TextStyle(
                                                color: Color(0xFFFFFFFF))),
                                        color: vupycolor,
                                      )),
                                      ButtonTheme(
                                          child: RaisedButton(
                                        onPressed: () {
                                          ftCamera();
                                          Navigator.pop(context);
                                        },
                                        child: Text("Camera",
                                            style: TextStyle(
                                                color: Color(0xFFFFFFFF))),
                                        color: vupycolor,
                                      )),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Container(
                      width: 45,
                      decoration: new BoxDecoration(
                        color: vupycolor,
                        border: new Border.all(
                          width: 0.0,
                          color: const Color(0x00000000),
                        ),
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      child: new IconButton(
                        padding: new EdgeInsets.all(0.0),
                        color: vupycolor,
                        icon: Icon(IconData(0xe9cb, fontFamily: "icomoon"),
                            size: 16.0, color: Colors.white),
                        onPressed: () {
                          portToprivate();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              _visible == true
                  ? WillPopScope(
                      onWillPop: will,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 250.0,
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          border: new Border.all(
                            width: 0.0,
                            color: const Color(0x00000000),
                          ),
                          borderRadius: new BorderRadius.circular(7.0),
                          boxShadow: [
                            new BoxShadow(
                              color: const Color(0x33000000),
                              blurRadius: 4.0,
                            )
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              child: TextField(
                                controller: emojicon,
                                decoration: new InputDecoration(
                                  hintText: 'Digite aqui...',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              child: CustomScrollView(
                                semanticChildCount: emojis.length,
                                slivers: <Widget>[
                                  SliverGrid(
                                    gridDelegate:
                                        SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 50.0,
                                      mainAxisSpacing: 4.0,
                                      crossAxisSpacing: 4.0,
                                      childAspectRatio: 1.0,
                                    ),
                                    delegate: SliverChildBuilderDelegate(
                                      (BuildContext context, int index) {
                                        return filter == null || filter == ""
                                            ? MaterialButton(
                                                child: Text(
                                                    emojis[index]["emoji"]),
                                                onPressed: () {
                                                  addEmoji(index);
                                                },
                                              )
                                            : emojis[index]['name']
                                                    .contains(filter)
                                                ? MaterialButton(
                                                    child: Text(
                                                        emojis[index]["emoji"]),
                                                    onPressed: () {
                                                      addEmoji(index);
                                                    },
                                                  )
                                                : Container();
                                      },
                                      childCount: emojis.length,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
