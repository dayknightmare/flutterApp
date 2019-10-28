import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:vupy/comments.dart';
import 'package:vupy/widgets/url.dart';

import './heroimg.dart';

class PostCard extends StatefulWidget {
  PostCard({
    Key key,
    this.talks,
    this.index,
    this.myId,
    this.api,
    this.name,
    this.returnPage,
    this.btn,
    this.differBtn,
    this.nav,
    this.differNav,
    this.syntax,
    this.body
    })
      : super(key: key);

  final List talks;
  final int index, myId;
  final String api, name, returnPage;
  final Color btn, body;
  final Color differBtn;
  final Color nav;
  final Color differNav;
  final Color syntax;

  @override
  State createState() => _PostCard();
}

class _PostCard extends State<PostCard> {
  int index, myId, deleted = 0;
  List talks;
  String url = URL().getUrl(), api, name, returnPage;
  String ftuser = "https://vupytcc.pythonanywhere.com/static/img/user.png";
  Color vupycolor;
  Color differBtn;
  Color nav;
  Color differNav;
  Color syntax;
  Color syntaxdiffer = Colors.black;

  @override
  void initState() {
    talks = widget.talks;
    myId = widget.myId;
    index = widget.index;
    api = widget.api;
    name = widget.name;
    returnPage = widget.returnPage;
    vupycolor = widget.btn;
    differBtn = widget.differBtn;
    differNav = widget.differNav;
    nav = widget.nav;
    syntax = widget.syntax;

    if (syntax == Color(0xff282828)) {
      syntaxdiffer = Colors.white;
    }
    setState(() {});
    super.initState();
  }

  void likeMe(int index, int idpub) async {
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
    deleted = 1;

    jsona["user"] = myId;
    jsona["id"] = idPub;
    jsona["api"] = api;
    await http.post(Uri.encodeFull(url + "/workserver/delpub/"),
        body: json.encode(jsona));

    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return deleted == 0
        ? Container(
            decoration: BoxDecoration(color: syntax),
            margin: EdgeInsets.only(top: 10),
            child: Column(
              children: <Widget>[
                talks[2] != ""
                    ? GestureDetector(
                        child: Hero(
                            child: Image.network(url + talks[2]),
                            tag: "Images" + talks[0].toString() + talks[1].toString()),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return DetailScreen(
                              imageurl: url + talks[2],
                              hero: "Images" + talks[0].toString() + talks[1].toString(),
                              name: talks[5],
                            );
                          }));
                        },
                      )
                    : Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 5, top: 5),
                      child: Row(
                        children: <Widget>[
                          talks[6] != ""
                              ? Container(
                                  width: 40,
                                  height: 40,
                                  margin: const EdgeInsets.only(right: 5.0),
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Color(0x01000001)),
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
                                      border:
                                          Border.all(color: Color(0x01000001)),
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
                                                        BorderRadius.circular(
                                                            8)),
                                                child: Text(
                                                  "Sim",
                                                  style: TextStyle(
                                                      color: differBtn),
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
                                                        BorderRadius.circular(
                                                            8)),
                                                child: Text(
                                                  "Não",
                                                  style: TextStyle(
                                                      color: differBtn),
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
                                  "${talks[8]}",
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
                                  "${talks[8]}",
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
                            "${talks[10]}",
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
                                    returnPage: returnPage,
                                    btn: vupycolor,
                                    differBtn: differBtn,
                                    differNav: differNav,
                                    nav: nav,
                                    syntax: syntax,
                                    body: widget.body,
                                  ),
                                ));
                          },
                        ),
                        FlatButton.icon(
                          onPressed: () {},
                          label: Text(
                            "${talks[9]}",
                            style: TextStyle(color: syntaxdiffer),
                          ),
                          icon: Icon(
                            IconData(0xe9ce, fontFamily: 'icomoon'),
                            size: 20,
                            color: Colors.grey,
                          ),
                        )
                      ]),
                ),
              ],
            ),
          )
        : Container();
  }
}
