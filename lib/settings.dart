import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

const vupycolor = const Color(0xFFE7002B);
const white = const Color(0xFFFFFFFF);

class Settings extends StatefulWidget {
    Settings({Key key}) : super(key: key);

    @override
    State createState() => _Settings();
}

class _Settings extends State<Settings> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: new Center(child: Text('Configurações')),
            ),
            body: Center(
                child: ButtonTheme(
                    height: 50.0,
                    minWidth: 400.0,
                    child: RaisedButton(
                        onPressed: ()async{
                            var prefs = await SharedPreferences.getInstance();
                            prefs.clear();
                            Navigator.pushReplacementNamed(context,'/log');
                        },
                        child: Text(
                            "Sair",
                            style: TextStyle(color: Colors.white)
                        ),
                        color: vupycolor,
                    )
                ),
            ),
        );
    }
}
