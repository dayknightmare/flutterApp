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

const vupycolor = const Color(0xFFE7002B);
const white = const Color(0xFFFFFFFF);

class HomePageVupy extends StatefulWidget {
  @override
  State createState() => _HomePageVupy();
}

class _HomePageVupy extends State<HomePageVupy> {
  var _visible = false, gnpTime;

  bool infor = false;

  String image = "", name, api, url = "http://201.76.95.46:80";
  int _selectedIndex = 0, myId, ids;

  List<Widget> post = new List();
  List talks = [];
  List emojis = [];

  final publ = TextEditingController();

  File file;

  FocusNode focusPubl = new FocusNode();

  void ftCamera() async {
    file = await ImagePicker.pickImage(source: ImageSource.camera);
    image = file.path;
    setState(() {});
  }

  void ftGaleria() async {
    file = await ImagePicker.pickImage(source: ImageSource.gallery);
    image = file.path;
    setState(() {});
  }

  void likeMe(int index, int idpub) async {
    var jsona = {};
    jsona["user"] = myId;
    jsona["pgc"] = idpub;
    jsona["api"] = api;
    print("sdf");
    await http.post(Uri.encodeFull(url + "/workserver/likepub/"),
        body: json.encode(jsona));
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
            gnpTime = new Timer(const Duration(seconds: 2), gnp);
          }
        } else {
          print("0");
          gnpTime = new Timer(const Duration(seconds: 2), gnp);
        }
      }
      setState(() {});
    }
  }

  void deletePub(idPub, index) async {
    talks.removeAt(index);
    var jsona = {};
    jsona["user"] = myId;
    jsona["id"] = idPub;
    jsona["api"] = api;
    await http.post(Uri.encodeFull(url + "/workserver/delpub/"),
        body: json.encode(jsona));
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
        print(file.path.split("/").last);
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
      setState(() {});
    }
  }

  void addEmoji(index) {
    publ.text = publ.text + emojis[index]["emoji"];
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

      emojis =
          json.decode(await rootBundle.loadString('assets/json/finish.json'));
      setState(() {});
    }

    focusPubl.addListener(changeFocusPubl);
    startChatPub();
    gnpTime = new Timer(const Duration(seconds: 2), gnp);
    super.initState();
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

              var prefs = await SharedPreferences.getInstance();
              prefs.clear();
              Navigator.pushReplacementNamed(context, '/log');
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Stack(
        // padding: new EdgeInsets.only(bottom:10.0),
        children: [
          CustomScrollView(
            semanticChildCount: talks.length,
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      padding: new EdgeInsets.symmetric(horizontal: 10.0),
                      margin: const EdgeInsets.only(top: 15.0),
                      child: Column(
                        children: [
                          image != ""
                              ? Image.file(File(image), height: 150.0)
                              : Text('', style: new TextStyle(fontSize: 1.0)),
                          Divider(color: Colors.white),
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
                                      child: ButtonTheme(
                                          height: 40.0,
                                          minWidth: 0.0,
                                          child: RaisedButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    content:
                                                        SingleChildScrollView(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: <Widget>[
                                                          ButtonTheme(
                                                              child:
                                                                  RaisedButton(
                                                            onPressed: () {
                                                              ftGaleria();
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                                "Galeria",
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xFFFFFFFF))),
                                                            color: vupycolor,
                                                          )),
                                                          ButtonTheme(
                                                              child:
                                                                  RaisedButton(
                                                            onPressed: () {
                                                              ftCamera();
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                                "Camera",
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xFFFFFFFF))),
                                                            color: vupycolor,
                                                          )),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Icon(
                                                IconData(0xe92b,
                                                    fontFamily: "icomoon"),
                                                size: 20.0,
                                                color: Colors.white),
                                            color: vupycolor,
                                          )),
                                    ),
                                    ButtonTheme(
                                        height: 40.0,
                                        minWidth: 0.0,
                                        child: RaisedButton(
                                          onPressed: () {
                                            if (_visible) {
                                              _visible = false;
                                            } else {
                                              focusPubl.unfocus();
                                              _visible = true;
                                            }
                                          },
                                          child: Icon(
                                              IconData(0xe9dc,
                                                  fontFamily: "icomoon"),
                                              size: 20.0,
                                              color: Colors.white),
                                          color: vupycolor,
                                        )),
                                  ]),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: ButtonTheme(
                                      height: 40.0,
                                      minWidth: 0.0,
                                      child: RaisedButton(
                                        onPressed: () {
                                          postPub();
                                        },
                                        child: Text("Publicar",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        color: vupycolor,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Container(
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        border: new Border.all(
                          width: 0.0,
                          color: const Color(0x00000000),
                        ),
                        borderRadius: new BorderRadius.circular(5.0),
                        boxShadow: [
                          new BoxShadow(
                            color: const Color(0x33000000),
                            blurRadius: 5.0,
                          )
                        ],
                      ),
                      margin: const EdgeInsets.only(
                          top: 15.0, left: 5.0, right: 5.0),
                      child: Column(
                        children: [
                          talks[index][2] != ""
                              ? Image.network(url + talks[index][2])
                              : Text('', style: new TextStyle(fontSize: 1.0)),
                          Container(
                            padding: new EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            talks[index][6] != ""
                                                ? Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 5.0),
                                                    child: new ClipRRect(
                                                      borderRadius:
                                                          new BorderRadius
                                                              .circular(50.0),
                                                      child: Image.network(
                                                        url + talks[index][6],
                                                        height: 40.0,
                                                        width: 40.0,
                                                      ),
                                                    ))
                                                : Text(''),
                                            Text(talks[index][5],
                                                style: new TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                          ],
                                        ),
                                      ),
                                      talks[index][1] == myId
                                          ? GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          'Você deseja remover essa publicação.'),
                                                      content:
                                                          SingleChildScrollView(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: <Widget>[
                                                            ButtonTheme(
                                                                child:
                                                                    RaisedButton(
                                                              onPressed: () {
                                                                deletePub(
                                                                    talks[index]
                                                                        [0],
                                                                    index);
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text("Sim",
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0xFFFFFFFF))),
                                                              color: vupycolor,
                                                            )),
                                                            ButtonTheme(
                                                                child:
                                                                    RaisedButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text("Não",
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0xFFFFFFFF))),
                                                              color: vupycolor,
                                                            )),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: Container(
                                                padding:
                                                    new EdgeInsets.all(5.0),
                                                margin: const EdgeInsets.only(
                                                    right: 5.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text("X"),
                                                ),
                                              ),
                                            )
                                          : Text('',
                                              style:
                                                  new TextStyle(fontSize: 1.0)),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: talks[index][6] != ""
                                      ? Container(
                                          margin:
                                              const EdgeInsets.only(left: 45.0),
                                          child: Text(talks[index][4]),
                                        )
                                      : Container(
                                          margin:
                                              const EdgeInsets.only(left: 0.0),
                                          child: Text(talks[index][4]),
                                        ),
                                ),
                                Divider(color: Color(0x00FFFFFF)),
                                Container(
                                  margin: const EdgeInsets.only(top: 8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: talks[index][3] != ""
                                        ? Text(talks[index][3])
                                        : Text('',
                                            style:
                                                new TextStyle(fontSize: 1.0)),
                                  ),
                                ),
                                Divider(color: Color(0xFFd2d2d2)),
                                Container(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        talks[index][7] == 0
                                            ? GestureDetector(
                                                onTap: () async {
                                                  talks[index][7] = 1;
                                                  likeMe(
                                                      index, talks[index][0]);
                                                },
                                                child: Icon(
                                                    IconData(0xe97c,
                                                        fontFamily: 'icomoon'),
                                                    size: 20))
                                            : GestureDetector(
                                                onTap: () async {
                                                  talks[index][7] = 0;
                                                },
                                                child: new IconTheme(
                                                  data: new IconThemeData(
                                                      color: vupycolor),
                                                  child: Icon(
                                                      IconData(0xe900,
                                                          fontFamily:
                                                              'icomoon'),
                                                      size: 20),
                                                ),
                                              ),
                                        Icon(
                                            IconData(0xe998,
                                                fontFamily: 'icomoon'),
                                            size: 20),
                                        Icon(
                                            IconData(0xe9ce,
                                                fontFamily: 'icomoon'),
                                            size: 20),
                                      ]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                    onWillPop: () async {
                      _visible = false;
                    },
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
                                return ButtonTheme(
                                    child: RaisedButton(
                                  onPressed: () {
                                    addEmoji(index);
                                  },
                                  child: Text(emojis[index]["emoji"]),
                                  color: Colors.white,
                                ));
                              },
                              childCount: emojis.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : SizedBox(),
          Divider(color: Colors.white),
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
