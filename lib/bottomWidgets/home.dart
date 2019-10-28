import 'dart:core';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:vupy/main.dart';
import 'package:vupy/widgets/getColors.dart';
import 'package:vupy/widgets/url.dart';

import 'dart:convert';
import 'dart:async';
import 'dart:io';

import '../comments.dart';
import '../otherperfil.dart';
import '../settings.dart';
import '../widgets/emojis.dart';
import '../widgets/heroimg.dart';

const white = const Color(0xFFFFFFFF);
final publ = TextEditingController();

class HomePageVupy extends StatefulWidget {
  final _HomePageVupy home = new _HomePageVupy();

  @override
  State createState() => home;

  void ungnp(dark, nav, btn) {
    home.ungnp(dark, nav, btn);
  }

  void stopgnp() {
    home.stopgnp();
  }
}

class Emojis extends EmojisData {
  Emojis(double media, List emojis) : super(media, emojis);

  @override
  void addEmoji(emo) {
    publ.text += emo;
  }
}

class _HomePageVupy extends State<HomePageVupy>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  var _visible = false, gnpTime;

  bool infor = false, fail = false, dark;

  String image = "", name, api, url = URL().getUrl(), filter;
  String ftuser = "https://vupytcc.pythonanywhere.com/static/img/user.png";

  int myId, ids;

  List<Widget> post = new List();
  List talks = [];
  List duoemojis = [];

  Color trueColor, trueBodyColor;
  Color differ = Color(0xffffffff);
  Color differBtn = Color(0xffffffff);
  Color vupycolor = Color(0xFFE7002B);
  Color syntax = Color(0xffffffff);
  Color syntaxdark = Color(0xffffffff);
  Color syntaxdiffer = Color(0xff000000);

  int show = 0;

  TextEditingController emojicon = new TextEditingController();

  File file;

  FocusNode focusPubl = new FocusNode();

  AnimationController animationController;
  Animation<double> animation;

  Future ungnp(darkx, nav, btn) async {
    fail = false;
    animationController.reset();

    gnpTime = new Timer(const Duration(seconds: 2), gnp);
    var jsona = {};
    jsona['user'] = myId;
    jsona['api'] = api;

    dark = darkx;
    trueColor = nav;
    vupycolor = btn;
    show = 1;

    if (trueColor.computeLuminance() > 0.673) {
      differ = Colors.black;
    }
    if (vupycolor.computeLuminance() > 0.673) {
      differBtn = Colors.black;
    }

    if (dark == true) {
      syntax = Color(0xff282828);
      syntaxdiffer = Color(0xffffffff);
      syntaxdark = Color(0xff1f1f1f);
    } else {
      syntax = Colors.white;
      syntaxdark = Colors.black;
      syntaxdiffer = Colors.black;
    }
  }

  Future stopgnp() async {
    fail = true;
    animationController.stop();
  }

  Future onlinecolors(var resposta) async {
    Future colorsnav = ColorsGetCustom().getColorNavAndBtn(
        resposta['navcolor'],
        trueColor,
        resposta['themecolor'],
        vupycolor,
        resposta['dark'],
        resposta['bodycolor'],
        trueBodyColor);
    if (this.mounted) {
      setState(() {
        colorsnav.then((response) {
          trueColor = response[0];
          differ = response[1];
          vupycolor = response[2];
          differBtn = response[3];
          show = 1;
          if (response[4] == 1) {
            syntax = Color(0xff282828);
            syntaxdiffer = Color(0xffffffff);
            syntaxdark = Color(0xff1f1f1f);
            dark = true;
          } else {
            syntax = Colors.white;
            syntaxdark = Colors.black;
            syntaxdiffer = Colors.black;
            dark = false;
          }
        });
      });
    }
  }

  Future likeMe(int index, int idpub) async {
    var jsona = {};
    jsona["user"] = myId;
    jsona["pgc"] = idpub;
    jsona["api"] = api;
    await http.post(Uri.encodeFull(url + "/workserver/likepub/"),
        body: json.encode(jsona));
    if (this.mounted) {
      setState(() {});
    }
  }

  void deletePub(idPub, index) async {
    var jsona = {};
    talks.removeAt(index);
    // deleted = 1;

    jsona["user"] = myId;
    jsona["id"] = idPub;
    jsona["api"] = api;
    await http.post(Uri.encodeFull(url + "/workserver/delpub/"),
        body: json.encode(jsona));

    if (this.mounted) {
      setState(() {});
    }
  }

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
      if (response.statusCode == 200) {
        if (this.mounted) {
          setState(() {});
        }
      }
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

  @override
  void dispose() {
    gnpTime = null;
    fail = true;
    super.dispose();
  }

  Future colorama(var prefs) async {
    if (this.mounted) {
      setState(() {
        var color = (prefs.getStringList("color") ?? ["255", "255", "255", "1"])
            .toList()
            .toString();
        var cc = jsonDecode(color);
        trueColor = Color.fromRGBO(cc[0], cc[1], cc[2], 1);

        color = (prefs.getStringList("colorbtn") ?? ["231", "0", "42", "1"])
            .toList()
            .toString();
        cc = jsonDecode(color);
        vupycolor = Color.fromRGBO(cc[0], cc[1], cc[2], 1);

        color = (prefs.getStringList("body") ?? ["255", "255", "255", "1"])
            .toList()
            .toString();
        cc = jsonDecode(color);
        trueBodyColor = Color.fromRGBO(cc[0], cc[1], cc[2], 1);
      });
    }
  }

  Future startChatPub() async {
    var prefs = await SharedPreferences.getInstance();
    colorama(prefs);
    var jsona = {};

    myId = prefs.getInt('userid') ?? 0;
    api = prefs.getString("api") ?? '';

    jsona["user"] = myId;
    jsona["api"] = api;
    var resposta;
    try {
      var r = await http.post(Uri.encodeFull(url + '/workserver/getinit/'),
          body: json.encode(jsona));
      resposta = json.decode(r.body);
      onlinecolors(resposta);
    } catch (e) {
      prefs.clear();
      navigatorKey.currentState.pushReplacementNamed("/log");
    }

    if (this.mounted) {
      setState(() {
        talks.addAll(resposta["resposta"]);
      });
    }

    ids = resposta["lsd"];
    name = resposta['name'];

    duoemojis =
        json.decode(await rootBundle.loadString('assets/json/finish.json'));
  }

  @override
  void initState() {
    focusPubl.addListener(changeFocusPubl);
    startChatPub();
    print("caller end");
    gnpTime = new Timer(const Duration(seconds: 2), gnp);
    super.initState();
    animationController = AnimationController(
      // vsync: this,
      vsync: this,
      duration: Duration(seconds: 5),
    )..addListener(() => setState(() {}));
    animation = Tween<double>(
      begin: 50.0,
      end: 120.0,
    ).animate(animationController);

    animationController.forward();
  }

  Future<bool> will() async {
    if (_visible) {
      _visible = false;
      setState(() {});
      return new Future.value(false);
    }
    return new Future.value(true);
  }

  Widget postCard(
    talks,
    index,
    context,
  ) {
    return Container(
      decoration: BoxDecoration(color: syntax),
      margin: EdgeInsets.only(top: 2),
      child: Column(
        children: <Widget>[
          talks[2] != ""
              ? GestureDetector(
                  child: Hero(
                      child: Image.network(url + talks[2]),
                      tag: "Images" + talks[0].toString()),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return DetailScreen(
                        imageurl: url + talks[2],
                        hero: "Images" + talks[0].toString(),
                        name: talks[5],
                      );
                    }));
                  },
                )
              : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtherPerfil(
                          idFr: talks[1],
                        ),
                      ));
                },
                child: Container(
                  margin: EdgeInsets.only(left: 5, top: 5),
                  child: Row(
                    children: <Widget>[
                      talks[6] != ""
                          ? Container(
                              width: 40,
                              height: 40,
                              margin: const EdgeInsets.only(right: 5.0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Color(0x01000001)),
                                  borderRadius: BorderRadius.circular(100),
                                  image: DecorationImage(
                                      image: NetworkImage(url + talks[6]),
                                      fit: BoxFit.cover)),
                            )
                          : Container(
                              width: 40,
                              height: 40,
                              margin: const EdgeInsets.only(right: 5.0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Color(0x01000001)),
                                  borderRadius: BorderRadius.circular(100),
                                  image: DecorationImage(
                                      image: NetworkImage(ftuser),
                                      fit: BoxFit.cover)),
                            ),
                      Text(
                        talks[5],
                        style: TextStyle(color: syntaxdiffer),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                  child: talks[1] == myId
                      ? IconButton(
                          icon: Icon(
                            IconData(0xea10, fontFamily: 'icomoon'),
                            size: 20,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                      'Você deseja remover essa publicação.'),
                                  content: SingleChildScrollView(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        MaterialButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Text(
                                            "Sim",
                                            style: TextStyle(color: differBtn),
                                          ),
                                          onPressed: () {
                                            deletePub(talks[0], index);
                                            Navigator.pop(context);
                                          },
                                          color: vupycolor,
                                        ),
                                        MaterialButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Text(
                                            "Não",
                                            style: TextStyle(color: differBtn),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          color: vupycolor,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        )
                      : Container())
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(left: 45.0),
              child: Text(
                talks[4],
                style: TextStyle(color: syntaxdiffer),
              ),
            ),
          ),
          Divider(color: Color(0x00FFFFFF)),
          talks[9] != "None"
              ? Container(
                  margin: EdgeInsets.only(left: 45),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      talks[9],
                      style: TextStyle(color: syntaxdiffer),
                    ),
                  ))
              : Container(),
          Container(
            margin: const EdgeInsets.only(top: 8.0, left: 45, right: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: talks[3] != ""
                  ? Text(
                      talks[3],
                      style: TextStyle(color: syntaxdiffer),
                    )
                  : Container(),
            ),
          ),
          Divider(color: Color(0xFFd2d2d2)),
          Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  talks[7] == 0
                      ? FlatButton.icon(
                          icon: Icon(
                            IconData(0xe97c, fontFamily: 'icomoon'),
                            size: 20,
                            color: Colors.grey,
                          ),
                          label: Text(
                            "${talks[10]}",
                            style: TextStyle(color: syntaxdiffer),
                          ),
                          onPressed: () {
                            talks[7] = 1;
                            likeMe(index, talks[0]);
                          },
                        )
                      : FlatButton.icon(
                          icon: Icon(
                            IconData(0xe900, fontFamily: 'icomoon'),
                            size: 20,
                            color: vupycolor,
                          ),
                          label: Text(
                            "${talks[10]}",
                            style: TextStyle(color: syntaxdiffer),
                          ),
                          onPressed: () {
                            talks[7] = 0;
                            likeMe(index, talks[0]);
                          },
                        ),
                  FlatButton.icon(
                    icon: Icon(
                      IconData(0xe998, fontFamily: 'icomoon'),
                      size: 20,
                      color: Colors.grey,
                    ),
                    label: Text(
                      "${talks[12]}",
                      style: TextStyle(color: syntaxdiffer),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Comments(
                              id: talks[0],
                              name: talks[5],
                              image: talks[6],
                              myname: name,
                              text: talks[3],
                              returnPage: "/bottom",
                              btn: vupycolor,
                              differBtn: differBtn,
                              differNav: differ,
                              nav: trueColor,
                              syntax: syntax,
                              body: trueBodyColor,
                            ),
                          ));
                    },
                  ),
                  FlatButton.icon(
                    icon: Icon(
                      IconData(0xe9ce, fontFamily: 'icomoon'),
                      size: 20,
                      color: Colors.grey,
                    ),
                    label: Text(
                      "${talks[11]}",
                      style: TextStyle(color: syntaxdiffer),
                    ),
                    onPressed: () {},
                  )
                ]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Emojis emox = new Emojis(MediaQuery.of(context).size.width, duoemojis);

    return Stack(
      children: [
        CustomScrollView(
          semanticChildCount: talks.length,
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              title: Text(
                'Publicações',
                style: TextStyle(color: differ),
              ),
              backgroundColor: trueColor,
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    IconData(0xe9cd, fontFamily: 'icomoon'),
                    color: differ,
                  ),
                  onPressed: () async {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Settings(
                                  navcolor: trueColor,
                                  btn: vupycolor,
                                  dark: dark,
                                )));
                  },
                ),
              ],
              leading: Container(),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    padding: new EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 15),
                    color: syntax,
                    child: Column(
                      children: [
                        TextField(
                            maxLines: 4,
                            focusNode: focusPubl,
                            controller: publ,
                            keyboardType: TextInputType.multiline,
                            decoration: new InputDecoration(
                              hintText: 'Faça uma publicação :)',
                              hintStyle: TextStyle(color: syntaxdiffer),
                              contentPadding: const EdgeInsets.all(15.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: syntaxdark, width: 1.5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: syntax == Color(0xff282828)
                                        ? Color(0xff181818)
                                        : Color(0xffe6ecf0),
                                    width: 2.0),
                              ),
                            ),
                            style: new TextStyle(
                                height: 1.0, color: syntaxdiffer)),
                        Container(
                          margin: const EdgeInsets.only(top: 5.0),
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
                                      border: Border.all(
                                          width: 0, color: Color(0x01000001)),
                                      borderRadius: BorderRadius.circular(100),
                                      color: vupycolor,
                                    ),
                                    child: IconButton(
                                      padding: new EdgeInsets.all(0.0),
                                      icon: Icon(
                                        IconData(0xe92b, fontFamily: "icomoon"),
                                        size: 20.0,
                                        color: differBtn,
                                      ),
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
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      onPressed: () {
                                                        ftGaleria();
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("Galeria"),
                                                      color: vupycolor,
                                                      textColor: differBtn,
                                                    ),
                                                    MaterialButton(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                      onPressed: () {
                                                        ftCamera();
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("Camera"),
                                                      color: vupycolor,
                                                      textColor: differBtn,
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
                                      border: Border.all(
                                          width: 0, color: Color(0x01000001)),
                                      borderRadius: BorderRadius.circular(100),
                                      color: vupycolor,
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                          IconData(0xe9dc,
                                              fontFamily: "icomoon"),
                                          size: 20.0,
                                          color: differBtn),
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
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    height: 40.0,
                                    child: Text("Publicar"),
                                    onPressed: () {
                                      postPub();
                                    },
                                    textColor: differBtn,
                                    color: vupycolor,
                                  )),
                            ],
                          ),
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

            /* ------------- LOAD  ------------- */
            show == 0
                ? SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Container(
                            color: syntax,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height - 300,
                            child: Image.asset("assets/load.gif"));
                      },
                      childCount: 1,
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Container();
                      },
                      childCount: 1,
                    ),
                  ),

            /* ------------- POSTS ------------- */

            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return postCard(
                    talks[index],
                    index,
                    context,
                  );
                  // return Text("sda " + index.toString());
                },
                childCount: talks.length,
              ),
            ),

            /* ------------- END POSTS ------------- */
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
                          height: 250,
                          child: DefaultTabController(
                            length: 8,
                            child: Scaffold(
                              backgroundColor: syntax,
                              appBar: TabBar(
                                labelColor: Colors.black,
                                indicatorColor: vupycolor,
                                unselectedLabelColor: Colors.grey,
                                tabs: <Widget>[
                                  Tab(text: "😀"),
                                  Tab(text: "🐶"),
                                  Tab(text: "🍎"),
                                  Tab(text: "🎮"),
                                  Tab(text: "⚽️"),
                                  Tab(text: "🌍"),
                                  Tab(text: "💯"),
                                  Tab(text: "🏴"),
                                ],
                              ),
                              body: TabBarView(
                                children: <Widget>[
                                  emox.emoGro1(),
                                  emox.emoGro2(),
                                  emox.emoGro3(),
                                  emox.emoGro4(),
                                  emox.emoGro5(),
                                  emox.emoGro6(),
                                  emox.emoGro7(),
                                  emox.emoGro8(),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ))
            : SizedBox(),
        // Divider(color: Colors.white),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
