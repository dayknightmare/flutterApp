import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class PerfilFtPage extends StatefulWidget{
	@override
  	State createState() =>  _PerfilFtPage();
}

class _PerfilFtPage extends State<PerfilFtPage>{

	File ftFile, cpFile;
	String cpImage = "", ftImage = "";

	void ftCamera() async {
		ftFile = await ImagePicker.pickImage(source: ImageSource.camera);
		ftImage = ftFile.path;
		setState(() {});
	}
	
	void ftGaleria() async {
		ftFile = await ImagePicker.pickImage(source: ImageSource.gallery);
		ftImage = ftFile.path;
		setState(() {});
	}

	void cpCamera() async {
		cpFile = await ImagePicker.pickImage(source: ImageSource.camera);
		cpImage = cpFile.path;
		setState(() {});
	}
	
	void cpGaleria() async {
		cpFile = await ImagePicker.pickImage(source: ImageSource.gallery);
		cpImage = cpFile.path;
		setState(() {});
	}

	@override
  	Widget build(BuildContext context) {
    	return Scaffold(
			appBar: AppBar(
				title: Text("Alterações"),
				centerTitle: true,
				backgroundColor: Colors.white,
				leading: IconButton(
					icon: Icon(IconData(0xe92f,fontFamily:'icomoon'),color: Colors.black),
					onPressed: () async {
					},
				),
			),
			body: SingleChildScrollView(
				child: Container (
					padding: EdgeInsets.all(10.0),
					child: Column(
						children: <Widget>[
							Text("Foto de perfil",style: new TextStyle(fontSize: 20.0),),
							ButtonTheme(
								height: 35.0,
								minWidth: 200.0,
								child: RaisedButton(
									onPressed: (){
										showDialog(
											context: context,
											builder: (context) {
												return AlertDialog(
													content: SingleChildScrollView(
														child: Row(
															mainAxisAlignment: MainAxisAlignment.spaceAround,
															children: <Widget>[
																ButtonTheme(
																	child: RaisedButton(
																		onPressed: () {
																			ftGaleria();
																			Navigator.pop(context);
																		},
																		child: Text("Galeria",style: TextStyle(color:Color(0xFFFFFFFF))),
																		color: Color(0XFFE7002A),
																	)
																),
																ButtonTheme(
																	child: RaisedButton(
																		onPressed: () {
																			ftCamera();
																			Navigator.pop(context);
																		},
																		child: Text("Camera",style: TextStyle(color:Color(0xFFFFFFFF))),
																		color: Color(0XFFE7002A),
																	)
																),
															],
														),
													),
												);
											},
										);
									},
									child: Text(
										"Escolher",
										style: TextStyle(color: Colors.white)
									),
									color: Color(0XFFE7002A),
								)
							),
							ftImage == "" ? Text("") : Image.file(File(ftImage),height: 350,),
							Divider(),
							Text("Capa de perfil",style: new TextStyle(fontSize: 20.0),),
							ButtonTheme(
								height: 35.0,
								minWidth: 200.0,
								child: RaisedButton(
									onPressed: (){
										showDialog(
											context: context,
											builder: (context) {
												return AlertDialog(
													content: SingleChildScrollView(
														child: Row(
															mainAxisAlignment: MainAxisAlignment.spaceAround,
															children: <Widget>[
																ButtonTheme(
																	child: RaisedButton(
																		onPressed: () {
																			cpGaleria();
																			Navigator.pop(context);
																		},
																		child: Text("Galeria",style: TextStyle(color:Color(0xFFFFFFFF))),
																		color: Color(0XFFE7002A),
																	)
																),
																ButtonTheme(
																	child: RaisedButton(
																		onPressed: () {
																			cpCamera();
																			Navigator.pop(context);
																		},
																		child: Text("Camera",style: TextStyle(color:Color(0xFFFFFFFF))),
																		color: Color(0XFFE7002A),
																	)
																),
															],
														),
													),
												);
											},
										);
									},
									child: Text(
										"Escolher",
										style: TextStyle(color: Colors.white)
									),
									color: Color(0XFFE7002A),
								)
							),
							cpImage == "" ? Text("") : Image.file(File(cpImage),height: 350,),
						],
					),
				),
			),
			
			
		);
  	}
}