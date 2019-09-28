import 'dart:async';
import 'dart:convert';

import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottomWidgets/perfil.dart';
import 'bottomWidgets/chat.dart';
import 'bottomWidgets/home.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.page = 0}) : super(key: key);

  final int page;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0, inTransition = 0;
  PageController _pageCon;
  Color colorB = Color(0xffffffff);

  void gets() async {
    var prefs = await SharedPreferences.getInstance();
    var color = prefs.getStringList("colorbtn") ?? ["231", "0", "42", "1"];

    color = color.toList();
    var cc = jsonDecode(color.toString());
    colorB = Color.fromRGBO(cc[0], cc[1], cc[2], 1);
    inTransition = 1;
    _pageCon.animateToPage(widget.page,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);

    Timer(Duration(milliseconds: 500), () {
      inTransition = 0;
    });

    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    _pageCon = PageController();
    _selectedIndex = widget.page;
    gets();
    super.initState();
  }

  @override
  void dispose() {
    _pageCon.dispose();
    super.dispose();
  }

  void changePage(int index) {
    inTransition = 1;
    if (this.mounted) {
      setState(() {
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

  void changePageView(int index) {
    if (this.mounted) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  final opts = [
    HomePageVupy(),
    ChatVupy(),
    Perfil(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0Xffe6ecf0),
      body: PageView(
        onPageChanged: (int index) {
          if (inTransition == 0) {
            changePageView(index);
          }
        },
        controller: _pageCon,
        children: <Widget>[
          Center(
            child: opts.elementAt(0),
          ),
          Center(
            child: opts.elementAt(1),
          ),
          Center(
            child: opts.elementAt(2),
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
