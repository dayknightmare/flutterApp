import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:vupy/comments.dart';

const vupycolor = Color(0xffe7002a);

class PostCard extends StatefulWidget {
  PostCard(
      {Key key,
      this.talks,
      this.index,
      this.myId,
      this.api,
      this.name,
      this.returnPage})
      : super(key: key);

  final List talks;
  final int index, myId;
  final String api, name, returnPage;

  @override
  State createState() => _PostCard();
}

class _PostCard extends State<PostCard> {
  int index, myId, deleted = 0;
  List talks;
  String url = "http://179.233.213.76", api, name, returnPage;

  @override
  void initState() {
    talks = widget.talks;
    myId = widget.myId;
    index = widget.index;
    api = widget.api;
    name = widget.name;
    returnPage = widget.returnPage;
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
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return deleted == 0 ? 
      Container(
        decoration: new BoxDecoration(
          color: Colors.white,
          border: new Border.all(
            width: 0.0,
            color: const Color(0x00000000),
          ),
          borderRadius: new BorderRadius.circular(5.0),
          boxShadow: [
            new BoxShadow(
              color: const Color(0x23000000),
              blurRadius: 4.0,
            )
          ],
        ),
        margin: const EdgeInsets.only(top: 10.0),
        child: Column(
          children: [
            talks[2] != ""
                ? Image.network(url + talks[2])
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
                              talks[6] != ""
                                  ? Container(
                                      margin: const EdgeInsets.only(right: 5.0),
                                      child: new ClipRRect(
                                        borderRadius:
                                            new BorderRadius.circular(50.0),
                                        child: Image.network(
                                          url + talks[6],
                                          height: 40.0,
                                          width: 40.0,
                                        ),
                                      ))
                                  : Text(''),
                              Text(talks[5],
                                  style: new TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                  )),
                            ],
                          ),
                        ),
                        talks[1] == myId
                            ? GestureDetector(
                                onTap: () {
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
                                              ButtonTheme(
                                                  child: RaisedButton(
                                                onPressed: () {
                                                  deletePub(talks[0], index);
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Sim",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFFFFFFFF))),
                                                color: vupycolor,
                                              )),
                                              ButtonTheme(
                                                  child: RaisedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Não",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFFFFFFFF))),
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
                                  padding: new EdgeInsets.all(5.0),
                                  margin: const EdgeInsets.only(right: 5.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("X"),
                                  ),
                                ),
                              )
                            : Text('', style: new TextStyle(fontSize: 1.0)),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: talks[6] != ""
                        ? Container(
                            margin: const EdgeInsets.only(left: 45.0),
                            child: Text(talks[4]),
                          )
                        : Container(
                            margin: const EdgeInsets.only(left: 0.0),
                            child: Text(talks[4]),
                          ),
                  ),
                  Divider(color: Color(0x00FFFFFF)),
                  Container(
                    margin: const EdgeInsets.only(top: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: talks[3] != ""
                          ? Text(talks[3])
                          : Text('', style: new TextStyle(fontSize: 1.0)),
                    ),
                  ),
                  Divider(color: Color(0xFFd2d2d2)),
                  Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          talks[7] == 0
                              ? GestureDetector(
                                  onTap: () async {
                                    talks[7] = 1;
                                    likeMe(index, talks[0]);
                                  },
                                  child: Icon(
                                      IconData(0xe97c, fontFamily: 'icomoon'),
                                      size: 20,color: Colors.grey))
                              : GestureDetector(
                                  onTap: () async {
                                    talks[7] = 0;
                                    likeMe(index, talks[0]);
                                  },
                                  child: new IconTheme(
                                    data: new IconThemeData(color: vupycolor),
                                    child: Icon(
                                        IconData(0xe900, fontFamily: 'icomoon'),
                                        size: 20),
                                  ),
                                ),
                          GestureDetector(
                            onTap: () async {
                              // Navigator.pushReplacement(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => Comments(
                              //       id: talks[0],
                              //       name: talks[5],
                              //       image: talks[6],
                              //       myname: name,
                              //       text: talks[3],
                              //       returnPage: returnPage,
                              //     ),
                              //   ),
                              // );
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => Comments(
                                    id: talks[0],
                                    name: talks[5],
                                    image: talks[6],
                                    myname: name,
                                    text: talks[3],
                                    returnPage: returnPage,
                                  ),
                                )
                              );
                            },
                            child: Icon(IconData(0xe998, fontFamily: 'icomoon'),
                                size: 20,color: Colors.grey),
                          ),
                          Icon(IconData(0xe9ce, fontFamily: 'icomoon'), size: 20, color: Colors.grey,),
                        ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    :
      Container();
  }
}
