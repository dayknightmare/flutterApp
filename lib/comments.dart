import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vupy/widgets/emojis.dart';

import 'bottomAll.dart';
import 'otherperfil.dart';
import 'widgets/url.dart';

final TextEditingController commCon = TextEditingController();

class Comments extends StatefulWidget {
  Comments({
    Key key,
    this.id,
    this.name,
    this.image,
    this.myname,
    this.text,
    this.returnPage,
    this.btn,
    this.nav,
    this.differNav,
    this.differBtn,
    this.syntax,
    this.body
  })
      : super(key: key);

  final String name, image, myname, text, returnPage;
  final int id;
  final Color syntax, btn, nav, differNav, differBtn, body;

  @override
  State createState() => _Comments();
}

class Emojis extends EmojisData {
  Emojis(double media, List emojis) : super(media, emojis);

  @override
  void addEmoji(emo) {
    commCon.text += emo;
  }
}

class _Comments extends State<Comments> {
  String name, image, imageV, myname, text, api, url = URL().getUrl();
  String userDefaultImage =
          "https://vupytcc.pythonanywhere.com/static/img/user.png",
      returnPage,
      filter;

  FocusNode focusComm = FocusNode();

  int id, myId;

  List talks = [];
  List duoemojis = [];

  bool _visible = false;

  File file;

  Color vupycolor, nav, differNav, differBtn;

  void startComm() async {
    var prefs = await SharedPreferences.getInstance();
    myId = prefs.getInt('userid') ?? 0;
    api = prefs.getString("api") ?? '';

    var jsona = {};
    jsona['id'] = id;
    jsona['user'] = myId;
    jsona['api'] = api;

    var r = await http.post(Uri.encodeFull(url + "/workserver/getComments/"),
        body: json.encode(jsona));

    var resposta = jsonDecode(r.body);
    talks.addAll(resposta['resposta']);

    duoemojis =
        json.decode(await rootBundle.loadString('assets/json/finish.json'));
    if (this.mounted) {
      setState(() {});
    }
  }

  void changeFocusPubl() {
    if (focusComm.hasFocus.toString() == "true") {
      _visible = false;
      if (this.mounted) {
        setState(() {});
      }
    }
  }

  Future<bool> will() async {
    if (_visible) {
      _visible = false;
      setState(() {});
      return new Future.value(false);
    }
    return new Future.value(true);
  }

  void removeImage() {
    file = null;
    imageV = "";
    if (this.mounted) {
      setState(() {});
    }
  }

  void ftCamera() async {
    file = await ImagePicker.pickImage(source: ImageSource.camera);
    imageV = file.path;
    if (this.mounted) {
      setState(() {});
    }
  }

  void ftGaleria() async {
    file = await ImagePicker.pickImage(source: ImageSource.gallery);
    imageV = file.path;
    if (this.mounted) {
      setState(() {});
    }
  }

  void postCommentsPub() async {
    if ((commCon.text == "" || commCon.text == null) &&
        (imageV == "" || imageV == null)) {
      return;
    }

    var uri = Uri.parse(url + "/workserver/comments/");
    var request = new http.MultipartRequest("POST", uri);

    request.fields['name'] = myname;
    request.fields['user'] = myId.toString();
    request.fields['api'] = api;
    request.fields['pubid'] = id.toString();
    request.fields['msg'] = commCon.text;

    if (imageV != "" && imageV != null) {
      var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
      var length = await file.length();
      var multipartFile = new http.MultipartFile('img', stream, length,
          filename: basename(file.path));
      request.files.add(multipartFile);
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      file = null;
      imageV = "";
      commCon.text = "";

      var jsona = {};
      jsona['id'] = id;
      jsona['user'] = myId;
      jsona['api'] = api;

      var r = await http.post(Uri.encodeFull(url + "/workserver/getComments/"),
          body: json.encode(jsona));

      talks.clear();
      var resposta = jsonDecode(r.body);
      talks.addAll(resposta['resposta']);

      if (this.mounted) {
        setState(() {});
      }
    }
  }

