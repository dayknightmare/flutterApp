import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vupy/settings.dart';
import 'package:vupy/widgets/getColors.dart';
import 'package:vupy/widgets/url.dart';

import '../widgets/postCard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class Perfil extends StatefulWidget {
  Perfil({Key key, this.title}) : super(key: key);

  final String title;
  @override
  State createState() => _Perfil();
}

class _Perfil extends State<Perfil> {
  int myId, show = 0;

  String url = URL().getUrl(),
      api,
      ftuser = "https://vupytcc.pythonanywhere.com/static/img/user.png",
      capeuser,
      name = '';

  List talks = [];

  Color trueColor, trueColorBtn, bodycolor;
  Color differ = Color(0xffffffff);

  Color differBtn = Color(0xffffffff);

  Color syntax = Color(0xffffffff);
  Color syntaxdiffer = Color(0xff000000);

  bool dark = false;


  Future colorama(var prefs) async {
    if (this.mounted) {
      setState(() {
        var color = (prefs.getStringList("color") ?? ["255","255","255","1"]).toList().toString();
        var cc = jsonDecode(color);
        trueColor = Color.fromRGBO(cc[0], cc[1], cc[2], 1);

        color = (prefs.getStringList("colorbtn") ?? ["231","0","42","1"]).toList().toString();
        cc = jsonDecode(color);
        trueColorBtn = Color.fromRGBO(cc[0], cc[1], cc[2], 1);

        color = (prefs.getStringList("body") ?? ["255","255","255","1"]).toList().toString();
        cc = jsonDecode(color);
        bodycolor = Color.fromRGBO(cc[0], cc[1], cc[2], 1);
      });
    }
  }

  Future getP() async {
    var prefs = await SharedPreferences.getInstance();
    colorama(prefs);
    var jsona = {};
    myId = prefs.getInt('userid') ?? 0;
    api = prefs.getString("api") ?? '';
    jsona["user"] = myId;
    jsona["api"] = api;
    
    var r = await http.post(Uri.encodeFull(url + "/workserver/getiProfile/"),
        body: json.encode(jsona));
    var resposta = json.decode(r.body);
    if (resposta['style'][1] == null || resposta['style'][1] == "") {
      ftuser = url + "/static/img/user.png";
    } else {
      ftuser = url + "/media" + resposta['style'][1];
    }

    if (resposta['style'][0] == null || resposta['style'][0] == "") {
      capeuser = null;
    } else {
      capeuser = url + "/media" + resposta['style'][0];
    }

    if (this.mounted) {
      setState(() {
        talks = resposta['talks'];
        name = resposta['name'];
      });
    }

    Future colorsnavs = ColorsGetCustom().getColorNavAndBtn(
      resposta['navcolor'],
      trueColor,
      resposta['themecolor'],
      trueColorBtn,
      resposta['style'][5],
      resposta['style'][6],
      bodycolor
    );

    if (this.mounted) {
      setState(() {
        colorsnavs.then((response){
          trueColor = response[0];
          differ = response[1];
          trueColorBtn = response[2];
          differBtn = response[3];
          show = 1;
          if (response[4] == 1) {
            dark = true;
            syntax = Color(0xff282828);
            syntaxdiffer = Color(0xffffffff);
          }
          else{
            dark = false;
            syntax = Colors.white;
            syntaxdiffer = Colors.black;
          }
        });
      });
    }
  }

  @override
  void initState() {
    void lets() async {
      getP();
    }
    lets();
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
          semanticChildCount: talks.length,
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              title: Text("Perfil", style: TextStyle(color: differ)),
              centerTitle: true,
              backgroundColor: trueColor,
              actions: <Widget>[
                IconButton(
                  icon: Icon(IconData(0xe9cd, fontFamily: 'icomoon'),color: differ,),
                  onPressed: () async {
                    Navigator.pushReplacement(context,
                    MaterialPageRoute(
                      builder: (context) => Settings(
                        navcolor: trueColor,
                        btn: trueColorBtn,
                        dark: dark,
                        returnPage: 2,
                      )
                    ));
                  },
                ),
              ],
              leading: IconButton(
                icon: Icon(
                  IconData(0xe95d, fontFamily: 'icomoon'),
                  color: differ,
                ),
                onPressed: () async {
                  Navigator.pushNamed(context, "/perfilFt");
                },
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.width /
                            1.7777777777777777,
                        width: MediaQuery.of(context).size.width,
                        decoration: capeuser == null
                            ? BoxDecoration(
                                color: Colors.grey[200],
                              )
                            : BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(capeuser),
                                    fit: BoxFit.cover),
                              ),
                        padding: EdgeInsets.symmetric(
                            vertical: (MediaQuery.of(context).size.width /
                                        1.7777777777777777 -
                                    MediaQuery.of(context).size.width / 3) /
                                2),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 3,
                              height: MediaQuery.of(context).size.width / 3,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0, color: Color(0x01000001)),
                                  borderRadius: BorderRadius.circular(100)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(ftuser,
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    height: MediaQuery.of(context).size.width /
                                        3),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 50,
                        padding: EdgeInsets.only(top: 10),
                        width: MediaQuery.of(context).size.width,
                        color: syntax,
                        child: Text(
                          name,
                          style: new TextStyle(
                            fontSize: 19.0,
                            color: syntaxdiffer
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Divider(
                        color: Color(0X01000001),
                      ),
                    ],
                  ),
                ),
              ]),
            ),

            /* ------------- LOAD  ------------- */
            show == 0 ?
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Container(
                      color: syntax,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 300,
                      child: Image.asset("assets/load.gif")
                    );
                  },
                  childCount: 1,
                ),
              )
            :
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container();
                },
                childCount: 1,
              ),
            ),

            /* ------ POSTS ------ */

            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return PostCard(
                    talks: talks[index],
                    index: index,
                    myId: myId,
                    api: api,
                    name: name,
                    returnPage: "/perfil",
                    btn: trueColorBtn,
                    differBtn: differBtn,
                    differNav: differ,
                    nav: trueColor,
                    syntax: syntax,
                    body: bodycolor,
                  );
                },
                childCount: talks.length,
              ),
            ),
          ],
        )
      ],
    );
  }
}
