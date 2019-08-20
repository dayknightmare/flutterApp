import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'dart:convert';
import '../privateChat.dart';

const vupycolor = const Color(0xFFE7002B);

class ChatVupy extends StatefulWidget {
  @override
  State createState() => _ChatVupy();
}

class _ChatVupy extends State<ChatVupy> {
  int _selectedIndex = 1, myId, ids;
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
    void _onItemTapped(int index) {
      if (index == 2) {
        Navigator.pushReplacementNamed(context, "/perfil");
      }
      if (index == 0) {
        Navigator.pushReplacementNamed(context, "/vupy");
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Conversas'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Color(0Xffffffff),
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            semanticChildCount: friends.length,
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Container(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(url + friends[index][2]),
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
          // BottomNavigationBarItem(icon: Icon(IconData(0xe9cd,fontFamily:'icomoon')), title: Text('Configurações')),
        ],
        backgroundColor: Color(0xffffffff),

        currentIndex: _selectedIndex,
        fixedColor: vupycolor,
        onTap: _onItemTapped,
      ),
    );
  }
}
