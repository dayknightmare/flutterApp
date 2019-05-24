import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

const vupycolor = const Color(0xFFE7002B);
const white = const Color(0xFFFFFFFF);

class PerfilPage extends StatefulWidget {
	PerfilPage({Key key}) : super(key: key);

	@override
	State createState() => _PerfilPage();
}

class _PerfilPage extends State<PerfilPage> {

	int _selectedIndex = 2, myId;
	String api, ftuser = "http://201.76.95.46/static/img/user.png", capeuser, name = '';
	List talks = [];

	void deletePub(idPub,index) async{
		print(index);
        talks.removeAt(index);
        var jsona = {};
        jsona["user"] = myId;
        jsona["id"] = idPub;
        jsona["api"] = api;
        await http.post(Uri.encodeFull("http://201.76.95.46:80/workserver/delpub/"),body:json.encode(jsona));
		setState(() {});
    }

	void getP() async {

		var jsona = {};

		var prefs = await SharedPreferences.getInstance();
		myId = prefs.getInt('userid') ?? 0;
		api = prefs.getString("api") ?? '';

		jsona["user"] = myId;
		jsona["api"] = api;


		var r = await http.post(Uri.encodeFull("http://201.76.95.46:80/workserver/getiProfile/"),body:json.encode(jsona));
		
		var resposta = json.decode(r.body);
		if(resposta['style'][1] == null || resposta['style'][1] == ""){
			ftuser = "http://201.76.95.46/static/img/user.png";
		}
		else{
			ftuser = "http://201.76.95.46:80/media" + resposta['style'][1];
		}

		if(resposta['style'][0] == null || resposta['style'][0] == ""){
			capeuser = null;
		}
		else{
			capeuser = "http://201.76.95.46:80/media" + resposta['style'][0];
		}
		talks = resposta['talks'];
		name = resposta['name'];
		setState(() {});
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
			body: Stack(
				children: <Widget>[
					CustomScrollView(
						semanticChildCount: talks.length,
						slivers: <Widget>[
							SliverList(
								delegate: SliverChildListDelegate([
									Container(
										child: Column(
											children: [
												Container(
													height: 280.0,
													width: MediaQuery.of(context).size.width,			
													decoration: capeuser == null ? BoxDecoration(
														color: Colors.grey[200],
													) :
													BoxDecoration(
														image: DecorationImage(image: NetworkImage(capeuser),fit: BoxFit.cover),
														
													),
													padding: EdgeInsets.symmetric(vertical: 52.5),
													child: Column(
														children: <Widget>[
															Container(
																width: 175,
																height: 175,
																decoration: BoxDecoration(
																	border: Border.all(width: 0),
																	borderRadius: BorderRadius.circular(100)
																),
																child: ClipRRect(
																	borderRadius: BorderRadius.circular(100),
																	child: Image.network(ftuser,width:175,height: 175),
																),
															),
														],
													),
												),
												Divider(color: Colors.white),
												Text(name,style: new TextStyle(
													fontSize: 25.0,
												)),
												Divider(color: Colors.grey[100],),
											],
										),
									),
								]),
							),
							SliverList(
								delegate: SliverChildBuilderDelegate(
									(BuildContext context, int index) {
										return Container(
											decoration: new BoxDecoration(
												color: Colors.white,
												border: new Border.all(
													width: 0.0,
													color: const Color(0x00000000),
												),
												borderRadius: new BorderRadius.circular(5.0),
												boxShadow: [
													new BoxShadow(
														color: const Color(0x33000000),
														blurRadius: 5.0,
													)
												],
											),
											margin: const EdgeInsets.only(top: 15.0,left: 5.0,right: 5.0),
											child: Column(
												children: [
													talks[index][2] != "" ? Image.network('http://201.76.95.46:80'+talks[index][2]) : Text('',style: new TextStyle(fontSize: 1.0)),
													Container(
														padding: new EdgeInsets.all(10.0),
														child: Column(
															children:[
																Container(
																	child: Row(
																		children: [
																			Expanded(
																				flex: 1,
																				child: Row(
																					mainAxisAlignment: MainAxisAlignment.spaceBetween,
																					children: <Widget>[
																						Align(
																							alignment: Alignment.centerLeft,
																							child: Container(
																								margin: const EdgeInsets.only(left: 0.0),
																								child:Text(talks[index][4]),
																							),
																						),
																						GestureDetector(
																							onTap: () {
																								showDialog(
																									context: context,
																									builder: (context) {
																										return AlertDialog(
																											title: Text('Você deseja remover essa publicação.'),
																											content: SingleChildScrollView(
																												child: Row(
																													mainAxisAlignment: MainAxisAlignment.spaceAround,
																													children: <Widget>[
																														ButtonTheme(
																															child: RaisedButton(
																															onPressed: (){
																																deletePub(talks[index][0],index);
																																Navigator.pop(context);
																															},
																															child: Text("Sim",style: TextStyle(color:Color(0xFFFFFFFF))),
																															color: vupycolor,
																															)
																														),
																														ButtonTheme(
																															child: RaisedButton(
																															onPressed: (){
																																Navigator.pop(context);
																															},
																															child: Text("Não",style: TextStyle(color:Color(0xFFFFFFFF))),
																															color: vupycolor,
																															)
																														),
																													],
																												),
																											),
																										);
																									},
																								);
																							},
																							child: Container(
																								padding: new EdgeInsets.all(5.0),
																								margin: const EdgeInsets.only(right: 5.0),                                                                               child: Align(
																									alignment: Alignment.centerRight,
																									child: Text("X"),
																								),
																							),
																						),
																					],
																				),
																			)
																		],
																	),
																),
																Divider(
																	color: Color(0x00FFFFFF)
																),
																Container(
																	margin: const EdgeInsets.only(top: 8.0),
																	child: Align(
																		alignment: Alignment.centerLeft,
																		child: talks[index][3] != "" ? Text(talks[index][3]) : Text('',style: new TextStyle(fontSize: 1.0)),
																	),
																),
																Divider(
																	color: Color(0xFFd2d2d2)
																),
															],
														),
													),
												],
											),
										);
									},
									childCount: talks.length,
								),
							),
						],
					)
				],
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