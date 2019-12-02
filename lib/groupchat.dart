import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:vupy/widgets/emojis.dart';
import 'package:vupy/widgets/url.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'bottomAll.dart';

final TextEditingController publ = TextEditingController();

class GroupChat extends StatefulWidget {
  GroupChat(
      {Key key,
      this.id,
      this.name,
      this.image,
      this.btn,
      this.differBtn,
      this.nav,
      this.differNav,
      this.syntax,
      this.syntaxdiffer})
      : super(key: key);

  final int id;
  final String name;
  final String image;
  final Color btn;
  final Color differBtn;
  final Color nav;
  final Color differNav;
  final Color syntax;
  final Color syntaxdiffer;

  @override
  State createState() => _GroupChatState();
}

class Emojis extends EmojisData {
  Emojis(double media, List emojis) : super(media, emojis);

  @override
  void addEmoji(emo) {
    publ.text += emo;
  }
}

class _GroupChatState extends State<GroupChat> {
  var gnpTime;
  String url = URL().getUrl();
  String style = "https://vupytcc.pythonanywhere.com/static/img/user.png";
  String myname;
  String api;

  int myid, lid, fail = 0;
  
  List talks = [];
  List imageF = [];
  List duoemojis = [];
  List<File> file = [];

  bool _visible = false;

  Color vupycolor;
  FocusNode focusPubl = new FocusNode();

  Future gets() async {
    vupycolor = widget.btn;
    var prefs = await SharedPreferences.getInstance();

    if (widget.image != '') {
      style = url + "/media" + widget.image;
    }
    else{
      style = "https://vupytcc.pythonanywhere.com/static/img/user.png";
    }

    myid = prefs.getInt("userid") ?? 0;
    api = prefs.getString("api") ?? '';

    var jsona = {"user": myid, "api": api, "id": widget.id};
    
    var r = await http.post(Uri.encodeFull(url + "/workserver/getGroupTalks/"),
        body: json.encode(jsona));
    var resposta = json.decode(r.body);

    talks.addAll(resposta['respostaT']);
    myname = resposta['name'];
    lid = resposta['id'];
    duoemojis =
        json.decode(await rootBundle.loadString('assets/json/finish.json'));
    gng();
    if (this.mounted) {
      setState(() {});
    }
  }

  Future gng() async {
    var jsona = {};
    if (myid != null || widget.id != null) {
      jsona["user"] = myid;
      jsona["grupo"] = widget.id;
      jsona["api"] = api;
      jsona['id'] = lid;

      var r = await http.post(Uri.encodeFull(url + "/workserver/gng/"),
          body: json.encode(jsona));
      var resposta;
      try {
        resposta = json.decode(r.body);
      } catch (e) {
        if (fail == 0) {
          gnpTime = new Timer(const Duration(seconds: 1), gng);
        }
        return;
      }
      var i;
      if (resposta["resposta"] != "error") {
        if (resposta["resposta"].length > 0) {
          for (i = 0; i < resposta["resposta"].length; i++) {
            lid = resposta["resposta"][i][0];
            talks.insert(0, resposta["resposta"][i]);
            if (this.mounted) {
              setState(() {});
            }
          }
          if (i + 1 >= resposta["resposta"].length) {
            if (fail == 0) {
              gnpTime = new Timer(const Duration(seconds: 1), gng);
            }
          }
        } else {
          if (fail == 0) {
            gnpTime = new Timer(const Duration(seconds: 1), gng);
          }
        }
      }
    }
  }

