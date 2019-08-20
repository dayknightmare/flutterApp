import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'dart:convert';
import '../otherperfil.dart';
import '../privateChat.dart';

const vupycolor = const Color(0xFFE7002B);

class ChatVupy extends StatefulWidget {
  @override
  State createState() => _ChatVupy();
}

class _ChatVupy extends State<ChatVupy> {
  int myId, ids;
  String api, url = "http://179.233.213.76";
  List friends = [];

  void getP() async {
    var prefs = await SharedPreferences.getInstance();
    myId = prefs.getInt('userid') ?? 0;
    api = prefs.getString("api") ?? '';
    var jsona = {};
    jsona["user"] = myId;
    jsona["api"] = api;
    var r = await http.post(Uri.encodeFull(url + "/workserver/gmf/"),
        body: json.encode(jsona));
    var resposta = json.decode(r.body);
    friends.addAll(resposta['resposta']);
    setState(() {});
  }

  @override
  void initState() {
    getP();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CustomScrollView(
          semanticChildCount: friends.length,
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              title: Text('Conversas'),
              backgroundColor: Colors.white,
              centerTitle: true,
              leading: Container(),
              actions: <Widget>[
                IconButton(
                  icon: Icon(IconData(0xe98f, fontFamily: 'icomoon'),
                      color: Colors.black),
                  onPressed: () async {
                    var prefs = await SharedPreferences.getInstance();
                    prefs.clear();
                    Navigator.pushReplacementNamed(context, '/log');
                  },
                ),
              ],
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    color: Colors.white,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(url + friends[index][2]),
                      ),
                      trailing: IconButton(
                        color: vupycolor,
                        icon: Icon(IconData(0xea00, fontFamily: 'icomoon')),
                        onPressed: () {
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OtherPerfil(
                                      idFr: friends[index][0],
                                    ),
                                  ));
                        },
                      ),
                      title: Text(friends[index][1]),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PrivateChatVupy(
                                id: friends[index][0],
                                name: friends[index][1],
                                image: friends[index][2]),
                          ),
                        );
                      },
                    ),
                  );
                },
                childCount: friends.length,
              ),
            ),
          ],
        )
      ],
    );
  }
}
