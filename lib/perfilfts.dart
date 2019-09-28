import 'package:async/async.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:vupy/bottomAll.dart';

import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:vupy/widgets/url.dart';

class PerfilFtPage extends StatefulWidget {
  @override
  State createState() => _PerfilFtPage();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _PerfilFtPage extends State<PerfilFtPage> {
  AppState state;
  File ftFile, cpFile;
  File ftFileCrop, cpFileCrop;
  String cpImage = "", ftImage = "";

  int myId;
  bool changed = false;
  String url = URL().getUrl(),
      api,
      ftuser = "https://vupytcc.pythonanywhere.com/static/img/user.png",
      capeuser,
      name = '';

  Future<String> _cropImageFT() async {
    ftFileCrop = await ImageCropper.cropImage(
      ratioX: 200,
      ratioY: 200,
      sourcePath: ftImage,
      toolbarTitle: 'Recorte a imagem',
      toolbarColor: Colors.white,
      toolbarWidgetColor: Colors.black,
    );
    if (ftFileCrop != null) {
      ftFile = ftFileCrop;
      changed = true;
      return "ok";
    } else {
      return "no";
    }
  }

  Future<String> _cropImageCP() async {
    ftFileCrop = await ImageCropper.cropImage(
      ratioX: 800,
      ratioY: 450,
      sourcePath: cpImage,
      toolbarTitle: 'Recorte a imagem',
      toolbarColor: Colors.white,
      toolbarWidgetColor: Colors.black,
    );
    if (ftFileCrop != null) {
      cpFile = ftFileCrop;
      changed = true;
      return "ok";
    } else {
      return "no";
    }
  }

  void getP() async {
    var jsona = {};
    var prefs = await SharedPreferences.getInstance();
    myId = prefs.getInt('userid') ?? 0;
    api = prefs.getString("api") ?? '';

    jsona["user"] = myId;
    jsona["api"] = api;

    var r = await http.post(Uri.encodeFull(url + "/workserver/getiProfile/"),
        body: json.encode(jsona));

    var resposta = json.decode(r.body);
    if (resposta['style'][1] == null || resposta['style'][1] == "") {
      ftuser = url + "/static/img/user.png";
    } else {
      ftuser = url + "/media" + resposta['style'][1];
    }

    if (resposta['style'][0] == null || resposta['style'][0] == "") {
      capeuser = null;
    } else {
      capeuser = url + "/media" + resposta['style'][0];
    }
    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    void lets() async {
      getP();
    }

    state = AppState.free;
    lets();
    super.initState();
  }

  Future<String> sendFTs() async {
    var prefs = await SharedPreferences.getInstance();
    myId = prefs.getInt('userid') ?? 0;
    api = prefs.getString("api") ?? '';
    if (ftImage != "") {
      var uri = Uri.parse(url + "/workserver/postftU/");
      var request = new http.MultipartRequest("POST", uri);
      request.fields['user'] = myId.toString();
      var stream =
          new http.ByteStream(DelegatingStream.typed(ftFile.openRead()));
      var length = await ftFile.length();
      print(ftFile.path.split("/").last);
      var multipartFile = new http.MultipartFile('ftuser', stream, length,
          filename: basename(ftFile.path));
      request.files.add(multipartFile);
      var response = await request.send();
      print(response.statusCode);
    }
    if (cpImage != "") {
      var uri = Uri.parse(url + "/workserver/postCtU/");
      var request = new http.MultipartRequest("POST", uri);
      request.fields['user'] = myId.toString();
      var stream =
          new http.ByteStream(DelegatingStream.typed(cpFile.openRead()));
      var length = await cpFile.length();
      print(cpFile.path.split("/").last);
      var multipartFile = new http.MultipartFile('capeuser', stream, length,
          filename: basename(cpFile.path));
      request.files.add(multipartFile);
      var response = await request.send();
      print(response.statusCode);
    }
    return "ok";
  }

  @override
  Widget build(BuildContext context) {
    void ftCamera() async {
      ftFile = await ImagePicker.pickImage(source: ImageSource.camera);
      ftImage = ftFile.path;
      var isok = await _cropImageFT();
      if (isok == "no") {
        ftFileCrop = null;
        ftFile = null;
        ftImage = "";
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("A imagem não foi cortada\n tente novamente ;)")
                  ],
                ),
              ),
            );
          },
        );
      }
      if (this.mounted) {
        setState(() {});
      }
    }

    void ftGaleria() async {
      ftFile = await ImagePicker.pickImage(source: ImageSource.gallery);
      ftImage = ftFile.path;
      var isok = await _cropImageFT();
      if (isok == "no") {
        ftFileCrop = null;
        ftFile = null;
        ftImage = "";
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("A imagem não foi cortada\n tente novamente ;)")
                  ],
                ),
              ),
            );
          },
        );
      }
      if (this.mounted) {
        setState(() {});
      }
    }

    void cpCamera() async {
      cpFile = await ImagePicker.pickImage(source: ImageSource.camera);
      cpImage = cpFile.path;
      var isok = await _cropImageCP();
      if (isok == "no") {
        cpFileCrop = null;
        cpFile = null;
        cpImage = "";
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("A imagem não foi cortada\n tente novamente ;)")
                  ],
                ),
              ),
            );
          },
        );
      }
      if (this.mounted) {
        setState(() {});
      }
    }

    void cpGaleria() async {
      cpFile = await ImagePicker.pickImage(source: ImageSource.gallery);
      cpImage = cpFile.path;
      var isok = await _cropImageCP();
      if (isok == "no") {
        cpFileCrop = null;
        cpFile = null;
        cpImage = "";
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("A imagem não foi cortada\n tente novamente ;)")
                  ],
                ),
              ),
            );
          },
        );
      }
      if (this.mounted) {
        setState(() {});
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Alterações"),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(IconData(0xea10, fontFamily: 'icomoon'),
                color: Colors.black),
            onPressed: () async {
              // Navigator.pushNamed(context, '/bottom');
            //  Navigator.pop(context);
            //  Navigator.pus(context, "/bottom");
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => MyHomePage(
                  page: 2,
                ) 
              ));            
            },
          ),
        ],
        leading: changed == true
            ? IconButton(
                icon: Icon(IconData(0xe92f, fontFamily: 'icomoon'),
                    color: Colors.black),
                onPressed: () async {
                  await sendFTs();
                  // Navigator.of(context).pushNamed("/bottom");
                  Navigator.pushReplacementNamed(context, '/bottom');
                //  Navigator.pop(context);
                },
              )
            : Container(),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 280,
                decoration: capeuser == null
                    ? cpImage == ""
                        ? BoxDecoration(
                            color: Colors.grey[200],
                          )
                        : BoxDecoration(
                            image: DecorationImage(
                                image: FileImage(cpFile), fit: BoxFit.cover),
                          )
                    : BoxDecoration(
                        image: cpImage == ""
                            ? DecorationImage(
                                image: NetworkImage(capeuser),
                                fit: BoxFit.cover)
                            : DecorationImage(
                                image: FileImage(cpFile), fit: BoxFit.cover),
                      ),
                child: Container(
                    decoration: BoxDecoration(
                      color: Color(0X41000000),
                    ),
                    child: Center(
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        child: Text("Trocar",
                            style: TextStyle(color: Colors.white)),
                        color: Color(0xffe7002a),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: SingleChildScrollView(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      ButtonTheme(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          child: RaisedButton(
                                        onPressed: () {
                                          cpGaleria();
                                          Navigator.pop(context);
                                        },
                                        child: Text("Galeria",
                                            style: TextStyle(
                                                color: Color(0xFFFFFFFF))),
                                        color: Color(0XFFE7002A),
                                      )),
                                      ButtonTheme(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          child: RaisedButton(
                                        onPressed: () {
                                          cpCamera();
                                          Navigator.pop(context);
                                        },
                                        child: Text("Camera",
                                            style: TextStyle(
                                                color: Color(0xFFFFFFFF))),
                                        color: Color(0XFFE7002A),
                                      )),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    )),
              ),
              Divider(
                color: Colors.white,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.6,
                height: MediaQuery.of(context).size.width / 1.6,
                decoration: ftuser == null
                    ? ftImage == ""
                        ? BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(width: 0),
                            borderRadius: BorderRadius.circular(200),
                          )
                        : BoxDecoration(
                            image: DecorationImage(
                                image: FileImage(ftFile), fit: BoxFit.cover),
                            border: Border.all(width: 0),
                            borderRadius: BorderRadius.circular(200),
                          )
                    : BoxDecoration(
                        image: ftImage == ""
                            ? DecorationImage(
                                image: NetworkImage(ftuser), fit: BoxFit.cover)
                            : DecorationImage(
                                image: FileImage(ftFile), fit: BoxFit.cover),
                        border: Border.all(width: 0, color: Color(0x01000001)),
                        borderRadius: BorderRadius.circular(200),
                      ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0X41000000),
                    borderRadius: BorderRadius.circular(200),
                    border: Border.all(width: 0, color: Color(0x01000001)),
                  ),
                  child: Center(
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child:
                        Text("Trocar", style: TextStyle(color: Colors.white)),
                    color: Color(0XFFE7002A),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: SingleChildScrollView(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  ButtonTheme(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      child: RaisedButton(
                                    onPressed: () {
                                      ftGaleria();
                                      Navigator.pop(context);
                                    },
                                    child: Text("Galeria",
                                        style: TextStyle(
                                            color: Color(0xFFFFFFFF))),
                                    color: Color(0XFFE7002A),
                                  )),
                                  ButtonTheme(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      child: RaisedButton(
                                    onPressed: () {
                                      ftCamera();
                                      Navigator.pop(context);
                                    },
                                    child: Text("Camera",
                                        style: TextStyle(
                                            color: Color(0xFFFFFFFF))),
                                    color: Color(0XFFE7002A),
                                  )),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