  Future portToprivate() async {
    if (imageF.length > 0 || publ.text != '') {
      var uri = Uri.parse(url + "/workserver/groupchat/");
      var request = new http.MultipartRequest("POST", uri);
      request.fields['name'] = myname;
      request.fields['api'] = api;
      request.fields['user'] = myid.toString();
      request.fields['group'] = widget.id.toString();

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

  @override
  void dispose() {
    super.dispose();
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
  void initState() {
    super.initState();
    focusPubl.addListener(changeFocusPubl);

    gets();
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
    Emojis emox = new Emojis(MediaQuery.of(context).size.width, duoemojis);

    return Scaffold(
      backgroundColor: widget.syntax,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: widget.nav,
        title: Row(
          children: <Widget>[
            Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () async {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyHomePage(
                          page: 1,
                        ),
                      ));
                },
                child: Row(
                  children: <Widget>[
                    Icon(IconData(0xe913, fontFamily: 'icomoon'), color: widget.differNav,),
                    Container(
                      width: 35,
                      height: 35,
                      margin: EdgeInsets.only(right: 3, left: 6),
                      decoration: BoxDecoration(
                        border: new Border.all(
                          width: 0.0,
                          color: const Color(0x01000001),
                        ),
                        borderRadius: new BorderRadius.circular(50.0),
                        image: DecorationImage(
                          image: NetworkImage(style),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 12),
              child: Text(
                widget.name,
                style: TextStyle(color: widget.differNav),
              ),
            )
            
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: imageF.length > 0
                        ? _visible == true
                            ? MediaQuery.of(context).size.height - 500
                            : MediaQuery.of(context).size.height - 250
                        : _visible == true
                            ? MediaQuery.of(context).size.height - 400
                            : MediaQuery.of(context).size.height - 150,
                    child: CustomScrollView(
                      reverse: true,
                      semanticChildCount: talks.length,
                      slivers: <Widget>[
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return Container(
                                  padding: talks[index][1] == myid
                                      ? 
                                        EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.32)
                                      : 
                                        EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.32),
                                  margin: const EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            talks[index][1] == myid
                                                ? MainAxisAlignment.end
                                                : MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                              decoration: new BoxDecoration(
                                                color: talks[index][1] == myid
                                                    ? Color(0Xff347cd5)
                                                    : widget.syntax ==
                                                            Color(0xff282828)
                                                        ? Color(0x1f1f1f)
                                                        : Color(0Xffe6ecf0),
                                                border: new Border.all(
                                                  width: 0.0,
                                                  color:
                                                      const Color(0x00000000),
                                                ),
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0),
                                                boxShadow: [
                                                  new BoxShadow(
                                                    color:
                                                        const Color(0x23000000),
                                                    blurRadius: 3.0,
                                                  )
                                                ],
                                              ),

                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  talks[index][3] != ""
                                                    ? 
                                                      Image.network(
                                                        url + talks[index][3],
                                                        width: MediaQuery.of(context).size.width * 0.6,
                                                        )
                                                    : Container(),
                                                  talks[index][1] != myid ?
                                                    Container(
                                                      padding: EdgeInsets.only(left: 5, top: 5),
                                                      child: Text(talks[index][5], style: TextStyle(color: widget.syntax == Color(
                                                        0xff282828
                                                      ) ? Colors.grey : Colors.black),),
                                                      
                                                    )
                                                  :
                                                    Container(),
                                                  talks[index][2] != ""
                                                    ? 
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                          left: 6,
                                                          bottom: 6,
                                                          right: 6,
                                                          top: 2
                                                        ),
                                                        constraints: BoxConstraints(
                                                          maxWidth: MediaQuery.of(context).size.width * 0.59),
                                                          child: Text(
                                                            talks[index][2],
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontFamily:
                                                                "emoji",
                                                              fontWeight: FontWeight.w400,
                                                              height: 1.4,
                                                              color: talks[index][1] == myid
                                                                ? Colors.white
                                                                : widget.syntax == Color(0xff282828)
                                                                  ? Colors.white
                                                                  : Colors.black
                                                                ),
                                                          ),
                                                        )
                                                      : Container(),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 6,
                                                        bottom: 6,
                                                        right: 6,
                                                        top: 2),
                                                    child: Align(
                                                      alignment: talks[index][1] == myid
                                                        ? Alignment.centerLeft
                                                        : Alignment.centerRight,
                                                      child: Text(
                                                        talks[index][4],
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w100,
                                                          fontSize: 13,
                                                          color: talks[index][2] == myid
                                                              ? Colors.white
                                                              : widget.syntax == Color(0xff282828)
                                                                ? Colors.white
                                                                : Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ],
                                      )
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
                color: widget.syntax,
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
                            size: 16.0, color: widget.differBtn),
                        onPressed: () {
                          _visible = !_visible;
                          if (_visible) {
                            focusPubl.unfocus();
                          }
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
                      child: TextField(
                        controller: publ,
                        focusNode: focusPubl,
                        keyboardType: TextInputType.multiline,
                        minLines: 5,
                        maxLines: 20,
                        style: TextStyle(
                            fontSize: 13.0, color: widget.syntaxdiffer),
                        decoration: new InputDecoration(
                          hintText: 'Faça uma publicação :)',
                          hintStyle: TextStyle(color: widget.syntaxdiffer),
                          contentPadding: const EdgeInsets.all(5.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: widget.syntax == Color(0xff282828)
                                    ? Color(0xff1f1f1f)
                                    : Color(0xffe6ecf0),
                                width: 2.0),
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
                            size: 16.0, color: widget.differBtn),
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
                                          // ftGaleria();
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
                                          // ftCamera();
                                          Navigator.pop(context);
                                        },
                                        child: Text("Camera",
                                            style: TextStyle(
                                                color: widget.differBtn)),
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
                        icon: Icon(IconData(0xe9cb, fontFamily: "icomoon"),
                            size: 16.0, color: widget.differBtn),
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
                              height: 250,
                              child: DefaultTabController(
                                length: 8,
                                child: Scaffold(
                                  backgroundColor: widget.syntax,
                                  appBar: TabBar(
                                    labelColor: Colors.black,
                                    indicatorColor: vupycolor,
                                    unselectedLabelColor: Colors.grey,
                                    tabs: <Widget>[
                                      Tab(text: "😀"),
                                      Tab(text: "🐶"),
                                      Tab(text: "🥯"),
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
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
