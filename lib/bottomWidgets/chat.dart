import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:vupy/groupchat.dart';
import 'package:vupy/widgets/getColors.dart';
import 'package:vupy/widgets/url.dart';

import 'dart:convert';
import '../otherperfil.dart';
import '../privateChat.dart';
import '../settings.dart';

class ChatVupy extends StatefulWidget {
  final _ChatVupy chat = new _ChatVupy();

  void styles(dark, nav, colorB) {
    chat.styles(dark, nav, colorB);
  }

  @override
  State createState() => chat;
}

class _ChatVupy extends State<ChatVupy> with AutomaticKeepAliveClientMixin {
  int myId, ids, show = 0, experince = 0;
  String api, url = URL().getUrl();
  List friends = [];
  Color trueColor, bodycolor;
  Color differ = Color(0xffffffff);
  Color differBtn = Color(0xffffffff);
  Color vupycolor = Color(0xffe7002a);
  Color syntax = Color(0xffffffff);
  Color syntaxdiffer = Color(0xff000000);
  bool dark;

  Future styles(darkx, nav, btn) async {
    if (experince == 0) {
      experince = 1;
      return;
    }

    if (this.mounted) {
      setState(() {
        dark = darkx;
        trueColor = nav;
        vupycolor = btn;
        show = 1;

        if (trueColor.computeLuminance() > 0.673) {
          differ = Colors.black;
        } else {
          differ = Colors.white;
        }
        if (vupycolor.computeLuminance() > 0.673) {
          differBtn = Colors.black;
        } else {
          differBtn = Colors.white;
        }

        if (dark == true) {
          syntax = Color(0xff282828);
          syntaxdiffer = Color(0xffffffff);
        } else {
          syntax = Colors.white;
          syntaxdiffer = Colors.black;
        }
      });
    }
  }

  @override
  bool get wantKeepAlive => true;

  void onlinecolors(resposta) {
    Future colorsnav = ColorsGetCustom().getColorNavAndBtn(
        resposta['navcolor'],
        trueColor,
        resposta['themecolor'],
        vupycolor,
        resposta['dark'],
        resposta['bodycolor'],
        bodycolor);
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
            dark = true;
          } else {
            syntax = Colors.white;
            syntaxdiffer = Colors.black;
            dark = false;
          }
        });
      });
    }
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
        bodycolor = Color.fromRGBO(cc[0], cc[1], cc[2], 1);
      });
    }
  }

  void getP() async {
    var prefs = await SharedPreferences.getInstance();
    colorama(prefs);
    myId = prefs.getInt('userid') ?? 0;
    api = prefs.getString("api") ?? '';

    var jsona = {};

    jsona["user"] = myId;
    jsona["api"] = api;

    var r = await http.post(Uri.encodeFull(url + "/workserver/gmf/"),
        body: json.encode(jsona));

    var resposta = json.decode(r.body);

    if (this.mounted) {
      setState(() {
        friends.addAll(resposta['resposta']);
      });
    }

    onlinecolors(resposta);
    show = 1;
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
    super.build(context);

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
                                dark: dark,
                                returnPage: 1)));
                  },
                ),
              ],
            ),

            /* ------------- LOAD  ------------- */
            show == 0
                ? SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Container(
                            color: syntax,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
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
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    color: syntax,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: friends[index][2]
                                    .contains("/media/") ||
                                friends[index][2].contains("/static/")
                            ? NetworkImage(url + friends[index][2])
                            : friends[index][2] != ''
                                ? NetworkImage(
                                    url + "/media" + friends[index][2])
                                : NetworkImage(url + "/static/img/user.png"),
                        backgroundColor: syntax,
                      ),
                      trailing: friends[index][3] == -1
                          ? Container(
                              decoration: BoxDecoration(
                                  // color: vupycolor,
                                  border: Border.all(color: Color(0x01000001)),
                                  borderRadius: BorderRadius.circular(200)),
                              child: IconButton(
                                color: syntax == Color(0xff282828)
                                    ? syntaxdiffer
                                    : Colors.blueGrey,
                                icon: Icon(
                                  IconData(0xea00, fontFamily: 'icomoon'),
                                  size: 26,
                                ),
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
                            )
                          : Text(""),
                      title: Text(
                        friends[index][1],
                        style: TextStyle(color: syntaxdiffer),
                      ),
                      onTap: () {
                        friends[index][3] == -1
                        ? Navigator.push(
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
                                syntax: syntax,
                                syntaxdiffer: syntaxdiffer,
                              ),
                            ),
                          )
                        : Navigator.push(context, MaterialPageRoute(
                            builder: (context) => GroupChat(
                              id: friends[index][0],
                              name: friends[index][1],
                              image: friends[index][2],
                              nav: trueColor,
                              differNav: differ,
                              differBtn: differBtn,
                              btn: vupycolor,
                              syntax: syntax,
                              syntaxdiffer: syntaxdiffer,
                            )
                          )
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
