import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  DetailScreen({
    Key key, 
    this.imageurl, 
    this.hero,
    this.name
  }) : super(key: key);

  final String imageurl;
  final String name;
  final String hero;

  State createState() => _DetailScreen();
  
}

class _DetailScreen extends State<DetailScreen> {
  var truecolor = Color(0xffffffff);
  var differ = Color(0xff000000);

  Future loadcolor() async {
    var prefs = await SharedPreferences.getInstance();
    var color = (prefs.getStringList("color") ?? ["255", "255", "255", "1"])
            .toList()
            .toString();

    if (this.mounted) {
      setState(() {
        var cc = jsonDecode(color);
        truecolor = Color.fromRGBO(cc[0], cc[1], cc[2], 1);
        if (truecolor.computeLuminance() > 0.673) {
          differ = Colors.black;
        }
        else{
          differ = Colors.white;
        }
      });
    }
  }

  @override
  void initState() { 
    super.initState();
    loadcolor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name, style: TextStyle(color: differ),),
        centerTitle: true,
        backgroundColor: truecolor,
        
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: differ,),
          onPressed: (){
            Navigator.pop(context);
          },
        )
        ,
      ),
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: widget.hero,
            child: Image.network(widget.imageurl),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}