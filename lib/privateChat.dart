import 'package:flutter/widgets.dart';
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
  int id, myId;
  String name, image, api, url = "http://201.76.95.46";
  List talks = [];

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
    talks.addAll(resposta['respostaT']);
    setState(() {});
  }

  @override
  void initState() {
    id = widget.id;
    name = widget.name;
    image = widget.image;
    getP();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(IconData(0xe912, fontFamily: 'icomoon'),
              color: Colors.black),
          onPressed: () async {
            Navigator.pushNamed(context, "/chat");
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
                    height: MediaQuery.of(context).size.height * 0.7829,
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
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.32,
                                      )
                                    : EdgeInsets.only(
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.32,
                                      ),
                                margin: const EdgeInsets.only(
                                    top: 15.0, left: 5.0, right: 5.0),
                                child: Container(
                                  decoration: new BoxDecoration(
                                    color: talks[index][2] == id
                                        ? Color(0Xcc020214)
                                        : Color(0XFFececec),
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                            )
                                          : Text('',
                                              style:
                                                  new TextStyle(fontSize: 1.0)),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 6),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            talks[index][5],
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                              color: talks[index][2] == id
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 6),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            talks[index][4],
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w400,
                                              height: 1.4,
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
                              );
                            },
                            childCount: talks.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 50,
                      child: ButtonTheme(
                          height: 50,
                          child: RaisedButton(
                            shape: CircleBorder(),
                            onPressed: () {},
                            child: Align(
                              alignment: Alignment.center,
                              child: Icon(
                                  IconData(0xe9dc, fontFamily: "icomoon"),
                                  size: 20.0,
                                  color: Colors.white),
                            ),
                            color: vupycolor,
                          )),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      width: MediaQuery.of(context).size.width - 185,
                      height: 50,
                      child: TextFormField(
                        decoration: new InputDecoration(
                          hintText: 'Digite',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 50,
                      margin: EdgeInsets.only(right: 5),
                      child: ButtonTheme(
                          height: 50,
                          child: RaisedButton(
                            shape: CircleBorder(),
                            onPressed: () {},
                            child: Align(
                              alignment: Alignment.center,
                              child: Icon(
                                  IconData(0xe92b, fontFamily: "icomoon"),
                                  size: 20.0,
                                  color: Colors.white),
                            ),
                            color: vupycolor,
                          )),
                    ),
                    Container(
                      width: 50,
                      child: ButtonTheme(
                          height: 50,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            onPressed: () {},
                            child: Align(
                              alignment: Alignment.center,
                              child: Icon(
                                  IconData(0xe9cb, fontFamily: "icomoon"),
                                  size: 20.0,
                                  color: Colors.white),
                            ),
                            color: vupycolor,
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
