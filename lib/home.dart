import 'dart:core' as prefix0;
import 'dart:core';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:path/path.dart';
import 'package:async/async.dart';

import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'widgets/postCard.dart';

const vupycolor = const Color(0xFFE7002B);
const white = const Color(0xFFFFFFFF);

class HomePageVupy extends StatefulWidget {
  @override
  State createState() => _HomePageVupy();
}

class _HomePageVupy extends State<HomePageVupy> {
  var _visible = false, gnpTime;

  bool infor = false, fail = false;

  String image = "", name, api, url = "http://179.233.213.76", filter;
  int _selectedIndex = 0, myId, ids;

  List<Widget> post = new List();
  List talks = [];
  List emojis = [];
  List duoemojis = [];

  TextEditingController emojicon = new TextEditingController();

  final publ = TextEditingController();

  File file;

  FocusNode focusPubl = new FocusNode();

  void ftCamera() async {
    file = await ImagePicker.pickImage(source: ImageSource.camera);
    image = file.path;
    if (this.mounted) {
      setState(() {});
    }
  }

  void ftGaleria() async {
    file = await ImagePicker.pickImage(source: ImageSource.gallery);
    image = file.path;
    if (this.mounted) {
      setState(() {});
    }
  }

  void gnp() async {
    var jsona = {};
    if (myId != null || ids != null) {
      jsona["user"] = myId;
      jsona["id"] = ids;
      jsona["api"] = api;
      var r = await http.post(Uri.encodeFull(url + "/workserver/gnp/"),
          body: json.encode(jsona));
      var resposta = json.decode(r.body);
      var i;
      if (resposta["resposta"] != "error") {
        if (resposta["resposta"].length > 0) {
          for (i = 0; i < resposta["resposta"].length; i++) {
            ids = resposta["resposta"][i][0];
            talks.insert(0, resposta["resposta"][i]);
          }
          if (i + 1 >= resposta["resposta"].length) {
            if (fail == false) {
              gnpTime = new Timer(const Duration(seconds: 2), gnp);
            }
          }
          if (this.mounted) {
            setState(() {});
          }
        } else {
          if (fail == false) {
            gnpTime = new Timer(const Duration(seconds: 2), gnp);
          }
        }
      }
    }
  }

  Future<String> postPub() async {
    if (image != "" || publ.text != "") {
      var uri = Uri.parse(url + "/workserver/prchat/");
      var request = new http.MultipartRequest("POST", uri);

      request.fields['name'] = name;
      request.fields['user'] = myId.toString();
      if (image != "") {
        var stream =
            new http.ByteStream(DelegatingStream.typed(file.openRead()));
        var length = await file.length();
        var multipartFile = new http.MultipartFile('img', stream, length,
            filename: basename(file.path));
        request.files.add(multipartFile);
      }

      if (publ.text != "") {
        request.fields['msg'] = publ.text;
      }

      image = "";
      file = null;
      publ.clear();

      var response = await request.send();
      print(response.statusCode);
      return "ok";
    }
    return "error";
  }

  void changeFocusPubl() {
    if (focusPubl.hasFocus.toString() == "true") {
      _visible = false;
      if (this.mounted) {
        setState(() {});
      }
    }
  }

  void addEmoji(index) {
    publ.text = publ.text + emojis[index]["emoji"];
  }

  @override
  void dispose() {
    gnpTime = null;
    fail = true;
    print("object");
    super.dispose();
  }

  @override
  void initState() {
    void startChatPub() async {
      var jsona = {};
      var prefs = await SharedPreferences.getInstance();
      myId = prefs.getInt('userid') ?? 0;
      api = prefs.getString("api") ?? '';

      jsona["user"] = myId;
      jsona["api"] = api;

      var r = await http.post(Uri.encodeFull(url + '/workserver/getinit/'),
          body: json.encode(jsona));
      var resposta = json.decode(r.body);

      talks.addAll(resposta["resposta"]);
      ids = resposta["lsd"];
      name = resposta['name'];

      duoemojis =
          json.decode(await rootBundle.loadString('assets/json/finish.json'));

      emojis.addAll(duoemojis);
      if (this.mounted) {
        setState(() {});
      }
    }

    focusPubl.addListener(changeFocusPubl);
    startChatPub();
    gnpTime = new Timer(const Duration(seconds: 2), gnp);
    emojicon.addListener(() {
      filter = emojicon.text;
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
    });
    super.initState();
  }

