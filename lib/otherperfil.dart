import 'dart:convert';
import 'package:http/http.dart' as http;

import './widgets/postCard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class OtherPerfil extends StatefulWidget {
  OtherPerfil({Key key, this.idFr}) : super(key: key);

  final int idFr;
  @override
  State createState() => _OtherPerfil();
}

class _OtherPerfil extends State<OtherPerfil> {
  int myId;
  String url = "http://179.233.213.76",
      api,
      ftuser = "https://vupytcc.pythonanywhere.com/static/img/user.png",
      capeuser,
      name = '',
      myname;
  List talks = [];

  void getP() async {
    var jsona = {};
    var prefs = await SharedPreferences.getInstance();

    myId = prefs.getInt('userid') ?? 0;
    api = prefs.getString("api") ?? '';

    jsona["user"] = myId;
    jsona["api"] = api;
    jsona["guy"] = widget.idFr;

    var r = await http.post(Uri.encodeFull(url + "/workserver/getiOtherProfile/"),
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
    talks = resposta['talks'];
    name = resposta['name'];
    myname = resposta['myname'];

    setState(() {});
  }

  @override
  void initState() {
    print("object2");
    void lets() async {
      getP();
    }

    lets();
    super.initState();
  }

  @override
  void dispose() {
    print("object");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            semanticChildCount: talks.length,
            slivers: <Widget>[
              SliverAppBar(
                floating: true,
                title: Text(name),
                centerTitle: true,
                backgroundColor: Colors.white,
                leading: IconButton(
                  icon: Icon(
                    IconData(0xe913, fontFamily: 'icomoon'),
                    color: Colors.black,
                  ),
                  onPressed: (){
                    Navigator.pop(context);
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
                                      MediaQuery.of(context).size.width / 2.4) /
                                  2),
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width / 2.4,
                                height: MediaQuery.of(context).size.width / 2.4,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 0, color: Color(0x01000001)),
                                    borderRadius: BorderRadius.circular(100)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.network(ftuser,
                                      width: MediaQuery.of(context).size.width /
                                          2.4,
                                      height:
                                          MediaQuery.of(context).size.width /
                                              2.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 50,
                          padding: EdgeInsets.only(top: 10),
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          child: Text(
                            name,
                            style: new TextStyle(
                              fontSize: 25.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Divider(
                          color: Color(0Xffe6ecf0),
                        ),
                      ],
                    ),
                  ),
                ]),
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
                      name: myname,
                      returnPage: "/perfil",
                    );
                  },
                  childCount: talks.length,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
