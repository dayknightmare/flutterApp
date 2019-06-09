import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'dart:convert';


const vupycolor = const Color(0xFFE7002B);


class ChatVupy extends StatefulWidget {
  @override
  State createState() => _ChatVupy();
}

class _ChatVupy extends State<ChatVupy>{

  int _selectedIndex = 1, myId, ids;
  String api, url = "http://201.76.95.46";
	List friends = [];


  void getP() async {
    var prefs = await SharedPreferences.getInstance();
		myId = prefs.getInt('userid') ?? 0;
		api = prefs.getString("api") ?? '';
    var jsona = {};
    jsona["user"] = myId;
		jsona["api"] = api;
		var r = await http.post(Uri.encodeFull(url+"/workserver/gmf/"),body:json.encode(jsona));
		var resposta = json.decode(r.body);
    print(resposta);
    friends.addAll(resposta['resposta']);
  }

  @override
	void initState(){
		void lets() async {
			getP();
		}
		lets();
		super.initState();
	}

  @override
  Widget build(BuildContext context) {

    void _onItemTapped(int index) {
      if (index == 2) {
        Navigator.pushReplacementNamed(context, "/perfil");
      }
      if (index == 0) {
          Navigator.pushReplacementNamed(context, "/vupy");
        }
      }

    return Scaffold(
      appBar: AppBar(
        title: Text('Publicações'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Text("srsds"),
      ),
      bottomNavigationBar: BottomNavigationBar(
				items: <BottomNavigationBarItem>[
					BottomNavigationBarItem(icon: Icon(IconData(0xe9cb,fontFamily:'icomoon')), title: Text('Publicações')),
					BottomNavigationBarItem(icon: Icon(IconData(0xe997,fontFamily:'icomoon')), title: Text('Conversas')),
					BottomNavigationBarItem(icon: Icon(IconData(0xea00,fontFamily:'icomoon')), title: Text('Perfil')),
          // BottomNavigationBarItem(icon: Icon(IconData(0xe9cd,fontFamily:'icomoon')), title: Text('Configurações')),
				],
				currentIndex: _selectedIndex,
				fixedColor: vupycolor,
				onTap: _onItemTapped,
			),
    );
  }
}