  Future<bool> will() async {
    if (_visible) {
      _visible = false;
      setState(() {});
      return new Future.value(false);
    }
    return new Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    void _onItemTapped(int index) {
      if (index == 2) {
        gnpTime.cancel();
        Navigator.pushReplacementNamed(context, "/perfil");
      }
      if (index == 1) {
        gnpTime.cancel();
        Navigator.pushReplacementNamed(context, "/chat");
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Publicações'),
        backgroundColor: white,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(IconData(0xe98f, fontFamily: 'icomoon'),
                color: Colors.black),
            onPressed: () async {
              await gnpTime.cancel();
              fail = true;
              var prefs = await SharedPreferences.getInstance();
              prefs.clear();
              Navigator.pushReplacementNamed(context, '/log');
            },
          ),
        ],
      ),
      backgroundColor: Color(0Xffe6ecf0),
      body: Stack(
        children: [
          CustomScrollView(
            semanticChildCount: talks.length,
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      padding: new EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 15),
                      color: white,
                      child: Column(
                        children: [
                          TextField(
                              maxLines: 4,
                              focusNode: focusPubl,
                              controller: publ,
                              keyboardType: TextInputType.multiline,
                              decoration: new InputDecoration(
                                hintText: 'Faça uma publicação :)',
                                contentPadding: const EdgeInsets.all(15.0),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1.5),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 1.0),
                                ),
                              ),
                              style: new TextStyle(
                                height: 1.0,
                              )),
                          Container(
                            margin: const EdgeInsets.only(top: 15.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Row(children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 5.0),
                                      height: 40.0,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(width: 0, color: white),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: vupycolor,
                                      ),
                                      child: IconButton(
                                        padding: new EdgeInsets.all(0.0),
                                        icon: Icon(
                                            IconData(0xe92b,
                                                fontFamily: "icomoon"),
                                            size: 20.0,
                                            color: Colors.white),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                content: SingleChildScrollView(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: <Widget>[
                                                      MaterialButton(
                                                        onPressed: () {
                                                          ftGaleria();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("Galeria"),
                                                        color: vupycolor,
                                                        textColor: white,
                                                      ),
                                                      MaterialButton(
                                                        onPressed: () {
                                                          ftCamera();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("Camera"),
                                                        color: vupycolor,
                                                        textColor: white,
                                                      )
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
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(width: 0, color: white),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: vupycolor,
                                      ),
                                      child: IconButton(
                                        icon: Icon(
                                            IconData(0xe9dc,
                                                fontFamily: "icomoon"),
                                            size: 20.0,
                                            color: Colors.white),
                                        onPressed: () {
                                          if (_visible) {
                                            _visible = false;
                                            if (this.mounted) {
                                              setState(() {});
                                            }
                                          } else {
                                            focusPubl.unfocus();
                                            _visible = true;
                                            if (this.mounted) {
                                              setState(() {});
                                            }
                                          }
                                        },
                                      ),
                                    )
                                  ]),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: MaterialButton(
                                      height: 40.0,
                                      child: Text("Publicar"),
                                      onPressed: () {
                                        postPub();
                                      },
                                      textColor: white,
                                      color: vupycolor,
                                    )),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.white,
                          ),
                          image != ""
                              ? Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      border: Border.all(
                                          width: 0, color: Color(0x00ffffff)),
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image: FileImage(File(image)),
                                          fit: BoxFit.cover)),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /* ------------- POSTS ------------- */

              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return new PostCard(
                      talks: talks[index],
                      index: index,
                      myId: myId,
                      api: api,
                      name: name,
                      returnPage: "/vupy",
                    );
                  },
                  childCount: talks.length,
                ),
              ),
            ],
          ),
          _visible == true
              ? Positioned(
                  bottom: 0,
                  child: WillPopScope(
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
                                              child:
                                                  Text(emojis[index]["emoji"]),
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
                  ))
              : SizedBox(),
          // Divider(color: Colors.white),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(IconData(0xe9cb, fontFamily: 'icomoon')),
              title: Text('Publicações')),
          BottomNavigationBarItem(
              icon: Icon(IconData(0xe997, fontFamily: 'icomoon')),
              title: Text('Conversas')),
          BottomNavigationBarItem(
              icon: Icon(IconData(0xea00, fontFamily: 'icomoon')),
              title: Text('Perfil')),
        ],
        currentIndex: _selectedIndex,
        fixedColor: vupycolor,
        onTap: _onItemTapped,
      ),
    );
  }
}
