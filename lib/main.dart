import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';

// import 'home.dart';
// import 'perfil.dart';
import 'settings.dart';
import 'login.dart';
import 'cadastro.dart';
import 'perfilfts.dart';
// import 'chat.dart';
import 'privateChat.dart';
import 'comments.dart';
import 'bottomAll.dart';

const vupycolor = const Color(0xFFE7002B);
const white = const Color(0xFFFFFFFF);

void main() => runApp(new MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryTextTheme: TextTheme(title: TextStyle(color: Colors.black)),
        primaryColor: Colors.black,
        accentColor: vupycolor,
      ),
      home: new MyApp(),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: routes,
    ));

Route routes(RouteSettings settings) {
  switch (settings.name) {
    case '/log':
      return PageTransition(
          child: MyApp(), type: PageTransitionType.upToDown);

    // case '/vupy':
    //   return PageTransition(
    //       child: HomePageVupy(), type: PageTransitionType.rightToLeftWithFade);

    case '/perfilFt':
      return PageTransition(
          child: PerfilFtPage(), type: PageTransitionType.downToUp);

    case '/settings':
      return PageTransition(
          child: Settings(), type: PageTransitionType.downToUp);

    // case '/perfil':
    //   return PageTransition(
    //       child: PerfilPage(), type: PageTransitionType.leftToRightWithFade);

    // case '/chat':
    //   return PageTransition(
    //       child: ChatVupy(), type: PageTransitionType.leftToRightWithFade);

    case '/privatechat':
      return PageTransition(
          child: PrivateChatVupy(), type: PageTransitionType.downToUp);

    case '/comments':
      return PageTransition(
          child: Comments(), type: PageTransitionType.downToUp);
  
    case '/bottom':
      return PageTransition(
        child: MyHomePage(), type: PageTransitionType.upToDown
      );

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

  @override
  Widget build(BuildContext context) {
    void checkuser() async {
      var prefs = await SharedPreferences.getInstance();
      var key = 'userid';
      var value = prefs.getInt(key) ?? 0;
      print(value);
      if (value != 0) {
        Navigator.pushReplacementNamed(context, "/bottom");
      }
    }

    checkuser();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          bottom: new TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: "LOGIN"),
              Tab(text: "CADASTRO"),
            ],
          ),
          centerTitle: true,
          title: Text('Vupy'),
          backgroundColor: white,
        ),
        body: TabBarView(
          children: [
            new Loginpage(),
            new Createpage(),
          ],
        ),
      ),
    );
  }
}
