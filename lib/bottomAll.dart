import 'dart:async';
import 'dart:convert';

import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vupy/widgets/getColors.dart';
import 'package:vupy/widgets/url.dart';

import 'bottomWidgets/perfil.dart';
import 'bottomWidgets/chat.dart';
import 'bottomWidgets/home.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.page = 0}) : super(key: key);

  final int page;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{
  int _selectedIndex = 0, inTransition = 0;
  PageController _pageCon;
  Color bodycolor, nav = Color(0xffffffff);
  Color colorB = Color(0xffffffff);
  Color syntax = Color(0xffffffff);
  Color syntaxdark = Color(0xff000000);
  Color syntaxdiffer = Colors.black;
  Color differ = Color(0xff000000);
  Color differBtn = Colors.white;
  List opts = [];
  List optsPages = [];
  bool dark = false;

  String url = URL().getUrl();

  PageStorageBucket _bucket;
  PageStorageKey keygem = new PageStorageKey("vupist");

  HomePageVupy homes = new HomePageVupy();
  ChatVupy chat = new ChatVupy();

  Future styles () async {
    var prefs = await SharedPreferences.getInstance();

    var color = prefs.getStringList("colorbtn") ?? ["231", "0", "42", "1"];

    color = color.toList();
    var cc = jsonDecode(color.toString());
    colorB = Color.fromRGBO(cc[0], cc[1], cc[2], 1);

    color = prefs.getStringList("body") ?? ["230", "236", "240", "1"];
    color = color.toList();
    cc = jsonDecode(color.toString());
    bodycolor = Color.fromRGBO(cc[0], cc[1], cc[2], 1);

    color = prefs.getStringList("color") ?? ["255", "255", "255", "1"];
    color = color.toList();
    cc = jsonDecode(color.toString());
    nav = Color.fromRGBO(cc[0], cc[1], cc[2], 1);

    var jsona = {};

    jsona['user'] = prefs.getInt("userid") ?? 0;
    jsona['api'] = prefs.getString("api") ?? '';

    var r = await http.post(Uri.encodeFull(url + '/workserver/gstt/'),
          body: json.encode(jsona));
    var resposta = json.decode(r.body);

    await onlinecolors(resposta);
  }

  Future onlinecolors(var resposta) async {
    Future colorsnav = ColorsGetCustom().getColorNavAndBtn(
      resposta['navcolor'],
      nav, 
      resposta['themecolor'], 
      colorB, 
      resposta['dark'],
      resposta['bodycolor'],
      bodycolor
    );
    if (this.mounted) {
      setState(() {
        colorsnav.then((response) {
          nav = response[0];
          differ = response[1];
          colorB = response[2];
          differBtn = response[3];
          bodycolor = response[5];
          if (response[4] == 1) {
            syntax = Color(0xff282828);
            syntaxdiffer = Color(0xffffffff);
            syntaxdark = Color(0xff1f1f1f);
            dark = true;
          }
          else{
            syntax = Colors.white;
            syntaxdark = Colors.black;
            syntaxdiffer = Colors.black;
            dark = false;
          }
        });
      });
    }
  }

  Future gets() async {
    await styles();
    inTransition = 1;
    print("sa");
    // _pageCon.animateToPage(widget.page,
    //     duration: Duration(milliseconds: 500), curve: Curves.easeInOut);

    Timer(Duration(milliseconds: 500), () {
      inTransition = 0;
    });
  }

  @override
  void initState() {
    _pageCon = PageController();
    _selectedIndex = widget.page;

    optsPages = [
      homes,
      chat,
      new Perfil(),
    ];
    gets();
    if (widget.page != 0) {
      homes.stopgnp();
    }
    
    super.initState();
  }

  @override
  void dispose() {
    _pageCon.dispose();
    super.dispose();
  }


  Widget readkeygempages(){
    return _bucket.readState(context, identifier: ValueKey(keygem));
  }

  Future changePage(int index) async {
    inTransition = 1;
    if (this.mounted) {
      await styles();
      setState(() {
        if (index == 0 && _selectedIndex != index) {
          homes.ungnp(dark, nav, colorB);
        }
        else{
          if (index == 1) {
            chat.styles(dark, nav, colorB);
          }
          if (_selectedIndex != index) {
            homes.stopgnp();
          }
        }
        _selectedIndex = index;
        _pageCon.animateToPage(index,
            duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      });
    }
    Timer(const Duration(milliseconds: 500), () {
      inTransition = 0;
    });
    // inTransition = 0;
  }

  void changePageView(int index) async {
    if (this.mounted) {
      await styles();
      setState(() {
        if (index == 0) {
          homes.ungnp(dark, nav, colorB);
        }
        else{
          homes.stopgnp();
          if (index == 1) {
            chat.styles(dark, nav, colorB);
          }
        }
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodycolor,
      body: PageView(
        onPageChanged: (int index) {
          if (inTransition == 0) {
            changePageView(index);
          }
        },
        controller: _pageCon,
        children: <Widget>[
          Center(
            child: optsPages.elementAt(0),
          ),
          Center(
            child: optsPages.elementAt(1),
          ),
          Center(
            child: optsPages.elementAt(2),
          ),
        ],
      ),
      bottomNavigationBar: BubbleBottomBar(
        opacity: 0.3,
        inkColor: Color(0x56F20024),
        hasInk: true,
        hasNotch: true,
        currentIndex: _selectedIndex,
        onTap: (int index) {
          changePage(index);
        },
        backgroundColor: syntax,
        elevation: 8,
        iconSize: 20,
        items: [
          BubbleBottomBarItem(
              title: Text("Publicações",
                  style: TextStyle(color: colorB)),
              icon: Icon(
                IconData(0xe9cb, fontFamily: 'icomoon'),
                color: Colors.grey[600],
              ),
              activeIcon: Icon(
                IconData(0xe9cb, fontFamily: 'icomoon'),
                color: colorB,
              ),
              backgroundColor: colorB),
          BubbleBottomBarItem(
              title:
                  Text("Conversas", style: TextStyle(color: colorB)),
              icon: Icon(
                IconData(0xe997, fontFamily: 'icomoon'),
                color: Colors.grey[600],
              ),
              activeIcon: Icon(
                IconData(0xe997, fontFamily: 'icomoon'),
                color: colorB,
              ),
              backgroundColor: colorB),
          BubbleBottomBarItem(
              title: Text("Perfil", style: TextStyle(color: colorB)),
              icon: Icon(
                IconData(0xea00, fontFamily: 'icomoon'),
                color: Colors.grey[600],
              ),
              activeIcon: Icon(
                IconData(0xea00, fontFamily: 'icomoon'),
                color: colorB,
              ),
              backgroundColor: colorB),
        ],
      ),
    );
  }
}
