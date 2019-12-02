import 'dart:async';

import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';

import 'settings.dart';
import 'login.dart';
import 'cadastro.dart';
import 'perfilfts.dart';
import 'privateChat.dart';
import 'comments.dart';
import 'bottomAll.dart';
import 'groupchat.dart';

const vupycolor = const Color(0xFFE7002B);
const white = const Color(0xFFFFFFFF);
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();



void main() => runApp(new MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryTextTheme: TextTheme(title: TextStyle(color: Colors.black)),
        primaryColor: Colors.black,
        accentColor: Colors.black,
        fontFamily: "Poppins",
      ),
      title: "Vupy",
      navigatorKey: navigatorKey,
      home: new MyApp(),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: routes,
    ));

Route routes(RouteSettings settings) {
  switch (settings.name) {
    case '/log':
      return PageTransition(child: MyApp(), type: PageTransitionType.upToDown);

    case '/perfilFt':
      return PageTransition(
          child: PerfilFtPage(), type: PageTransitionType.downToUp);

    case '/settings':
      return PageTransition(
          child: Settings(), type: PageTransitionType.downToUp);

    case '/privatechat':
      return PageTransition(
          child: PrivateChatVupy(), type: PageTransitionType.downToUp);

    case '/groupchat':
      return PageTransition(
          child: GroupChat(), type: PageTransitionType.downToUp);

    case '/comments':
      return PageTransition(
          child: Comments(), type: PageTransitionType.downToUp);

    case '/bottom':
      return PageTransition(
          child: MyHomePage(), type: PageTransitionType.upToDown);

    default:
      return null;
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  final email = TextEditingController();
  final nome = TextEditingController();
  final userS = TextEditingController();
  final password1 = TextEditingController();
  final password2 = TextEditingController();

  int iduser;
  String apicad;

  int _index = 0;
  PageController _pageCon;
  int inTransition = 0;

  @override
  void initState() {
    _pageCon = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void checkuser() async {
      var prefs = await SharedPreferences.getInstance();
      var key = 'userid';
      var value = prefs.getInt(key) ?? 0;
      if (value != 0) {
        Navigator.pushReplacementNamed(context, "/bottom");
      }
    }
    checkuser();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 170,
              padding: EdgeInsets.only(top: 30, bottom: 10),
              child: Column(
                children: <Widget>[
                  Image.network("https://vupytcc.pythonanywhere.com/static/img/vupylogo.png", fit: BoxFit.cover,height: 90,),
                  Text("Seja bem vindo a Vupy" ,style: TextStyle(fontSize: 23),)
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 250,
              child: PageView(
                onPageChanged: (int index) {
                  if (inTransition == 0) {
                    if (this.mounted) {
                      setState(() {
                        _index = index;
                      });
                    }
                  }
                },
                controller: _pageCon,
                children: <Widget>[
                  new Loginpage(),
                  new Createpage(),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BubbleBottomBar(
        opacity: 0.3,
        inkColor: Color(0x56F20024),
        hasInk: true,
        hasNotch: true,
        currentIndex: _index,
        onTap: (int index) {
          if (this.mounted) {
            inTransition = 1;
            setState(() {
              _index = index;
              _pageCon.animateToPage(index,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
              Timer(const Duration(milliseconds: 500), () {
                inTransition = 0;
              });
            });
          }
        },
        elevation: 8,
        iconSize: 20,
        items: [
          BubbleBottomBarItem(
              title: Text("Entrar", style: TextStyle(color: Color(0xffe7002a))),
              icon: Icon(
                IconData(0xe98e, fontFamily: 'icomoon'),
                color: Colors.grey[600],
              ),
              activeIcon: Icon(
                IconData(0xe98e, fontFamily: 'icomoon'),
                color: Color(0xffe7002a),
              ),
              backgroundColor: Color(0xffe7002a)),
          BubbleBottomBarItem(
              title:
                  Text("Cadastrar", style: TextStyle(color: Color(0xffe7002a))),
              icon: Icon(
                IconData(0xe9fe, fontFamily: 'icomoon'),
                color: Colors.grey[600],
              ),
              activeIcon: Icon(
                IconData(0xe9fe, fontFamily: 'icomoon'),
                color: Color(0xffe7002a),
              ),
              backgroundColor: Color(0xffe7002a)),
        ],
      ),
    );
  
  }
}
