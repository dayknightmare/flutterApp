import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

const vupycolor = const Color(0xFFE7002B);
const white = const Color(0xFFFFFFFF);

class PerfilPage extends StatefulWidget {
    PerfilPage({Key key}) : super(key: key);

    @override
    State createState() => _PerfilPage();
}

class _PerfilPage extends State<PerfilPage> {
    int _selectedIndex = 2;
    @override
    Widget build(BuildContext context) {
        void _onItemTapped(int index) {
            if(index == 0){
                Navigator.pushReplacementNamed(context,"/vupy");
            }
        }
        return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(

                title: new Center(child: Text('Pefil')),
                backgroundColor: Colors.white,
                actions: <Widget>[
                    IconButton(
                        icon: Icon(IconData(0xe9cd,fontFamily:'icomoon'),color: Colors.black),
                        onPressed: () async {
                            var prefs = await SharedPreferences.getInstance();
                            prefs.clear();
                            Navigator.pushReplacementNamed(context,'/log');
                        },
                    ),
                ],
            ),
            body: Center(
                child: Column(
                    children: [
                        Container(
                            height: 250.0,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.grey,
                            padding: EdgeInsets.symmetric(vertical: 37.5),
                            child: Column(
                                children: <Widget>[
                                    Container(
                                        width: 175,
                                        height: 175,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(image: NetworkImage("http://201.76.95.46/media/FTU/nl6jpf6bjv.png")),
                                            border: Border.all(width: 0),
                                            borderRadius: BorderRadius.circular(100)
                                        ),
                                    ),
                                ],
                            ),
                        ),
                        Divider(color: Colors.white),
                        Text("Miguel Colombo",style: new TextStyle(
                            fontSize: 25.0,
                        )),
                        Divider(color: Colors.grey[100],),
                        Text("dsdf"),
                    ],
                ),
            ),
            bottomNavigationBar: BottomNavigationBar(
                items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(icon: Icon(IconData(0xe9cb,fontFamily:'icomoon')), title: Text('Publicações')),
                    BottomNavigationBarItem(icon: Icon(IconData(0xe997,fontFamily:'icomoon')), title: Text('Conversas')),
                    BottomNavigationBarItem(icon: Icon(IconData(0xea00,fontFamily:'icomoon')), title: Text('Perfil')),
//                    BottomNavigationBarItem(icon: Icon(IconData(0xe9cd,fontFamily:'icomoon')), title: Text('Configurações')),
                ],
                currentIndex: _selectedIndex,
                fixedColor: vupycolor,
                onTap: _onItemTapped,
            ),
        );
    }
}
