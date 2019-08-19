import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottomWidgets/perfil.dart';
import 'bottomWidgets/chat.dart';
import 'bottomWidgets/home.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final opts = [
    HomePageVupy(),
    ChatVupy(),
    Perfil(),
  ];

  @override
  Widget build(BuildContext context) {
    final bars = [
      homeBar("Publicações", context),
      simpleBar("Conversas", context),
      perfilBar("Perfil", context)
    ];
    return Scaffold(
      backgroundColor: Color(0Xffe6ecf0),
      appBar: bars[_selectedIndex],
      body: Center(
        child: opts.elementAt(_selectedIndex),
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
        ],
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        fixedColor: Color(0xffe7002a),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class LowerTextTitle extends StatefulWidget {
  LowerTextTitle({Key key, this.title}) : super(key: key);

  final String title;
  @override
  State createState() => _LowerTextTitle();
}

class _LowerTextTitle extends State<LowerTextTitle> {
  @override
  void dispose() {
    print("object");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(widget.title);
  }
}

Widget simpleBar(title, context) {
  return AppBar(
    title: Text('Conversas'),
    backgroundColor: Colors.white,
    centerTitle: true,
    leading: Container(),
    actions: <Widget>[
      IconButton(
        icon:
            Icon(IconData(0xe98f, fontFamily: 'icomoon'), color: Colors.black),
        onPressed: () async {
          var prefs = await SharedPreferences.getInstance();
          prefs.clear();
          Navigator.pushReplacementNamed(context, '/log');
        },
      ),
    ],

  );
}

Widget perfilBar(title, context) {
  return AppBar(
    title: Text(title),
    centerTitle: true,
    backgroundColor: Colors.white,
    actions: <Widget>[
      IconButton(
        icon:
            Icon(IconData(0xe98f, fontFamily: 'icomoon'), color: Colors.black),
        onPressed: () async {
          var prefs = await SharedPreferences.getInstance();
          prefs.clear();
          Navigator.pushReplacementNamed(context, '/log');
        },
      ),
    ],
    leading: IconButton(
      icon: Icon(IconData(0xe95d, fontFamily: 'icomoon'), color: Colors.black),
      onPressed: () async {
        Navigator.pushNamed(context, "/perfilFt");
      },
    ),
  );
}

Widget homeBar(title, context) {
  return AppBar(
    title: Text('Publicações'),
    backgroundColor: Colors.white,
    centerTitle: true,
    actions: <Widget>[
      IconButton(
        icon:
            Icon(IconData(0xe98f, fontFamily: 'icomoon'), color: Colors.black),
        onPressed: () async {
          var prefs = await SharedPreferences.getInstance();
          prefs.clear();
          Navigator.pushReplacementNamed(context, '/log');
        },
      ),
    ],
    leading: Container(),
  );
}
