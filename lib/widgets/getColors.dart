import 'dart:convert';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColorsGetCustom{
  Future<List> getColorNavAndBtn(
    String nav,
    Color trueColorNav,
    String btn,
    Color trueColorBtn,
    {int you=0}
  ) async {

    List<Color> colors = [];
    var prefs = await SharedPreferences.getInstance();
    Color differNav;
    Color trueColorNav;
    Color differBtn;
    Color trueColorBtn;
    var color, cca, antColor;

    if (nav != "white") {
      color = nav.replaceAll("rbg(","").replaceAll(")", "").replaceAll("rgba(","");
      color = "[" + color +  "]";
      cca = jsonDecode(color);
      antColor = trueColorNav;
      trueColorNav = Color.fromRGBO(cca[0], cca[1], cca[2], 1);

      if (trueColorNav != antColor && you == 0) {
        prefs.setStringList("color", [
          cca[0].toString(), cca[1].toString(), cca[2].toString(),
        ]);
      }

    }
    else{
      trueColorNav = Color(0xffffffff);
    }
    if (trueColorNav.computeLuminance() > 0.673) {
      differNav = Colors.black;
    }
    else{
      differNav = Colors.white;
    }
    colors.add(trueColorNav);
    colors.add(differNav);


    print(btn);
    if (btn != "white" && btn != null) {
      color = btn.replaceAll("rbg(","").replaceAll(")", "").replaceAll("rgba(","");
      color = "[" + color +  "]";
      cca = jsonDecode(color);
      antColor = trueColorBtn;
      trueColorBtn = Color.fromRGBO(cca[0], cca[1], cca[2], 1);

      if (trueColorBtn != antColor && you == 0) {
        prefs.setStringList("colorbtn", [
          cca[0].toString(), cca[1].toString(), cca[2].toString(),
        ]);
      }
    }
    else{
      trueColorBtn = Color(0xffffffff);
    }
    if (trueColorBtn.computeLuminance() > 0.673) {
      differBtn = Colors.black;
    }
    else{
      differBtn = Colors.white;
    }

    colors.add(trueColorBtn);
    colors.add(differBtn);

    return colors;
  }
}