  void changeFocus() {
    if (focusComm.hasFocus.toString() == "true") {
      _visible = false;
      if (this.mounted) {
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    name = widget.name;
    id = widget.id;
    myname = widget.myname;
    image = widget.image;
    text = widget.text;
    returnPage = widget.returnPage;
    vupycolor = widget.btn;
    differBtn = widget.differBtn;
    differNav = widget.differNav;
    nav = widget.nav;
    focusComm.addListener(changeFocus);
    startComm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Emojis emox = new Emojis(MediaQuery.of(context).size.width, duoemojis);

    return Scaffold(
      backgroundColor: widget.body,
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            semanticChildCount: talks.length,
            slivers: <Widget>[
              SliverAppBar(
                title: Text(
                  "Comentários",
                  style: TextStyle(color: differNav),
                ),
                centerTitle: true,
                backgroundColor: nav,
                leading: IconButton(
                  onPressed: () => {Navigator.pop(context)},
                  icon: Icon(
                    IconData(0xe913, fontFamily: 'icomoon'),
                    color: differNav,
                  ),
                ),
                floating: true,
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      child: Column(
                        children: <Widget>[
                          Divider(
                            color: Color(0x00000000),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                image != ""
                                    ? Container(
                                        width: 40,
                                        height: 40,
                                        margin:
                                            EdgeInsets.only(right: 6, left: 10),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 0,
                                                color: Color(0x00000000)),
                                            borderRadius:
                                                BorderRadius.circular(1000),
                                            image: DecorationImage(
                                                image:
                                                    NetworkImage(url + image),
                                                fit: BoxFit.cover)),
                                      )
                                    : Container(
                                        width: 40,
                                        height: 40,
                                        margin:
                                            EdgeInsets.only(right: 6, left: 10),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 0,
                                                color: Color(0x00000000)),
                                            borderRadius:
                                                BorderRadius.circular(1000),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    userDefaultImage),
                                                fit: BoxFit.cover)),
                                      ),
                                Text(
                                  name,
                                  style: TextStyle(fontSize: 20, color: widget.syntax == Color(0xff282828)? Colors.white : Colors.black),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Color(0x00000000),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(text, style: TextStyle(color: widget.syntax == Color(0xff282828)? Colors.white : Colors.black),),
                            ),
                          ),
                          Divider(
                            color: Color(0x00000000),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              children: <Widget>[
                                TextField(
                                    maxLines: 3,
                                    controller: commCon,
                                    focusNode: focusComm,
                                    keyboardType: TextInputType.multiline,
                                    decoration: new InputDecoration(
                                      hintText: 'Faça uma publicação :)',
                                      hintStyle: TextStyle(color: widget.syntax == Color(0xff282828) ? Colors.white : Colors.black),
                                      contentPadding:
                                          const EdgeInsets.all(15.0),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 1.5),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: widget.syntax == Color(0xff282828) ? widget.syntax : Color(0xffe6ecf0),
                                            width: 2.0),
                                      ),
                                    ),
                                    style: new TextStyle(
                                      height: 1.0,
                                      color: widget.syntax == Color(0xff282828) ? Colors.white : Colors.black
                                    )),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(right: 5),
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                color: vupycolor,
                                                border: Border.all(
                                                    color: Color(0x01000001)),
                                                borderRadius:
                                                    BorderRadius.circular(200),
                                              ),
                                              child: IconButton(
                                                icon: Icon(
                                                  IconData(0xe92b,
                                                      fontFamily: "icomoon"),
                                                  color: differBtn,
                                                  size: 18,
                                                ),
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
                                                              MaterialButton(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8)),
                                                                onPressed: () {
                                                                  ftGaleria();
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                    "Galeria"),
                                                                color:
                                                                    vupycolor,
                                                                textColor:
                                                                    differBtn,
                                                              ),
                                                              MaterialButton(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8)),
                                                                onPressed: () {
                                                                  ftCamera();
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                    "Camera"),
                                                                color:
                                                                    vupycolor,
                                                                textColor:
                                                                    differBtn,
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
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                  color: vupycolor,
                                                  border: Border.all(
                                                      color: Color(0x01000001)),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          200)),
                                              child: IconButton(
                                                highlightColor:
                                                    Color(0x0000ff00),
                                                icon: Icon(
                                                  IconData(0xe9dc,
                                                      fontFamily: "icomoon"),
                                                  color: differBtn,
                                                  size: 18,
                                                ),
                                                onPressed: () {
                                                  _visible = !_visible;
                                                  if (_visible) {
                                                    focusComm.unfocus();
                                                  }
                                                  if (this.mounted) {
                                                    setState(() {});
                                                  }
                                                },
                                                color: Color(0xff4587a6),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: MaterialButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          onPressed: () {
                                            postCommentsPub();
                                          },
                                          child: Text(
                                            "Comentar",
                                            style: TextStyle(
                                                fontSize: 15, color: differBtn),
                                          ),
                                          color: vupycolor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                imageV != null && imageV != ""
                                    ? Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              left: 10, bottom: 15),
                                          width: 120,
                                          height: 120,
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 0,
                                                    color: Color(0x01000001)),
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(20)),
                                                color: differBtn,
                                              ),
                                              width: 30,
                                              height: 30,
                                              child: GestureDetector(
                                                  onTap: () {
                                                    removeImage();
                                                  },
                                                  child: Center(
                                                    child: Text(
                                                      "X",
                                                      style: TextStyle(
                                                          color: vupycolor),
                                                    ),
                                                  )),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 0,
                                                  color: Color(0x01000001)),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                  image: FileImage(file),
                                                  fit: BoxFit.cover)),
                                        ),
                                      )
                                    : Container(),
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
                      // color: widget.syntax,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      padding: EdgeInsets.all(5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              if (talks[index][3] == myId) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyHomePage(
                                        page: 2,
                                      ),
                                    ));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OtherPerfil(
                                        idFr: talks[index][3],
                                      ),
                                    ));
                              }
                            },
                            child: talks[index][5] == ""
                                ? Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0, color: Color(0x00ffffff)),
                                        borderRadius:
                                            BorderRadius.circular(1000),
                                        image: DecorationImage(
                                            image:
                                                NetworkImage(userDefaultImage),
                                            fit: BoxFit.cover)),
                                  )
                                : Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0, color: Color(0x00ffffff)),
                                        borderRadius:
                                            BorderRadius.circular(1000),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                url + talks[index][5]),
                                            fit: BoxFit.cover)),
                                  ),
                          ),
                          Container(
                            padding: EdgeInsets.all(4),
                            // color: Color(0xfff0f0f6),
                            width: MediaQuery.of(context).size.width - 67,
                            margin: EdgeInsets.only(left: 7),
                            decoration: BoxDecoration(
                                color: widget.syntax == Color(0xff282828) ? widget.syntax : Color(0xfff0f0f6),
                                border:
                                    Border.all(width: 0, color: widget.syntax == Color(0xff282828) ? widget.syntax : Colors.white),
                                borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(talks[index][0] +
                                      " " +
                                      talks[index][4] +
                                      " comentou:", style: TextStyle(color: widget.syntax == Color(0xff282828) ? Colors.white : Colors.black),),
                                ),
                                Divider(
                                  color: Color(0x00000000),
                                ),
                                talks[index][2] != ""
                                    ? Image.network(url + talks[index][2])
                                    : Container(),
                                talks[index][2] != ""
                                    ? Divider(
                                        color: Color(0x00000000),
                                      )
                                    : Container(),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(talks[index][1], style: TextStyle(color: widget.syntax == Color(0xff282828) ? Colors.white : Colors.black),),
                                ),
                              ],
                            ),
                          )
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
                  ))
              : SizedBox(),
        ],
      ),
    );
  }
}
