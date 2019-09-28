import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:vupy/widgets/getColors.dart';
import 'package:vupy/widgets/url.dart';

import 'dart:convert';
import '../otherperfil.dart';
import '../privateChat.dart';
import '../settings.dart';

class ChatVupy extends StatefulWidget {
  @override
  State createState() => _ChatVupy();
}

class _ChatVupy extends State<ChatVupy> {
  int myId, ids;
  String api, url = URL().getUrl();
  List friends = [];
  Color trueColor;
  Color differ = Color(0xffffffff);
  Color differBtn = Color(0xffffffff);
  Color vupycolor = Color(0xffe7002a);

  void getP() async {
    var prefs = await SharedPreferences.getInstance();
    myId = prefs.getInt('userid') ?? 0;
    api = prefs.getString("api") ?? '';

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
      });
    }

    var jsona = {};
    jsona["user"] = myId;
    jsona["api"] = api;
    var r = await http.post(Uri.encodeFull(url + "/workserver/gmf/"),
        body: json.encode(jsona));
    var resposta = json.decode(r.body);
    friends.addAll(resposta['resposta']);

    Future colorsnav = ColorsGetCustom().getColorNavAndBtn(
        resposta['navcolor'], trueColor, resposta['themecolor'], vupycolor);

    colorsnav.then((response) {
      trueColor = response[0];
      differ = response[1];
      vupycolor = response[2];
      differBtn = response[3];
    });

    if (this.mounted) {
      setState(() {});
    }
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
              title: Text(
                'Conversas',
                style: TextStyle(color: differ),
              ),
              backgroundColor: trueColor,
              centerTitle: true,
              leading: Container(),
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
                          returnPage: 1
                        )
                      )
                    );
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
                        backgroundColor: Colors.white,
                      ),
                      trailing: Container(
                        decoration: BoxDecoration(
                          // color: vupycolor,
                          border: Border.all(
                            color: Color(0x01000001)
                          ),
                          borderRadius: BorderRadius.circular(200)
                        ),
                        child: IconButton(
                          color: Colors.blueGrey,
                          icon: Icon(IconData(0xea00, fontFamily: 'icomoon'),size: 26,),
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
                      ),
                      title: Text(friends[index][1]),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PrivateChatVupy(
                              id: friends[index][0],
                              name: friends[index][1],
                              image: friends[index][2],
                              nav: trueColor,
                              differNav: differ,
                              differBtn: differBtn,
                              btn: vupycolor,
                            ),
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
